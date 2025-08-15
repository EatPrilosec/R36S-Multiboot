#!/bin/bash

say Installing ${OsName} to ${imgname}

npsz=$(cat bootsizereq)
sayin new $((npsz/1024))GiB partition
OsBootLabel=andboot
newpart $npsz fat $OsBootLabel
ThisBootPartNum=${partcount}
ThisBootDev=${ImgLodev}p${ThisBootPartNum}
sayin new boot is ${ThisBootDev}

npsz=$(cat sizereq)
sayin new $((npsz/1024))GiB partition
newpart $npsz ext4 androot
ThisRootPartNum=${partcount}
ThisRootDev=${ImgLodev}p${ThisRootPartNum}
sayin new root is ${ThisRootDev}

# [[ -n "$AnDataSizeOverride" ]] && npsz=$AnDataSizeOverride || npsz=8192
# sayin new $((npsz/1024))GiB partition
# newpart $npsz ext4 andata
# ThisDataPartNum=${partcount}
# ThisDataDev=${ImgLodev}p${ThisRootPartNum}
# sayin new data is ${ThisRootDev}

sayin setup mounts
OSBootMnt=${tmpmnts}/os-${OsName}-boot
OSRootMnt=${tmpmnts}/os-${OsName}-root
OSDataMnt=${tmpmnts}/os-${OsName}-data
mkdir -p "${OSBootMnt}" "${OSRootMnt}" #"${OSDataMnt}"
Thislodev=$(losetup -f)
sudo losetup -P ${Thislodev} ${ThisImgName}
sudo mount ${Thislodev}p1 "${OSBootMnt}"
sudo mount ${Thislodev}p2 "${OSRootMnt}"
#sudo mount ${Thislodev}p3 "${OSDataMnt}"

sayin copy boot files to ${imgname}
sudo cp -v "boot.${OsName}.ini" "${ImgBootMnt}/boot.${OsName}.ini"
ThisBootPartNumHex=$(printf '%x\n' ${ThisBootPartNum})
sudo sed -i "s|###bootPartNum###|${ThisBootPartNumHex}|g" "${ImgBootMnt}/boot.${OsName}.ini"
sudo sed -i "s|###rootPartNum###|${ThisRootPartNum}|g" "${ImgBootMnt}/boot.${OsName}.ini"

# mount boot partition
DestBootMnt=${tmpmnts}/boot-${OsName}
sudo mkdir -p "${DestBootMnt}"
sudo mount ${ThisBootDev} "${DestBootMnt}"

sayin copy kernel and gapps to ${imgname} boot partition
sudo cp -v "${OSBootMnt}/Image" "${DestBootMnt}"
sudo cp -v "${OSBootMnt}/rk3326-r36s-android.dtb" "${DestBootMnt}"
sudo cp -vr "${OSBootMnt}/Panels" "${DestBootMnt}"
#wget --no-verbose --quiet -Ogapps.zip "https://archive.org/download/MindTheGapps/MindTheGapps-11.0.0-arm64-20210412_124247.zip"
# sudo mkdir -p "${DestBootMnt}/gapps"
# sudo unzip gapps.zip -d "${DestBootMnt}/gapps"

# mount root partition
DestRootMnt=${tmpmnts}/root-${OsName}
sudo mkdir -p "${DestRootMnt}"
sudo mount ${ThisRootDev} "${DestRootMnt}"

sudo rsync -aHAX --no-compress "${OSRootMnt}/" "${DestRootMnt}" #>/dev/null 2>&1

sudo mv "${DestRootMnt}/fstab.rk30board" "${DestRootMnt}/fstab.rk30board.orig"

sudo cp -v fstab.rk30board "${DestRootMnt}/fstab.rk30board"

sudo sed -i "s|###bootPartNum###|${ThisBootPartNum}|g" "${DestRootMnt}/fstab.rk30board"
sudo sed -i "s|###rootPartNum###|${ThisRootPartNum}|g" "${DestRootMnt}/fstab.rk30board"
sudo sed -i "s|###dataPartNum###|$(( ThisRootPartNum + 1 ))|g" "${DestRootMnt}/fstab.rk30board"


# mount data partition
# DestDataMnt=${tmpmnts}/data-${OsName}
# sudo mkdir -p "${DestDataMnt}"
# sudo mount ${ThisRootDev} "${DestDataMnt}"