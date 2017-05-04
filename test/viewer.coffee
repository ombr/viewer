import expect from 'expect.js'
import Viewer from '../src/viewer.coffee'
import Helper from '../test/helper.coffee'
import $ from 'jquery'

export default ->
  describe 'Viewer', ->
    describe 'set_item', ->
      it 'update all elements when set_index is called with a number out of range', ->
        viewer = new Viewer(
          elem: Helper.viewer_dom(after)
          callback: (changes, positions)->
            expect(changes.length).to.equal(3)
            expect(changes[0].index).to.equal(17)
            expect(changes[1].index).to.equal(18)
            expect(changes[2].index).to.equal(19)
        )
        viewer.set_index(18)
      it 'update one item when ', ->
        viewer = new Viewer(
          elem: Helper.viewer_dom(after)
          callback: (changes, positions)->
            expect(changes.length).to.equal(1)
            expect(changes[0].index).to.equal(2)
        )
        viewer.set_index(1)
      it 'does not update when index do not change', ->
        viewer = new Viewer(
          elem: Helper.viewer_dom(after)
          callback: (changes, positions)->
            throw 'This should not happen !'
        )
        viewer.set_index(0)
        viewer.set_index(0)

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
        viewer = new Viewer(
          elem: viewer_dom
          callback: (changes, positions)->
            expect(changes.length).to.equal(1)
            expect(positions.length).to.equal(3)
            expect(changes[0].elem).to.equal(first_item)
            done()
        )
        viewer.down([[50, 50]])
        viewer.move([[20, 50]])
        viewer.tick()
        viewer.up([[20, 50]])
