#!/bin/bash
AMSMAJORVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MAJOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
AMSMINORVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MINOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
AMSMICROVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MICRO\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
HBLVER=$(grep -P "APP_VERSION\t:=\t" nx-hbloader/Makefile | head -1 | cut -c 16-20)
HBMENUVER=$(grep -P "export APP_VERSION\t:=\t" nx-hbmenu/Makefile | head -1 | cut -c 23-27)
AMSVER=$AMSMAJORVER.$AMSMINORVER.$AMSMICROVER
AMSZIPHASH=$(git -C Atmosphere rev-parse HEAD | cut -c -9)
mkdir temp && \
mkdir temp/bootloader && \
mkdir temp/bootloader/payloads && \
mkdir bundle && \
cd bundle && \
sleep 1 && \
wget $(curl -s https://api.github.com/repos/CTCaer/hekate/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) && \
unzip -o hekate*.zip -d ../temp && \
rm hekate*.zip && \
mv ../temp/hekate_ctcaer_*.bin ../temp/hekate.bin && \
mkdir ../temp/atmosphere && \
mkdir ../temp/atmosphere/hosts && \
mkdir ../temp/config && \
wget $(curl -s https://api.github.com/repos/suchmememanyskill/TegraExplorer/releases/latest | grep "browser_download_url" | head -1 | cut -d '"' -f 4) -O ../temp/bootloader/payloads/TegraExplorer.bin && \
sleep 1 && \
cp ../configs/emummc.txt ../temp/atmosphere/hosts/emummc.txt && \
cp ../configs/sysmmc.txt ../temp/atmosphere/hosts/sysmmc.txt && \
cp ../configs/exosphere.ini ../temp/exosphere.ini && \
cd ../ && \
rm -rf bundle && \
mkdir temp/switch && \
cp Atmosphere/out/nin*/release/fusee.bin temp/bootloader/payloads/fusee.bin && \
unzip -o Atmosphere/out/nin*/release/atmosphere-*.zip -d temp/ && \
cp nx-hbloader/hbl.nsp temp/atmosphere/hbl.nsp && \
cp nx-hbmenu/nx-hbmenu.nro temp/hbmenu.nro && \
cd temp && \
zip -r ../atmosphere-${AMSVER}-master-${AMSZIPHASH}+hbl-${HBLVER}+hbmenu-${HBMENUVER}.zip * && \
cd .. && \
rm -rf temp && \
cp atmosphere-${AMSVER}-master-${AMSZIPHASH}+hbl-${HBLVER}+hbmenu-${HBMENUVER}.zip /out/ && \
chown 1000:1000 /out/atmosphere*.zip