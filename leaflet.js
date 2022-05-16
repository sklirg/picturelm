const timeout = 250;

function initializeMap(coordinates, tries = 0) {
  if (document.getElementById("osm-map-div") === null) {
    return false;
  }

  if (tries > 3) {
    console.warn("Tried to initialize map 3 times, aborting");
    return false;
  }

  const mapboxTilesAccessToken = process.env.PE_MAPBOX_API_TOKEN || "";

  let map;
  try {
    map = L.map("osm-map-div");
  } catch (err) {
    console.warn(
      `Failed to render map, retrying in ${timeout}ms (${err.message})`
    );
    setTimeout(() => initializeMap(coordinates, tries + 1 || 1), timeout);
    return true;
  }

  map.setView(coordinates, 12);

  L.tileLayer(
    `https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=${mapboxTilesAccessToken}`,
    {
      attribution:
        'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
      maxZoom: 18,
      id: "mapbox/streets-v11",
      accessToken: mapboxTilesAccessToken
    }
  ).addTo(map);

  L.marker(coordinates).addTo(map);

  return true;
}

let tries = 10;
function tryInitMap(coordinates) {
  tries--;

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
