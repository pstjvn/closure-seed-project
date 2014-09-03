#This makefile assumes you have your tools in a parent directory as follow
# __someparentfoler__
# 	compiler/
# 		compiler.jar
# 	library/
# 		svn checkout of the latest closure library
# 	stylesheets/
# 		cs.jar
# 	templates/
# 		SoyToJsCompiler.jar
# 		soyutils.js
# 		soyutils_usegoog.js
# 	apps/
# 		@yourproject
# 	jsdoc/
# 		plugins/removegoog.js
#
#
# 	Project structure:
# 	/ - list of html files to load. $(NS).html format is preferred.
# 	assets/ - all images and static assets (fonts etc).
# 	build/ - the build files will be put in there.
# 	gss/ - gss source files in this directory will be always included.
# 		common/ - gss source files in this directory will also be always included, but are considered imported from elsewhere (i.e. not project specific)
# 		$(NS)/ - gss sources that are specific to the name space that is being build.
# 	js/ - tree of JavaScript files that will be available to the project (project specific). Could include a sub-module with another project if needed.
# 		templates/ - flat list of soy files to compile.
# 	tpl/ - list of locales that have been built
# 		$(LOCALE)/ - locale specific build of the templates.



# This should match most projects.
APPDIR=$(shell basename `pwd`)

# The default name space to build. Could be modified on the command line.
NS=app

# The directory name to use as a build target directory. All compiled
# JavaScript, CSS and dependency files will be stored there. The directory is
# considered dirty and is ignored by Git.
BUILDDIR=build

# The directory to put translation files in.
I18NDIR=i18n

# Option to localize / internationalize the project. Set to desired locale when
# compiling. The locale is propagated to the closure compiler.
LOCALE=en

# Where the compiled templates should be kept
# Basically we want them out of the build dir as they are not a build result of its own
TEMPLATE_TMP_DIR=tpl/

# The sources of the templates.
TEMPLATES_SOURCE_DIR=templates/

# common libs
PSTJ=../pstj/
SMJS=../smjs/
GCW=../gcw/

# if the build should use goog debug, bu default we want to use debug
DEBUG=true

########################################
# Service variables. Please change those only if you know what you are doing!!!
#######################################
LIBRARY_PATH=../../library/
DEPSWRITER_BIN=$(LIBRARY_PATH)closure/bin/build/depswriter.py
TEMPLATES_PATH=../../templates/
APPS_PATH=apps/
COMPILER_JAR=../../compiler/compiler.jar
EXTERNS_PATH=../../externs/
STYLES_COMPILER_JAR=../../stylesheets/closure-stylesheets.jar
SOY_COMPILER_JAR=../../templates/SoyToJsSrcCompiler.jar
MESSAGE_EXTRACTOR_JAR=../../templates/SoyMsgExtractor.jar
CLOSURE_BUILDER ?= ../../library/closure/bin/build/closurebuilder.py

define newline


endef


define SOURCES
--root=js/ \
--root=$(TEMPLATE_TMP_DIR)/$(LOCALE)/ \
--root=$(PSTJ) \
--root=$(SMJS) \
--root=$(GCW) \
--root=$(TEMPLATES_PATH) \
--root=$(LIBRARY_PATH)
endef

define JSFILES
-f --js=build/deps.js \
-f --js=$(TEMPLATES_PATH)/deps.js \
-f --js=$(PSTJ)/deps.js \
-f --js=$(SMJS)/deps.js \
-f --js=$(GCW)/deps.js
endef


define GITIGNOREFILE
build/
$(TEMPLATE_TMP_DIR)
help/
*sublime-*
endef

# Default build to execute on 'make'.
all: css tpl deps

FILE?=-r js/

lint:
	gjslint  --jslint_error=all --strict --max_line_length 80 \
	-e "vendor,tpl" $(FILE)

################ Application level setups #####################
# write dep file in js/build/
# This should happen AFTER building the templates as to assure the templates
# have all the provides needed for the dependencies.
deps:
	python $(DEPSWRITER_BIN) \
	--root_with_prefix="js ../../../$(APPS_PATH)$(APPDIR)/js" \
	--root_with_prefix="$(TEMPLATE_TMP_DIR)/$(LOCALE) ../../../$(APPS_PATH)/$(APPDIR)/$(TEMPLATE_TMP_DIR)/$(LOCALE)/" \
	--output_file="$(BUILDDIR)/deps.js"

# Compile template soy files from js/templates/ and put them in tpl/$(LOCALE)/
tpl:
	java -jar $(SOY_COMPILER_JAR) \
	--locales $(LOCALE) \
	--messageFilePathFormat "$(I18NDIR)/translations_$(LOCALE).xlf" \
	--shouldProvideRequireSoyNamespaces \
	--shouldGenerateJsdoc \
	--codeStyle concat \
	--cssHandlingScheme GOOG \
	--outputPathFormat '$(TEMPLATE_TMP_DIR)/$(LOCALE)/{INPUT_FILE_NAME_NO_EXT}.soy.js' \
	$(TEMPLATES_SOURCE_DIR)/*.soy

# Extracts the translation messages from the templates in a file
# Translated file should be used to compile to a different locale.
extractmsgs:
	java -jar $(MESSAGE_EXTRACTOR_JAR) \
	--outputFile "$(I18NDIR)/translations_$(LOCALE).xlf" \
	--targetLocaleString $(LOCALE) \
	$(TEMPLATES_SOURCE_DIR)/*.soy

lessc:
	lessc --no-ie-compat less/$(NS).less > less/$(NS).css

# Create CSS file for name space and put name mapping in js/build/
css: lessc
	java -jar $(STYLES_COMPILER_JAR) \
	`cat options/css.ini | tr '\n' ' '` \
	--output-file $(BUILDDIR)/$(NS).css \
	--output-renaming-map $(BUILDDIR)/$(NS)-cssmap.js \
	less/$(NS).css
	rm less/$(NS).css

cssbuild: lessc
	java -jar $(STYLES_COMPILER_JAR) \
	`cat options/cssbuild.ini | tr '\n' ' '` \
	--output-file $(BUILDDIR)/$(NS).css \
	--output-renaming-map $(BUILDDIR)/cssmap-build.js \
  less/$(NS).css
	rm less/$(NS).css

simple: cssbuild tpl deps
	python2.7 $(LIBRARY_PATH)/closure/bin/build/closurebuilder.py \
	-n $(NS) \
	${SOURCES} \
	${JSFILES} \
	-f --js=build/cssmap-build.js \
	-f --flagfile=options/compile.ini \
	-f --compilation_level=WHITESPACE_ONLY \
	-o script \
	-f --define='goog.LOCALE="$(LOCALE)"' \
	-f --define='goog.DEBUG=$(DEBUG)' \
	-c $(COMPILER_JAR) \
	--output_file=$(BUILDDIR)/$(NS).build.js

compile: cssbuild tpl deps
	python2.7 $(LIBRARY_PATH)/closure/bin/build/closurebuilder.py \
	-n $(NS) \
	${SOURCES} \
	${JSFILES} \
	-f --js=build/cssmap-build.js \
	-f --flagfile=options/compile.ini \
	-o compiled \
	-f --define='goog.LOCALE="$(LOCALE)"' \
	-f --define='goog.DEBUG=$(DEBUG)' \
	-c $(COMPILER_JAR) \
	--output_file=$(BUILDDIR)/$(NS).build.js
	rm $(BUILDDIR)/cssmap-build.js
	echo 'Size compiled: ' `ls -al $(BUILDDIR)/$(NS).build.js`


deploy: compile
	node ../../node/inline.js $(NS)-deploy.html

######################### Debugging and work flow set ups ######################

debug: cssbuild tpl deps
	python2.7 $(LIBRARY_PATH)/closure/bin/build/closurebuilder.py \
	-n $(NS) \
	${SOURCES} \
	${JSFILES} \
	-f --js=build/cssmap-build.js \
	-f --flagfile=options/compile.ini \
	-o compiled \
	-f --define='goog.LOCALE="$(LOCALE)"' \
	-f --define='goog.DEBUG=$(DEBUG)' \
	-f --formatting=PRETTY_PRINT \
	-c $(COMPILER_JAR) \
	-f --debug \
	--output_file=$(BUILDDIR)/$(NS).build.js
	rm $(BUILDDIR)/cssmap-build.js


# Run the compalier against a specific name space only for the checks.
# This includes the templates (so it is compatible with applications and the
# library as well).
#
# To use it with application code replace the first root include to js/
check:
	python2.7 $(CLOSURE_BUILDER) \
	-n $(NS) \
	${SOURCES} \
	${JSFILES} \
	-f --flagfile=options/compile.ini \
	-o compiled \
	-c $(COMPILER_JAR) \
	--output_file=/dev/null

size: compile
	gzip -9  $(BUILDDIR)/$(NS).build.js
	echo '>>>>Comiler size gzipped: ' `ls -al $(BUILDDIR)/$(NS).build.js.gz`
	rm $(BUILDDIR)/$(NS).build.js.gz
	python $(LIBRARY_PATH)/closure/bin/build/closurebuilder.py \
	-n $(NS) \
	${SOURCES} \
	${JSFILES} \
	-f --flagfile=options/compile.ini \
	-o script \
	-f --define='goog.LOCALE="$(LOCALE)"' \
	-f --define='goog.DEBUG=$(DEBUG)' \
	-c $(COMPILER_JAR) \
	--output_file=$(BUILDDIR)/$(NS).build.js
	echo '>>>>Original size: ' `ls -al $(BUILDDIR)/$(NS).build.js`
	gzip -9  $(BUILDDIR)/$(NS).build.js
	echo '>>>>Original size gzipped: ' `ls -al $(BUILDDIR)/$(NS).build.js.gz`
	rm $(BUILDDIR)/$(NS).build.js.gz

#### Calls specific to library development (i.e. no application code) #####

# Provides the deps file for the library, should be available to the compiler to
# provide the types used as parameters but not really required.
libdeps:
	python $(DEPSWRITER_BIN) \
	--root_with_prefix="./ ../../../$(APPS_PATH)$(APPDIR)/" \
	--output_file="deps.js"

.PHONY: tpl css cssbuild deps all compile check
