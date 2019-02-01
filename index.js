import { Elm } from './src/Main.elm';

const app = Elm.Main.init({
  node: document.getElementById("main"),
  flags: location.href,
});

// Add routing as of https://github.com/elm/browser/blob/1.0.0/notes/navigation-in-elements.md

// Inform app of browser navigation (the BACK and FORWARD buttons)
window.addEventListener('popstate', function() {
  app.ports.onUrlChange.send(location.href);
});

// Change the URL upon request, inform app of the change.
app.ports.pushUrl.subscribe(function(url) {
  history.pushState({}, '', url);
  app.ports.onUrlChange.send(location.href);
});
