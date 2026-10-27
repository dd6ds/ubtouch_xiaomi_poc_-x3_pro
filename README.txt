sha256sum -c vayu-ubuntu-touch-24.04-flashkit.tar.zst.sha256
zstd -dc --long=27 vayu-ubuntu-touch-24.04-flashkit.tar.zst | tar -xf -
cd vayu-ubuntu-touch-24.04-flashkit && ./flash.sh
