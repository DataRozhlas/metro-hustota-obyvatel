container = d3.select ig.containers.base
mapElement = container.append \div
  ..attr \class \map
map = L.map do
  * mapElement.node!
  * minZoom: 11,
    maxZoom: 18,
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

lines = L.geoJson do
  * ig.data.'metro-lines'
  * style: (feature) ->
      id = feature.properties.shape_id
      if id is null then id = 9
      opacity: 0.8
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

