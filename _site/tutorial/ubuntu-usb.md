# Create Ubuntu USB

## Convert ISO File
    $ hdiutil convert ~/Downloads/ubuntu-18.04.2-desktop-amd64.iso -format UDRW -o /tmp/ubuntu

## Copy Image to USB
    $ diskutil list
    $ diskutil unmountDisk /dev/disk2
    $ sudo dd if=/tmp/ubuntu.dmg of=/dev/disk2 bs=1m
    # wait a long time
