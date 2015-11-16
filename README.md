inkscape-chain-paths
===================

An inkscape extension to combine paths. Like really combining path snippets
into longer paths. The stock inkscape path operation combine does not do that.
It only creates a single path object consisting of multiple distinct segments.

Many comercial CAD packages create object contours consisting of separate path snippets using adjacent end points. Such objects cannot be used in path operations like add, intersect, difference, as they are technically a group of objects, rather than a single stroke object.

This extension stitces path ends together. If one path ends at the same point
where another path starts, these paths are combined into one path.  If path
ends are very close, an optional gap fill ('chain link') can be added to
combine the paths.


Usage
-----
Select multiple objects. If the status line shows you different object types,
then use "Path -> Object to Path". This is needed as we operate only on paths
here. 
Then select "Extensions -> Chain Paths" to open the settings dialog. 
You can choose the maximum endpoint distance for path ends to be combined, and the combination method: snap the points together, or create a linking path segment.

Paths never fork. This means, that if there are three or more path ends at the same loction. Only two are chained together, the others are left unchanged.


Installation
------------

Copy the the folder silhouette and the two files chain_paths.inx and 
chain_paths.py to your computer:

Ubuntu / SUSE
* ~/.config/inkscape/extensions/ or
* /usr/share/inkscape/extensions/

Arch Linux:
* pacman -S inkscape
* git clone https://github.com/fablabnbg/inkscape-chain-paths.git
* cd inkscape-master
* sudo python2 setup.py build && sudo python2 setup.py install
* sudo cp chain_paths.* /usr/share/inkscape/extensions/

Windows (untested): 
* Download and install the free test version of **winzip** from http://www.winzip.com
* Download https://github.com/fablabnbg/inkscape-chain-paths/archive/master.zip
* Navigate to your Downloads folder and double-click on **inkscape-chain-paths-master.zip**
* Click open the **inkscape-chain-paths-master** folder.
* Select the following two items (with Ctrl-Click): **chain_paths.inx**, and **chain_paths.py**
* Extract to My Computer **C:\Program Files\Inkscape\share\extensions**


Mac OS X (untested)
*  /Applications/Inkscape.app/Contents/Resources/extensions/ . 


