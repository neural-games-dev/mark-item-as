# Build script to create a clean version of the folder for upload to Curseforge
# NOTE :: Run this by using `zsh build.sh`; DON'T DO THIS `./build.sh`
# Test this out on macOS, it works on WSL
echo "================================================================"
echo "Running the Curseforge upload/build script for 'mark-item-as'..."
echo "================================================================"

DIR_BASE="${HOME}"
JUGG_WD='jugg-wd' # my gaming PC

if [[ "${HOST}" == *"$JUGG_WD"* ]]; then
   WSL_BASE='/mnt/f'
   echo "You're on WSL. Switching the build location to '${WSL_BASE}'."
   DIR_BASE="${WSL_BASE}"
   echo '——————————————————————————————————————————'
fi

ADDON_DIR="${DIR_BASE}/Downloads/mark-item-as"

echo "The current addon dir location is..."
echo $ADDON_DIR
echo '——————————————————————————————————————————'

# Check to see if the downloads folder exists
if [[ ! -d "$ADDON_DIR" ]]; then
   echo "MIA folder does not exist. Creating..."
   mkdir --parents $ADDON_DIR
   echo '——————————————————————————————————————————'
fi

# Clone the addon into the downloads folder
echo "Cloning 'mark-item-as' into the Downloads folder..."
cp --recursive ./ $ADDON_DIR
echo '——————————————————————————————————————————'

echo "Switching into the 'mark-item-as' Downloads folder..."
cd $ADDON_DIR || exit
echo '——————————————————————————————————————————'

echo "Removing the Git & IDE settings dirs/files..."
rm -rf .gitignore
rm -rf .git/
rm -rf .github/
rm -rf .idea/
rm -rf .vscode/
rm -rf mark-item-as.code-workspace
echo '——————————————————————————————————————————'

echo "Removing the image files..."
rm -rf Screenshots/
rm -rf mark-item-as-junk-icon.afphoto
rm -rf mark-item-as-logo.jpeg
echo '——————————————————————————————————————————'

echo "Removing additional files & this script..."
rm -rf .DS_store
rm -rf CHANGELOG.md
rm -rf README.md
rm -rf build.sh
echo '——————————————————————————————————————————'

echo "COMING SOON: Creating the zip archive file..."
# TODO :: Figure out how to use the Keka CLI option to zip things up
