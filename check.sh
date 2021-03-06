#!/bin/bash
CURRENT_COMMIT=$(cat latest.release)
TARGET_COMMIT=$(curl --silent "https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest" | grep -Po '"browser_download_url": "\K.*?(?=")' | grep -oE "\-([0-9a-fA-f]{8})" | head -1 | cut -c2-)
HBLVER=$(curl --silent "https://api.github.com/repos/switchbrew/nx-hbloader/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | cut -c 2-6)
HBMENUVER=$(curl --silent "https://api.github.com/repos/switchbrew/nx-hbmenu/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | cut -c 2-6)
if
	[ "$CURRENT_COMMIT" = "$TARGET_COMMIT" ]
then
	echo "No need to rebase, exiting..." && exit
else
	echo "Current commit hash does not match, rebasing..."
	echo "$TARGET_COMMIT" > latest.release &&
	git -C NeutOS fetch origin
	git -C NeutOS fetch upstream
	git -C NeutOS rebase $(cat latest.release) master
	git -C NeutOS push -f
	git -C NeutOS checkout master
	git -C NeutOS reset --hard master
fi

if find out | grep -q $(git ls-remote https://github.com/borntohonk/NeutOS/ --heads master | cut -c 1-8); then
	echo "Pre-existing build matches latest release, nothing needs to be done, exiting..." && exit
else
	echo "Pre-existing build not found/ does not match latest commit, building..."
	rm -rf out
	mkdir out
	echo "$HBLVER" > hbl.version
	echo "$HBMENUVER" > hbmenu.version
	curl --silent "https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest" | grep body | head -1 | cut -c 12->ams.changelog
	sed -i 's/.$//' ams.changelog
	cd libnx
	sudo -E make -j8 clean
	git fetch origin
	git checkout master
	git pull
	git reset --hard master
	sudo -E make -j8 install
	sudo chmod -R 755 /opt/devkitpro/libnx
	cd ..
	cd NeutOS
	make -j8 clean
	make -j8 dist-no-debug
	cd ..
	echo "Putting togheter the release archive" && sh build.sh
	echo "Completed new build, publishing new build to github" && sh publish.sh
	echo "A new build has now been published to github"
	cd NeutOS
	make -j8 clean
	cd ..
	cd libnx
	sudo -E make -j8 clean
	cd ..
	rm ams.changelog
	rm ams.version
	rm hbl.version
	rm hbmenu.version
	echo "Updating suppository submodules"
	git add -A
	git commit -m"Update submodules."
	git push
fi
