# Commands
copy image
```bash
byobu

imgname=`date +"%Y-%m-%d-%H%M-%S"`-grandfatherclock-pi4.img; xzname=$imgname.xz;  dadisk=/dev/sdb; webhook "starting copy $dadisk to $imgname to $xzname"; sudo dd if=$dadisk of=$imgname bs=4M status=progress; webhook "Copied the disk to $imgname, compressing to $xzname"; sudo pishrink.sh -v -Z -a $imgname $xzname; webhook "$imgname shrunk to $xzname, deleting $imgname" true; # sudo rm -f $imgname; webhook "done!" true; sudo shutdown -r +1
```

watch file
```bash
watch -n $((60 * 5)) "ls -lAh | rg grand | awk '{print \$5,\"/ 238.3G\", \"\\t\", \$9}'"
```