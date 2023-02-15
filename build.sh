# Build script to create a clean version of the folder for upload to Curseforge
echo "================================================================";
echo "Running the Curseforge upload/build script for 'mark-item-as'...";
echo "================================================================";

ADDON_DIR="${HOME}/Downloads/mark-item-as";
JUGG_WD='jugg-wd'; # my gaming PC

if [[ "$HOST" == *"$JUGG_WD"* ]]; then
   echo "You're on WSL. Switching the build location to '/mnt/f'.";
   ADDON_DIR="/mnt/f/Downloads/mark-item-as";
fi

# Check to see if the desktop folder exists
# if [[ ! -d "$ADDON_DIR" ]]; then
#    echo "MIA folder on desktop does not exist. Creating...";
#    mkdir -p $ADDON_DIR;
# fi

echo "The current addon dir location is...";
echo $ADDON_DIR;

# Clone the addon into the Desktop folder
echo "Cloning 'mark-item-as' into the Downloads folder...";
cp -r ./ $ADDON_DIR;

echo "Switching into the 'mark-item-as' Downloads folder...";
cd $ADDON_DIR || exit;

echo "Removing the Git & IDE settings dirs/files...";
rm -rf .gitignore;
rm -rf .git/;
rm -rf .github/;
rm -rf .idea/;
rm -rf .vscode/;
rm -rf mark-item-as.code-workspace;

echo "Removing the image files...";
rm -rf Screenshots/;
rm -rf mark-item-as-junk-icon.afphoto;
rm -rf mark-item-as-logo.jpeg;

echo "Removing the README & this script file...";
rm -rf .DS_store;
rm -rf README.md;
rm -rf build.sh;

echo "COMING SOON: Creating the zip archive file...";
# TODO :: Figure out how to use the Keka CLI option to zip things up
