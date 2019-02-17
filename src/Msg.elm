module Msg exposing (AppMsg(..), send)

import Navigation exposing (Route)
import Gallery.Graphql exposing (APIModel)
import Task
import Gallery.Scalar exposing (Id(..))

type AppMsg
    = UrlChanged(String)
    | ChangeRoute Route
    | FetchGalleries
    | FetchImages Id
    | FetchImageInfo Id
    | FetchNothing
    | ReceiveGalleries APIModel


send : AppMsg -> Cmd AppMsg
send msg =
    Task.succeed msg |> Task.perform identity
