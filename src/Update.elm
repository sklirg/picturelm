module Update exposing (update)

import Debug
import Model exposing (AppModel)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), locationHrefToRoute, pushUrl, routeToUrl)

update : AppMsg -> AppModel -> ( AppModel, Cmd AppMsg )
update msg model =
    case msg of
        UrlChanged url ->
            let
                route = case locationHrefToRoute url of
                    Just r -> r
                    Nothing -> Home
            in
            ( { model | route = route }, Cmd.none )
        ChangeRoute route ->
            let
                url = routeToUrl route
            in
                ( model, pushUrl url )
