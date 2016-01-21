### Seed closure project

Use this seed project to kick-start a new closure project of your own.

Many assumptions are made about your environment and those should be met for this to work out of the box. The best way to install all needed dependencies is to use the [provioning](https://github.com/pstjvn/closure-env-provisioning) scripts. The author of this seed project uses and supports those, but you can install what you need manually as well (please see the Makefile in the linked project for list of required binaries).

The seed project assumes that you are about to build a full featured web applciation with the following being suported:

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

License: MIT
