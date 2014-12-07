#!/usr/bin/python
import sys
import re
import os
import subprocess
import argparse
import select
import time
import threading
from urllib import request
try:
    from Queue import Queue, Empty
except ImportError:
    from queue import Queue, Empty  # python 3.x

parser = argparse.ArgumentParser(description='rip shit up')

## TODO: REQUIREMENTS BASED ON SUBCOMMANDS...

parser.add_argument('-a', '--announce', metavar='URL', type=str,
                   help='your announce url')
parser.add_argument('-o', '--rip-offset', metavar='N', type=str,
                   help='your drive\'s offset (default 0)', default='0')
parser.add_argument('-c', '--cover-art', metavar='URL', type=str,
                   help='url of art for this release', default='')
parser.add_argument('action', type=str,
                   choices={'all': 'rip ->  encode -> torrent -> post',
                            'rip': 'just rip to flac',
                            'encode': 'just encode flacs',
                            'torrent': 'just make torrent files',
                            'post': 'just post torrent files'},
                   help='action(s) to perform')
parser.add_argument('-q', '--quality', metavar='Q', type=str,
                   help='quality to encode to, can be specified more than '
                        'once (default v0, v2, 320)',
                   action='append',
                   choices=['v0', 'v2', '320'])
parser.add_argument('-u', '--unknown', action='store_true',
                   help='rip even if not in MusicBrainz?', default=False)
parser.add_argument('-d', '--data-dir', metavar='PATH', type=str,
                   help=('scp-style path to your torrent client\'s '
                        'data directory.'),
                   default='')
parser.add_argument('-w', '--watch-dir', metavar='PATH', type=str,
                   help=('scp-style path to your torrent client\'s '
                        'watch directory.  ex. user@host:path/'))
parser.add_argument('-k', '--ssh-pubkey', metavar='PATH', type=str,
                   help='local path to the ssh key for your remote',
                   default="~/.ssh/id_rsa.pub")
parser.add_argument('work', metavar='DIR', type=str,
                   help='work dir')

args = parser.parse_args()

ANNOUNCE = args.announce
WORK_DIR = os.path.abspath(args.work)
drk, wdirname = os.path.split(WORK_DIR)
COMPLETE_DIR = os.path.join(drk, '%s%s' % (wdirname, '_complete'))
ACTION = args.action
OFFSET = args.rip_offset
UNKNOWN = args.unknown
ON_POSIX = 'posix' in sys.builtin_module_names
COVER_ART_URL = re.sub(r'[\?\#].*$', '', args.cover_art)
COVER_ART_PATH = None
COVER_ART_FILENAME = None
if COVER_ART_URL:
    import tempfile
    import mimetypes
    from PIL import Image
    mtype, menc = mimetypes.guess_type(COVER_ART_URL)
    if mtype != None:
        ext = mimetypes.guess_extension(mtype)
    else:
        root, ext = os.path.splitext(COVER_ART_URL)

    af = tempfile.NamedTemporaryFile(delete=False)
    COVER_ART_PATH = af.name
    print('Downloading cover art: %s' % COVER_ART_URL)
    u = request.urlopen(COVER_ART_URL)
    af = open(COVER_ART_PATH, 'wb')
    af.write(u.read())
    af.close()
    COVER_ART_FILENAME = 'folder%s' % ext
    if not re.compile(r'\.(jpe?g|png)$', re.I).match(ext):
        print('Converting art...')
        im = Image.open(COVER_ART_PATH)
        im.save(COVER_ART_PATH, format='jpeg')
        COVER_ART_FILENAME = 'folder.jpg'

QUALITIES = args.quality if args.quality else ['v0', 'v2', '320']
TORRENT_UPLOAD = {
        'DATA_DIR': args.data_dir,
        'WATCH_DIR': args.watch_dir,
        'PUBKEY': args.ssh_pubkey,
    }

##TODO: avoid mistakes
REQUIREDS = {
    'all': [],
    'rip': [],
    'encode': [],
    'torrent': [],
    'post': [],
}


QUALS={
    'v0': ['-b', 'none', '-l', "-V0 --preset fast extreme", ],
    'v2': ['-b', 'none', '-l', "-V2 --preset fast standard", ],
    '320': ['-b', '320', ]
}

def enqueue_output(han, queue):
    thr = threading.current_thread()
    for line in iter(han.readline, b''):
        queue.put(line)
        if thr.stopped():
            break

    han.close()


class StoppableThread(threading.Thread):
    """Thread class with a stop() method. The thread itself has to check
    regularly for the stopped() condition."""

    def __init__(self, *args, **kwargs):
        super(StoppableThread, self).__init__(*args, **kwargs)
        self._stop_event = threading.Event()

    def stop(self):
        self._stop_event.set()
        return self

    def stopped(self):
        return self._stop_event.isSet()


def run(*args, **kwargs):
    kwargs.update({'stdout': subprocess.PIPE,
                   'stderr': subprocess.STDOUT,
                   'universal_newlines':  True})
    rip = subprocess.Popen(*args, **kwargs)
    q = Queue()
    t = StoppableThread(target=enqueue_output, args=(rip.stdout, q))
    t.daemon = True # thread dies with the program
    t.start()

    out_dir = ''
    while rip.poll() is None:
        try:  line = q.get_nowait() # or q.get(timeout=.1)
        except Empty: time.sleep(1)
        else:
            try:
                line = line.decode('utf8', 'ignore')
            except AttributeError:
                pass
            if 'output directory' in line:
                out_dir = re.sub(r'^.*output directory ', '', line)
            sys.stdout.write(line) # got lineV

    t.stop().join()

    ## empty anything remaining on the queue...
    while not q.empty():
        line = q.get()
        try:
            line = line.decode('utf8', 'ignore')
        except AttributeError:
            pass
        sys.stdout.write(line) # got lineV

    if rip.returncode:
        raise RuntimeError('Got bad return code [%s].  Halting.' % rip.returncode)
    return {'out_dir': out_dir.strip()}



## MAIN

if __name__ == '__main__':

    #makem
    for dd in [WORK_DIR, COMPLETE_DIR]:
        if not os.path.exists(dd):
            os.mkdir(dd)

    if ACTION in ['rip', 'all']:
        import shutil

        print('Ripping to %s ...' % WORK_DIR)
        rip_cmd = ['rip', 'cd', 'rip',
                   '--offset', OFFSET,
                   '--logger', 'whatcd',
                   '--output-directory', WORK_DIR,
                   '--track-template', '%A - %d (%y) [%x]/%t %n',
                   '--disc-template', '%A - %d (%y) [%x]/%A - %d',
                   ] + (['--unknown'] if UNKNOWN else [])
        out_dir = run(rip_cmd, cwd=WORK_DIR).get('out_dir', '')

        if not out_dir:
            raise RuntimeError('no outdir')

        if COVER_ART_PATH:
            cover_art_path = os.path.join(out_dir, COVER_ART_FILENAME)
            shutil.copy(COVER_ART_PATH, cover_art_path)

        ## remove a vestigial 'hidden audio' track, but only if it
        ## is "empty"
        #vestha = os.path.join(out_dir, '00 Hidden Track One Audio.flac')
        #if os.path.exists(vestha):
        #    stat = os.stat(vestha)
        #    if stat.st_size <= 265: #4K observed to be the size of these empty guys
        #        os.path.unlink


    if ACTION in ['encode', 'torrent', 'all']:
        import glob
        import shutil

        for flacdir in os.listdir(WORK_DIR):
            in_path = os.path.join(WORK_DIR, flacdir)
            if not ' [flac]' in flacdir or not os.path.isdir(in_path): continue

            name = flacdir.replace(' [flac]', '')

            ## look for folder in flac
            if not COVER_ART_PATH:
                globpath = os.path.join(in_path, 'folder.*')
                globpath = re.sub(r'\[', '[[]', globpath)
                for image in glob.glob(globpath):
                    if re.compile(r'\.(jpe?g|png)$', re.I).search(image):
                        COVER_ART_PATH = image
                        break

            if ACTION in ['torrent', 'all']:
                tor_cmd = ['mktorrent', '--announce', ANNOUNCE, '-p', in_path, ]
                run(tor_cmd, cwd=WORK_DIR)

            #for qual, lameargs in QUALS.items():
            for qual in QUALITIES:
                lameargs = QUALS[qual]
                out_path = os.path.join(WORK_DIR, '%s [%s]' % (name, qual))
                if not os.path.exists(out_path): os.mkdir(out_path)

                if ACTION in ['encode', 'all']:
                    if COVER_ART_PATH:
                        drek, cover_art_filename = os.path.split(COVER_ART_PATH)
                        cover_art_path = os.path.join(out_path, cover_art_filename)
                        shutil.copyfile(COVER_ART_PATH, cover_art_path)

                    enc_cmd = ['flac2mp3', '-d', '0', '-r', '-o', '%s' % out_path,
                            ] + lameargs + [in_path, ]
                    run(enc_cmd)

                if ACTION in ['torrent', 'all']:
                    tor_cmd = ['mktorrent', '--announce', ANNOUNCE, '-p', out_path, ]
                    run(tor_cmd, cwd=WORK_DIR)

    if ACTION in ['post', 'all']:
        import glob
        import shutil
        ## now:  upload torrent and data to seedbox
        ## assume this was validated at start..

        ##TODO: replace with rsync to easily skip
        ##files that exist...?

        ## data first
        print('Uploading data...')
        for datadir in os.listdir(WORK_DIR):
            datapath = os.path.join(WORK_DIR, datadir)
            if not os.path.isdir(datapath): continue
            print('\t%s' % datapath)

            scp_cmd = ['scp', '-q', '-r', ]
            if TORRENT_UPLOAD['PUBKEY']:
                scp_cmd.extend(['-i', TORRENT_UPLOAD['PUBKEY']])
            scp_cmd.extend([datapath, TORRENT_UPLOAD['DATA_DIR']])
            run(scp_cmd)

            shutil.move(datapath, COMPLETE_DIR)

        ## then torrents
        print('Uploading torrent files...')
        globpath = os.path.join(WORK_DIR, '*.torrent')
        globpath = re.sub(r'\[', '[[]', globpath)
        for torrent in glob.glob(globpath):
            print('\t%s' % torrent)
            scp_cmd = ['scp', '-q', ]
            if TORRENT_UPLOAD['PUBKEY']:
                scp_cmd.extend(['-i', TORRENT_UPLOAD['PUBKEY']])
            scp_cmd.extend([torrent, TORRENT_UPLOAD['WATCH_DIR']])
            run(scp_cmd)

            shutil.move(torrent, COMPLETE_DIR)

        ## last .. mechanize what.cd formpost??


    sys.exit(0)
