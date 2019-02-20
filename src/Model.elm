module Model exposing (AppModel, Flags, baseModel)

import Gallery.Model exposing (Gallery, Image)
import Gallery.Scalar exposing (Id(..))
import Msg exposing (AppMsg, send)
import Navigation exposing (Route(..), locationHrefToRoute)


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
    ( { galleries = []
      , route = initRoute
      , api = flags.api
      , errors = []
      }
    , send Msg.FetchGalleries
    )


type alias Flags =
    { location : String
    , api : String
    }


type alias AppModel =
    { galleries : List Gallery
    , route : Route
    , api : String
    , errors : List String
    }
