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

# get disk
lsblk
echo "Enter disk name (including /dev/) ex /dev/sdb"
read dadisk

# start
webhook "starting copy $dadisk to $imgname to $xzname at $(date)($(date +%s))" true

# copy disk
sudo dd if=$dadisk of=$imgname bs=4M status=progress
imgsize=$(du -h $imgname)

# shrink and compress the image
webhook "Copied the disk to $imgname ($imgsize), compressing to $xzname"
sudo pishrink.sh -v -Z -a $imgname
xzsize=$(du -h $xzname)

# sha256 checksums
webhook "$imgname ($imgsize) shrunk to $xzname ($xzsize), calculating sha256 checksums..."
sha256sum $imgname | tee $checksums
sha256sum $xzname | tee -a $checksums

# log filesizes
webhook "saving sizes"
echo -e "imgsize: $imgsize\nxzsize: $xzsize" | tee $sizes

# change archive to be friendly perms
webhook "changing perms"
sudo chown $username:$username $xzname

# test archive
webhook "testing archive $xzname"
xz -t $xzname
ret=$?
# if test fails
if [ $ret -gt 0 ]; then
    webhook "FAIL! ARCHIVE DES NOT CHECK return code: $ret EXITING"
    exit 1
# if test succeeds
else
    webhook "Archive Test SUCCESS"
fi

# schedule reboot in 1 minute
sudo shutdown -r +1

# finish and notify
webhook "DONE\n\tdisk: $dadisk\n\timgname: $imgname ($imgsize)\n\txzname: $xzname ($xzsize)" true
```

watch file
```bash
watch -n $((60 * 5)) "ls -lAh | rg grand | awk '{print \$5,\"/ 238.3G\", \"\\t\", \$9}'"
```