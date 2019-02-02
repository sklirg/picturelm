module Msg exposing (AppMsg(..))

import Navigation exposing (Route)

type AppMsg
    = UrlChanged(String)
    | ChangeRoute Route
