#!/bin/bash
cd /build && \
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
sh ./pack.sh