#!/bin/sh

NAME="bipscript"
#VERSION=$(date +%s)
#VERSION=$(date +%Y-%m-%d-%H%M%S)
VERSION="v0.18"

test -d $NAME/DEBIAN || mkdir -p $NAME/DEBIAN
cat <<EOF > $NAME/DEBIAN/control
Source: $NAME
Section: unknown
Priority: extra
Maintainer: Basil Stotz <stotz@amxa.ch>
Package: $NAME
Version: $VERSION 
Architecture: amd64
Depends: 
Description: Audio scripting interpreter based on squirell
 Audio scripting interpreter based on squirell
EOF

cat <<EOF > $NAME/DEBIAN/copyright
Copyright: 2021 Basil Stotz <stotz@amxa.ch>
License: GPL-3+
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version. 
.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
.
You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

ATTRIBUTION

Much appreciation to the following projects for the use of their code:

* abcmidi release abcMIDI-2016.05.05 (C) 1999 James Allwright
  Many thanks also to current maintainer Seymour Shlien

* ABCp release abcp060127 Copyright (C) 2005 by Remo Dentato

* Ableton Link Copyright (c) 2016 Ableton AG, Berlin

* BTrack release 1.0.4 Copyright (c) 2014 Queen Mary University of London
  by Adam Stark, Matthew Davies and Mark Plumbley

* Ebu128LoudnessMeter Copyright (c) 2018 Klangfreund, Samuel Gaehwiler

* Miniz release 2.2.0 Copyright 2013-2014 RAD Game Tools and Valve Software
  Copyright 2010-2014 Rich Geldreich and Tenacious Software LLC

* Steev's MIDI Library Copyright (c) 1998-2010, Steven Goodwin

* Squirrel release 3.2 Copyright (c) 2003-2022 Alberto Demichelis

* 'A tiny MML parser' release 0.5.0 Copyright (c) 2014-2015 Shinichiro Nakamura

* tlsf version 3.1 Copyright (c) 2006-2016, Matthew Conte

* vst3sdk Copyright (c) 2021, Steinberg Media Technologies GmbH

original bipscript code Copyright (c) 2015-2022 John Hammen
EOF

dpkg-deb -b $NAME .


exit 0



