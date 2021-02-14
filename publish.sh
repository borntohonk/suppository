#!/usr/bin/env bash

GH_USER=borntohonk
GH_PATH=`cat $GH_TOKEN_PATH`
GH_REPO=NeutOS
GH_TARGET=master
ASSETS_PATH=out
AMSVER=`cat ams.version`
HBLVER=`cat hbl.version`
HBMENUVER=`cat hbmenu.version`
AMSCHANGELOG=`cat ams.changelog`
BUILD_HASH=$(git ls-remote https://github.com/borntohonk/NeutOS/ --heads master | cut -c 1-8)

res=`curl --user "$GH_USER:$GH_PATH" -X POST https://api.github.com/repos/${GH_USER}/${GH_REPO}/releases \
-d "
{
  \"tag_name\": \"$AMSVER-$BUILD_HASH\",
  \"target_commitish\": \"$GH_TARGET\",
  \"name\": \"NeutOS $AMSVER-$BUILD_HASH\",
  \"body\": \"![Banner](https://github.com/borntohonk/NeutOS/raw/master/img/banner.png) I can be reached on discord at borntohonk#9099 if there are any inquiries. This github and release is automated. NeutOS $AMSVER-$BUILD_HASH, HBL $HBLVER and HBMENU $HBMENUVER has been auto-built and auto-published with suppository. (https://github.com/borntohonk/suppository) . If you are looking for fusee-primary, it is in the release .zip \r\n\r\n the following is the changelog of Atmosphere, which this  NeutOS release is based on: \r\n\r\n ${AMSCHANGELOG} \",
  \"draft\": false,
  \"prerelease\": false
}"`
file_name=$(ls out)
upload_name=$(urlencode ${file_name})
echo Create release result: ${res}
rel_id=`echo ${res} | python -c 'import json,sys;print(json.load(sys.stdin, strict=False)["id"])'`

curl --user "$GH_USER:$GH_PATH" -X POST https://uploads.github.com/repos/${GH_USER}/${GH_REPO}/releases/${rel_id}/assets?name=${upload_name}\
 --header 'Content-Type: application/zip ' --upload-file ${ASSETS_PATH}/${file_name}
