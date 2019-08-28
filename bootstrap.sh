#!/bin/bash

mkdir -p ./volumes/data

if [[ ! -d ./volumes/keys ]]; then
  mkdir -p ./volumes/keys
  ssh-keygen -N '' -C share -t ed25519 \
    -f ./volumes/keys/hostkey-ed25519 < /dev/null
  ssh-keygen -N '' -C share -t rsa -b 4096 \
    -f ./volumes/keys/hostkey-rsa < /dev/null
fi

if [[ ! -f ./volumes/users ]]; then
  touch ./volumes/users
  password="$(pwgen 32 -N 1)"
  encrypted_password="$(echo $password | \
    makepasswd --crypt-md5 --clearfrom=- | \
    awk '{print $2}')"
  echo -e "user:$encrypted_password:e:1001" > ./volumes/users
  echo -e "$password" > ./volumes/passwd
fi

if [[ ! -d ./volumes/autostart ]]; then
  mkdir -p ./volumes/autostart
fi

if [[ ! -f ./volumes/autostart/cron.sh ]]; then
  cp ./cron.sh.sample \
    ./volumes/autostart/cron.sh
  chmod +x ./volumes/autostart/cron.sh
fi

if [[ ! -f ./volumes/http.conf ]]; then
  cp ./http.conf.sample ./volumes/http.conf
fi
