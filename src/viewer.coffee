`import Listener from './listener.coffee'`
`import $ from '../node_modules/jquery/dist/jquery';`

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
      @translation = [
        @translation[0] + translation[0],
        @translation[1] + translation[1]
      ]
      # console.log @translation
      # $('h1').html(@scale)

      center = @barycentre(@last_touches)
      # if @scale != 1
      # @$items[1].css(
      #   'transform-origin',
      #   @barycentre(@position[0], @position[1]).join('px ') + 'px'
      # )
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
  # distance: (p)->
  #   Math.sqrt(p[0]*p[0]+p[1]*p[1])
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

`export default Viewer`
