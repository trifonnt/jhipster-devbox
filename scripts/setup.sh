#!/bin/sh

# update the system
export DEBIAN_FRONTEND=noninteractive
apt-mark hold keyboard-configuration
apt-get update
apt-get -y upgrade
apt-mark unhold keyboard-configuration

################################################################################
# Install the mandatory tools
################################################################################

# install utilities
apt-get -y install vim git zip bzip2 fontconfig curl language-pack-en

# @Trifon - Additional utilities (MidnightCommander, wget)
apt-get -y install mc wget

# @Trifon - Time zone(UTC+2)
ln -fs /usr/share/zoneinfo/Europe/Sofia /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

# @Trifon - NTP
apt-get install ntp

# install Java 8
#apt-get install openjdk-8-jdk

# install Java 11
apt-get -y install openjdk-11-jdk

# install Node.js
wget https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.gz -O /tmp/node.tar.gz
tar -C /usr/local --strip-components 1 -xzf /tmp/node.tar.gz

# update NPM
npm install -g npm

# install Yarn
npm install -g yarn
su -c "yarn config set prefix /home/vagrant/.yarn-global" vagrant

# install Yeoman
npm install -g yo

# install JHipster
npm install -g generator-jhipster@6.9.1

# install JHipster UML
npm install -g jhipster-uml@2.0.3

################################################################################
# Install the graphical environment
################################################################################

# force encoding
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment

# run GUI as non-privileged user
echo 'allowed_users=anybody' > /etc/X11/Xwrapper.config

# install Ubuntu desktop and VirtualBox guest tools
apt-get install -y xubuntu-desktop virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# @Trifon - https://techpiezo.com/linux/switch-display-manager-in-ubuntu-20-04/
apt install -y lightdm

# remove light-locker (see https://github.com/jhipster/jhipster-devbox/issues/54)
apt-get remove -y light-locker --purge

# change the default wallpaper
#wget https://jhipster.github.io/images/wallpaper-004-2560x1440.png -O /usr/share/xfce4/backdrops/jhipster-wallpaper.png
wget https://raw.githubusercontent.com/jhipster/jhipster-devbox/master/images/jhipster-wallpaper.png -O /usr/share/xfce4/backdrops/jhipster-wallpaper.png
sed -i -e 's/xubuntu-wallpaper.png/jhipster-wallpaper.png/' /etc/xdg/xdg-xubuntu/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

################################################################################
# Install the development tools
################################################################################

# install Ubuntu Make - see https://wiki.ubuntu.com/ubuntu-make
apt-get install -y ubuntu-make

# install Chromium Browser
apt-get install -y chromium-browser

# install MySQL Workbench
apt-get install -y mysql-workbench

# install PgAdmin
apt-get install -y pgadmin3

# install Heroku toolbelt
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# install Guake
apt-get install -y guake
cp /usr/share/applications/guake.desktop /etc/xdg/autostart/

# @Trifon
# install jhipster-devbox
git clone git://github.com/trifonnt/vagrant-jhipster-devbox.git /home/vagrant/jhipster-devbox
chmod +x /home/vagrant/jhipster-devbox/tools/*.sh

# install zsh
apt-get install -y zsh

# install oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
chsh -s /bin/zsh vagrant
echo 'SHELL=/bin/zsh' >> /etc/environment

# install jhipster-oh-my-zsh-plugin
git clone https://github.com/jhipster/jhipster-oh-my-zsh-plugin.git /home/vagrant/.oh-my-zsh/custom/plugins/jhipster
sed -i -e "s/plugins=(git)/plugins=(git docker docker-compose jhipster)/g" /home/vagrant/.zshrc
echo 'export PATH="$PATH:/usr/bin:/home/vagrant/.yarn-global/bin:/home/vagrant/.yarn/bin:/home/vagrant/.config/yarn/global/node_modules/.bin"' >> /home/vagrant/.zshrc

# change user to vagrant
chown -R vagrant:vagrant /home/vagrant/.zshrc /home/vagrant/.oh-my-zsh

# install Visual Studio Code
su -c 'umake ide visual-studio-code /home/vagrant/.local/share/umake/ide/visual-studio-code --accept-license' vagrant

# fix links (see https://github.com/ubuntu/ubuntu-make/issues/343)
sed -i -e 's/visual-studio-code\/code/visual-studio-code\/bin\/code/' /home/vagrant/.local/share/applications/visual-studio-code.desktop

# disable GPU (see https://code.visualstudio.com/docs/supporting/faq#_vs-code-main-window-is-blank)
sed -i -e 's/"$CLI" "$@"/"$CLI" "--disable-gpu" "$@"/' /home/vagrant/.local/share/umake/ide/visual-studio-code/bin/code

# @Trifon
# install IDEA community edition
#su -c 'umake ide idea /home/vagrant/.local/share/umake/ide/idea' vagrant

# @Trifon - Sublime Editor
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
apt-add-repository "deb https://download.sublimetext.com/ apt/stable/"
apt install sublime-text

# @Trifon - Install PyCharm
snap download pycharm-community
snap ack pycharm-community_240.assert
snap install pycharm-community_240.snap --classic

# @Trifon - Install Eclipse STS IDE
wget https://download.springsource.com/release/STS4/4.6.2.RELEASE/dist/e4.15/spring-tool-suite-4-4.6.2.RELEASE-e4.15.0-linux.gtk.x86_64.tar.gz -O /home/vagrant/.local/share/umake/ide/spring-sts-4.6.2.tar.gz
mkdir /home/vagrant/.local/share/umake/ide/spring-sts
mkdir /home/vagrant/.local/share/umake/ide/spring-sts/4.6.2
tar -zxvf /home/vagrant/.local/share/umake/ide/spring-sts-4.6.2.tar.gz -C /home/vagrant/.local/share/umake/ide/spring-sts/4.6.2 --strip-components=1

echo "[Desktop Entry]" > /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Version=1.0" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Type=Application" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Name=Spring STS-4.6.2" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Icon=/home/vagrant/.local/share/umake/ide/spring-sts/4.6.2/icon.xpm" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Exec=\"/home/vagrant/.local/share/umake/ide/spring-sts/4.6.2/SpringToolSuite4\" %f" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Comment=Spring STS IDE" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Categories=Development;IDE;" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Terminal=false" >> /home/vagrant/.local/share/applications/spring-sts.desktop


# increase Inotify limit (see https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit)
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-inotify.conf
sysctl -p --system

# install latest Docker
curl -sL https://get.docker.io/ | sh

# install latest docker-compose
curl -L "$(curl -s https://api.github.com/repos/docker/compose/releases | grep browser_download_url | grep Linux | grep -v sha256 | head -n 1 | cut -d '"' -f 4)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# configure docker group (docker commands can be launched without sudo)
usermod -aG docker vagrant

# fix ownership of home
chown -R vagrant:vagrant /home/vagrant/

# Enable reading of shared folders by "vagrant" user in VirtualBox VM
adduser vagrant vboxsf

# clean the box
apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY
