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


imageView : Gallery -> Image -> Html AppMsg
imageView gallery image =
    div []
        [ link (ChangeRoute (Navigation.Image gallery.slug image.title))
            []
            [ img
                [ css
                    [ height (rem 15)
                    , width (rem 20)
                    ]
                , src image.imageUrl
                ]
                []
            ]
        ]


imageListView : Gallery -> Html AppMsg
imageListView gallery =
    div
        [ css
            [ property "display" "grid"
            , property "grid-template-columns" "repeat(auto-fit, minmax(200px, 1fr))"
            , property "grid-gap" "1rem"
            , property "justify-items" "center"
            , marginLeft (rem 1)
            , marginRight (rem 1)
            ]
        ]
        [ div
            []
            [ p []
                [ text (String.fromInt (List.length gallery.images) ++ " image(s)") ]
            , div
                []
                (List.map (imageView gallery) gallery.images)
            ]
        ]


galleryView : Gallery -> Html AppMsg
galleryView gallery =
    div []
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
                        , width (rem 12.5)
                        , height (rem 12.5)
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
            , property "grid-template-columns" "repeat(auto-fit, minmax(200px, 1fr))"
            , property "grid-gap" "1rem"
            , property "justify-items" "center"
            , marginLeft (rem 1)
            , marginRight (rem 1)
            ]
        ]
        (List.map galleryView galleries)
