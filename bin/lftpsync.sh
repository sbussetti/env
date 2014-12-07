#!/bin/bash

OPTIND=1
is_file=

while getopts "h?f" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    f)  is_file="(file)"
        ;;
    esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

login=
pass=
host=
file_name=$1
remote_dir=""
local_dir=${2-""}
file_id=`echo "$file_name" | md5sum  | cut -d' ' -f1`

if [ -z "$is_file" ]; then
  mirror_cmd="mirror -vv -c -P5 --log=/tmp/synctorrents.${file_id}.log \"$remote_dir\" \"$local_dir\""
  remote_dir="$remote_dir/$file_name"
  local_dir="$local_dir/$file_name"
  echo "[$file_id] ($remote_dir) -> ($local_dir)";
else
  mirror_cmd="mirror -r -vv -c -P5 --log=/tmp/synctorrents.${file_id}.log --include=\"$file_name\" \"$remote_dir\" \"$local_dir\"";
  echo "[$file_id] ($remote_dir/$file_name) -> ($local_dir/$file_name)";
fi

 
trap "rm -f /tmp/synctorrent.${file_id}.lock" SIGINT SIGTERM
if [ -e "/tmp/synctorrent.${file_id}.lock" ]
then
  echo "$(basename $0) is running already."
  exit 1
else
  touch "/tmp/synctorrent.${file_id}.lock"
  lftp -u $login,$pass $host << EOF
  set ftp:ssl-allow no
  set mirror:use-pget-n 5
  $mirror_cmd
  quit
EOF
  rm -f "/tmp/synctorrent.${file_id}.lock"
  trap - SIGINT SIGTERM
  exit 0
fi
