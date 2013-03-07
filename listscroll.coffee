define (require) ->
  require 'css!./titlebar'

  $ = require 'amdquery!morpheus,bonzo'
  $z = require 'zest'

  $z.create [$z.Component],
    render: (o) -> """
    """

    construct: (el, o) ->

    prototype:
      dosomething: