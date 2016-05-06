/**
 * @fileoverview Provides the actual starting module for the app.
 * The main logic will be hodted here.
 *
 * @author PeterStJ (regardingscot@gmail.com)
 */
goog.provide('b_init');

goog.require('app');
goog.require('goog.functions');
goog.require('goog.module.ModuleLoader');
goog.require('goog.module.ModuleManager');

b_init = function() {
  // Wait for the rendering to kick off.
  setTimeout(function() {
    // Configure modules.
    var mm = goog.module.ModuleManager.getInstance();
    var ml = new goog.module.ModuleLoader();
    mm.setLoader(ml);
    mm.setAllModuleInfo(goog.global['MODULE_INFO']);
    mm.setModuleUris(goog.global['MODULE_URIS']);

    // Tell module manager that the scaffold module and the main app modules are
    // loaded
    mm.setLoaded('a');
    mm.setLoaded('b');

    console.log('Code executed in second module');

    // Start loading third module...
    mm.execOnLoad('c', function() {
      console.log('The third module has been loaded...');
    });
  }, 10);
};

b_init();
