# Commands
copy image
```bash
byobu

imgname=`date +"%Y-%m-%d-%H%M-%S"`-grandfatherclock-pi4.img
xzname=$imgname.xz
dadisk=/dev/sdb

webhook "starting copy $dadisk to $imgname to $xzname"
sudo dd if=$dadisk of=$imgname bs=4M status=progress

webhook "Copied the disk to $imgname, compressing to $xzname"
sudo pishrink.sh -v -Z -a $imgname

webhook "$imgname shrunk to $xzname, calculating sha256 checksums..." true
sha256sum $imgname | tee sha256sum-$imgname.txt
sha256sum $imgname | tee -a sha256sum-$xzname.txt

webhook "getting sizes"
du -h $imgname | tee sizes-$imgname-$xzame.txt
du -h $xzname | tee -a sizes-$imgname-$xzame.txt

# sudo rm -f $imgname
webhook "done!" true
# sudo shutdown -r +1
```

watch file
```bash
watch -n $((60 * 5)) "ls -lAh | rg grand | awk '{print \$5,\"/ 238.3G\", \"\\t\", \$9}'"
```