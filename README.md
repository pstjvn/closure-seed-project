### Seed closure project

Use this seed project to kick-start a new closure project of your own.

The following assumptions are made about your environment (and if not met
the seed project might not work).

you have the following folder structure:

* /apps/
* /apps/pstj/ -- a copy of the [pstj library](https://github.com/pstjvn/pstj-closure)
* /compiler/ -- here should live a copy of the latest compiler named compiler.jar
* /library/ -- a copy of the [closure library](https://github.com/google/closure-library)
* /stylesheets/ -- a copy of the latest stylesheet jar named closure-stylesheets.jar
* /templates/
* /templates/SoyMsgExtractor.jar
* /templates/SoyToJsSrcCompiler.jar
* /templates/deps.js
* /templates/soyutils.js
* /templates/soyutils_usegoog.js

It is also assumed that you will put this project in the /apps/ directory, next
to the pstj library folder.


java, python, bash and make are all reauired for this to work, code gen also
require nodejs and npm.