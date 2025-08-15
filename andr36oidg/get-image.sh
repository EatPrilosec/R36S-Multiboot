#!/bin/bash
# sudo apt install -y gh #>/dev/null 2>&1

# if [[ ! -f "${ThisImgName}" ]]
# then
#     gh release download -p "*r36s-android.img.zip" -D dl -R andr36oid/releases
#     cd dl
#     dlf1=$(find -name "*.img.zip") 
#     unzip $dlf1
#     dlf2=$(find -name "*.img")
#     mv $dlf2 ../"${ThisImgName}"
#     sync
#     cd ../
#     rm -rf dl
# fi

if [[ ! -f "gapps.zip" ]]
then
    wget -Ogapps.zip "https://archive.org/download/MindTheGapps/MindTheGapps-11.0.0-arm64-20210412_124247.zip"
fi


asset_url=$(curl -s "https://api.github.com/repos/andr36oid/releases/releases" \
  | jq -r '[.[]] | sort_by(.published_at) | reverse | .[0].assets[] | select(.name | test("'r36s'")) | .browser_download_url' \
  | head -n 1)

if [[ ! -f "${ThisImgName}" ]]
then
    wget "$asset_url" -O"${ThisImgName}.zip"
    unzip "${ThisImgName}.zip"
    rm -f "${ThisImgName}.zip"
    dlf=$(find -name "lineage-*-r36s-android.img")
    mv $dlf "${ThisImgName}"
    sync
fi