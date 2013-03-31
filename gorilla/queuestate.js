define(function(require) {
  var zoe = require('zoe');

  return {
    _extend: {
      '_queueStates': 'ARR_APPEND'
    },
    _implement: zoe.Constructor,
    _queueStates: [],
    _built: function() {
      for (var i = 0; i < this._queueStates.length; i++) (function(i) {
        var fnName = this._queueStates[i];
        var fn = this.prototype[this._queueStates[i]];
        this.prototype[this._queueStates[i]] = function() {
          if (this._queueNext) {
            this._queueNext = {
              fn: fnName,
              args: arguments
            };
          }
          else {
            this._queueNext = true;
            fn.apply(this, arguments);
          }
        }
      }).call(this, i);
    },
    prototype: {
      popQueue: function() {
        var queueNext = this._queueNext;
        delete this._queueNext;
        if (typeof queueNext != 'object')
          return;
        this[queueNext.fn].apply(this, queueNext.args);
      }
    }
  };
});