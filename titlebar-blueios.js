// Generated by CoffeeScript 1.6.2
(function() {
  define(function(require) {
    var $z, TitleBar;

    require('css!./titlebar-blueios');
    TitleBar = require('./titlebar');
    $z = require('zest');
    return $z.create([TitleBar], {
      className: 'blueios'
    });
  });

}).call(this);
