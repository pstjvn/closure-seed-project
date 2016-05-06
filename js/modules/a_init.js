/**
 * @fileoverview Provides the app schell that will be immediately shown to the
 * users. Note that the subsequent actual app module would provide the
 * actual app code as well as tell the module manager that this one has been
 * loaded.
 *
 * @author PeterStJ (regardingscot@gmail.com)
 */

goog.provide('a_init');

// Require the template used for main app shell / skeleton view
goog.require('app.template');
goog.require('goog.dom');

/** Render the app shell */
a_init = function() {
  console.log('Code executed in initial / scaffold module...');
  document.body.appendChild(
      goog.dom.safeHtmlToNode(app.template.Test(null).toSafeHtml()));
};

a_init();
