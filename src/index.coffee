`import css from './index.sass';`
`import $ from '../node_modules/jquery/dist/jquery';`
window.$ = $
class Listener
  constructor: (@element, @viewer)->
    @$viewer = $(@element)
    @sizes = [ @$viewer.width() * 1.0, @$viewer.height() * 1.0 ]
    @on_down = (e)=>
      @send('down', e)
    @on_up = (e)=>
      @send('up', e)
    @on_move = (e)=>
      @send('move', e)
    @$viewer.on 'touchstart mousedown', @on_down
    @$viewer.on 'touchmove mousemove', @on_move
    @$viewer.on 'touchend mouseup mouseout touchcancel', @on_up
  destroy: ->
    @$viewer.off 'touchstart mousedown', @on_down
    @$viewer.off 'touchmove mousemove', @on_move
    @$viewer.off 'touchend mouseup mouseout touchcancel', @on_up
  send: (type, event)->
    event.preventDefault()
    event.stopPropagation()
    touches = @extract_touches(event)
    # console.log type, touches.join(', ')
    @viewer[type](touches)
  extract_touches: (e)->
    touches = []
    if e.touches?
      return @_touch_cache if e.touches.length == 0
      touches = []
      for i in [0...e.touches.length]
        touch = e.touches[i]
        touches.push([touch.pageX, touch.pageY])
    else
      touches.push([e.pageX, e.pageY])
    for touch, i in touches
      touches[i] = [touch[0] / @sizes[0] * 100.0, touch[1] / @sizes[1] * 100.0]
    touches.push([20, 20]) if e.shiftKey
    touches
    # console.log touches.join(', ')
    @_touch_cache = touches
    @_touch_cache

class Viewer
  constructor: (@_config)->
    @listener = new Listener(@_config.elem, this)
    @$viewer = $(@_config.elem)
    @drag = false
    @destroyed = false

    @touches = []
    @last_touches = []

    @translation = [0, 0]
    @scale = 1.0

    @$viewer_content = @$('.viewer-content')
    @$viewer_background = @$('.viewer-background')

    items = @$('.viewer-container')
    @$items = [$(items[0]), $(items[1]), $(items[2])]

    @index = 0

    @$items[0].css('left', '-100%')
    @$items[2].css('left', '100%')
    @loop_callback = =>
      @loop()
    requestAnimationFrame @loop_callback

  destroy: ->
    @listener.destroy()
    @destroyed = true
    @_config.destroyed(@$viewer[0]) if @_config.destroyed?
  barycentre: (touches)->
    if touches.length == 2
      [a, b] = touches
      [a[0] + (a[0]-b[0])/2.0, a[1] + (a[1]-b[1])/2.0]
    else
      [touches[0][0], touches[0][1]]
  loop: (e)->
    return if @destroyed
    if @drag
      # console.log @touches, @last_touches
      translation = @compute_translation(@touches, @last_touches)
      # console.log 'translation', translation
      @scale += @compute_scale(@touches, @last_touches)
      @translation = [@translation[0] + translation[0], @translation[1] + translation[1]]
      # console.log @translation
      # console.log "#{@touches.length}, #{@last_touches.length} => #{@compute_scale(@touches, @last_touches)}"
      # $('h1').html(@scale)

      center = @barycentre(@last_touches)
      # if @scale != 1
      # @$items[1].css('transform-origin', @barycentre(@position[0], @position[1]).join('px ') + 'px')
      # @$items[1].css('transform', "scale(#{@scale})")

      # jconsole.log @translation
      translatex = -100.0*@index + @translation[0]
      # console.log translatex
      # console.log @scale, translatex, @translation
      @$viewer_content
        .css(
          'transform',
          "scale(#{@scale}) translate(#{translatex}%, #{@translation[1]}%)"
        )
      # console.log "#{translatex}% 50%"
      console.log 'center', center
      @$viewer_content
        .css(
          'transform-origin',
          "#{translatex + center[0]}% #{@translation[1] + center[1]}%"
        )
    @$viewer_background.css(
      'opacity', Math.max(0, 1-(Math.abs(@translation[1]/100.0)))
    )
    @last_touches = @touches
    requestAnimationFrame @loop_callback
  distance: (p)->
    Math.sqrt(p[0]*p[0]+p[1]*p[1])
  down: (@touches)->
    # console.log 'down !'
    @$viewer.removeClass('viewer-annimate')
    # @last_start = Date.now()
    @last_touches = @touches
    @drag = true
  $: (selector)->
    if selector?
      $(selector, @$viewer)
    else
      @$viewer
  set_index: (index)->
    @scale = 1
    @translation = [0, 0]
    @$viewer.addClass('viewer-annimate')
    diff = index - @index
    changes = {}
    switch diff
      when 1
        changes[@index+2] = @$items[0]
      when -1
        changes[@index-2] = @$items[2]
      else
        changes[index-1] = @$items[0]
        changes[index] = @$items[1]
        changes[index+1] = @$items[2]
    for i, $element of changes
      $element.css('left', "#{i*100}%")
      changes[i] = $element[0]
    @index = index
    @_rotate_items(diff)
    positions = []
    for i, item of @$items
      positions[item.index()] = i
    if Object.keys(changes).length > 0 && @_config.callback?
      @_config.callback(changes, positions)
    @drag = false
    @$viewer_content.css('transform', "translate(#{-@index*100}%, 0)")
  _rotate_items: (index)->
    return if index == 0
    @$items[1].css('z-index', 0)
    if index > 0
      @$items.push(@$items.shift())
      @_rotate_items(index - 1)
    else
      @$items.unshift(@$items.pop())
      @_rotate_items(index + 1)
    @$items[1].css('z-index', 1)
  up: (@touches)->
    return unless @drag
    @drag = false
    if Math.abs(@scale-1.0) < 0.01
      if Math.abs(@translation[1]) > 30
        return @destroy()
      if Math.abs(@translation[0]) > 20
        @drag = false
        changes = {}
        if @translation[0] < 0
          @set_index(@index+1)
        else
          @set_index(@index-1)
      else
        @set_index(@index)
    else

  move: (@touches)->
  compute_scale: (a,b)->
    if a.length > 1 and b.length > 1
      d1 = @distance(a[0], a[1])
      d2 = @distance(b[0], b[1])
      2.0 * (d1-d2) / (d1+d2)
    else
      0.0
  distance: (a,b)->
    # console.log 'Distance !'
    # console.log "distance #{a} #{b}"
    x = a[0] - b[0]
    y = a[1] - b[1]
    Math.sqrt(x*x + y*y)
  compute_translation: (a,b)->
    if a.length > 0 and b.length > 0
      [a[0][0] - b[0][0], a[0][1] - b[0][1]]
    else
      [0, 0]
$ ->
  i = 0
  window.v = new Viewer(
    elem: '.viewer'
    callback: (changes, positions)->
      for index, element of changes
        $('p', element).html(index)
    destroyed: (e)->
      $(e).remove()
  )
  v.down([[50,50]])
  setTimeout( ->
    v.move([[45,45]])
    setTimeout( ->
      v.up([[45, 45]])
    , 1000)
  , 1000)
  # $('body').on 'mousemove', ->
  #   console.log 'MOUSE MOVE BODY !'
  # setTimeout(->
  #   v.set_index(30)
  # , 1000)
  # v.$items = [0, 1, 2]
  # v._rotate_items(1)
  # console.log v.$items
