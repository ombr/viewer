import expect from 'expect.js'
import Viewer from '../src/viewer.coffee'
import Helper from '../test/helper.coffee'
import $ from 'jquery'

export default ->
  describe 'Viewer', ->
    describe 'Simple swipe', ->

      it 'does not change for a small move', ->
        viewer = new Viewer(
          elem: Helper.viewer_dom(after)
          callback: (changes, positions)->
            throw 'This should not happen !'
        )
        viewer.down([[50, 50]])
        viewer.move([[49, 50]])
        viewer.tick()
        viewer.up([[49, 50]])

      it 'change the first element with index 3', (done)->
        viewer_dom = Helper.viewer_dom(after)
        first_item = $('.viewer-container', viewer_dom)[0]
        console.log viewer_dom, first_item
        viewer = new Viewer(
          elem: viewer_dom
          callback: (changes, positions)->
            expect(changes.length).to.equal(1)
            expect(positions.length).to.equal(3)
            expect(changes[0].elem).to.equal(first_item)
            console.log first_item, changes
            done()
        )
        viewer.down([[50, 50]])
        viewer.move([[20, 50]])
        viewer.tick()
        viewer.up([[20, 50]])
