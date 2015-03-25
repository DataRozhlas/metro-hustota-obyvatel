class ig.Infobox
  (@parentElement) ->
    @element = @parentElement.append \div
      ..attr \class \infobox
    @element
      ..append \form
        ..append \ul
          ..selectAll \li .data ["Rok 2001" "Rozdíl" "Rok 2014"] .enter!append \li
            ..append \input
              ..attr \type \radio
              ..attr \value -> it
              ..attr \name \backgroundSelector
              ..attr \id (d, i) -> "chc-#i"
              ..attr \checked (d, i) -> if i == 1 then "checked" else void
              ..on \change ->
                  switch @value
                    | "Rok 2001" =>
                      ig.legend.setCount yes
                      ig.drawYear 2001
                    | "Rok 2014" =>
                      ig.legend.setCount yes
                      ig.drawYear 2014
                    | "Rozdíl" =>
                      ig.legend.setCount no
                      ig.drawDiff!
            ..append \label
              ..html -> it
              ..attr \for (d, i) -> "chc-#i"
    @content = @element.append \p
    @reset!

  setFeature: (feature) ->
    direction = if feature.obyv.diff < 0 then "úbytek" else "přírustek"
    @content.html """Ve zvýrazněné oblasti žije
    <b>#{ig.utils.formatNumber feature.obyv['2014/12'] || 0}</b> obyvatel.
    V roce 2001 zde žilo
    <b>#{ig.utils.formatNumber feature.obyv['2001/12'] || 0}</b> lidí,
    je tu tedy <b>#direction #{ig.utils.formatNumber Math.abs feature.obyv.diff || 0}</b> obyvatel."""

  reset: ->
    @content.html "Najeďte myší na oblast a zobrazí se vám počet obyvatel, kteří v ní žijí"


