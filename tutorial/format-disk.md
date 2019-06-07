# Format Disk
    $ sudo fdisk -l
    $ sudo fdisk /dev/sdb
    $ sudo mkfs.ext3 /dev/sdb1

## Mount Disk
    # add to /etc/fstab
    $ sudo echo \
        '/dev/sdb1               /disk1           ext3    defaults        1 2' \
        >> /etc/fstab
