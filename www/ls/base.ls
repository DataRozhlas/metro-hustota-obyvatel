container = d3.select ig.containers.base
mapElement = container.append \div
  ..attr \class \map
map = L.map do
  * mapElement.node!
  * minZoom: 11,
    maxZoom: 16,
    zoom: 11
    center: [50.0845, 14.496]
    maxBounds: [[49.89,14.14], [50.23,15.04]]

baseLayer = L.tileLayer do
  * "https://samizdat.cz/tiles/ton_b1/{z}/{x}/{y}.png"
  * zIndex: 1
    opacity: 1
    attribution: 'data <a href="https://www.czso.cz/" target="_blank">ČSÚ</a>, mapová data &copy; přispěvatelé <a target="_blank" href="http://osm.org">OpenStreetMap</a>, obrazový podkres <a target="_blank" href="http://stamen.com">Stamen</a>, <a target="_blank" href="https://samizdat.cz">Samizdat</a>'

labelLayer = L.tileLayer do
  * "https://samizdat.cz/tiles/ton_l1/{z}/{x}/{y}.png"
  * zIndex: 3
    opacity: 0.75

map
  ..addLayer baseLayer
  ..addLayer labelLayer

metroColors =
  0: \#143487
  9: \#03A86B
  18: \#FAB32E
  32: \#D11F42

allValues = []

for feature in ig.data.grid.features
  allValues.push feature.properties['obyv_2014']
  allValues.push feature.properties['obyv_2001'] if feature.properties['obyv_2001']
  feature.properties.diff = feature.properties['obyv_2014'] - (feature.properties['obyv_2001'] || 0)

allValues.sort (a, b) -> a - b
colorYear = d3.scale.quantile!
  ..domain allValues
  ..range ['rgb(255,247,251)','rgb(236,231,242)','rgb(208,209,230)','rgb(166,189,219)','rgb(116,169,207)','rgb(54,144,192)','rgb(5,112,176)','rgb(4,90,141)','rgb(2,56,88)']

colorDiff = d3.scale.linear!
  ..domain [-3000 -500 -150 0 150 500 4000]
  ..range ['rgb(215,48,39)','rgb(252,141,89)','rgb(254,224,139)','rgb(255,255,191)','rgb(217,239,139)','rgb(145,207,96)','rgb(26,152,80)']

color = colorDiff
toDisplay = "diff"

hexStyle = (feature) ->
  fillColor = color (feature.properties?[toDisplay] || 0)
  fillOpacity: 0.8
  fillColor: fillColor
  color: \#000
  weight: 0
hexes = L.geoJson do
  * ig.data.grid
  * style: hexStyle
    onEachFeature: (feature, layer) ->
      layer.on \mouseover ->
        layer.setStyle weight: 1
        infobox.setFeature feature
      layer.on \mouseout ->
        layer.setStyle weight: 0
        infobox.reset!

hexes.addTo map

ig.drawYear = (year) ->
  color := colorYear
  toDisplay := "obyv_#{year}"
  hexes.setStyle hexStyle

ig.drawDiff = ->
  color := colorDiff
  toDisplay := "diff"
  hexes.setStyle hexStyle

lines = L.geoJson do
  * ig.data.'metro-lines'
  * style: (feature) ->
      id = feature.properties.shape_id
      if id is null then id = 9
      opacity: 1
      weight: 7
      color: metroColors[id]

lines.addTo map

L.Icon.Default.imagePath = "https://samizdat.cz/tools/leaflet/images/"
graphTip = new ig.GraphTip mapElement
for let stop in ig.data.'metro-stops'.features
  latlng = L.latLng [stop.geometry.coordinates.1, stop.geometry.coordinates.0]
  fillColor = if stop.properties.nazev in ['Bořislavka' 'Nádraží Veleslavín' 'Petřiny' 'Nemocnice Motol']
    \#bbb
  else
    \#fff
  marker = L.circleMarker do
    * latlng
    * radius: 5
      color: \black
      fillColor: fillColor
      opacity: 1
      fillOpacity: 1
  marker.on \mouseover ->
    {x, y} = map.latLngToContainerPoint latlng
    graphTip.display x, (y - 8), stop.properties.nazev
  marker.on \mouseout ->
    graphTip.hide!


  marker.addTo map

infobox = new ig.Infobox container

ig.legend = new ig.Legend container, ig.data.grid.features

embedLogo = new ig.EmbedLogo ig.containers.base, {dark: yes}
