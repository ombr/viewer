import Listener from './listener.coffee'
import Geomtery from './geometry.coffee'
import css from './viewer.sass'

class Viewer
  constructor: (@_config)->
    @listener = new Listener(@_config.elem, this)
    @element = @_config.elem
    @drag = false
    @destroyed = false

    @touches = []
    @last_touches = []

    @translation = [0, 0]
    @scale = 1.0

    @viewer_content = @element.getElementsByClassName('viewer-content')[0]
    @viewer_background = @element.getElementsByClassName('viewer-background')[0]

    @index = 0

    @items = @element.getElementsByClassName('viewer-container')
    @items = [@items[0], @items[1], @items[2]]

    for item in @items
      item.style.display = ''
    @items[0].style.left = '-100%'
    @items[2].style.left = '100%'
    @loop_callback = =>
      @tick()
    requestAnimationFrame @loop_callback

  destroy: ->
    return if @destroyed
    @destroyed = true
    @listener.destroy()
    @element.remove()
  tick: (e)->
    return if @destroyed
    if @drag
      translation = Geomtery.translation(@touches, @last_touches)
      @scale += Geomtery.scale(@touches, @last_touches)
      @translation = [
        @translation[0] - (translation[0]/@scale),
        @translation[1] - (translation[1]/@scale)
      ]
      translatex = -100.0*@index + @translation[0]
      @viewer_content.style.transform =
        "scale(#{@scale}) translate(#{translatex}%, #{@translation[1]}%)"
    @viewer_background.style.opacity =
      Math.max(0, 1-(Math.abs(@translation[1]/100.0)))
    # @$viewer_background.css(
    #   'opacity', Math.max(0, 1-(Math.abs(@translation[1]/100.0)))
    # )
    @last_touches = @touches
    requestAnimationFrame @loop_callback
  down: (@touches)->
    # console.log 'down !'
    @element.classList.remove('viewer-annimate')
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
    @element.classList.add('viewer-annimate')
    diff = index - @index
    # console.log 'set index', index, diff
    changes = []
    if diff != 0
      switch diff
        when 1
          changes.push
            elem: @items[0]
            index: @index + 2
        when -1
          changes.push
            elem: @items[2]
            index: @index - 2
        else
          changes.push
            elem: @items[0]
            index: @index - 1
          changes.push
            elem: @items[1]
            index: @index
          changes.push
            elem: @items[2]
            index: @index + 1
    for i, change of changes
      change.elem.style.left = "#{change.index*100}%"
    @index = index
    @_rotate_items(diff)
    positions = []
    for i, item of @items
      positions.push(
        elem: item,
        index: @index + @items.indexOf(item) - 1
      )
      # positions[item] = @items.indexOf(item) + 1
    if Object.keys(changes).length > 0 && @_config.callback?
      @_config.callback(changes, positions)
    @drag = false
    @viewer_content.style.transform = "translate(#{-@index*100}%, 0)"
  _rotate_items: (index)->
    return if index == 0
    @items[1].style.zIndex = 0
    if index > 0
      @items.push(@items.shift())
      @_rotate_items(index - 1)
    else
      @items.unshift(@items.pop())
      @_rotate_items(index + 1)
    @items[1].style.zIndex = 1
  up: (@touches)->
    return unless @drag
    # debugger
    @drag = false
    if @scale < 0.2 # Destroy via scale
      return @destroy()
    if @scale <= 1.1 # Mode transition classiques
      if Math.abs(@translation[1]) > 30
        return @destroy()

      if Math.abs(@translation[0]) > 20
        if @translation[0] < 0
          return @set_index(@index+1)
        else
          return @set_index(@index-1)
      return @set_index(@index)
    if @scale > 1.1
      console.log 'ICIC ?'

  move: (@touches)->

export default Viewer
