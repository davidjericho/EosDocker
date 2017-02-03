#!/bin/bash

# Script used to register the filesystems in EOS and enable all the features
# necessary for a default setup
set -e
export EOSHOST=`hostname -f`
export EOSINSTANCENAME=`hostname -s`

echo "Starting as host ${EOSHOST} running instance ${EOSINSTANCENAME}..."

echo "Configure QuarkDB backend ..."
mkdir -p /var/quarkdb/node-0
chown -R daemon:daemon /var/quarkdb/node-0
/usr/bin/xrootd -n quarkdb -c /etc/xrd.cf.quarkdb -l /var/log/eos/xrdlog.quarkdb -b -Rdaemon

echo "Configure EOS instance ..."
source /etc/sysconfig/eos
export SYSTEMCTL_SKIP_REDIRECT=1
mkdir -p /run/lock/subsys
mkdir -p /var/eos/config/${EOSHOST}
chown daemon:root /var/eos/config/${EOSHOST}
touch /var/eos/config/${EOSHOST}/default.eoscf
chown daemon:daemon /var/eos/config/${EOSHOST}/default.eoscf

echo "Mark container as EOS MD master..."
touch /var/eos/eos.mq.master
touch /var/eos/eos.mgm.rw

echo "Start EOS MQ..."
/usr/bin/xrootd -n mq -c /etc/xrd.cf.mq -l /var/log/eos/xrdlog.mq -b -Rdaemon

echo "Start EOS MGM..."
/usr/bin/xrootd -n mgm -c /etc/xrd.cf.mgm -m -l /var/log/eos/xrdlog.mgm -b -Rdaemon

# Register FSTs with the EOS MGM
for i in {1..6}
do
    echo "Starting fst${i} ..."
    /usr/bin/xrootd -n fst${i} -c /etc/xrd.cf.fst${i} -l /var/log/eos/xrdlog.fst${i} -b -Rdaemon
    echo "Add file system $i"
    UUID=fst$i
    DATADIR=/home/data/eos$i
    echo "Create data directory for fst${i}"
    mkdir -p $DATADIR
    echo "$UUID" > $DATADIR/.eosfsuuid
    echo "$i" > $DATADIR/.eosfsid
    chown -R daemon:daemon $DATADIR
    eos -b fs add -m $i $UUID $HOSTNAME:$((2000+$i)) $DATADIR default rw
    eos -b node set $HOSTNAME:$((2000+$i)) on
done

echo "Configuring EOS namespace..."
eos -b space quota default off
eos -b space set default on
eos -b vid enable sss
eos -b vid enable unix
eos -b fs boot \*
eos -b config save -f default

echo '############################'
echo '# Run "eos" to control EOS #'
echo '# Logs in /var/log/eos     #'
echo '############################'

exec /bin/bash
