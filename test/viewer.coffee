import expect from 'expect.js'

export default ->
  describe 'Viewer', ->
    it 'Can be required', (done)->
      expect(1).to.equal(1)
      # console.log window.viewer
      done()
  # viewer_id = Helper.$viewer(this)
  # describe 'Simple swipe', ->
  #   it 'give me a change', (done)->
  #     viewer = new Viewer(
  #       elem: document.getElementById(viewer_id),
  #       callback: (positions, changes)->
  #         console.log changes
  #         console.log positions
  #         done()
  #     )
  #     viewer.down([[50, 50]])
  #     viewer.move([[20, 50]])
  #     viewer.up([[20, 50]])
