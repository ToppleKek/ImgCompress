# ImgCompress
Script used for testing different compression methods. Used in the 2018 Rotary Science Fair by yours truly.

##Usage
`ruby img_compress.rb`
Follow the prompts! It's that simple™ (I hope)

##Installation

###Debian (Stretch/Testing/Unstable) GNU/Linux

Install packages:
`sudo apt install build-essential yasm libmagickwand-dev imagemagick libsdl-image1.2-dev cmake libsdl-dev libwebp6 libwebp-dev webp`

Download the libbpg source from here: https://bellard.org/bpg/ and extract it.

Edit `x265/source/CMakeLists.txt` with your favourite text editor (vim, nano, vi, emacs, whatever)

Add `set (CMAKE_CXX_STANDARD 98)` to the top of the file and save.

Return to the root directory.

`make` and `sudo make install`

Enjoy.

###Arch Linux

`sudo pacman -S ruby libwebp libpng`

`sudo pacman -U https://archive.archlinux.org/packages/i/imagemagick/imagemagick-6.9.9.9-5-x86_64.pkg.tar.xz`

libbpg must be either compiled from source or installed from the AUR (Arch User Repository)

From the AUR:
Use an AUR Helper or any other way of installing packages from the AUR. (Ex. trizen)
`trizen -S libbpg`

###macOS
No.

###Windows
Haha good one.

###Gems
To install rmagick:
`gem install rmagick`



