module Gallery.View exposing (galleryListView, imageListView, singleImageView)

import Css
    exposing
        ( backgroundColor
        , block
        , borderRadius
        , color
        , column
        , display
        , displayFlex
        , flexDirection
        , flexWrap
        , fontSize
        , height
        , hex
        , justifyContent
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , maxWidth
        , minHeight
        , minWidth
        , none
        , padding2
        , pct
        , property
        , px
        , rem
        , spaceBetween
        , textDecoration
        , width
        , wrap
        )
import Gallery.Graphql exposing (WebGalleries)
import Gallery.Model exposing (ExifData, Gallery, Image)
import Gallery.Utils exposing (getTriplet)
import Html.Styled exposing (Html, div, h1, h2, img, p, text)
import Html.Styled.Attributes exposing (css, href, src, title)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), link)
import RemoteData
import Spinner exposing (textLoadingSpinner)
import Update exposing (getImageForSlug)


backgroundedLabel : String -> String -> Html msg
backgroundedLabel hexColor txt =
    div
        [ css
            [ padding2 (rem 0.1) (rem 0.4)
            , backgroundColor (hex hexColor)
            , borderRadius (rem 0.25)
            ]
        ]
        [ text txt ]


tag : String -> String -> Html msg
tag key val =
    div
        [ css
            [ displayFlex
            , marginBottom (rem 0.5)
            , marginRight (rem 0.25)
            ]
        ]
        [ backgroundedLabel "c3c3c3" key
        , backgroundedLabel "d4d4d4" val
        ]


exifViewFunc : ExifData -> Html msg
exifViewFunc exif =
    div [ css [ displayFlex, flexWrap wrap, justifyContent spaceBetween, marginRight (rem -0.25) ] ]
        [ div [] [ tag "Aperture" exif.aperture ]
        , div [] [ tag "FStop" (String.fromFloat exif.fStop) ]
        , div [] [ tag "Shutter speed" exif.shutterSpeed ]
        , div [] [ tag "ISO" exif.iso ]
        , div [] [ tag "Focal length" exif.focalLength ]
        , div [] [ tag "Camera" exif.cameraModel ]
        , div [] [ tag "Lens" exif.lensModel ]
        ]


imageViewFunc : Html msg -> Image -> Html msg
imageViewFunc imgHeader image =
    div
        [ css
            [ property "display" "grid"
            , property "grid-template-rows" "4rem 1fr auto"
            , property "justify-items" "center"
            ]
        ]
        [ imgHeader
        , img
            [ src image.imageUrl
            , css [ maxWidth (pct 100) ]
            ]
            []
        , div [ css [ marginLeft (pct 20), marginRight (pct 20) ] ]
            [ h2 [] [ text "Metadata" ]
            , exifViewFunc image.exif
            ]
        ]


imageViewWithPrevNext : Gallery -> Image -> Image -> Image -> Html AppMsg
imageViewWithPrevNext gallery prevImage nextImage image =
    imageViewFunc
        (div
            [ css
                [ displayFlex
                , justifyContent spaceBetween
                , width (pct 100)
                ]
            ]
            [ prevImageLink gallery prevImage
            , h1
                [ css
                    [ displayFlex
                    , property "align-self" "flex-start"
                    , marginTop (rem 0)
                    , marginBottom (rem 0)
                    , flexDirection column
                    ]
                ]
                [ text image.title
                ]
            , nextImageLink gallery nextImage
            ]
        )
        image


imageViewPrev : Gallery -> Image -> Image -> Html AppMsg
imageViewPrev gallery prevImage image =
    imageViewFunc
        (div
            [ css
                [ displayFlex
                , justifyContent spaceBetween
                , width (pct 100)
                ]
            ]
            [ prevImageLink gallery prevImage
            , h1 [ css [ marginTop (rem 0), marginBottom (rem 0) ] ] [ text image.title ]
            , div [ css [ property "filter" "opacity(calc(1/3)) grayscale(100%)" ] ] [ nextImageIcon ]
            ]
        )
        image


imageViewNext : Gallery -> Image -> Image -> Html AppMsg
imageViewNext gallery nextImage image =
    imageViewFunc
        (div
            [ css
                [ displayFlex
                , justifyContent spaceBetween
                , width (pct 100)
                ]
            ]
            [ div [ css [ property "filter" "opacity(calc(1/3)) grayscale(100%)" ] ] [ prevImageIcon ]
            , h1 [ css [ marginTop (rem 0), marginBottom (rem 0) ] ] [ text image.title ]
            , nextImageLink gallery nextImage
            ]
        )
        image


prevImageLink : Gallery -> Image -> Html AppMsg
prevImageLink gallery image =
    link (ChangeRoute (Navigation.Image gallery.slug image.title))
        [ href image.title ]
        [ prevImageIcon ]


nextImageIcon : Html msg
nextImageIcon =
    div
        [ css
            [ fontSize (rem 3)
            , property "transform" "scale(-1, 1)"
            ]
        , title "Next"
        ]
        [ text "👀" ]


prevImageIcon : Html msg
prevImageIcon =
    div
        [ css
            [ fontSize (rem 3)
            ]
        , title "Previous"
        ]
        [ text "👀" ]


nextImageLink : Gallery -> Image -> Html AppMsg
nextImageLink gallery image =
    link (ChangeRoute (Navigation.Image gallery.slug image.title))
        [ href image.title ]
        [ nextImageIcon ]


ivCurrentOnly : Image -> Html msg
ivCurrentOnly image =
    imageViewFunc (h1 [ css [ marginTop (rem 0), marginBottom (rem 0) ] ] [ text image.title ]) image


singleImageView : Gallery -> String -> Html AppMsg
singleImageView gallery slug =
    let
        image =
            getImageForSlug slug gallery.images

        threeImages =
            getTriplet image gallery.images

        prevImage =
            case threeImages of
                [ prev, _, _ ] ->
                    prev

                [] ->
                    image

                _ :: _ ->
                    image

        nextImage =
            case threeImages of
                [ _, _, next ] ->
                    next

                [] ->
                    image

                _ :: _ ->
                    image

        -- This will be next/previous if we're at the start/end of the list
        middleImage =
            case threeImages of
                [ _, middle, _ ] ->
                    middle

                [] ->
                    image

                _ :: _ ->
                    image
    in
    if prevImage == image then
        imageViewNext gallery middleImage image

    else if nextImage == image then
        imageViewPrev gallery middleImage image

    else if nextImage == image && prevImage == image then
        ivCurrentOnly image

    else
        imageViewWithPrevNext gallery prevImage nextImage image


imageFileGetEnding : String -> String
imageFileGetEnding filename =
    let
        numDots =
            String.split "." filename

        fileEnding =
            case List.head (List.reverse numDots) of
                Just val ->
                    val

                Nothing ->
                    ""
    in
    fileEnding


imageFileStripEnding : String -> String
imageFileStripEnding filename =
    let
        fileEnding =
            imageFileGetEnding filename

        fileNameWithoutEnding =
            String.slice 0 (String.length filename - (String.length fileEnding + 1)) filename
    in
    fileNameWithoutEnding


imageThumb : String -> String
imageThumb filename =
    let
        fileEnding =
            "." ++ imageFileGetEnding filename

        fileName =
            imageFileStripEnding filename
    in
    fileName ++ "_thumb" ++ fileEnding


imageView : Gallery -> Image -> Html AppMsg
imageView gallery image =
    div []
        [ link (ChangeRoute (Navigation.Image gallery.slug image.title))
            [ css [ display block ]
            , href image.title
            ]
            [ img
                [ css
                    [ display block
                    , width (pct 100)
                    , height (pct 100)
                    , backgroundColor (hex "ccc")
                    , minHeight (px 200)
                    , minWidth (px 200)
                    ]
                , src (imageThumb image.imageUrl)
                ]
                []
            ]
        ]


imageListView : Gallery -> Html AppMsg
imageListView gallery =
    div
        [ css
            [ property "display" "grid"
            , property "grid-template-columns" "repeat(auto-fit, minmax(12.5rem, 1fr))"
            , property "grid-gap" "0.5rem"
            , property "justify-items" "center"
            , marginLeft (rem 1)
            , marginRight (rem 1)
            ]
        ]
        (List.map (imageView gallery) gallery.images)


galleryView : Gallery -> Html AppMsg
galleryView gallery =
    div
        [ css
            [ marginLeft (rem 1)
            , marginRight (rem 1)
            ]
        ]
        [ div
            []
            [ p []
                [ link (ChangeRoute (Navigation.Gallery gallery.slug))
                    [ css
                        [ color (hex "000")
                        , textDecoration none
                        ]
                    , href gallery.slug
                    ]
                    [ text (gallery.title ++ " (" ++ String.fromInt (List.length gallery.images) ++ ")") ]
                ]
            , link (ChangeRoute (Navigation.Gallery gallery.slug))
                [ css [ display block ]
                , href gallery.slug
                ]
                [ img
                    [ css
                        [ backgroundColor (hex "ddd")
                        , display block
                        , width (pct 100)
                        ]
                    , src gallery.thumbnail
                    ]
                    []
                ]
            ]
        ]


galleryListView : WebGalleries -> Html AppMsg
galleryListView webGalleries =
    case webGalleries of
        RemoteData.Success galleries ->
            div
                [ css
                    [ property "display" "grid"
                    , property "grid-template-columns" "repeat(auto-fit, minmax(12.5rem, 0.5fr))"
                    , property "grid-gap" "0.5rem"
                    , property "justify-items" "center"
                    ]
                ]
                (List.map galleryView galleries)

        RemoteData.NotAsked ->
            textLoadingSpinner "Initializing application"

        RemoteData.Loading ->
            textLoadingSpinner "Loading galleries"

        RemoteData.Failure _ ->
            div [] [ text "Something went wrong while fetching galleries" ]
