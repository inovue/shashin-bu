sudo apt update -y && sudo apt upgrade -y

# exiftool
sudo apt install exiftool fd

# mozjpeg
sudo apt install cmake autoconf automake libtool nasm make pkg-config
wget https://github.com/mozilla/mozjpeg/archive/refs/tags/v4.1.1.tar.gz &&
	tar xvzf ./v4.1.1.tar.gz &&
	rm -f v4.1.1.tar.gz &&
	cd mozjpeg-4.1.1 &&
	mkdir build && cd build &&
	sudo cmake -G"Unix Makefiles" -DPNG_SUPPORTED=ON ../ &&
	sudo make install && sudo make deb &&
	sudo dpkg -i mozjpeg_4.1.1_amd64.deb &&
	sudo ln -s /opt/mozjpeg/bin/cjpeg /usr/bin/mozjpeg &&
	sudo ln -s /opt/mozjpeg/bin/jpegtran /usr/bin/mozjpegtran &&
	cd ../../ && sudo rm -rf mozjpeg-4.1.1


# shashin-bu
sudo mkdir -p /opt/shashin-bu && 
  sudo rm -f /opt/shashin-bu/compress.sh $HOME/.local/bin/compress.sh && 
  sudo cp compress.sh /opt/shashin-bu/compress.sh &&
  sudo ln -s /opt/shashin-bu/compress.sh $HOME/.local/bin