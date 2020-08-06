module Msg exposing (AppMsg(..), send)

import Browser
import Gallery.Graphql exposing (WebGalleries)
import Gallery.Scalar exposing (Id(..))
import Task
import Time
import Url


type AppMsg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | FetchGalleries
    | FetchImages Id
    | FetchImageInfo String String
    | FetchNothing
    | ReceiveGalleries WebGalleries
    | OnKeyPress String
    | RenderMap (List Float)
    | Tick Time.Posix


send : AppMsg -> Cmd AppMsg
send msg =
    Task.succeed msg |> Task.perform identity
