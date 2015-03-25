class ig.Infobox
  (@parentElement) ->
    @element = @parentElement.append \div
      ..attr \class \infobox

    @content = @element.append \p
    @reset!

  setFeature: (feature) ->
    @content.html "Ve zvýrazněné oblasti žije #{ig.utils.formatNumber feature.value} obyvatel"

  reset: ->
    @content.html "Najeďte myší na oblast a zobrazí se vám počet obyvatel, kteří v ní žijí"


