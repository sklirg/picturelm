function initializeMap(coordinates) {
  if (document.getElementById("osm-map-div") === null) {
    return false;
  }

  const mapboxTilesAccessToken = process.env.PE_MAPBOX_API_TOKEN || "";

  const map = L.map("osm-map-div");

  map.setView(coordinates, 12);

  L.tileLayer(
    `https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=${mapboxTilesAccessToken}`,
    {
      attribution:
        'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
      maxZoom: 18,
      id: "mapbox.streets",
      accessToken: mapboxTilesAccessToken
    }
  ).addTo(map);

  L.marker(coordinates).addTo(map);

  return true;
}

let tries = 10;
function tryInitMap(coordinates) {
  tries--;
  const timeout = 250;

  if (tries > 0) {
    const renderSuccess = initializeMap(coordinates);
    if (!renderSuccess) {
      setTimeout(() => tryInitMap(coordinates), timeout);
    }
  }
}

export default coordinates => {
  tries = 10;
  tryInitMap(coordinates);
};
