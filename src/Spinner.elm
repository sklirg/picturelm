module Spinner exposing (loadingSpinner, textLoadingSpinner)

import Css exposing (center, column, displayFlex, flexDirection, justifyContent, marginTop, rem)
import Html.Styled exposing (Html, div, p, text)
import Html.Styled.Attributes exposing (css, property)
import Json.Encode as Encode


loadingSpinner : Html msg
loadingSpinner =
    div
        [ css
            [ displayFlex
            , justifyContent center
            ]
        ]
        [ spinner
        ]


textLoadingSpinner : String -> Html msg
textLoadingSpinner txt =
    div
        [ css
            [ displayFlex
            , justifyContent center
            ]
        ]
        [ div
            [ css
                [ displayFlex
                , flexDirection column
                ]
            ]
            [ loadingSpinner
            , p
                [ css
                    [ displayFlex
                    , justifyContent center
                    , marginTop (rem 1)
                    ]
                ]
                [ text txt ]
            ]
        ]


spinner : Html msg
spinner =
    div [ property "className" (Encode.string "lds-ripple") ]
        [ div [] []
        , div [] []
        , div [] []
        , div [] []
        ]
