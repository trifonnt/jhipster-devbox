#!/bin/sh

# update the system
apt-get update
apt-get upgrade

################################################################################
# Install the mandatory tools
################################################################################

export LANGUAGE='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# install utilities
apt-get -y install vim git zip bzip2 fontconfig curl language-pack-en

# @Trifon - Additional utilities (MidnightCommander, wget)
apt-get -y install mc wget meld gedit

# @Trifon - Time zone(UTC+2)
ln -fs /usr/share/zoneinfo/Europe/Sofia /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

# Install Java 7
#add-apt-repository ppa:openjdk-r/ppa  
#apt-get update   
#apt-get -y install openjdk-7-jdk
# Update alternatives - If necessary
# update-java-alternatives -s java-1.7.0-openjdk-amd64
# Set JAVA_HOME
#echo 'JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64' >> /etc/environment

## Install Java 8 - OpenJDK
#apt-get install openjdk-8-jdk
## Set JAVA_HOME
#echo 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> /etc/environment

## Install Java 8 - Oracle
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections 
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java8-installer
echo 'JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> /etc/environment


# install node.js
curl -sL https://deb.nodesource.com/setup_6.x | bash -
apt-get install -y nodejs unzip python g++ build-essential

# update npm
npm install -g npm

# install yarn
npm install -g yarn
su -c "yarn config set prefix /home/vagrant/.yarn-global" vagrant

# install yeoman grunt bower gulp
su -c "yarn global add yo bower gulp" vagrant

# install JHipster
su -c "yarn global add generator-jhipster@4.5.6" vagrant

# install JHipster UML
su -c "yarn global add jhipster-uml@2.0.3" vagrant

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

add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make

apt-get update
apt-get upgrade

apt install -y ubuntu-make

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

## Gedit
su -c 'mkdir -p /home/vagrant/Desktop' vagrant
echo '[Desktop Entry]
Version=1.0
Name=Gedit
Exec=/usr/bin/gedit %U
Terminal=false
Icon=
Type=Application
Categories=
MimeType=text/html;text/xml;application/xhtml_xml;
Actions=NewWindow;NewPrivateWindow;
[Desktop Action NewWindow]
Name=New Window
Exec=/usr/bin/gedit' > /home/vagrant/Desktop/gedit.desktop
chmod +x /home/vagrant/Desktop/gedit.desktop

# install Visual Studio Code
#su -c 'umake ide visual-studio-code /home/vagrant/.local/share/umake/ide/visual-studio-code --accept-license' vagrant

# fix links (see https://github.com/ubuntu/ubuntu-make/issues/343)
#sed -i -e 's/visual-studio-code\/code/visual-studio-code\/bin\/code/' /home/vagrant/.local/share/applications/visual-studio-code.desktop

# disable GPU (see https://code.visualstudio.com/docs/supporting/faq#_vs-code-main-window-is-blank)
#sed -i -e 's/"$CLI" "$@"/"$CLI" "--disable-gpu" "$@"/' /home/vagrant/.local/share/umake/ide/visual-studio-code/bin/code

# install IDEA community edition
#su -c 'umake ide idea /home/vagrant/.local/share/umake/ide/idea' vagrant

# @Trifon - Install Eclipse STS IDE
wget http://download.springsource.com/release/STS/3.8.4.RELEASE/dist/e4.6/spring-tool-suite-3.8.4.RELEASE-e4.6.3-linux-gtk-x86_64.tar.gz -O /home/vagrant/.local/share/umake/ide/spring-sts-3.8.4.tar.gz
mkdir /home/vagrant/.local/share/umake/ide/spring-sts
tar -zxvf /home/vagrant/.local/share/umake/ide/spring-sts-3.8.4.tar.gz -C /home/vagrant/.local/share/umake/ide/spring-sts --strip-components=1

echo "[Desktop Entry]" > /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Version=1.0" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Type=Application" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Name=Spring STS-3.8.4" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Icon=/home/vagrant/.local/share/umake/ide/spring-sts/sts-3.8.4.RELEASE/icon.xpm" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Exec=\"/home/vagrant/.local/share/umake/ide/spring-sts/sts-3.8.4.RELEASE/STS\" %f" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Comment=Spring STS IDE" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Categories=Development;IDE;" >> /home/vagrant/.local/share/applications/spring-sts.desktop
echo "Terminal=false" >> /home/vagrant/.local/share/applications/spring-sts.desktop

# Install JavaFX Scene Builder
wget http://download.gluonhq.com/scenebuilder/8.4.0/scenebuilder-8.4.0-all.jar
mkdir -p /home/vagrant/.local/share/umake/ide/javafx-scenebuilder/
mv ~/scenebuilder-8.4.0-all.jar /home/vagrant/.local/share/umake/ide/javafx-scenebuilder/

echo '[Desktop Entry]
Version=1.0
Type=Application
Name=JavaFX-SceneBuilder-8.4.0
Icon=/home/vagrant/.local/share/umake/ide/javafx-scenebuilder/icon.xpm
Exec=java -jar /home/vagrant/.local/share/umake/ide/javafx-scenebuilder/scenebuilder-8.4.0-all.jar %U
Terminal=false
Comment=JavaFX Scene Builder
Categories=Development;IDE;
MimeType=text/html;text/xml;application/xhtml_xml;
Actions=NewWindow;NewPrivateWindow;
[Desktop Action NewWindow]
Name=New Window
Exec=java -jar /home/vagrant/.local/share/umake/ide/javafx-scenebuilder/scenebuilder-8.4.0-all.jar' > /home/vagrant/Desktop/SceneBuilder-8.4.0.desktop
chmod +x /home/vagrant/Desktop/SceneBuilder-8.4.0.desktop
su -c 'mkdir -p /home/vagrant/.local/share/applications/' vagrant
su -c 'ln -s /home/vagrant/Desktop/SceneBuilder-8.4.0.desktop /home/vagrant/.local/share/applications/SceneBuilder-8.4.0.desktop' vagrant


# Install Eclipse IDE - via umake
# umake ide eclipse --remove
#su -c 'umake ide eclipse /home/vagrant/.local/share/umake/ide/eclipse' vagrant
#
# Install Eclipse IDE JEE 4.7(Oxygen) - via download
su -c 'mkdir -p /home/vagrant/.local/share/umake/ide' vagrant
cd /home/vagrant/.local/share/umake/ide

su -c 'wget http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/oxygen/1/eclipse-jee-oxygen-1-linux-gtk-x86_64.tar.gz' vagrant
su -c 'tar xvzf eclipse-jee-oxygen-1-linux-gtk-x86_64.tar.gz' vagrant
rm -rf eclipse-jee-oxygen-1-linux-gtk-x86_64.tar.gz
su -c 'mv eclipse 4.7-jee' vagrant
su -c 'mkdir -p eclipse' vagrant
su -c 'mv 4.7-jee eclipse/4.7-jee' vagrant

echo '[Desktop Entry]
Version=1.0
Type=Application
Name=Eclipse-4.7-JEE
Icon=/home/vagrant/.local/share/umake/ide/eclipse/4.7-jee/icon.xpm
Exec=/home/vagrant/.local/share/umake/ide/eclipse/4.7-jee/eclipse %U
Terminal=false
Comment=Eclipse Java EE IDE
Categories=Development;IDE;
MimeType=text/html;text/xml;application/xhtml_xml;
Actions=NewWindow;NewPrivateWindow;
[Desktop Action NewWindow]
Name=New Window
Exec=/home/vagrant/.local/share/umake/ide/eclipse/4.7-jee/eclipse' > /home/vagrant/Desktop/eclipse-4.7-jee.desktop
chmod +x /home/vagrant/Desktop/eclipse-4.7-jee.desktop
su -c 'mkdir -p /home/vagrant/.local/share/applications/' vagrant
su -c 'ln -s /home/vagrant/Desktop/eclipse-4.7-jee.desktop /home/vagrant/.local/share/applications/eclipse-4.7-jee.desktop' vagrant


# increase Inotify limit (see https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit)
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-inotify.conf
sysctl -p --system

# install latest Docker
curl -sL https://get.docker.io/ | sh

# install latest docker-compose
curl -L "$(curl -s https://api.github.com/repos/docker/compose/releases | grep browser_download_url | head -n 4 | grep Linux | cut -d '"' -f 4)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# configure docker group (docker commands can be launched without sudo)
usermod -aG docker vagrant

# fix ownership of home
chown -R vagrant:vagrant /home/vagrant/

# clean the box
apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY
reboot
