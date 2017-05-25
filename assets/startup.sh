#!/bin/sh

#Check if Webgrab++ config file exists in config folder. Copy to config if not existing.
if [ ! -f /config/WebGrab++.config.xml ]; then
  cp /webgrab/assets/WebGrab++.config.xml /config/
fi

#Check if mdb folder exists in config folder. Copy to config if not existing.
if [ ! -d /config/mdb ]; then
  cp -R /webgrab/mdb /config/ && rm -f /config/mdb/*.example.xml
fi

#Check if rex folder exists in config folder. Copy to config if not existing.
if [ ! -d /config/rex ]; then
  cp -R /webgrab/rex /config/ && rm -f /config/rex/*.example.xml
fi

#Symlink WebGrab++ config
if [ -f /config/WebGrab++.config.xml ]; then
  ln -s /config/WebGrab++.config.xml /webgrab/WebGrab++.config.xml
fi

#Symlink MDB config
if [ -f /config/mdb.config.xml ]; then
  rm -f /webgrab/mdb/
  ln -s /config/mdb /webgrab/mdb
fi

#Symlink REX config
if [ -f /config/rex.config.xml ]; then
  rm -f /webgrab/rex/
  ln -s /config/rex /webgrab/rex
fi

#Create log file if it doesn't exist
if [ ! -f /data/WebGrab++.log.txt ]; then
  touch /data/WebGrab++.log.txt && chown nobody /data/WebGrab++.log.txt
fi

#Symlink log file
ln -sf /data/WebGrab++.log.txt /webgrab/WebGrab++.log.txt

#Check if user modified cron file exists and move to wg++.
if [ -e /config/mycron ]; then
  crontab -u nobody /config/mycron
fi

#Change owner for config files and guide.xml
chown -R nobody:users /config
chown -R nobody:users /data

#Start an update on container start if config file exist
if [ -f /config/WebGrab++.config.xml ]; then
  sudo -u nobody /webgrab/run.sh
fi
