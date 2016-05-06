/**
 * @fileoverview The namespace is provided only to test the seed project.
 *
 * @author PeterStJ (regardingscot@gmail.com)
 */
goog.provide('seedtest');

goog.require('goog.events');
goog.require('pstj.app.worker');


goog.events.listen(pstj.app.worker.getInstance(), goog.events.EventType.MESSAGE, function(e) {
  console.log('Test worker', e.data);
});

pstj.app.worker.getInstance().send('test 123');
