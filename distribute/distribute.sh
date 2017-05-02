#!/bin/bash
echo "Determining Version:"
VERSION=$(echo '<xml/>' | env LC_ALL=C python ../chain_paths.py --version /dev/stdin)
grep Version ../*.inx
echo "Version should be: \"$VERSION\""



name=inkscape-chain-paths
if [ -d $name ]
then
	echo "Removing leftover files"
	rm -rf $name
fi
echo "Copying contents ..."
mkdir $name
cp ../README.md $name/README
cp ../LICENSE* $name/
cp ../*.py ../*.inx ../Makefile $name/


echo "****************************************************************"
echo "Ubuntu Version: For Building you must have checkinstall and dpkg"
echo "Build Ubuntu Version (Y/n)?"
read answer
if [ "$answer" != "n" ]
then
  cp -a $name/* deb/files
  rm -f deb/files/setup.py
  (cd deb && sh ./dist.sh $name $VERSION)
fi


echo "Built packages are in distribute/out :"
ls -la out
echo "Cleaning up..."
rm -rf $name
echo "done."
