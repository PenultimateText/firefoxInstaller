#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "You must be run as root so it can access /opt/firefox/ and /usr/share/applications/"
   exit 1
fi

sysArch=linux-`uname -m`

ffDownload=`curl -s  https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US | grep href`
ffDownload=$(echo $ffDownload | cut -d'"' -f2)
ffDownload=${ffDownload/'win32'/$sysArch}
ffDownload=${ffDownload/'Firefox%20Setup%20'/'firefox-'}
ffDownload=${ffDownload/'.exe'/'.tar.bz2'}

echo $ffDownload

wget -O /tmp/FireFox.tar.bz2 $ffDownload
rm -rf /opt/firefox
tar xfj /tmp/FireFox.tar.bz2 -C /opt/
rm-rf /tmp/FireFox.tar.bz2

sudo touch /usr/share/applications/firefox-quantum.desktop

sudo bash -c 'echo "[Desktop Entry]
Version=1.0
Name=Firefox Quantum Web Browser
Comment=Browse the Web
Exec=/opt/firefox/firefox %u
Exec=/opt/firefox/firefox -new-window
xec=/opt/firefox/firefox -private-window
Icon=/opt/firefox/browser/icons/mozicon128.png
Terminal=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Categories=Network;WebBrowser;
X-Desktop-File-Install-Version=0.23" > /usr/share/applications/firefox-quantum.desktop'
