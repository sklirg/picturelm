module Gallery.View exposing (galleryListView, imageListView)

import Css exposing
    ( backgroundColor
    , color
    , height
    , hex
    , marginLeft
    , marginRight
    , none
    , property
    , rem
    , textDecoration
    , width
    )
import Gallery.Model exposing (Gallery, Image)
import Html.Styled exposing (Html, a, div, img, p, text)
import Html.Styled.Attributes exposing (css, href, src)
import Navigation exposing (Route(..), routeToUrl)

imageView : Image -> Html msg
imageView image = img [ src image.url ] []

imageListView : List Image -> Html msg
imageListView images = div
    [ css
        [ property "display" "grid"
        , property "grid-template-columns" "repeat(auto-fit, minmax(200px, 1fr))"
        , property "grid-gap" "1rem"
        , property "justify-items" "center"
        , marginLeft (rem 1)
        , marginRight (rem 1)
        ]
    ]
    (List.map imageView images)

galleryView : Gallery -> Html msg
galleryView gallery = div []
    [ div
        []
        [ p []
            [ a
                [ css [ color (hex "000")
                , textDecoration none
                ]
                , href gallery.url
                ]
                [ text gallery.title ] ]
        , a
            [ href (routeToUrl (Navigation.Gallery gallery.id))
            ]
            [ img
                [ css
                    [ backgroundColor (hex "ddd")
                    , width (rem 12.5)
                    , height (rem 12.5)
                    ]
                , src gallery.thumbnail ]
                []
            ]
        ]
    ]

galleryListView : List Gallery -> Html msg
galleryListView galleries = div
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
