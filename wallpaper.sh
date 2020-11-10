#!/bin/bash

randomwallpaper() {
    CLIENT_ID=Mb_R6GjeSv-klOZJrhJhQf1mEIqDms0KXnE3WQRvc0I
    URL=https://api.unsplash.com/photos/random/?client_id=$CLIENT_ID


    #checking http status
    echo "Checking connectivity status" 

    STATUS=`curl -I $URL | grep HTTP/2 | awk '{print $2}'`

    if [ $STATUS -ne 200 ]
        then
            echo "❌"
            printf "An error occured a status of $STATUS was received.\nTry checking your internet connection"
            exit 1
    fi

    # making app data folder and changing directory

    if [ -d "$HOME/.randomwallpaper" ]
        then
            rm -rf $HOME/.randomwallpaper
    fi

    mkdir $HOME/.randomwallpaper
    cd $HOME/.randomwallpaper

    # downloading the json data
    curl -o response.json $URL

    # checking if json helper library exists on device
    if ! command -v jq > /dev/null
        then
            sudo apt install jq
    fi

    IMAGE_URL=`jq -r ".urls.full" $HOME/.randomwallpaper/response.json`

    # downloading image
    curl -o $HOME/.randomwallpaper/wallpaper.jpg $IMAGE_URL

    # setting wallpaper
    gsettings set org.gnome.desktop.background picture-uri $HOME/.randomwallpaper/wallpaper.jpg

    echo "Done ✅"
}

randomwallpaper