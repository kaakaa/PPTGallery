PPTGallery
==========

This app is ppt/pptx gallery on CentOS.

When you upload .ppt or .pptx file, this app coverts it to pdf and slide html.

USAGE
-----

see cookbooks -> [PPTGallery_vagrant](http://github.com/kaakaa/PPTGallery_vagrant.git "PPTGallery_vagrant")

REQUIREMENTS
------------

This app use [JODConverter](http://www.artofsolving.com/opensource/jodconverter "JODConverter") for converting .ppt/.pptx to .pdf and [rmagick](https://github.com/rmagick/rmagick "rmagick") for converting .pdf to .png.
So NEED to install [LibreOffice](http://www.libreoffice.org/ "LibreOffice") and [ImageMagick](http://www.imagemagick.org/script/index.php "ImageMagick").

And JODConverter library requires bellow:
```
 * Java 1.4 or higher
 * OpenOffice.org 2.x or 3.x; the latest stable version (currenty 3.0.1) is generally recommended
```



Licenses
--------

PPTGallery is distributed under the terms of the LGPL.

This basically means that you are free to use it in both open source
and commercial projects.

If you modify the library itself you are required to contribute
your changes back.

(You are free to modify the sample webapp as a starting point for your
own webapp without restrictions.)

PPTGallery includes various third-party libraries so you must
agree to their respective licenses - included in docs/third-party-licenses.
