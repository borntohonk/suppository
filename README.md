This repository is for the former docker container "suppository" which existed as a full toolchain to compile homebrew for the Nintendo Switch, and now is instead for a general GIT workflow atmosphere release suite.

The following commands can be used to compile atmosphere, and output the compiled release (release .zip and fusee.bin) it in the directory you run the command from:


Current example below is the build instructions that produce atmosphere 1.8.0 (22nd of october 2024), note the "haze" and "daybreak" .nro's are made before atmosphere because of issues with paralell thread makes in atmospheres's codebase.


note as of 24.10.2024: the docker container on dockerhub borntohonk/suppository, is deprecated until it otherwise would be needed again as devkitpro/devkita64 is now viable to compile atmosphere.

```

sudo docker pull devkitpro/devkita64:latest

sudo docker run --name suppository \
 --rm \
 --volume $PWD/.:/out \
 devkitpro/devkita64:latest /bin/bash -c \
 "cd /build && \
 git clone https://github.com/Atmosphere-NX/libnx.git && \
 git -C libnx fetch && \
 git -C libnx checkout 1900_support && \
 make -C libnx -j$(nproc) && \
 make -C libnx install && \
 git clone https://github.com/borntohonk/nx-hbloader.git && \
 make -C nx-hbloader -j$(nproc) && \
 git clone https://github.com/switchbrew/nx-hbmenu.git && \
 make -C nx-hbmenu nx -j$(nproc) && \
 git clone https://github.com/borntohonk/Atmosphere.git && \
 make -C Atmosphere/troposphere/haze -j$(nproc) && \
 make -C Atmosphere/troposphere/daybreak -j$(nproc) && \
 make -C Atmosphere -j$(nproc) && \
 rm Atmosphere/out/nintendo_nx_arm64_armv8a/release/atmosphere*debug*.zip && \
 cp Atmosphere/out/nintendo_nx_arm64_armv8a/release/atmosphere*.zip /out/ && \
 cp Atmosphere/out/nintendo_nx_arm64_armv8a/release/fusee.bin /out/fusee.bin && \
 chown 1000:1000 /out/fusee.bin && \
 chown 1000:1000 /out/atmosphere*.zip"

```


below are instructions that instead use build.sh and pack.sh from this repository, which additionally bundles hekate, hbl, hbmenu, atmosphere and tegraexplorer, as well as some configs, such as exosphere.ini and dnsmitm.


```
sudo docker pull devkitpro/devkita64:latest

sudo docker run --name suppository \
 --rm \
 --volume $PWD/.:/out \
 devkitpro/devkita64:latest /bin/bash -c \
 "cd /build && \
 wget https://github.com/borntohonk/suppository/raw/refs/heads/master/build.sh && \
 wget https://github.com/borntohonk/suppository/raw/refs/heads/master/pack.sh && \
 sh ./build.sh"

```


If you have any inquiries; file an issue with the github tracker.

workflow related instructions:

The following should be filed under https://github.com/borntohonk/suppository/settings/secrets/actions as "Repository Secrets"
pre-requisites: 

* a github Private Access Token(PAT) saved in the repository as "GH_TOKEN", with Repo permissions, and Org read/write permissions is required to deploy to a repository of choice.

the following should be filed under https://github.com/borntohonk/suppository/settings/variables/actions as "Repository Variables"
* Atmosphere source repository you want to compile defined as "ATMOSPHERE_REPOSITORY", examples: borntohonk/Atmosphere, Atmosphere-NX/Atmosphere
* Atmosphere branch to use, defined as "ATMOSPHERE_BRANCH", for which branch to use. examples: master
* target repository defined as "TARGET_REPOSITORY", for where to deploy the github release to. example: borntohonk/Atmosphere
* libnx repository defined as "LIBNX_REPOSITORY", for which repository to use as a base. examples: switchbrew/libnx, Atmosphere-NX/libnx
* libnx branch to use, defined as "LIBNX_BRANCH", for which branch to use. examples: master, 1900_support
* sys-patch username, defined as "SYSPATCH_REPOSITORY", for which sys-patch repository to use. examples: impeeza/sys-patch borntohonk/sys-patch


Credits: [@borntohonk](https://github.com/borntohonk)
license: whichever applicable to whichever files and MIT on whatever else (not that there's anything worth licensing here)