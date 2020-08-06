module Model exposing (AppModel, Flags, baseModel)

import Browser.Navigation as Nav
import Gallery.Graphql exposing (WebGalleries)
import Gallery.Scalar exposing (Id(..))
import Msg exposing (AppMsg, send)
import Navigation exposing (Route(..), locationHrefToRoute)
import RemoteData exposing (RemoteData(..))
import Url


baseModel : Flags -> Url.Url -> Nav.Key -> ( AppModel, Cmd AppMsg )
baseModel flags url key =
    let
        route =
            locationHrefToRoute url
    in
    ( { galleries = NotAsked
      , route = route
      , api = flags.api
      , commitSha = flags.commitSha
      , commitMsg = flags.commitMsg
      , commitLink = flags.commitLink
      , autoplay = False
      , key = key
      , url = url
      }
    , send Msg.FetchGalleries
    )


type alias Flags =
    { api : String
    , commitSha : String
    , commitMsg : String
    , commitLink : String
    }


type alias AppModel =
    { galleries : WebGalleries
    , route : Route
    , api : String
    , commitSha : String
    , commitMsg : String
    , commitLink : String
    , autoplay : Bool
    , key : Nav.Key
    , url : Url.Url
    }
