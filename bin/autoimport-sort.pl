#!/usr/bin/perl

use File::Iterator;
use File::Basename qw/basename dirname/;
use File::Copy::Recursive qw/rmove/;
use File::Copy qw/move/;
use File::Path qw/make_path remove_tree/;
use File::Touch qw/touch/;
use File::Spec::Functions qw/catpath catdir abs2rel/;
use Cwd;

$| = 1;

my $DEBUG;
my $LOG;
my $DRY_RUN = 0;

BEGIN { 
    $DEBUG = 1;

    if ($DEBUG) {
        *LOG = STDOUT;
    } else {
        $LOG='/tmp/clean-downloads.log' or die $!;
        open (LOG, '>>', $LOG);
    }
}
END {
    close LOG;
    closedir DIR;
}
use strict;

my $ROOT_DIR = '';
my $INCOMING_DIR = catdir($ROOT_DIR, 'incoming');
my $UNRAR = '/usr/bin/unrar';
my $UNZIP = '/usr/bin/unzip';

my $EXT_MAP = {
    ## based on extension only
    ## dir rel to ROOT_DIR =>   [ [wanted, strip_dir] (t/f), match re ]    
    ## applied in lexical order ...

    ## junk we want removed...
    '.junk' => [[0, 1], '^(s(fv|ub|r[str])|par2?|txt|idx|diz|url|m3u|log|DS_Store)$'],
    '.nfos' => [[0, 1], '^nfo$'],
    '.nzbs' => [[0, 1], '^nzb$'],
    '.torrents' => [[0, 1], '^torrent$'],

    ## content we want in the shared folder... 
    'DROPBOX' => [[1, 0], '^(mkv|avi|divx|mov|mp4|m4v)$'],
    'SOFTWARE_INCOMING' => [[1, 0], '^(img|iso|bin|cue|exe|pdf)$'],
    'VID_INCOMING' => [[1, 0], '^(mp3|flac|wav|aiff|m4a)$'],

    ## todo, we need a "tagalong" list.. where if they match, they go along w/ whatever
    ## explicit match happened in the folder (for instance cover art)
};

my $NAME_MAP = {
    ## override extension settings based on name.... gets applied first
    '.junk' => [[0, 1], '(^|\b)sample\b'], 
};

## ensure all destdirs exist..
(! -d catdir($ROOT_DIR, $_)) and make_path(catdir($ROOT_DIR, $_)) foreach keys %$EXT_MAP, keys %$NAME_MAP;

##TODO: consider, if we have junk, but we're not stripping the dirs, do we also move
##all the junk along with it?  For instance nfos for software often contain useful info
##whereas for a/v files it's basically pointless..

#MAIN
## do a non-resursing loop on  the top of the incoming folder and go from there, processing each dir or file
## found there as a separate case.
opendir(DIR, $INCOMING_DIR) or die $!;
while (my $case = readdir(DIR)) {
    next if $case =~ /^\.{1,2}$/;
    my $CASE_PATH = catdir($INCOMING_DIR, $case);
    print LOG localtime, ' [', join('] [', $CASE_PATH), ']', "\n";

    ## need concept of ALSO okay when in presense of x for mixed media... think instead
    ## run the cleaners to remove all junk,  then identify the contents, then move the entire folder
    ## also need a simple extractor for spanned rars..
    my @SEARCH = ();
    if ( -d $CASE_PATH) {
        my $iter = File::Iterator->new(DIR => $CASE_PATH, RECURSE => 1);
        while (my $file = $iter->next) {
            push @SEARCH, $file;
        }
    } else {
        @SEARCH = ($CASE_PATH, )
    }

    print LOG "Checking ".@SEARCH." files in $CASE_PATH\n";

    my ($w, $j, $u) = process(@SEARCH);
    my @WANTED = @{$w};
    my @JUNK = @{$j};
    my @UNKNOWNS = @{$u};

    print LOG "Found: Wanted(".@WANTED.") Junk(".@JUNK.") Unknown(".@UNKNOWNS.")\n";
    ## -> if search == moves we know exactly what  to do with it
    ##      simply then need to process moves w/ a destination
    ##      if anything left in moves w/o a dest after, move root folder
    ## -> if moves and unknowns we mostly know what to do

    if ($DRY_RUN) {
        if (@WANTED) {
            print LOG "WANTED:\n";
            for my $m (@WANTED) {
                my ($s, $d) = @{$m};
                print LOG "\t", $s, " -> ", $d, "\n";
            }
        }

        if (@UNKNOWNS) {
            print LOG "UNKNOWNS:\n";
            for my $u (@UNKNOWNS) {
                print LOG "\t", $u, "\n";
            }
        }

        if (@JUNK) {
            print LOG "JUNK:\n";
            for my $m (@JUNK) {
                my ($s, $d) = @{$m};
                print LOG "\t", $s, " -> ", $d, "\n";
            }
        }
    } else {
        ## we got at least one wanted, so do some stuff..
        if (@WANTED) {
            print LOG "WANTED:\n";
            #basically just shuffle the unkowns over to wanted
            #dir, somewhere..
            my $wanted_dest;
            for my $w (@WANTED) {
                my ($fro, $to) = @{$w};
                print LOG "\t", $fro, " -> ", $to, "\n";
                _move($fro, $to);
                $wanted_dest = dirname($to);
            }

            if (@UNKNOWNS) {
                print LOG "UNKNOWNS:\n";
                for my $fro (@UNKNOWNS) {
                    my $bn = basename($fro);
                    my $to = catpath(undef, $wanted_dest, $bn);
                    print LOG "\t", $fro, " -> ", $to, "\n";
                    _move($fro, $to);
                }
            }
            ## so all the files we wanna keep are kept.. now do junk
            if (@JUNK) {
                for my $j (@JUNK) {
                    my ($fro, $to) = @{$j};
                    print LOG "\t", $fro, " -> ", $to, "\n";
                    _move($fro, $to);
                }
            }
        }
    }

    #if we moved all the files we found, the dir is empty... (should move entire dir tree..)
    ## this needs to be revisited.. i think just actually check if the dir is empty..
    #if (@SEARCH and @WANTED and @SEARCH == @WANTED + @JUNK) {
    if ( -d $CASE_PATH) {
        my $deliter = File::Iterator->new(DIR => $CASE_PATH, RECURSE => 1);
        my $NOT_EMPTY = 0;
        while (my $file = $deliter->next) { $NOT_EMPTY++; }
        if ($NOT_EMPTY) { 
            print LOG "($NOT_EMPTY) FILES REMAIN, DO NOTHING\n";
        } else {
            print LOG "FULLY CLEANED (".@SEARCH."); REMOVING $CASE_PATH\n";
            if (! $DRY_RUN) {
                remove_tree($CASE_PATH);
            }
        }
    }

    print LOG "\n\n\n=====================================\n\n\n";
}

exit 0;

## processes one dir, or file from top level
sub process {
    my @SEARCH = @_;

    my @WANTED = ();  
    my @JUNK = ();
    my @UNKNOWNS = ();
    
    ## it's just one file.. out in the root..
    my $LOOSE_FILE = (@SEARCH == 1 and basename($SEARCH[0]) == $INCOMING_DIR);

    my $START_CWD = getcwd;

    ## there could be multiple separate archives in SEARCH.. e.g. several separate
    ## spanned zips or a series of rararchives.. we need to group them in a 
    ## sub array and loop as needed..
    my @rarch = grep { /\.(rar|r?0+)$/ } @SEARCH;
    my @zarch = grep { /\.(zip|zipx|zx?0+)$/ } @SEARCH;
    my $ARCH_REX = {
            'rar' => \@rarch,
            'zip' => \@zarch
        };

    my $ARCH_SETS = {
            'rar' => {},
            'zip' => {}
        };

    ## COLLECT ARCHIVE SETS
    for my $kind (keys %$ARCH_REX) {
        foreach my $arch (@{$ARCH_REX->{$kind}}) {
            my $bn = basename($arch);
            my ($name, $ext) = $bn =~ m/^(.+)\.([^\.]+)$/;
            ## unrar and unzip smart enough to find rest of the archive..
            if (not defined $ARCH_SETS->{$kind}->{$name}) { $ARCH_SETS->{$kind}->{$name} = $arch }
            #else { push(@{$ARCH_SETS->{$kind}->{$name}}, $arch) }
        }
    }

    ## PROCESS ARCHIVE SETS
    for my $kind (sort keys %$ARCH_SETS) {
        for my $arch_set_name (sort keys %{$ARCH_SETS->{$kind}}) {
            ## RARS  RAR ARA RAR

            my $cwd = '';
            if ( $kind eq 'rar' ) {
                my $rarch = $ARCH_SETS->{$kind}->{$arch_set_name};
                #print "RAR: $arch_set_name\n", $rarch, "\n============\n";

                ## maybe there's more than one individual archive..
                $cwd = dirname($rarch);
                my $bn = basename($rarch);
                ### make a dir named for the file, and extract it there..
                if ($LOOSE_FILE) {
                    my ($rbn) = $bn =~ m/(.*)\.[^\.]+$/;
                    $cwd = catdir($cwd, $rbn);
                    make_path($cwd) or die "could not make $cwd: $@";
                }

                print LOG "extracting $bn\n";

                chdir($cwd);
                my $raw_ret;
                if ($DRY_RUN) {
                    $raw_ret = 0;
                } else {
                    system($UNRAR, 'e', '-kb', '-y', '-o+', '-inul', $rarch);
                    $raw_ret = $?;
                }

                if ($raw_ret == -1) {
                    print LOG "unrar of $bn failed: $!\n";
                } else {
                    my $ret = $raw_ret >> 8;
                    print LOG "unrar of $bn completed with code ($ret)\n";
                    #...
                    if (! $ret) { #OK 
                        # so clean up.. remove the rar files, then rescan the dir
                        #print LOG "looking for: $arch_set_name".'\.r(ar|[0-9]+)$'."\n";
                        my @matches = grep { /\/$arch_set_name\.r(ar|[0-9]+)$/ } @SEARCH;
                        for my $rarfile (@matches) {
                            print LOG "Cleaning archive($arch_set_name) file: ", basename($rarfile), "\n";
                            if (! $DRY_RUN) {
                                unlink $rarfile;
                                @SEARCH = grep { !/$rarfile$/ } @SEARCH;
                            }
                        }
                    } else {
                        print LOG "... skipping ...\n";
                    }
                }
            }
            ## UNRARED
            ## UNZIP
            elsif ( $kind eq 'zip' ) {
                my $zarch = $ARCH_SETS->{$kind}->{$arch_set_name};
                #print "ZIP\n", join("\n", @zarch), "\n============\n";

                $cwd = dirname($zarch);
                my $bn = basename($zarch);
                ### make a dir named for the file, and extract it there..
                if ($LOOSE_FILE) {
                    my ($zbn) = $bn =~ m/(.*)\.[^\.]+$/;
                    $cwd = catdir($cwd, $zbn);
                    make_path($cwd) or die "could not make $cwd: $@";
                }

                print LOG "extracting $bn\n";
                chdir($cwd);
                my $raw_ret;
                if ($DRY_RUN) {
                    $raw_ret = 0;
                } else {
                    system($UNZIP, '-o', $zarch, '-d', $cwd);
                    $raw_ret = $?;
                }

                if ($raw_ret == -1) {
                    print LOG "unzip of $bn failed: $!\n";
                } else {
                    my $ret = $raw_ret >> 8;
                    print LOG "unzip of $bn completed with code ($ret)\n";

                    if (! $ret) { #OK 
                        # so clean up.. remove the rar files, then rescan the dir
                        my @matches = grep { /\/$arch_set_name\.(zip|zipx|zx?[0-9]+)$/ } @SEARCH;
                        for my $zipfile (@matches) {
                            print LOG "Cleaning archive($arch_set_name) file: ", basename($zipfile), "\n";
                            if (! $DRY_RUN) {
                                unlink $zipfile;
                                @SEARCH = grep { ! /$zipfile/ } @SEARCH;
                            }
                        }
                    } else {
                        print LOG "... skipping ...\n";
                    }
                }
            }
            ## UNZIPPED

            # rescan..
            my @NUSEARCH = ();
            my $liter = File::Iterator->new(DIR => $cwd, RECURSE => 1);
            while (my $file = $liter->next) {
                push @NUSEARCH, $file;
            }
            @SEARCH = @NUSEARCH;
        }
    }

    chdir($START_CWD);

    ## UNARCHIVE COMPLETE

FITER: foreach my $file (@SEARCH) {
        print LOG "\tChecking: $file\n";
        my $basename = basename($file);
        my $ident = $basename;
        $ident =~ s/\.\d+$//; ## strip any kind of counter numeric suffix like .1..
        my ($search_name, $ext) = $ident =~ m/(.*)\.([^\.]+)/;

        ## treat any file with no extension as text .. such as README
        $ext = 'txt' unless defined $ext and $ext ne '';

        for my $rdir (sort keys %$NAME_MAP) {
            my ($w, $nrestr) = @{$NAME_MAP->{$rdir}};
            my ($wanted, $strip_dirs) = @{$w};
            my $namere = qr/$nrestr/i;
            ## it's a match!
            if ($search_name =~ $namere) {
                my $destination;
                if ($strip_dirs) {
                    $destination = catpath(undef, catdir($ROOT_DIR, $rdir), $basename);
                } else {
                    ## whole path wanted.., so get it rel to hunt dir
                    $destination = catpath(undef, catdir($ROOT_DIR, $rdir), abs2rel($file, $INCOMING_DIR));
                }
                if ($wanted) {
                    push @WANTED, [$file, $destination];
                } else { # junk
                    push @JUNK, [$file, $destination];
                }
                print LOG "MATCHED NAME: $search_name vs $nrestr\n";
                next FITER;
            }
        }

        for my $rdir (sort keys %$EXT_MAP) {
            my ($w, $restr) = @{$EXT_MAP->{$rdir}};
            my ($wanted, $strip_dirs) = @{$w};
            my $extre = qr/$restr/i;
            ## what a match!
            if ($ext =~ $extre) {
                my $destination;
                if ($strip_dirs) {
                    $destination = catpath(undef, catdir($ROOT_DIR, $rdir), $basename);
                } else {
                    $destination = catpath(undef, catdir($ROOT_DIR, $rdir), abs2rel($file, $INCOMING_DIR));
                }
                if ($wanted) {
                    push @WANTED, [$file, $destination];
                } else { # junk
                    push @JUNK, [$file, $destination];
                }
                print LOG "\tMATCHED EXT: $ext vs $restr\n";
                next FITER;
            }
        }

        ## if we got here, we don't know what's to be done with this file
        push @UNKNOWNS, $file;

    }

    return (\@WANTED, \@JUNK, \@UNKNOWNS);
} #END process


sub _move {
    my ($a, $b) = (shift, shift);
    #print LOG "MOVE: $a => $b\n";
    if (! $DRY_RUN) {
        ## check if destpath exists, if not make it..
        my $dirn = dirname($b);
        if (! -d $dirn) {
            make_path($dirn);
        }
        move($a, $b);
        touch($b);
    }
}




__END__
