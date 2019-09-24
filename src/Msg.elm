module Msg exposing (AppMsg(..), send)

import Gallery.Graphql exposing (WebGalleries)
import Gallery.Scalar exposing (Id(..))
import Navigation exposing (Route)
import Task


type AppMsg
    = UrlChanged String
    | ChangeRoute Route
    | FetchGalleries
    | FetchImages Id
    | FetchImageInfo String String
    | FetchNothing
    | ReceiveGalleries WebGalleries
    | OnKeyPress String
    | RenderMap (List Float)


send : AppMsg -> Cmd AppMsg
send msg =
    Task.succeed msg |> Task.perform identity
