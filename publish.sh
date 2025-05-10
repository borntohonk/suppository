#!/bin/bash
AMSMAJORVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MAJOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
AMSMINORVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MINOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
AMSMICROVER=$(grep 'define ATMOSPHERE_RELEASE_VERSION_MICRO\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
HOS_MAJORVER=$(grep 'define ATMOSPHERE_SUPPORTED_HOS_VERSION_MAJOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
HOS_MINORVER=$(grep 'define ATMOSPHERE_SUPPORTED_HOS_VERSION_MINOR\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
HOS_MICROVER=$(grep 'define ATMOSPHERE_SUPPORTED_HOS_VERSION_MICRO\b' Atmosphere/libraries/libvapours/include/vapours/ams/ams_api_version.h | tr -s [:blank:] | cut -d' ' -f3)
HBLVER=$(grep -P "APP_VERSION\t:=\t" nx-hbloader/Makefile | head -1 | cut -c 16-20)
HBMENUVER=$(grep -P "export APP_VERSION\t:=\t" nx-hbmenu/Makefile | head -1 | cut -c 23-27)
HEKATEVER=$(git -C hekate describe --tags `git -C hekate rev-list --tags --max-count=1`)
TEXPLORERVER=$(git -C TegraExplorer describe --tags `git -C TegraExplorer rev-list --tags --max-count=1`)
HOSVER=$HOS_MAJORVER.$HOS_MINORVER.$HOS_MICROVER
AMSVER=$AMSMAJORVER.$AMSMINORVER.$AMSMICROVER
AMSHASH=$(git -C Atmosphere rev-parse HEAD)
HBLHASH=$(git -C nx-hbloader rev-parse HEAD)
HBMENUHASH=$(git -C nx-hbmenu rev-parse HEAD)
LIBNXHASH=$(git -C libnx rev-parse HEAD)
AMSZIPHASH=$(git -C Atmosphere rev-parse HEAD | cut -c -9)
echo "" > changelog.md && \
echo "This release works off of https://github.com/Atmosphere-NX/Atmosphere/commit/46a43578829163cd08b9ddcaaacc6febd1e71e0e and proposes https://github.com/borntohonk/Atmosphere/commit/$AMSHASH to modernize and shift to an "internal streamlined experience"." >> changelog.md && \
echo "" >> changelog.md && \
echo "- This release supports up to FW version ${HOSVER}" >> changelog.md && \
echo "" >> changelog.md && \
echo "- The intention of the proposed changes enable running homebrew games on consoles that run Atmosphere. Some of these homebrew games in circulation rely on these changes to run. Though there are controversial other usecases for the changes." >> changelog.md && \
echo "" >> changelog.md && \
echo "- This release has been compiled with this version of libnx: https://github.com/switchbrew/libnx/commit/$LIBNXHASH"  >> changelog.md && \
echo "" >> changelog.md && \
echo "- This release is intended for demonstrative purposes only. Any inquries or questions can be submitted at https://github.com/borntohonk/Atmosphere/issues" >> changelog.md && \
echo "" >> changelog.md && \
echo "- This release does include HBL and HBMENU, and the non-debug output from compiling commit https://github.com/borntohonk/Atmosphere/commit/$AMSHASH"  >> changelog.md && \
echo "" >> changelog.md && \
echo "- The HBL version provided is compiled during this release, and the source is from: https://github.com/borntohonk/nx-hbloader/commit/$HBLHASH" >> changelog.md && \
echo "" >> changelog.md && \
echo "- The HBMENU version provided is compiled during this release, and the source is from: https://github.com/switchbrew/nx-hbmenu/commit/$HBMENUHASH" >> changelog.md && \
echo "" >> changelog.md && \
echo "- dns.mitm's default.txt host file has been altered to provide a block for all nintendo servers to supplement the connectivity test patches this fork provides." >> changelog.md && \
echo "" >> changelog.md && \
echo "- fusee.bin is located in /bootloader/payloads/fusee.bin for convenience" >> changelog.md && \
echo "" >> changelog.md && \
echo "- hekate.bin is provided and is the version obtained currently at https://github.com/CTCaer/hekate/releases/$HEKATEVER" >> changelog.md && \
echo "" >> changelog.md && \
echo "- bootloader/payloads/tegraexplorer.bin is provided and is the version currently obtained at https://github.com/suchmememanyskill/TegraExplorer/releases/$TEXPLORERVER" >> changelog.md && \
echo "" >> changelog.md && \
echo "- Contains crash fix for users who use exosphere prodinfo blanker functionality and previously have used "incognito" to mess with their prodinfo. Credit for finding this goes to https://github.com/fruityloops1/nim-prodinfo-blank-fix" >> changelog.md && \
echo "" >> changelog.md && \
cat changelog.md
#example release, requires gh_token enviroment variable set gh release create $HOSVER-$AMSVER-$AMSZIPHASH -F changelog.md atmosphere-${AMSVER}-master-${AMSZIPHASH}+hbl-${HBLVER}+hbmenu-${HBMENUVER}.zip --title "Atmosphère+ $AMSVER-$AMSZIPHASH for FW version $HOSVER" --repo github.com/borntohonk/Atmosphere