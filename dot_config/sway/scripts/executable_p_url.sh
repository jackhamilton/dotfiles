#!/bin/sh

DIR="$HOME/.config/sway/wallpapers/"

# Check if sway/wallpapers directory exists, if not create it.
if [ ! -d "$DIR" ]; then
  mkdir -p $DIR
fi

# Wallpaper path
wlpath="$HOME/.config/sway/wallpapers/wallpaper.jpg"
# Lockscreen wallpaper path
lswlpath="$HOME/.config/sway/wallpapers/lockscreen_wallpaper.jpg"
output="*"
baseurl="https://www.bing.com/"

# Get URL for Bing Image Of The Day for Canada
while [ -z $wlurl ]; do
  wlurl=$(curl $baseurl"HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-CA" -s | jq '.images[].url' --raw-output)
done

# Get name for Bing Image of the Day
imageName=$(curl $baseurl"HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-CA" -s | jq '.images[].copyright' --raw-output)

# Save Bing image name
echo $imageName > $HOME/.config/sway/wallpapers/bing_name.txt

# Download and save Bing Image of the Day
hires_wlurl="${wlurl//1920x1080/2560x1440/}"
echo "$baseurl$hires_wlurl"
