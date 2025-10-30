# Commands
copy image
```bash
#/bin/bash
imgname=`date +"%Y-%m-%d-%H%M-%S"`-grandfatherclock-pi4.img
xzname=$imgname.xz
sizes=sizes-$imgname-$xzame.txt
checksums=sha256sum-$imgname-$xzname.sha256

# get real username (not root) if run with sudo
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

lsblk
echo "Enter disk name (including /dev/) ex /dev/sdb"
read dadisk

webhook "starting copy $dadisk to $imgname to $xzname"
sudo dd if=$dadisk of=$imgname bs=4M status=progress
imgsize=$(du -h $imgname)
webhook "Copied the disk to $imgname ($imgsize), compressing to $xzname"
sudo pishrink.sh -v -Z -a $imgname
xzsize=$(du -h $xzname)

webhook "$imgname ($imgsize) shrunk to $xzname ($xzsize), calculating sha256 checksums..."
sha256sum $imgname | tee $checksums
sha256sum $xzname | tee -a $checksums

webhook "getting sizes"
echo -e "imgsize: $imgsize\nxzsize: $xzsize" | tee $sizes

echo "changing perms"
sudo chown $username:$username $xzname

webhook "testing archive $xzname"
xz -t $xzname
ret=$?
webhook "test status: $ret"

webhook "DONE\n\tdisk: $dadisk\n\timgname: $imgname ($imgsize)\n\txzname: $xzname ($xzsize)" true
sudo shutdown -r +1
```

watch file
```bash
watch -n $((60 * 5)) "ls -lAh | rg grand | awk '{print \$5,\"/ 238.3G\", \"\\t\", \$9}'"
```