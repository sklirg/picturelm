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
        , none
        , padding2
        , pct
        , property
        , px
        , rem
        , spaceBetween
        , textDecoration
        , vh
        , width
        , wrap
        )
import Gallery.Graphql exposing (WebGalleries)
import Gallery.Model exposing (ExifData, Gallery, Image)
import Gallery.Utils exposing (get5, getTriplet)
import Html.Styled exposing (Html, a, div, h1, h2, h3, img, p, text)
import Html.Styled.Attributes exposing (attribute, css, href, src, target, title)
import Html.Styled.Keyed exposing (node)
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


addToListWithComma : String -> String -> String
addToListWithComma prev next =
    prev ++ "," ++ next


imgWithSrcSetAttribute : List (Html.Styled.Attribute msg) -> Image -> Html.Styled.Html msg
imgWithSrcSetAttribute attrs image =
    img
        (src image.imageUrl
            :: attribute "srcset" (List.foldl addToListWithComma "" image.sizes)
            -- , attribute "sizes" (List.foldl addToListWithComma "" (List.map (\size -> size) image.sizes))
            :: attrs
        )
        []


galleryCarousel : Image -> Gallery -> Html AppMsg
galleryCarousel currentImage gallery =
    let
        images =
            gallery.images

        carouselImages =
            get5 currentImage images
    in
    div
        [ css
            [ Css.margin Css.auto
            , Css.marginTop (rem 5)
            , Css.marginBottom (rem 5)
            , Css.width (pct 80)
            ]
        ]
        [ h2 [] [ text "Gallery" ]
        , div
            [ css
                [ displayFlex
                , Css.justifyContent Css.spaceBetween
                ]
            ]
            (List.map
                (\image ->
                    node "div"
                        []
                        [ ( image.title
                          , link (ChangeRoute (Navigation.Image gallery.slug image.title))
                                [ href image.title
                                , css
                                    [ Css.width (pct 19.5)
                                    ]
                                ]
                                [ imgWithSrcSetAttribute
                                    [ css
                                        [ Css.width (pct 100)
                                        ]
                                    ]
                                    image
                                ]
                          )
                        ]
                )
                carouselImages
            )
        ]


imageViewFunc : Html AppMsg -> Image -> Gallery -> Html AppMsg
imageViewFunc imgHeader image gallery =
    div
        [ css
            [ property "display" "grid"
            , property "grid-template-rows" "4rem 1fr auto"
            , property "justify-items" "center"
            ]
        ]
        [ imgHeader
        , node "div"
            []
            [ ( image.imageUrl
              , imgWithSrcSetAttribute
                    [ css [ maxWidth (pct 100), Css.maxHeight (vh 90) ]
                    ]
                    image
              )
            ]
        , div [ css [ Css.margin Css.auto, Css.maxWidth (rem 35), Css.width (pct 90) ] ]
            [ h2 [] [ text "Metadata" ]
            , exifViewFunc image.exif
            ]
        , a [ href image.imageUrl, target "_blank" ] [ h3 [ css [ color (hex "000"), Css.textDecoration Css.underline ] ] [ text "Download" ] ]
        , div [] [ galleryCarousel image gallery ]
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
        gallery


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
        gallery


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
        gallery


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


ivCurrentOnly : Image -> Gallery -> Html AppMsg
ivCurrentOnly image gallery =
    imageViewFunc (h1 [ css [ marginTop (rem 0), marginBottom (rem 0) ] ] [ text image.title ]) image gallery


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
        ivCurrentOnly image gallery

    else
        imageViewWithPrevNext gallery prevImage nextImage image


imageView : Gallery -> Image -> Html AppMsg
imageView gallery image =
    div []
        [ link (ChangeRoute (Navigation.Image gallery.slug image.title))
            [ css [ display block ]
            , href (gallery.slug ++ "/" ++ image.title)
            ]
            [ imgWithSrcSetAttribute
                [ css
                    [ display block
                    , width (pct 100)
                    , height (pct 100)
                    , backgroundColor (hex "ccc")
                    , minHeight (px 100)
                    ]
                ]
                image
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
                , href ("gallery/" ++ gallery.slug)
                ]
                [ imgWithSrcSetAttribute
                    [ css
                        [ backgroundColor (hex "ddd")
                        , display block
                        , width (pct 100)
                        ]
                    ]
                    gallery.thumbnailImage
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
