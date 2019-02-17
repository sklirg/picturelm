module Model exposing (AppModel, baseModel)

import Gallery.Model exposing (Gallery)
import Msg exposing (AppMsg, send)
import Navigation exposing (Route(..), locationHrefToRoute)
import Gallery.Scalar exposing (Id(..))


baseModel : String -> ( AppModel, Cmd AppMsg )
baseModel url =
    let
        initRoute = case locationHrefToRoute url of
            Just route -> route
            Nothing -> Home
    in
        ( { galleries = []
            , route = initRoute
            }
        , send Msg.FetchGalleries
        )


type alias AppModel =
    { galleries: List Gallery
    , route: Route
    }
