import Helper from './helper.coffee'
import Viewer from '../src/viewer.coffee'

test = ->
  describe 'Viewer', ->
    viewer_id = Helper.$viewer(this)
    describe 'Simple swipe', ->
      it 'give me a change', (done)->
        viewer = new Viewer(
          elem: document.getElementById(viewer_id),
          callback: (positions, changes)->
            console.log changes
            console.log positions
            done()
        )
        viewer.down([[50, 50]])
        viewer.move([[20, 50]])
        viewer.up([[20, 50]])

export default test
