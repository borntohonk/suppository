This repository is for the docker container "suppository" which exists as a full toolchain to compile homebrew for the Nintendo Switch.

This container can still be used to compile atmosphere by using the following command, and output the compiled release (release .zip and fusee.bin) it in the directory you run the command from:

Container rebuilt with latest dkp and packages last on: 22nd of july 2024.

```

docker pull borntohonk/suppository:latest

docker run --name suppository \
 --rm \
 --volume $PWD/.:/out \
 borntohonk/suppository:latest /bin/bash -c \
 "git clone https://github.com/switchbrew/libnx.git && \
 make -C libnx -j$(nproc) && \
 make -C libnx install && \
 git clone https://github.com/Atmosphere-NX/Atmosphere.git && \
 make -C Atmosphere -j$(nproc) && \
 rm Atmosphere/out/nintendo_nx_arm64_armv8a/release/atmosphere*debug*.zip && \
 cp Atmosphere/out/nintendo_nx_arm64_armv8a/release/atmosphere*.zip /out/ && \
 cp Atmosphere/out/nintendo_nx_arm64_armv8a/release/fusee.bin /out/fusee.bin && \
 chown 1000:1000 /out/fusee.bin && \
 chown 1000:1000 /out/atmosphere*.zip"

```

```

If you have any inquiries; file an issue with the github tracker.

pre-requisites: 
* must be able to use a text-editor (at very least) to make alterations to deploy to another repository.
* create a secret in github settings:
* a github token saved in the repository secrets as "GH_TOKEN", with Repo permissions, and Org read/write permissions.

```

Credits: [@borntohonk](https://github.com/borntohonk)
license: whichever applicable to whichever files and MIT on whatever else (not that there's anything worth licensing here)
