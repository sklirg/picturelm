module Gallery.Components exposing (backgroundedLabelLeft, backgroundedLabelRight, imageViewNext, imageViewPrev, imageViewWithPrevNext, imgWithSrcSetAttribute, ivCurrentOnly, nextImageIcon, nextImageLink, prevImageIcon, prevImageLink, tag)

import Css
    exposing
        ( backgroundColor
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderTopLeftRadius
        , borderTopRightRadius
        , color
        , column
        , displayFlex
        , flexDirection
        , flexWrap
        , fontSize
        , hex
        , justifyContent
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , maxWidth
        , padding4
        , pct
        , property
        , rem
        , spaceBetween
        , textDecoration
        , vh
        , width
        , wrap
        )
import Gallery.Model exposing (ExifData, Gallery, Image)
import Gallery.Utils exposing (get5)
import Html.Styled exposing (Html, a, div, h1, h2, h3, img, text)
import Html.Styled.Attributes exposing (alt, attribute, css, href, src, target, title)
import Html.Styled.Keyed exposing (node)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), link)


backgroundedLabelLeft : String -> String -> Html msg
backgroundedLabelLeft hexColor txt =
    div
        [ css
            [ padding4 (rem 0.2) (rem 1.25) (rem 0.2) (rem 0.4)
            , backgroundColor (hex hexColor)
            , borderBottomLeftRadius (rem 0.45)
            , borderTopLeftRadius (rem 0.45)
            , color (hex "fefefe")
            , property "clip-path" "polygon(0% 0%, 100% 0%, calc(100% - 1rem) 100%, 0% 100%);"
            ]
        ]
        [ text txt ]


backgroundedLabelRight : String -> String -> Html msg
backgroundedLabelRight hexColor txt =
    div
        [ css
            [ padding4 (rem 0.2) (rem 0.4) (rem 0.2) (rem 2)
            , backgroundColor (hex hexColor)
            , borderBottomRightRadius (rem 0.45)
            , borderTopRightRadius (rem 0.45)
            , marginLeft (rem -2)
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
        [ backgroundedLabelLeft "747474" key
        , backgroundedLabelRight "d4d4d4" val
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
            :: alt image.title
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
                -- set css height
              )
            ]
        , div [ css [ Css.margin Css.auto, Css.maxWidth (rem 35), Css.width (pct 90) ] ]
            [ h2 [] [ text "Metadata" ]
            , if image.exif.cameraModel /= "" then
                exifViewFunc image.exif

              else
                div [] [ text "Looks like we're missing the image metadata 😢" ]
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
