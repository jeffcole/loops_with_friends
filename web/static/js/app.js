require("../css/app.sass")

import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import elm from "./elm/src/App.elm"

window.Elm = elm
