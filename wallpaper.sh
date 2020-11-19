#!/bin/bash

randomwallpaper() {
    CLIENT_ID=Mb_R6GjeSv-klOZJrhJhQf1mEIqDms0KXnE3WQRvc0I
    URL=https://api.unsplash.com/photos/random/?client_id=$CLIENT_ID
    BASE_DIR=$HOME/.randomwallpaper


    #checking http status
    echo "Checking connectivity status ⏳" 

    curl $URL 2> $BASE_DIR/error.log
    clear

    if [ -s $BASE_DIR/error.log ]
        then 
            echo "You are not connected to the internet 🚀"
            cat < /dev/null > $BASE_DIR/error.log
            exit 1
    fi


    STATUS=`curl -s -I $URL | grep HTTP/2 | awk '{print $2}'`

    if [ $STATUS -ne 200 ]
        then
            echo "❌"
            echo  "An error occured a status of $STATUS was received."
            exit 1
    fi

    # making app data folder and changing directory

    if [ -d $BASE_DIR ]
        then
            rm -rf $BASE_DIR
    fi

    mkdir $BASE_DIR
    cd $BASE_DIR

    # downloading the json data
    echo "Fetching random image from the web 🏃"
    curl -s -o response.json $URL

    # checking if json helper library exists on device
    if ! command -v jq > /dev/null
        then
            sudo apt install jq
    fi

    IMAGE_URL=`jq -r ".urls.full" $BASE_DIR/response.json`

    # downloading image
    echo "Downloading random image ⏳"
    curl -s -o $BASE_DIR/wallpaper.jpg $IMAGE_URL

    # setting wallpaper
    echo "Setting wallpaper 😁"
    gsettings set org.gnome.desktop.background picture-uri $BASE_DIR/wallpaper.jpg

    echo "Done ✅"
}

randomwallpaper