module Gallery.View exposing (galleryListView, galleryView)

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
import Gallery.Model exposing (Gallery)
import Html.Styled exposing (Html, a, div, img, p, text)
import Html.Styled.Attributes exposing (css, href, src)

image : String -> Html msg
image imageUrl = img [ src imageUrl ] []

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
            [ href gallery.url ]
            [ img
                [ css
                    [ backgroundColor (hex "ddd")
                    , width (rem 12.5)
                    , height (rem 12.5)
                    ]
                , src gallery.url ]
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
