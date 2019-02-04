module Update exposing (update)

import Debug
import Model exposing (AppModel)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), locationHrefToRoute, pushUrl, routeToUrl)
import Gallery.View exposing (makeRequest)
import RemoteData

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
        FetchGalleries ->
            ( model, makeRequest )
        ReceiveGalleries response -> case response of
            RemoteData.Success data ->
                let
                    galleries = model.galleries
                    newGalleries = data.gallery
                in 
                    ( { model | galleries = newGalleries :: galleries }, Cmd.none )
            RemoteData.Failure error ->
                ( model, Cmd.none )
            RemoteData.Loading ->
                ( model, Cmd.none )
            RemoteData.NotAsked ->
                ( model, Cmd.none )
            -- let
            --     galleries = model.galleries
            -- in
            --     ( { model | galleries = response :: galleries  }, Cmd.none )
