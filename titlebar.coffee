###

TitleBar Component
Allows any content in regions - not a safe component for user options
Should be encapsulated further

Options
-------
  title: region / text string for H1 implied
  left: region
  right: region
###

define (require) ->
  require 'css!./titlebar'

  $ = require 'amdquery!morpheus,bonzo'
  $z = require 'zest'
  QueueState = require './queuestate'

  $z.create [$z.Component, QueueState],
    options:
      title: 'This is a title'
      left: '<button>left</button><button>left2</button><p style="height: 100px;">hi</p>'
      right: '<button>right</button><button>right2</button><p style="height: 100px;">hi</p>'
      tDuration: 500

    className: 'titlebar'
    
    render: """
      <header>
        {`TitleSections`}
      </header>
    """
    TitleSections: TitleSections = 
      load: (o) ->
        if typeof o.title == 'string' && o.title.substr(0, 1) != '@' && o.title.substr(0, 1) != '<'
          o.title = '<h1 class="title">' + $z.esc(o.title, 'htmlText') + '</h1>'
        if o.new then o.new = ' new' else o.new = ''
        
        o.leftHTML = if o.left then """<div class="title-left#{o.new}">{`left`}</div>""" else ''
        o.rightHTML = if o.right then """<div class="title-right#{o.new}">{`right`}</div>""" else ''
      render: (o) -> """
        #{o.leftHTML}
        <div class="title-center#{o.new}">{`title`}</div>
        #{o.rightHTML}
      """

    pipe: ['tDuration']

    construct: (el, o) ->
      @resetState()
      @$el = $(el)

    _queueStates: ['slideLeft', 'slideRight', 'set']

    prototype:
      # side elements fade out
      # center title slides
      # new side elements fade in and slide with old title and new title
      _slide: (newState, right) ->
        titleWidth = @$el.dim().width

        newState.new = true
        $z.render(TitleSections, newState, @el, =>
          newTitleLeft = $('.title-left.new', @el)
          newTitleCenter = $('.title-center.new', @el)
          newTitleRight = $('.title-right.new', @el)

          newTitleLeft.animate(opacity: 1, duration: @o.tDuration)
          @titleLeft.animate(opacity: 0, duration: @o.tDuration)
          
          @titleCenter.css(transform: "translate(0px, 0px)", left: 0, top: 0, position: 'absolute', width: '100%', opacity: 1).addClass('boxsize')

          if right
            @titleCenter.animate(transform: "translate(#{titleWidth}px, 0px)", opacity: 0, duration: @o.tDuration)
            newTitleCenter.css(transform: "translate(-#{titleWidth}px, 0px)")
            newTitleCenter.animate(transform: "translate(0px, 0px)", opacity: 1, duration: @o.tDuration)
          else
            @titleCenter.animate(transform: "translate(-#{titleWidth}px, 0px)", opacity: 0, duration: @o.tDuration)
            newTitleCenter.css(transform: "translate(#{titleWidth}px, 0px)")
            newTitleCenter.animate(transform: "translate(0px, 0px)", opacity: 1, duration: @o.tDuration)

          newTitleRight.animate(opacity: 1, duration: @o.tDuration)
          @titleRight.animate(opacity: 0, duration: @o.tDuration, complete: => 
            newTitleLeft.removeClass('new')
            newTitleCenter.removeClass('new')
            newTitleRight.removeClass('new')
            @resetState()
          )
        )
      resetState: ->
        if (@titleLeft && @titleLeft.length)
          $z.dispose @titleLeft
        if (@titleRight && @titleRight.length)
          $z.dispose @titleRight
        if (@titleCenter)
          $z.dispose @titleCenter

        @titleLeft = $('.title-left', @el)
        @titleCenter = $('.title-center', @el)
        @titleRight = $('.title-right', @el)

        @popQueue()
      
      slideLeft: (newState) ->
        @_slide(newState, false)

      slideRight: (newState) ->
        @_slide(newState, true)

      set: (newState) ->
        $z.dispose(@el.childNodes)
        newState.new = true
        $z.render(TitleSections, newState, @el, => @resetState())
