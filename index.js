import { Elm } from "./src/Main.elm";
import initializeMap from "./leaflet.js";

const app = Elm.Main.init({
  node: document.getElementById("main"),
  flags: {
    api: process.env.PE_GRAPHQL_API || "",
    location: location.href,
    commitLink: process.env.DRONE_COMMIT_LINK || "",
    commitMsg: process.env.DRONE_COMMIT_MESSAGE || "",
    commitSha: process.env.DRONE_COMMIT_SHA || ""
  }
});

// Add routing as of https://github.com/elm/browser/blob/1.0.0/notes/navigation-in-elements.md

// Save the scrollY positions between state changes so we can scroll back to it.
let scrollY = 0;

// Inform app of browser navigation (the BACK and FORWARD buttons)
window.addEventListener("popstate", function() {
  app.ports.onUrlChange.send(location.href);
  setTimeout(() => window.scrollTo(0, scrollY), 10);
});

// Change the URL upon request, inform app of the change.
app.ports.pushUrl.subscribe(function(url) {
  scrollY = window.pageYOffset;
  history.pushState({}, "", url);
  app.ports.onUrlChange.send(location.href);
});

// Add map render function port
app.ports.renderMap.subscribe(initializeMap);

window.addEventListener("keydown", e => app.ports.onKeyPress.send(e.key));
