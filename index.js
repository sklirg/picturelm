import { Elm } from './src/Main.elm';

Elm.Main.init({
  node: document.getElementById("main"),
  flags: {
    galleries: [],
  },
});
