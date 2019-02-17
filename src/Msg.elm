module Msg exposing (AppMsg(..), send)

import Gallery.Graphql exposing (APIModel)
import Gallery.Scalar exposing (Id(..))
import Navigation exposing (Route)
import Task


type AppMsg
    = UrlChanged String
    | ChangeRoute Route
    | FetchGalleries
    | FetchImages Id
    | FetchImageInfo Id
    | FetchNothing
    | ReceiveGalleries APIModel


send : AppMsg -> Cmd AppMsg
send msg =
    Task.succeed msg |> Task.perform identity
