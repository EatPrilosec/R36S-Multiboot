#!/bin/bash

set_con() {
  sudo chcon -h u:object_r:"$1":s0 $2
  sudo chcon u:object_r:"$1":s0 $2
}

set_perm() {
  sudo chmod $1 $2
}

set_owner() {
  sudo chown $1:$2 $3
}

ui_print() {
#   echo "ui_print $1" > "$OUTFD";
#   echo "ui_print" > "$OUTFD";
    sayin $1
}


say Post-installing andr36oid to ${imgname}


# sayin installing gapps 


# thisosdir=$(pwd)
# ui_print "Extracting files"
# TMP=$(pwd)/tmp
# ZIP=$(pwd)/gapps.zip
# [[ -d "$TMP" ]] && sudo rm -rf "$TMP" || true
# mkdir -p $TMP
# cd "$TMP"
# unzip -o "$ZIP"
# rm -rf META-INF

# # ui_print "Setting up environment"
# # TOYBOX="${TMP}/toybox"
# # sudo chmod +x "$TOYBOX"

# # TOYS_PATH="${TMP}/bin"
# # rm -rf "$TOYS_PATH";
# # $TOYBOX install -d "$TOYS_PATH"
# # for toy in $($TOYBOX); do
# #   $TOYBOX ln -sf "$TOYBOX" "${TOYS_PATH}/${toy}"
# # done
# # PATH="${TOYS_PATH}:${PATH}"

# SYSTEM_OUT="${DestRootMnt}/system"

# cd system

# ui_print "Low resource device detected, removing large extras"
#   rm -rf product/app/GoogleTTS
#   rm -rf product/app/MarkupGoogle
#   rm -rf product/app/talkback
#   rm -rf product/priv-app/AndroidMigratePrebuilt
#   rm -rf product/priv-app/SetupWizardPrebuilt
#   rm -rf product/priv-app/Velvet

# ui_print "Generating addon.d file"
# cat addon.d/addond_head > addon.d/30-gapps.sh
# for f in `find . ! -path "./addon.d/*" -type f`; do
#   line=$(echo "$f" | sed 's/\.\///')
#   echo "$line" >> addon.d/30-gapps.sh
# done
# cat addon.d/addond_tail >> addon.d/30-gapps.sh
# rm addon.d/addond_head addon.d/addond_tail


# ui_print "Preparing files for copying"
# for d in `find . -mindepth 1 -type d -type d`; do
#   set_perm 0755 $d
#   set_owner root root $d
# done
# for f in `find . -type f`; do
#   type=$(echo "$f" | sed 's/.*\.//')
#   if [ "$type" == "sh" ] || [ "$type" == "$f" ]; then
#     set_perm 0755 $f
#   else
#     set_perm 0644 $f
#   fi
#   set_owner root root $f
#   set_con system_file $f
# done


# ui_print "Copying files"
# sudo cp --preserve=a -r ./* "${SYSTEM_OUT}/"

# if [ -e product/priv-app/SetupWizardPrebuilt ] ; then
#   sudo rm -rf ${SYSTEM_OUT}/system_ext/priv-app/Provision
# fi

# cd $thisosdir

# sudo rm -rf "$TMP"



sayin cleanup mounts and img dev
sync
sudo umount ${Thislodev}p1
sudo umount ${Thislodev}p2
sudo umount ${ThisBootDev}
sudo umount ${ThisRootDev}
#sudo umount ${ThisDataDev}

sync
sudo losetup -d ${Thislodev}

[[ "$BuildImgEnv" == "github" ]] && rm ${ThisImgName} || sayin keep ${ThisImgName}


# if [[ "$@" == *"andr36oid"* ]] 
# then



    sayin add android data partition
    sync
    sudo umount "${ImgBootMnt}"
    [[ -n "$AnDataSizeOverride" ]] && imgsize=$((imgsize + AnDataSizeOverride)) || imgsize=$((imgsize + 8192))
    sudo losetup -d $ImgLodev
    fallocate -l ${imgsize}MiB ${BuildingImgFullPath}
    sync
    sudo losetup -P ${ImgLodev} ${BuildingImgFullPath}
    sudo parted -s ${ImgLodev} resizepart 2 100%
    sudo mount ${ImgLodev}p1 "${ImgBootMnt}"
    [[ -n "$AnDataSizeOverride" ]] && npsz=$AnDataSizeOverride || npsz=8192
    sayin new $((npsz/1024))GiB partition
    newpart $npsz ext4 andata

# fi
