module Home exposing (view)

import Browser
import Css
    exposing
        ( backgroundColor
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
        , marginTop
        , minHeight
        , pct
        , property
        , rem
        , vh
        , width
        )
import Gallery.View exposing (galleryListView, imageListView, singleImageView)
import Html.Styled exposing (Html, a, div, h1, text, toUnstyled)
import Html.Styled.Attributes exposing (css, href, rel, target)
import Model exposing (AppModel)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), link, routeToUrl)
import RemoteData
import Spinner exposing (textLoadingSpinner)
import Update exposing (getGalleryForSlug, getGalleryForWebGallerySlug)


router : AppModel -> Html AppMsg
router model =
    case model.galleries of
        RemoteData.Success galleries ->
            case model.route of
                Home ->
                    galleryListView galleries

                Gallery slug ->
                    let
                        gallery =
                            getGalleryForSlug slug galleries
                    in
                    imageListView gallery

                Image gallerySlug imageSlug ->
                    let
                        gallery =
                            getGalleryForWebGallerySlug gallerySlug model.galleries
                    in
                    singleImageView gallery imageSlug

        RemoteData.NotAsked ->
            textLoadingSpinner
                "Initializing application"

        RemoteData.Loading ->
            textLoadingSpinner
                "Loading galleries"

        RemoteData.Failure _ ->
            div [] [ text "Something went wrong while fetching galleries" ]


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
            (getAppTitle model
                ++ (if model.autoplay then
                        " ▶️"

                    else
                        ""
                   )
            )
        , body model
        , footer model.commitSha model.commitMsg model.commitLink
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
            [ link (routeToUrl Home)
                [ css
                    [ color (hex "fff") ]
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


footer : String -> String -> String -> Html msg
footer commitSha commitMsg commitLink =
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
                , Css.flexDirection Css.column
                , Css.justifyContent Css.center
                , Css.alignItems Css.center
                , height (pct 100)
                ]
            ]
            [ a
                [ href "https://github.com/sklirg/picturelm"
                , target "_blank"
                , rel "noopener"
                , css [ fontWeight (int 300) ]
                ]
                [ text "Image gallery made with ❤ in Elm" ]
            , a
                [ css [ fontWeight (int 300), marginTop (Css.px 2), Css.fontSize (rem 0.8) ] ]
                [ a
                    [ href commitLink
                    , target "_blank"
                    , rel "noopener"
                    ]
                    [ text ("Latest update - " ++ String.slice 0 7 commitSha ++ ": " ++ commitMsg) ]
                ]
            ]
        ]


view : AppModel -> Browser.Document AppMsg
view model =
    { title = ""
    , body = [ toUnstyled (home model) ]
    }



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
