sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install apache2 curl lib32gcc1 lib32stdc++6 lib32tinfo5 screen nodejs -y    
gmodpath=$(pwd)
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz
chmod +x steamcmd.sh
./steamcmd.sh +login anonymous +force_install_dir gmod +app_update 4020 validate +force_install_dir css +app_update 232330 validate +quit
echo '#!/bin/sh
gamemode="sandbox"
map="gm_construct"
tickrate="45"
maxplayers="16"
echo "Starting gmod server!"
screen -A -m -d -S gmod ./srcds_run -game garrysmod -tickrate $tickrate +maxplayers $maxplayers +gamemode $gamemode +map $map
echo "gmod server has been started"
echo "To connect to console : screen -x gmod"' > $gmodpath/gmod/run.sh
chmod +x $gmodpath/gmod/run.sh
mv $gmodpath/gmod/garrysmod/cfg/mount.cfg $gmodpath/gmod/garrysmod/cfg/mount_original.cfg
echo '//
// Use this file to mount additional paths to the filesystem
// DO NOT add a slash to the end of the filename
//

"mountcfg"
{
	 "cstrike"	"'$gmodpath'/css/cstrike"
	// "tf"			"C:\mytf2server\tf"
}' > $gmodpath/gmod/garrysmod/cfg/mount.cfg
echo "const fs = require('fs');

var downloadFilePath = __dirname+'/lua/autorun/server/download.lua';

var gamemodeId = '';

var mapId = '';

if (fs.existsSync(downloadFilePath)) { fs.unlinkSync(downloadFilePath); }

fs.readdirSync(__dirname+'/addons').forEach((addon) => {
    if (addon[0] !== '.') {
        var addonSplit = addon.split('_');
        var workshopId = addonSplit[addonSplit.length - 1];
        if (/^\d+$/.test(workshopId)) {
            fs.appendFileSync(downloadFilePath, 'resource.AddWorkshop("' + workshopId + '")\n');
        }
    }
});

if (gamemodeId !== '') fs.appendFileSync(downloadFilePath, 'resource.AddWorkshop("' + gamemodeId + '")\n');
if (mapId !== '') fs.appendFileSync(downloadFilePath, 'resource.AddWorkshop("' + mapId + '")\n');

console.log('All addons added !');">$gmodpath/gmod/garrysmod/fastDl.js
mkdir $gmodpath/gmod/garrysmod/disabled_addons