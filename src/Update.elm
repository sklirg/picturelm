module Update exposing (getGalleryForSlug, update)

import Gallery.Model exposing (Gallery)
import Gallery.Scalar exposing (Id(..))
import Gallery.View exposing (makeRequest)
import Model exposing (AppModel)
import Msg exposing (AppMsg(..), send)
import Navigation exposing (Route(..), locationHrefToRoute, pushUrl, routeToUrl)
import RemoteData


update : AppMsg -> AppModel -> ( AppModel, Cmd AppMsg )
update msg model =
    case msg of
        UrlChanged url ->
            let
                route =
                    case locationHrefToRoute url of
                        Just r ->
                            r

                        Nothing ->
                            Home

                fetchRoute =
                    loadPath route model
            in
            ( { model | route = route }, send fetchRoute )

        ChangeRoute route ->
            let
                url =
                    routeToUrl route
            in
            ( model, pushUrl url )

        FetchGalleries ->
            ( model, makeRequest )

        ReceiveGalleries response ->
            case response of
                RemoteData.Success data ->
                    let
                        galleries =
                            model.galleries

                        newGalleries =
                            data.galleries
                    in
                    ( { model | galleries = newGalleries ++ galleries }, Cmd.none )

                RemoteData.Failure error ->
                    ( model, Cmd.none )

                RemoteData.Loading ->
                    ( model, Cmd.none )

                RemoteData.NotAsked ->
                    ( model, Cmd.none )

        FetchNothing ->
            ( model, Cmd.none )

        FetchImages id ->
            ( model, Cmd.none )

        FetchImageInfo id ->
            ( model, Cmd.none )


loadPath : Route -> AppModel -> AppMsg
loadPath route model =
    if model.route == route then
        FetchNothing

    else
        case route of
            Home ->
                FetchNothing

            Navigation.Gallery slug ->
                FetchImages (getGalleryIdForSlug slug model.galleries)

            Image slug ->
                FetchImageInfo (getGalleryIdForSlug slug model.galleries)


getGalleryForSlug : String -> List Gallery -> Gallery
getGalleryForSlug slug galleries =
    case List.filter (\gallery -> gallery.title == slug) galleries of
        head :: _ ->
            head

        [] ->
            { title = ""
            , description = ""
            , images = []
            , thumbnail = ""
            , id = Id ""
            }



-- get image for slug


getGalleryIdForSlug : String -> List Gallery -> Id
getGalleryIdForSlug slug galleries =
    (getGalleryForSlug slug galleries).id
