module Gallery.View exposing (galleryListView, imageListView, query, singleImageView)

import Css
    exposing
        ( backgroundColor
        , block
        , color
        , display
        , height
        , hex
        , marginLeft
        , marginRight
        , maxWidth
        , none
        , property
        , rem
        , textDecoration
        , vw
        , width
        )
import Gallery.Graphql exposing (Response, imageSet)
import Gallery.Model as Model exposing (Gallery, Image)
import Gallery.Object
import Gallery.Object.GalleryNode
import Gallery.Object.GalleryNodeConnection
import Gallery.Object.GalleryNodeEdge
import Gallery.Query
import Gallery.Scalar exposing (Id(..))
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html.Styled exposing (Html, div, h1, img, p, text)
import Html.Styled.Attributes exposing (css, href, src)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), link)


singleImageView : Image -> Html msg
singleImageView image =
    div
        [ css
            [ property "display" "grid"
            , property "grid-template-rows" "6rem 1fr"
            , property "grid-gap" "1rem"
            , property "justify-items" "center"
            ]
        ]
        [ h1 [] [ text image.title ]
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



-- imageListView : Gallery -> Html msg


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



-- galleryView : Gallery -> Html AppMsg


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



-- galleryListView : List Gallery -> Html msg


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


apiGallery : SelectionSet Gallery Gallery.Object.GalleryNode
apiGallery =
    SelectionSet.succeed Model.Gallery
        |> with Gallery.Object.GalleryNode.id
        |> with Gallery.Object.GalleryNode.title
        |> with Gallery.Object.GalleryNode.slug
        |> with Gallery.Object.GalleryNode.thumbnail
        |> with (Gallery.Object.GalleryNode.description |> SelectionSet.map (Maybe.withDefault ""))
        |> with imageSet


apiGalleryNodeEdge : SelectionSet Gallery Gallery.Object.GalleryNodeEdge
apiGalleryNodeEdge =
    SelectionSet.succeed identity
        |> with (Gallery.Object.GalleryNodeEdge.node apiGallery |> SelectionSet.nonNullOrFail)


apiGalleries : SelectionSet (List Gallery) Gallery.Object.GalleryNodeConnection
apiGalleries =
    SelectionSet.succeed identity
        |> with (Gallery.Object.GalleryNodeConnection.edges apiGalleryNodeEdge |> SelectionSet.nonNullElementsOrFail)


query : SelectionSet Response RootQuery
query =
    SelectionSet.succeed Response
        |> with (Gallery.Query.allGalleries (\opts -> opts) apiGalleries |> SelectionSet.nonNullOrFail)
