/**
 * @fileoverview Generic entry point for your application. Require your actual
 * application namespace from here and instancite it accordingly.
 *
 * Note that no assumptions are made about your application. However if you
 * want to go with module system and loading indication - those are not
 * handled automatically and you need to use corresponding utilities.
 *
 * @author regardingscot@gmail.com (Peter StJ)
 */

goog.module('app');

// NOTE: we have switched to using module system to improve code
// readability and predictibility.

// NOTE: If you need to use modules (closure compiler modules that is), you need
// to bear in mind that the module calculations are now built with the compiler
// itself rather than the calcdeps script.