import $ from 'jquery'
helper = {
  $viewer: (context)->
    $viewer = null
    id = "viewer-#{Math.round(Math.random()*100000)}"
    context.beforeEach ->
      $viewer = $(
        '<div id="' + id + '" class=".viewer"> \
          <div class="viewer-background"/> \
          <div class="viewer-content"> \
            <div class="viewer-container"/> \
            <div class="viewer-container"/> \
            <div class="viewer-container"/> \
          </div> \
        </div>'
      )
      $('body').append($viewer)
    context.afterEach ->
      $viewer.remove()
    id
}

`export default helper`
