define (require) ->
  require 'css!./titlebar-blueios'
  TitleBar = require 'cs!./titlebar'
  $z = require 'zest'

  $z.create [TitleBar],
    className: 'blueios'