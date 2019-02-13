module Model exposing (AppModel, baseModel)

import Gallery.Model exposing (Gallery)
import Msg exposing (AppMsg)
import Navigation exposing (Route(..), locationHrefToRoute)
import Gallery.Scalar exposing (Id(..))
import Task


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
        , Task.succeed Msg.FetchGalleries |> Task.perform identity )


type alias AppModel =
    { galleries: List Gallery
    , route: Route
    }
