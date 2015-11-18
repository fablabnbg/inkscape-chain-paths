inkscape-chain-paths
===================

An inkscape extension to combine paths. Like really combining path snippets
into longer paths. The stock inkscape path operation "combine" does not do that.
It only creates a single path object consisting of multiple distinct segments.

Many comercial CAD packages create object contours consisting of separate path snippets using adjacent end points. Such objects cannot be used in path operations like "add", "intersect", "difference", as they are technically a set of objects, rather than a single stroke.

This extension forms a longer path from multiple shorter path segments. It is irrelevant if the path segments are separate path objects in inkscape, or if the path segments belong to the same path object.
If two path segments have an end point in common, or if their end points are close together, they are linked together to form a longer path.  It is optional weather the linking end points meld into a single common point, or if an optional straight line ('chain link') fills the gap, if any. The maximum distance for end points is a user setting. Usually a fraction of a millimeter works fine.


Usage
-----
Select multiple pathlike objects. If the status line shows you different object types,
then use "Path -> Object to Path". This is needed as we operate only on paths only. 
Then select "Extensions -> Chain Paths" to open the settings dialog.
You can choose the maximum endpoint distance for path ends to be linked, and the combination method: snap the points together, or create a linking path segment.

Paths never fork. This means, that if there are three or more path ends at the same location, only two are chained together. The others are left unchanged.


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
* Download https://github.com/fablabnbg/inkscape-chain-paths/archive/master.zip
* Navigate to your Downloads folder and double-click on **inkscape-chain-paths-master.zip**
* Download and install the free test version of **winzip** from http://www.winzip.com, if needed.
* Click open the **inkscape-chain-paths-master** folder.
* Select the following two items (with Ctrl-Click): **chain_paths.inx**, and **chain_paths.py**
* Extract to My Computer **C:\Program Files\Inkscape\share\extensions**


Mac OS X (untested)
* ~/.config/inkscape/extensions/ or
*  /Applications/Inkscape.app/Contents/Resources/extensions/ .



