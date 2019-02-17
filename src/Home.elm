module Home exposing (view)

import Css
    exposing
        ( auto
        , backgroundColor
        , color
        , displayFlex
        , hex
        , margin2
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , minHeight
        , pct
        , property
        , rem
        , vh
        , vw
        , width
        )
import Gallery.View exposing (galleryListView, imageListView)
import Html.Styled exposing (Html, a, button, div, p, text, toUnstyled)
import Html.Styled.Attributes exposing (css, href)
import Html.Styled.Events exposing (onClick)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), link)
import Update exposing (getGalleryForSlug)



-- router : AppModel -> Html msg


router model =
    case model.route of
        Home ->
            galleryListView model.galleries

        Gallery slug ->
            let
                gallery =
                    getGalleryForSlug slug model.galleries

                images =
                    gallery.images
            in
            imageListView images

        Image _ ->
            div [] [ text "Image" ]



-- home : AppModel -> Html msg


home model =
    div
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


header : Html AppMsg
header =
    div
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
            [ link (ChangeRoute Home)
                [ css [ color (hex "fff") ] ]
                [ text "Picturelm" ]
            ]
        ]



-- body : AppModel -> Html msg


body model =
    div
        [ css
            [ margin2 (rem 2) auto
            , width (pct 100)
            ]
        ]
        [ router model
        , button [ onClick FetchGalleries ] [ text "Fetch galleries" ]
        ]


footer : Html msg
footer =
    div
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



-- view : AppModel -> Node msg


view model =
    toUnstyled (home model)
