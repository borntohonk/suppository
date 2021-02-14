#!/bin/bash
AMSBRANCH=$(git -C NeutOS symbolic-ref --short HEAD)
AMSHASH=$(git -C NeutOS rev-parse --short HEAD)
HBLVER=$(cat hbl.version)
HBMENUVER=$(cat hbmenu.version)
MAJORVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MAJOR\b' NeutOS/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
MINORVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MINOR\b' NeutOS/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
MICROVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MICRO\b' NeutOS/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
AMSREV="$AMSBRANCH-$AMSHASH"
AMSVER="$MAJORVER.$MINORVER.$MICROVER-$AMSREV"
	echo "$MAJORVER.$MINORVER.$MICROVER" > ams.version
	mkdir hbl
	mkdir hbmenu
	wget $(curl -s https://api.github.com/repos/switchbrew/nx-hbloader/releases/latest | grep browser_download_url | cut -d '"' -f 4) -O hbl/hbl.nsp
	wget $(curl -s https://api.github.com/repos/switchbrew/nx-hbmenu/releases/latest | grep browser_download_url | cut -d '"' -f 4) -O hbmenu/temp.zip
	unzip hbmenu/temp.zip -d hbmenu
	mkdir atmosphere-$AMSVER
	unzip NeutOS/out/atmosphere-$AMSVER.zip -d atmosphere-$AMSVER/
	mkdir atmosphere-$AMSVER/atmosphere/hosts
	cp configs/default.txt atmosphere-$AMSVER/atmosphere/hosts/default.txt
	cp NeutOS/fusee/fusee-primary/fusee-primary.bin atmosphere-$AMSVER/fusee-primary.bim
	cp hbl/hbl.nsp atmosphere-$AMSVER/atmosphere/hbl.nsp
	cp hbmenu/hbmenu.nro atmosphere-$AMSVER/hbmenu.nro
	rm atmosphere-$AMSVER/sept/sept-secondary.bin
	cp $(echo $SEPT_SECONDARY_BIN_PATH) atmosphere-$AMSVER/sept/sept-secondary.bin
	mkdir atmosphere-$AMSVER/atmosphere/kip_patches/fs_patches
	cp -r patches/fs_patches atmosphere-$AMSVER/atmosphere/kip_patches/
	cp -r patches/exefs_patches atmosphere-$AMSVER/atmosphere/
	cd atmosphere-$AMSVER; zip -r ../atmosphere-$AMSVER.zip ./*; cd ../;
	rm -r atmosphere-$AMSVER
	rm -r hbl
	rm -r hbmenu
	mv atmosphere-$AMSVER.zip out/NeutOS-$AMSVER+hbl-$HBLVER+hbmenu-$HBMENUVER+patches.zip
