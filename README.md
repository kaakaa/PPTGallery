PPTGallery
==========

This app is slide gallery.

When you upload .ppt file, this covert that to pdf file and create link to the pdf file.


USAGE
-----

Firstly, start OpenOffice.org in listening mode on port 8100
```
soffice -headless -accept="socket,port=8100;urp;"
```

Then, git clone PPTGallery sources.
```
git clone https://github.com/kaakaa/PPTGallery.git
```

Next, type follow command.

```
bundle install --path vendor/bundle
bundle exec rackup config.ru
```

And then you access localhost:9292

REQUIREMENTS
------------

This app use [JODConverter | Art of Solving](http://www.artofsolving.com/opensource/jodconverter "JODConverter | Art of Solving") and .
So NEED to install [Apache OpenOffice](http://www.openoffice.org/ja/ "Apache OpenOffice").

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
