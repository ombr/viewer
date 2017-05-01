import $ from 'jquery'
helper = {
  viewer_dom: (cleanup)->
    $viewer = $(
      '<div class=".viewer"> \
        <div class="viewer-background"/> \
        <div class="viewer-content"> \
          <div class="viewer-container"/> \
          <div class="viewer-container"/> \
          <div class="viewer-container"/> \
        </div> \
      </div>'
    )
    $('body').append($viewer)
    cleanup ->
      console.log 'CleanUp?'
      $viewer.remove()
    $viewer[0]
}
export default helper
