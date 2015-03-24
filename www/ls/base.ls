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
    attribution: 'data <a href="http://www.zzshmp.cz/" target="_blank">ZZS HMP</a>, mapová data &copy; přispěvatelé <a target="_blank" href="http://osm.org">OpenStreetMap</a>, obrazový podkres <a target="_blank" href="http://stamen.com">Stamen</a>, <a target="_blank" href="https://samizdat.cz">Samizdat</a>'

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

color = d3.scale.quantile!
  ..domain ig.data.grid.features.map (.properties.SUMu111100)
  ..range ['rgb(255,247,251)','rgb(236,231,242)','rgb(208,209,230)','rgb(166,189,219)','rgb(116,169,207)','rgb(54,144,192)','rgb(5,112,176)','rgb(4,90,141)','rgb(2,56,88)']

darkColors = ['rgb(54,144,192)','rgb(5,112,176)','rgb(4,90,141)','rgb(2,56,88)']
hexes = L.geoJson do
  * ig.data.grid
  * style: (feature) ->
      fillColor = color feature.properties.SUMu111100
      fillOpacity: 0.8
      fillColor: fillColor
      color: if fillColor in darkColors then \#fff else "rgb(2,56,88)"
      weight: 0
    onEachFeature: (feature, layer) ->
      layer.on \mouseover ->
        layer.setStyle weight: 1
        infobox.setFeature feature
      layer.on \mouseout ->
        layer.setStyle weight: 0
        infobox.reset!

hexes.addTo map

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
for stop in ig.data.'metro-stops'.features
  marker = L.circleMarker do
    * [stop.geometry.coordinates.1, stop.geometry.coordinates.0]
    * radius: 5
      color: \black
      fillColor: \white
      opacity: 1
      fillOpacity: 1
  marker.addTo map

infobox = new ig.Infobox container
