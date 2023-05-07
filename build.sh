# Build script to create a clean version of the folder for upload to Curseforge
# NOTE :: Run this by using `zsh build.sh`; DON'T DO THIS `./build.sh`
echo "================================================================"
echo "Running the Curseforge upload/build script for 'mark-item-as'..."
echo "================================================================"

DIR_BASE="${HOME}"
JUGG_WD='jugg-wd' # my gaming PC

if [[ "${HOST}" == *"$JUGG_WD"* ]]; then
   # When running this on Windows, have to use WSL because `zsh` is not available on PowerShell
   WSL_BASE='/mnt/f'
   echo "You're on WSL. Switching the build location base to '${WSL_BASE}'."
   DIR_BASE="${WSL_BASE}"
   echo '——————————————————————————————————————————'
fi

# TODO :: Update this path to dynamically pull the version from the TOC
ADDON_DIR="${DIR_BASE}/Downloads/mark-item-as_v1.0.3"

echo "The current addon dir location is..."
echo $ADDON_DIR
echo '——————————————————————————————————————————'

# Check to see if the downloads folder exists
if [[ ! -d "$ADDON_DIR" ]]; then
   echo "MIA folder does not exist. Creating..."

   if [[ "${HOST}" == *"$JUGG_WD"* ]]; then
      mkdir --parents $ADDON_DIR # this is for WSL
   else
      mkdir -p $ADDON_DIR
   fi

   echo '——————————————————————————————————————————'
fi

# Clone the addon into the downloads folder
echo "Cloning 'mark-item-as' into the Downloads folder..."

if [[ "${HOST}" == *"$JUGG_WD"* ]]; then
   cp --recursive ./ $ADDON_DIR # this is for WSL
else
   cp -R ./ $ADDON_DIR
fi

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
