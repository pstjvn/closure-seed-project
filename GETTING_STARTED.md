# Starting a new project

## I

If you are not expecting to use closure modules (synamic code loading)
you should disable the option in 'Makefile' (line 3 - set to false).

```
use_worker = false
```

## II

If you do not intend to use the JSONScheme code generator of you will
use a different generator (swagger, discovery document or other), set the
dto_prefix to a namespace you are sure you are not going to use, for exmaple

```
dto_prefix = nonexisting
```

## III

By default the project is configured to a be a full fledged web app
and include soy templates, less files, pstj library etc. If you need to
build only JS you might need to change the 'all' target to omit the
targets you ar not insterested in.

If you are not using less/css you need to also remove the dependency on
the css.min.js and cssmap.* files from JS builds.

## IV

Building an app is as simple as typing `make`.
If you left workers enabled the main app as well as the worker will be built.

To build the module app you need to run both: `make && make modulebuild`
This will build the main app (including the worker if used) and then it will
build the modules. It might sound like a redundancy, but the practice shows that
devs usually develop without modules and switch to it at some point, so we build
to allow testing.

Relevant html files with all needed includes are provided to test all possible
scenarios (development, dev with modules, production, production with modules)

*NOTE: currently we do not generate the 'built' modules settings - you need to
update those manually if you have diferent modules than the default.*
