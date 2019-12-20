#!/bin/busybox ash

. /etc/init.d/tc-functions
. /home/tc/www/cgi-bin/pcp-functions

useBusybox
TARGET=`cat /etc/sysconfig/backup_device`


cd /home/tc
wget http://download.roonlabs.com/updates/stable/RoonBridge_linuxarmv7hf.tar.bz2
tar xf RoonBridge_linuxarmv7hf.tar.bz2

mkdir -p /.RoonBridge/Settings
echo AskAlways > /.RoonBridge/Settings/update_mode
mkdir /.RAATServer

mv /home/tc/RoonBridge /opt/

echo ".RoonBridge" >> /opt/.filetool.lst
echo ".RAATServer" >> /opt/.filetool.lst

rm -f /home/tc/RoonBridge_linuxarmv7hf.tar.bz2
#rm -f /home/tc/roon.sh

pcp_write_var_to_config USER_COMMAND_1 "%2fopt%2fRoonBridge%2fstart.sh"

sed -i '/.RoonBridge/d' /opt/.filetool.lst
sed -i '/.RAATServer/d' /opt/.filetool.lst
echo '.RoonBridge' >>/opt/.filetool.lst
echo '.RAATServer' >>/opt/.filetool.lst

[ -n "$TARGET" ] || exit 1
echo "Backup device is set to: "$TARGET""
echo -n "Perform backup now? (y/N)"
read ANS
[ "$ANS" == "y" ] && filetool.sh -b

