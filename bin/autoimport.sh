#!/bin/bash
SERVER=
RUNDIR=/var/run/autoimport
sudo mkdir -p $RUNDIR && sudo chown -R $USER:$USER $RUNDIR && sudo chmod 700 -R $RUNDIR
pidfile=$RUNDIR/sync.pid
manlockfile=$RUNDIR/lock
if [ -e $manlockfile ]; then
  echo "Manual Lock"
  exit 1
else
  if [ -f $pidfile ]; then
    pid=`cat $pidfile`
    if kill -0 &>1 > /dev/null $pid; then
      echo "Already running"
      exit 1
    else
      rm $pidfile
    fi
  fi
fi
echo $$ > $pidfile


# VPN no longer needed, just ssh in both directions... 
#sleep 20
#sudo /etc/rc.d/openvpn start
# be nice
#sleep 60

#pull from seedbox
ssh $SERVER ./syncdown.sh

#sudo /etc/rc.d/openvpn stop

#sort out the mixed incoming dir
$HOME/bin/autoimport-sort.pl

#beet preprocess
beet import -q $INCOMING_DIR

#norma processing
$HOME/bin/normalize.pl -b $BACKUP_DIR -s $PREPROCESS_DIR -r "$LIBRARY_DIR" -un


rm $pidfile
