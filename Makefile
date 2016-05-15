# a simple makefile to pull a tar ball or to release packages

DEST=/usr/share/inkscape/extensions
TARNAME=inkscape-chain-paths
EXCL=--exclude \*.orig --exclude \*.pyc
ALL=README.md *.png *.sh *.rules *.py *.inx examples misc silhouette
VERSION=$$(echo '<xml/>' | env LC_ALL=C python ./chain_paths.py --version /dev/stdin)

dist:
	cd distribute; sh ./distribute.sh

#install is used by dist.
install:
	mkdir -p $(DEST)
	install -m 755 -t $(DEST) *.py
	install -m 644 -t $(DEST) *.inx

tar_dist_classic: clean
	name=$(TARNAME)-$(VERS); echo "$$name"; echo; \
	tar jcvf $$name.tar.bz2 $(EXCL) --transform="s,^,$$name/," $(ALL)
	grep Version ./*.inx 
	@echo version should be $(VERS)

tar_dist:
	python setup.py sdist --format=bztar
	mv dist/*.tar* .
	rm -rf dist

clean:
	rm -f *.orig */*.orig
