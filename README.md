IBFrameFind
===========

An XML Parser used to extract the frame values from Apple Interface Builder Files.

Usage:

./IBFrameFind fileOne.xib fileTwo.xib ...

IBFrameFind then parses out the frame values from thre xib files and prints them out in copy and paste ready format:

--- fileOne.xib ---

_myFirstView.frame = CGRectMake(x, y, width, height);
_mySecondView.frame = CGRectMake(x, y, width, height);

--- fileTwo.xib ---

...

Note that the view's name is determined by the "Xcode specific label" set in the xib file. If this is not set then then the view will be flagged as un-names and will be printed:

(NO_NAME)tabelView.frame = ...
