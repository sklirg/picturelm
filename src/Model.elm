module Model exposing (AppModel, baseModel)

import Msg exposing (AppMsg)


baseModel : AppModel -> ( AppModel, Cmd AppMsg )
baseModel _ =
    ( {}, Cmd.none )


type alias AppModel =
    {}
