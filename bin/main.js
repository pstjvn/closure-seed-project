var fs = require('fs');

var file = fs.readFileSync(__dirname + '/../build/moddeps.js', 'utf8');
var json = JSON.parse(file);

var buf = '';

// Module deps
buf += 'var MODULE_INFO = {'
json.forEach(function(item, index, arr) {
  buf += ('\'' + item.name + '\': [');
  item.dependencies.forEach(function(dep, i, a) {
    buf += '\'' + dep  + '\'';
    if (i < a.length - 1) buf += ', ';
  });
  buf += ']';
  if (index < arr.length - 1) {
    buf += ', ';
  }
});
buf += '};\n';

// modules urls
buf += 'var MODULE_URIS = {';
json.forEach(function(module, index, list) {
  buf += ('\'' + module.name + '\': [');
  module.inputs.forEach(function(dep, i, a) {
    if (dep.indexOf('cssmap') == -1) {
      buf += '\'' + dep  + '\'';
      if (i < a.length - 1) buf += ', ';
    }
  });
  buf += ']';
  if (index < list.length - 1) {
    buf += ', ';
  }
});
buf += '};\n';

fs.writeFileSync(__dirname + '/../build/moddepssource.js', buf);

