import expect from 'expect.js'
import Viewer from '../src/viewer.coffee'
import Helper from '../test/helper.coffee'
import $ from 'jquery'

export default ->
  describe 'Viewer', ->
    viewer_id = Helper.$viewer(this)
    describe 'Simple swipe', ->
      it 'change the first element with index 3', (done)->
        @timeout(20000)
        first_item = $('.viewer-container', $(viewer_id)[0])[0]
        console.log first_item
        viewer = new Viewer(
          elem: document.getElementById(viewer_id),
          callback: (positions, changes)->
            console.log first_item
            # expect(Object.keys(changes)[0]).to.equal(first_item)
            # expect(first_item).to eq(changes
            console.log changes
            console.log positions
            setTimeout( ->
              done()
            15000)
        )
        viewer.down([[50, 50]])
        viewer.move([[20, 50]])
        viewer.up([[20, 50]])
