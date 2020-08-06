module Gallery.View exposing (galleryListView, imageListView, singleImageView)

import Css
    exposing
        ( backgroundColor
        , block
        , color
        , display
        , height
        , hex
        , marginLeft
        , marginRight
        , minHeight
        , none
        , pct
        , property
        , px
        , rem
        , textDecoration
        , width
        )
import Gallery.Components exposing (imageViewNext, imageViewPrev, imageViewWithPrevNext, imgWithSrcSetAttribute, ivCurrentOnly)
import Gallery.Model exposing (Gallery, Image)
import Gallery.Utils exposing (getTriplet)
import Html.Styled exposing (Html, div, p, text)
import Html.Styled.Attributes exposing (css)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), link, routeToUrl)
import Update exposing (getImageForSlug)


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
        [ link (routeToUrl (Navigation.Image gallery.slug image.title))
            [ css [ display block ]
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
                [ link (routeToUrl (Navigation.Gallery gallery.slug))
                    [ css
                        [ color (hex "000")
                        , textDecoration none
                        ]
                    ]
                    [ text (gallery.title ++ " (" ++ String.fromInt (List.length gallery.images) ++ ")") ]
                ]
            , link (routeToUrl (Navigation.Gallery gallery.slug))
                [ css [ display block ]
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


galleryListView : List Gallery -> Html AppMsg
galleryListView galleries =
    div
        [ css
            [ property "display" "grid"
            , property "grid-template-columns" "repeat(auto-fit, minmax(12.5rem, 0.5fr))"
            , property "grid-gap" "0.5rem"
            , property "justify-items" "center"
            ]
        ]
        (List.map galleryView galleries)
