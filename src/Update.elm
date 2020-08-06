module Update exposing (getGalleryForSlug, getGalleryForWebGallerySlug, getImageForSlug, update)

import Browser
import Browser.Navigation as Nav
import Gallery.Graphql exposing (WebGalleries)
import Gallery.Model exposing (Gallery, Image, baseExifData)
import Gallery.Scalar exposing (Id(..))
import Gallery.Utils exposing (getTriplet)
import Graphql exposing (makeRequest)
import Map exposing (renderMap)
import Model exposing (AppModel)
import Msg exposing (AppMsg(..), send)
import Navigation exposing (Route(..), internalPath, locationHrefToRoute)
import RemoteData
import Url


update : AppMsg -> AppModel -> ( AppModel, Cmd AppMsg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    let
                        route =
                            locationHrefToRoute url
                    in
                    ( { model | route = route }, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )

        FetchGalleries ->
            ( { model | galleries = RemoteData.Loading }, makeRequest model.api )

        ReceiveGalleries response ->
            ( { model | galleries = response }, Cmd.none )

        FetchNothing ->
            ( model, Cmd.none )

        FetchImages _ ->
            ( model, Cmd.none )

        FetchImageInfo gallerySlug imageSlug ->
            case model.route of
                Navigation.Image _ _ ->
                    let
                        gallery =
                            getGalleryForWebGallerySlug gallerySlug model.galleries

                        image =
                            getImageForSlug imageSlug gallery.images
                    in
                    ( model, send (RenderMap image.exif.coordinates) )

                _ ->
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
                                    send (LinkClicked (Browser.Internal (internalPath model.url (Navigation.Image gallery.slug nextImage.title))))

                                "ArrowLeft" ->
                                    send (LinkClicked (Browser.Internal (internalPath model.url (Navigation.Image gallery.slug prevImage.title))))

                                "Escape" ->
                                    send (LinkClicked (Browser.Internal (internalPath model.url (Navigation.Gallery gallery.slug))))

                                "m" ->
                                    send (RenderMap image.exif.coordinates)

                                _ ->
                                    Cmd.none

                        newModel =
                            case key of
                                "p" ->
                                    { model | autoplay = not model.autoplay }

                                _ ->
                                    model
                    in
                    ( newModel, cmd )

                _ ->
                    ( model, Cmd.none )

        RenderMap coordinates ->
            ( model, renderMap coordinates )

        Tick _ ->
            if model.autoplay then
                case model.route of
                    Navigation.Image gallerySlug imageSlug ->
                        let
                            gallery =
                                getGalleryForWebGallerySlug gallerySlug model.galleries

                            image =
                                getImageForSlug imageSlug gallery.images

                            triplet =
                                getTriplet image gallery.images

                            nextImage =
                                case triplet of
                                    [ _, _, next ] ->
                                        next

                                    [] ->
                                        image

                                    _ :: _ ->
                                        image

                            cmd =
                                if nextImage /= image then
                                    send (LinkClicked (Browser.Internal (internalPath model.url (Navigation.Image gallery.slug nextImage.title))))

                                else
                                    Cmd.none
                        in
                        ( model, cmd )

                    _ ->
                        ( { model | autoplay = False }, Cmd.none )

            else
                ( model, Cmd.none )


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
            , thumbnailImage =
                { title = ""
                , imageUrl = ""
                , exif = baseExifData
                , sizes = []
                }
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
            , thumbnailImage =
                { title = ""
                , imageUrl = ""
                , exif = baseExifData
                , sizes = []
                }
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
            , sizes = []
            }
