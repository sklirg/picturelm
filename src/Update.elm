module Update exposing (update)

import Model exposing (AppModel)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), locationHrefToRoute)

update : AppMsg -> AppModel -> ( AppModel, Cmd AppMsg )
update msg model =
    case msg of
        UrlChanged url ->
            let
                parsedUrl = case locationHrefToRoute url of
                    Just route -> route
                    Nothing -> Home
            in
            ( { model | route = parsedUrl }, Cmd.none)
