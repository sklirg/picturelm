module Model exposing (AppModel, Flags, baseModel)

import Gallery.Graphql exposing (WebGalleries)
import Gallery.Scalar exposing (Id(..))
import Msg exposing (AppMsg, send)
import Navigation exposing (Route(..), locationHrefToRoute)
import RemoteData exposing (RemoteData(..))


baseModel : Flags -> ( AppModel, Cmd AppMsg )
baseModel flags =
    let
        initRoute =
            case locationHrefToRoute flags.location of
                Just route ->
                    route

                Nothing ->
                    Home
    in
    ( { galleries = NotAsked
      , route = initRoute
      , api = flags.api
      , commitSha = flags.commitSha
      , commitMsg = flags.commitMsg
      , commitLink = flags.commitLink
      }
    , send Msg.FetchGalleries
    )


type alias Flags =
    { location : String
    , api : String
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
    }
