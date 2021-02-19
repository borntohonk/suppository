If you have any inquiries; I can be reached at discord borntohonk#9099

how to obtain: git clone https://github.com/borntohonk/suppository.git --recurse-submodules

how to use: sh check.sh

check.sh will check if there's a need to rebase, and if there is a reason to, it will rebase against the commit declared in the filename of the latest release from Atmosphere-NX/Atmosphere, then check the hash of the locally built file to see if it matches the forks hash; do nothing if it matches; re-build if it doesn't match and then attempt to run publish.sh which will publish an automated release. (scenarios where it might not match include: new Atmosphere-NX/Atmosphere release, or a "stealth-update")

It currently will automatically rebase, then build and publish a release of the fork it's targeting, if needed utilizing the github api.

This repository is called suppository. It's purpose is auto-rebase against atmosphere's latest release, and rebuild a new copy if it detects a change was made to the fork it's directed at, and then attempt to publish a release automatically. It also contains minor tweaks to the output of atmosphere, such as including nifm_ctest patches that enable connecting to local network without passing the ctest check.

You can fork suppository and alter the values defined in check.sh, build.sh and publish.sh to make adustments. (and obviously the submodule)

For publishing you're going to want to put your github api personal token under .ghtoken and have it set up as GH_TOKEN_PATH in i.e. .bashrc


Payload.bin within the resulting release archive is "Lockpick_RCM" forked and altered to boot "/atmosphere/reboot_payload.bin" instead of deriving keys. It's basically just used as a chainloader, to remove the need to flash dongle/ update payload on phone on rekado, etc.
---

pre-requisites: 
* must atleast be able to compile Atmosphere
* must be able to use a text-editor (at very least) to make alterations to deploy other forks. 
* maybe be on linux, not that I care if you aren't.
* have a path for "SEPT_SECONDARY_BIN_PATH" similar to that of the path for the .enc's that atmosphere require for building (this done to have people not nag about sept-secondary.bin being 0kb despite it not being used by atmosphere at all)
* have a path for "GH_TOKEN_PATH", with the contents of your github api token, with permissions for managing repositories.

---
credits: me (@borntohonk)
license: whichever applicable to whichever files and MIT on whatever else (not that there's anything worth licensing here)
