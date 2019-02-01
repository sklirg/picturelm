module Home exposing (view)

import Css exposing
    ( property
    , minHeight
    , vh
    , rem
    , backgroundColor
    , hex
    , color
    , margin2
    , width
    , marginTop
    , marginBottom
    , marginLeft
    , marginRight
    , displayFlex
    , vw
    , auto
    , pct
    )
import Gallery.View exposing (galleryListView)
import Html.Styled exposing (Html, div, text, p, toUnstyled)
import Html.Styled.Attributes exposing (css)
import VirtualDom exposing (Node)

import Model exposing (AppModel)

home : AppModel -> Html msg
home model = div
    [ css
        [ property "display" "grid"
        , property "grid-template-rows" "5rem auto 5rem"
        , minHeight (vh 100)
        ]
    ]
    [ header
    , body model
    , footer
    ]

header : Html msg
header = div
    [ css
        [ backgroundColor (hex "3c3c3c")
        , color (hex "ccc")
        ]
    ]
    [ div
        [ css
            [ margin2 (rem 2) (rem 2)
            , displayFlex
            ]
        ]
        [ p
            []
            [ text "Picturelm" ]
        ]
    ]

body : AppModel -> Html msg
body model = div
    [ css
        [ margin2 (rem 2) auto
        , width (pct 100)
        ]
    ]
    [ galleryListView model.galleries ]

footer : Html msg
footer = div
    [ css
        [ backgroundColor (hex "3c3c3c")
        , color (hex "ccc")
        , width (vw 100)
        ]
    ]
    [ div
        [ css
            [ displayFlex
            , marginTop (rem 2)
            , marginBottom (rem 2)
            ]
        ]
        [ p
            [ css
                [ marginLeft auto
                , marginRight auto
                ]
            ]
            [ text "Image gallery made with ❤ in Elm" ]
        ]
    ]

view : AppModel -> Node msg
view model = toUnstyled (home model)
