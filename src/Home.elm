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
import Gallery.View exposing (galleryListView, imageListView, singleImageView)
import Html
import Html.Styled exposing (Html, div, p, text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Model exposing (AppModel)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), link)
import Update exposing (getGalleryForSlug, getImageForSlug)


router : AppModel -> Html AppMsg
router model =
    case model.route of
        Home ->
            galleryListView model.galleries

        Gallery slug ->
            let
                gallery =
                    getGalleryForSlug slug model.galleries
            in
            imageListView gallery

        Image gallerySlug imageSlug ->
            let
                gallery =
                    getGalleryForSlug gallerySlug model.galleries

                image =
                    getImageForSlug imageSlug gallery.images
            in
            singleImageView image


home : AppModel -> Html AppMsg
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


body : AppModel -> Html AppMsg
body model =
    div
        [ css
            [ marginBottom (rem 2)
            , width (pct 100)
            , marginTop (rem 2)
            ]
        ]
        [ router model
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


view : AppModel -> Html.Html AppMsg
view model =
    toUnstyled (home model)
