#!/bin/bash

set -euo pipefail

apt-get install -y --no-install-recommends wine wine64 winetricks msitools winbind

mkdir -p /opt/fontconf
cat << EOF > /opt/fontconf/dummy.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fontconfig.dtd">
<fontconfig>
  <dir>/usr/share/fonts</dir>
</fontconfig>
EOF

if [[ $(uname -m) == "aarch64" ]]; then
  curl -sS "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0xEDB98BFE8A2310DC9C4A376E76DBFEBEA206F5AC" | gpg --dearmor -o /etc/apt/keyrings/fex-emu.gpg
  echo "deb [signed-by=/etc/apt/keyrings/fex-emu.gpg] https://ppa.launchpadcontent.net/fex-emu/fex/ubuntu resolute main" >> /etc/apt/sources.list.d/fex-emu.list
  echo "deb-src [signed-by=/etc/apt/keyrings/fex-emu.gpg] https://ppa.launchpadcontent.net/fex-emu/fex/ubuntu resolute main" >> /etc/apt/sources.list.d/fex-emu.list
  apt-get update
  apt-get install -y --no-install-recommends fex-emu-wine
  path=$(dpkg -L fex-emu-wine | grep -m1 'libwow64fex\.dll$')
  cp $path /usr/lib/aarch64-linux-gnu/wine/aarch64-windows/xtajit.dll
fi
