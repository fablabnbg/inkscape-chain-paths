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


echo ""
echo "****************************************************************"
echo "Windows Version: Needs nsis"
echo "Build Windows Version (Y/n)?"
read answer
if [ "$answer" != "n" ]
then
  echo "Creating Windows installer"
  [ -d wintmp ] && rm -rf wintmp
  mkdir wintmp
  cp -r windows/* wintmp/
  [ -d wintmp/stream ] || mkdir wintmp/stream
  cp -r visicut/* wintmp/stream/
  cat windows/installer.nsi|sed s#VERSION#"$VERSION"#g > wintmp/installer.nsi
  cp ../tools/inkscape_extension/* wintmp/
  cat ../tools/inkscape_extension/visicut_export.py|sed 's#"visicut"#"visicut.exe"#g' > wintmp/visicut_export.py
  pushd wintmp
  makensis installer.nsi > /dev/null || exit 1
  popd
  mv wintmp/setup.exe $name-$VERSION-Windows-Installer.exe || exit 1
  zip $name-$VERSION-Windows-Installer.zip $name-$VERSION-Windows-Installer.exe	# for github upload
  rm -rf wintmp
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

echo "Dir:$(pwd)"
echo "****************************************************************"
echo "Ubuntu Version: For Building you must have checkinstall and dpkg"
echo "and no VisiCut installation may be installed."
echo "Build Ubuntu Version (Y/n)?"
read answer
if [ "$answer" != "n" ]
then
  pushd .
  cp linux/description-pak ../
  cd ..
  # hide doc directory from checkinstall
  # mv doc doctmp
  test -f /usr/bin/visicut && { echo "error: please first uninstall visicut"; exit 1; }
  fakeroot checkinstall --fstrans --reset-uid --type debian --install=no -y --pkgname visicut --pkgversion $VERSION --arch all --pkglicense LGPL --pkggroup other --pkgsource "http://visicut.org" --pkgaltsource "https://github.com/t-oster/VisiCut" --pakdir distribute/ --maintainer "'Thomas Oster <thomas.oster@rwth-aachen.de>'" --requires "bash,java-runtime,potrace" make install -e PREFIX=/usr > /dev/null || { echo "error"; exit 1; }
  rm description-pak
  rm -rf doc-pak
  # mv doctmp doc
  popd
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
