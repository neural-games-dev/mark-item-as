# Build script to create a clean version of the folder for upload to Curseforge
echo "================================================================";
echo "Running the Curseforge upload/build script for 'mark-item-as'...";
echo "================================================================";

# Clone the addon into the Desktop folder
echo "Cloning 'mark-item-as' into the desktop folder...";
cp -r ./ ~/Desktop/mark-item-as;

echo "Switching into the 'mark-item-as' desktop folder...";
cd ~/Desktop/mark-item-as;

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

echo "Removing the README, this script file, and other junk...";
rm -rf .DS_store;
rm -rf README.md;
rm -rf build.sh;

echo "COMING SOON: Creating the zip archive file...";
# TODO :: Figure out how to use the Keka CLI option to zip things up
