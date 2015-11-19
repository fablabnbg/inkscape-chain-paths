#!/bin/bash
echo "Determining Version:"
VERSION=$(echo '<xml/>' | env LC_ALL=C python ../chain_paths.py --version /dev/stdin)
echo "Version is: \"$VERSION\""
name=chain-paths
if [ -d $name ]
then
	echo "Removing leftover files"
	rm -rf name
fi
echo "Copying content..."
mkdir $name
cp ../README.md $name/README
cp ../LICENSE* $name/
mkdir -p $name/inkscape_extension
cp ../*.py $name/
cp ../*.inx $name/


echo "****************************************************************"
echo "Ubuntu Version: For Building you must have checkinstall and dpkg"
echo "and no VisiCut installation may be installed."
echo "Build Ubuntu Version (Y/n)?"
read answer
if [ "$answer" != "n" ]
then
  (cd deb && ./dist.sh $name $VERSION ..)
fi



echo ""
echo "****************************************************************"
echo "Windows Version: Needs nsis"
echo "Build Windows Version (Y/n)?"
read answer
if [ "$answer" != "n" ]
then
  (cd windows && ./dist.sh $name $VERSION ..)
fi


echo ""
echo "****************************************************************"
echo "Mac OS Version: Building the Mac OS Version should work on all platforms"
echo "Build Mac OS Version (Y/n)?"
read answer
if [ "$answer" != "n" ]
then
  echo "Creating Mac OS Bundle"
  [ -d VisiCut.app ] && rm -rf VisiCut.app
  cp -r "mac/VisiCut.app" .
  mkdir -p "VisiCut.app/Contents/Resources/Java"
  cp -r visicut/* "VisiCut.app/Contents/Resources/Java/"
  echo "Updating Bundle Info"
  cp "VisiCut.app/Contents/Info.plist" .
  cat Info.plist|sed s#VISICUTVERSION#"$VERSION"#g > VisiCut.app/Contents/Info.plist
  rm Info.plist
  echo "Compressing Mac OS Bundle"
  rm -rf VisiCutMac-$VERSION.zip
  zip -r VisiCutMac-$VERSION.zip VisiCut.app > /dev/null || exit 1
  echo "Cleaning up..."
  rm -rf VisiCut.app
fi

echo "Dir: $(pwd)"
echo "****************************************************************"
echo "Arch Linux Version: For Building you must have pacman installed."
echo "Build Arch Linux Version (Y/n)?"
read answer
if [ "$answer" != "n" ]
then
  cd linux
  ARCHVERSION=$(echo $VERSION|sed "s#-#_#g")
  cat PKGBUILD | sed "s#pkgver=VERSION#pkgver=$ARCHVERSION#g" > PKGBUILD-tmp
  makepkg -p PKGBUILD-tmp > /dev/null || exit 1
  mv *.pkg.tar.xz ../
  echo "Cleaning up..."
  rm -rf src pkg PKGBUILD-tmp
  cd ..
fi

echo "Cleaning up..."
rm -rf visicut  
echo "done."
