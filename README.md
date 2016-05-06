# Seed closure project

Use this seed project to kick-start a new closure project of your own.

### What is supported

A lot has been updated to support more modern workflow:

* Support for worker applications
* Dynamic worker loading in development
* Building the worker as compilation target
* Telling the compiler where the build worker will be via define clause is supported
* Modules out of the box
* Automatic module building (based on assumptions that module names are ordered correctly)
* Automatic module compilation with correct inputs
* Automatic module loading in development
* Support for es6

*NOTE: goog.module is not supported correctly by calcdeps, so we cannot use them in modules!!*

### Assumptions

Many assumptions are made about your environment and those should be met for
this to work out of the box. The best way to install all needed dependencies
is to use the [env build script](https://gist.github.com/pstjvn/d15c6ba2c8a2b875b575).
The author of this script uses and supports those, but you can
install what you need manually as well (please see the Makefile in the linked
project for list of required binaries).

The seed project assumes that you are about to build a full featured web
applciation with the following being suported:

* less (for css)
* gss (for class names minification)
* soy templates
* closure library
* pstj library
* closure compiler with advanced mode
* closure compiler modules
* web workers
* json schemas (unofficial extentions!) for your data transfers
* internationalization
* multiple entry points (multiple apps as well as custom build via customized namespaces)

If you need a simpler build environment you might want to look for alternatives
as this project assumes very good knowledge of the build stack: never the less
you can always edit the Makefile and make it match your needs.

License: MIT
