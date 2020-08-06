import { Elm } from "./src/Main.elm";
import initializeMap from "./leaflet.js";

const app = Elm.Main.init({
  flags: {
    api: process.env.PE_GRAPHQL_API || "",
    location: location.href,
    commitLink: process.env.DRONE_COMMIT_LINK || "https://github.com/sklirg/picturelm",
    commitMsg: process.env.DRONE_COMMIT_MESSAGE || "DEVELOPMENT",
    commitSha: process.env.DRONE_COMMIT_SHA || "SHA256"
  }
});

// Add map render function port
app.ports.renderMap.subscribe(initializeMap);

window.addEventListener("keydown", e => app.ports.onKeyPress.send(e.key));
