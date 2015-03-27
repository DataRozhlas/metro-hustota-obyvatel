colors =
  ['rgb(215,48,39)','rgb(252,141,89)','rgb(254,224,139)','rgb(254,224,139)','rgb(255,255,191)','rgb(217,239,139)','rgb(145,207,96)','rgb(145,207,96)','rgb(26,152,80)']
  ['rgb(255,247,251)','rgb(236,231,242)','rgb(208,209,230)','rgb(166,189,219)','rgb(116,169,207)','rgb(54,144,192)','rgb(5,112,176)','rgb(4,90,141)','rgb(2,56,88)']

assignments = [0 1 1 2 3 3 4 4 5 6 7 8]
class ig.Legend
  (@baseElement, features) ->
    items = [438 437 456 455 471 470 488 487 504 503 519 518]
    features = items.map ->
      features[it]
    @element = @baseElement.append \div
      ..attr \class \legend
    width = 80
    {width, height, projection} = ig.utils.geo.getFittingProjection features, width

    path = d3.geo.path!
      ..projection projection
    @svgs = @element.selectAll \div .data colors .enter!append \div
      ..attr \class \line
      ..append \div
        .html (d, i) ->
          if i == 0 then "Úbytek" else "Méně<br>obyvatel"
      ..append \svg
        ..attr \width width
        ..attr \height height
        ..selectAll \path .data features .enter!append \path
          ..attr \d path
          ..attr \fill (d, i, ii) ~> colors[ii][assignments[i]]

      ..append \div
        .html (d, i) ->
          if i == 0 then "Přírůstek" else "Více<br>obyvatel"

  setCount: ->
    @element.classed \count it
