goog.provide('c_init');

goog.require('goog.module.ModuleManager');

c_init = function() {
  console.log('Code executed in third module');
  goog.module.ModuleManager.getInstance().setLoaded('c');
};

c_init();
