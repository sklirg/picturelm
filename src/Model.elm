module Model exposing (AppModel, baseModel)

import Gallery.Model exposing (Gallery)
import Msg exposing (AppMsg)
import Navigation exposing (Route(..), locationHrefToRoute)
import Gallery.Scalar exposing (Id(..))


baseModel : String -> ( AppModel, Cmd AppMsg )
baseModel url =
    let
        initRoute = case locationHrefToRoute url of
            Just route -> route
            Nothing -> Home
    in
        ( { galleries = [ testGallery ]
            , route = initRoute
            }
        , Cmd.none )


type alias AppModel =
    { galleries: List Gallery
    , route: Route
    }


testGallery : Gallery
testGallery =
    { title = "Gallery 1"
    , id = Id "abcd"
    }

    -- , url = "/gallery/gallery-1"
    -- , thumbnail = "https://picsum.photos/200?r"
    -- , images = []