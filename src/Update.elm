module Update exposing (getGalleryForSlug, getGalleryForWebGallerySlug, getImageForSlug, update)

import Gallery.Graphql exposing (WebGalleries)
import Gallery.Model exposing (Gallery, Image, baseExifData)
import Gallery.Scalar exposing (Id(..))
import Gallery.Utils exposing (getTriplet)
import Graphql exposing (makeRequest)
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
            ( model, makeRequest model.api )

        ReceiveGalleries response ->
            ( { model | galleries = response }, Cmd.none )

        FetchNothing ->
            ( model, Cmd.none )

        FetchImages id ->
            ( model, Cmd.none )

        FetchImageInfo id ->
            ( model, Cmd.none )

        OnKeyPress key ->
            case model.route of
                Navigation.Image gallerySlug imageSlug ->
                    let
                        gallery =
                            getGalleryForWebGallerySlug gallerySlug model.galleries

                        image =
                            getImageForSlug imageSlug gallery.images

                        triplet =
                            getTriplet image gallery.images

                        prevImage =
                            case triplet of
                                [ prev, _, _ ] ->
                                    prev

                                [] ->
                                    image

                                _ :: _ ->
                                    image

                        nextImage =
                            case triplet of
                                [ _, _, next ] ->
                                    next

                                [] ->
                                    image

                                _ :: _ ->
                                    image

                        cmd =
                            case key of
                                "ArrowRight" ->
                                    send (ChangeRoute (Navigation.Image gallery.slug nextImage.title))

                                "ArrowLeft" ->
                                    send (ChangeRoute (Navigation.Image gallery.slug prevImage.title))

                                "Escape" ->
                                    send (ChangeRoute (Navigation.Gallery gallery.slug))

                                _ ->
                                    Cmd.none
                    in
                    ( model, cmd )

                _ ->
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
                FetchImages (getGalleryForWebGallerySlug slug model.galleries).id

            Navigation.Image gallerySlug imageSlug ->
                let
                    gallery =
                        getGalleryForWebGallerySlug gallerySlug model.galleries

                    image =
                        getImageForSlug imageSlug gallery.images
                in
                FetchImageInfo (Id gallery.slug)


getGalleryForWebGallerySlug : String -> WebGalleries -> Gallery
getGalleryForWebGallerySlug slug webGalleries =
    case webGalleries of
        RemoteData.Success galleries ->
            getGalleryForSlug slug galleries

        _ ->
            { title = ""
            , slug = ""
            , description = ""
            , images = []
            , thumbnail = ""
            , id = Id ""
            }


getGalleryForSlug : String -> List Gallery -> Gallery
getGalleryForSlug slug galleries =
    case List.filter (\gallery -> gallery.slug == slug) galleries of
        head :: _ ->
            head

        [] ->
            { title = ""
            , slug = ""
            , description = ""
            , images = []
            , thumbnail = ""
            , id = Id ""
            }


getImageForSlug : String -> List Image -> Image
getImageForSlug slug images =
    case List.filter (\image -> image.title == slug) images of
        head :: _ ->
            head

        [] ->
            { title = ""
            , imageUrl = ""
            , exif = baseExifData
            }


getGalleryIdForSlug : String -> List Gallery -> Id
getGalleryIdForSlug slug galleries =
    (getGalleryForSlug slug galleries).id
