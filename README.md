Docker for Darwin Calendar Server
=================================

This is a Docker build project to run Darwin Calendar Server (calendarserver.org)

DCS is a rich product with a rich set of dependencies. The installation procedure is far from flawless, therefore I 
documented a successful installation with this Dockerfile. It may not encompass all options.

The base image is Centos 7.

Currently this image deploys Calendarserver 6.0. The latest version as of 2015-07-28 is 6.1,
but version 6.1 runs into the problem "from pycalendar.datetime import DateTime/ImportError: 
cannot import name DateTime". I think that it is a bug.

Status: this is a development project. YMMV