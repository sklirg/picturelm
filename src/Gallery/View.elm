module Gallery.View exposing (galleryListView, imageListView, singleImageView)

import Css
    exposing
        ( backgroundColor
        , block
        , color
        , display
        , height
        , hex
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , maxWidth
        , none
        , pct
        , property
        , rem
        , textDecoration
        , vw
        , width
        )
import Gallery.Model exposing (Gallery, Image)
import Html.Styled exposing (Html, div, h1, img, p, text)
import Html.Styled.Attributes exposing (css, href, src)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), link)


singleImageView : Image -> Html msg
singleImageView image =
    div
        [ css
            [ property "display" "grid"
            , property "grid-template-rows" "4rem 1fr"
            , property "justify-items" "center"
            ]
        ]
        [ h1 [ css [ marginTop (rem 0), marginBottom (rem 0) ] ] [ text image.title ]
        , img
            [ src image.imageUrl
            , css [ maxWidth (vw 100) ]
            ]
            []
        ]


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
            [ css [ display block ] ]
            [ img
                [ css
                    [ display block
                    , width (pct 100)
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
            , property "grid-template-columns" "repeat(auto-fit, minmax(200px, 15rem))"
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
                    , href gallery.title
                    ]
                    [ text (gallery.title ++ " (" ++ String.fromInt (List.length gallery.images) ++ ")") ]
                ]
            , link (ChangeRoute (Navigation.Gallery gallery.slug))
                [ css [ display block ]
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


galleryListView : List Gallery -> Html AppMsg
galleryListView galleries =
    div
        [ css
            [ property "display" "grid"
            , property "grid-template-columns" "repeat(auto-fit, minmax(200px, 15rem))"
            , property "grid-gap" "0.5rem"
            , property "justify-items" "center"
            ]
        ]
        (List.map galleryView galleries)
