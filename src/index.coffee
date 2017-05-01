`import css from './index.sass'`
`import Viewer from './viewer.coffee'`
`import $ from '../node_modules/jquery/dist/jquery'`

$ ->
  i = 0
  window.v = new Viewer(
    elem: document.getElementsByClassName('viewer')[0]
    callback: (changes, positions)->
      # console.log 'changes !:', changes
      for index, element of changes
        $('p', element).html(index)
        $img = $('img', element)
        # console.log $img.attr('src') + Math.round(Math.random()*9)
        $img.attr('src', $img.attr('src') + Math.round(Math.random()*9))
    destroyed: (e)->
      $(e).remove()
  )
  # v.down([[50,50]])
  # setTimeout( ->
  #   v.move([[45,45]])
  #   setTimeout( ->
  #     v.up([[45, 45]])
  #   , 1000)
  # , 1000)
# # $('body').on 'mousemove', ->
#   console.log 'MOUSE MOVE BODY !'
# setTimeout(->
#   v.set_index(30)
# , 1000)
# v.$items = [0, 1, 2]
# v._rotate_items(1)
# console.log v.$items
