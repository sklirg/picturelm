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
    , maxWidth
    , width
    , marginTop
    , marginBottom
    , marginLeft
    , marginRight
    , displayFlex
    , vw
    , auto
    )
import Html.Styled exposing (Html, div, text, p, toUnstyled)
import Html.Styled.Attributes exposing (css)

home : Html msg
home = div
    [ css
        [ property "display" "grid"
        , property "grid-template-rows" "5rem auto 5rem"
        , minHeight (vh 100)
        ]
    ]
    [ header
    , body
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

body : Html msg
body = div
    [ css
        [ margin2 (rem 2) auto
        , maxWidth (rem 60)
        ]
    ]
    [ text "body" ]

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

view = toUnstyled home
