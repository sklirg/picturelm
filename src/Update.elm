module Update exposing (update)

import Model exposing (AppModel)
import Msg exposing (AppMsg)


update : AppMsg -> AppModel -> ( AppModel, Cmd AppMsg )
update msg model =
    ( model, Cmd.none )
