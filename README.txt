制作MLO
mkimage -T omapimage -a 0x402F0400 -d u-boot-spl.bin MLO
制作u-boot.img
mkimage -A arm -T firmware -C none -O u-boot -a 0x80800000 -e 0 -d u-boot.bin u-boot.img
