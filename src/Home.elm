module Home exposing (view)

import Css
    exposing
        ( auto
        , backgroundColor
        , center
        , color
        , column
        , displayFlex
        , flexDirection
        , fontWeight
        , height
        , hex
        , int
        , justifyContent
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , minHeight
        , pct
        , property
        , rem
        , vh
        , width
        )
import Gallery.View exposing (galleryListView, imageListView, singleImageView)
import Html
import Html.Styled exposing (Html, a, div, h1, p, text, toUnstyled)
import Html.Styled.Attributes exposing (css, href)
import Model exposing (AppModel)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), link)
import RemoteData
import Update exposing (getGalleryForSlug, getGalleryForWebGallerySlug, getImageForSlug)


router : AppModel -> Html AppMsg
router model =
    case model.route of
        Home ->
            galleryListView model.galleries

        Gallery slug ->
            let
                gallery =
                    getGalleryForWebGallerySlug slug model.galleries
            in
            imageListView gallery

        Image gallerySlug imageSlug ->
            let
                gallery =
                    getGalleryForWebGallerySlug gallerySlug model.galleries
            in
            singleImageView gallery imageSlug


home : AppModel -> Html AppMsg
home model =
    div
        [ css
            [ property "display" "grid"
            , property "grid-template-rows" "5rem auto 5rem"
            , minHeight (vh 100)
            ]
        ]
        [ header (getAppTitle model)
        , body model
        , footer
        ]


header : String -> Html AppMsg
header headerText =
    div
        [ css
            [ backgroundColor (hex "3c3c3c")
            , color (hex "ccc")
            ]
        ]
        [ div
            [ css
                [ displayFlex
                , justifyContent center
                , flexDirection column
                , marginLeft (rem 2)
                , height (pct 100)
                ]
            ]
            [ link (ChangeRoute Home)
                [ css
                    [ color (hex "fff") ]
                , href "/"
                ]
                [ h1
                    [ css
                        [ marginTop (rem 0)
                        , marginBottom (rem 0)
                        ]
                    ]
                    [ text headerText ]
                ]
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
            , width (pct 100)
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
                    , fontWeight (int 300)
                    ]
                ]
                [ a [ href "https://github.com/sklirg/picturelm" ] [ text "Image gallery made with ❤ in Elm" ] ]
            ]
        ]


view : AppModel -> Html.Html AppMsg
view model =
    toUnstyled (home model)



-- Utility functions


getAppTitle : AppModel -> String
getAppTitle model =
    case model.route of
        Gallery slug ->
            let
                gallery =
                    getGalleryForWebGallerySlug slug model.galleries
            in
            gallery.title

        Home ->
            "Picturelm"

        Image gallerySlug _ ->
            let
                gallery =
                    getGalleryForWebGallerySlug gallerySlug model.galleries
            in
            gallery.title
