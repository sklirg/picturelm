module Model exposing (AppModel, baseModel)

import Gallery.Model exposing (Gallery)
import Msg exposing (AppMsg)


baseModel : AppModel -> ( AppModel, Cmd AppMsg )
baseModel flags =
    ( { galleries = flags.galleries }
    , Cmd.none )


type alias AppModel =
    { galleries: List Gallery
    }
