module Msg exposing (AppMsg(..))

import Navigation exposing (Route)
import Gallery.Graphql exposing (APIModel)

type AppMsg
    = UrlChanged(String)
    | ChangeRoute Route
    | FetchGalleries
    | ReceiveGalleries APIModel
