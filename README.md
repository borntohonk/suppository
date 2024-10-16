This repository is for the docker container "suppository" which exists as a full toolchain to compile homebrew for the Nintendo Switch.

This container can still be used to compile atmosphere by using the following command, and output the compiled release (release .zip and fusee.bin) it in the directory you run the command from:

Container rebuilt with latest dkp and packages last on: 16th of october 2024.

Current example below is the build instructions that produce atmosphere 1.8.0 (16th of october 2024), note the "haze" and "daybreak" .nro's are made before atmosphere because of issues with paralell thread makes in atmospheres's codebase.

```

docker pull borntohonk/suppository:latest

sudo docker run --name suppository \
 --rm \
 --volume $PWD/.:/out \
 borntohonk/suppository:latest /bin/bash -c \
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

sudo docker run --name suppository \
 --rm \
 --volume $PWD/.:/out \
 borntohonk/suppository:latest /bin/bash -c \
 "cd /build && \
 wget https://github.com/borntohonk/suppository/raw/refs/heads/master/build.sh && \
 wget https://github.com/borntohonk/suppository/raw/refs/heads/master/pack.sh && \
 sh ./build.sh"

```


TODO:
publish working release with git actions



```

If you have any inquiries; file an issue with the github tracker.

pre-requisites: 
* must be able to use a text-editor (at very least) to make alterations to deploy to another repository.
* create a secret in github settings:
* a github token saved in the repository secrets as "GH_TOKEN", with Repo permissions, and Org read/write permissions.

```

Credits: [@borntohonk](https://github.com/borntohonk)
license: whichever applicable to whichever files and MIT on whatever else (not that there's anything worth licensing here)