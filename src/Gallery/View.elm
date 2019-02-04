module Gallery.View exposing (galleryListView, imageListView, makeRequest)

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
import Gallery.Graphql exposing (APIGallery, APIModel, Response)
import Gallery.Model as Model exposing (Gallery, Image)
import Gallery.Object exposing (GalleryNode, GalleryNodeEdge)
import Gallery.Object.GalleryNode
import Gallery.Object.GalleryNodeEdge
import Gallery.Object.GalleryNodeConnection
import Gallery.Query exposing (AllGalleriesOptionalArguments)
import Gallery.Scalar exposing (Id(..))
import Graphql.Operation exposing (RootQuery)
import Graphql.Http
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
import Html.Styled exposing (Html, a, button, div, img, p, text)
import Html.Styled.Attributes exposing (css, href, src)
import Html.Styled.Events exposing (onClick)
import Msg exposing (AppMsg(..))
import Navigation exposing (Route(..), routeToUrl)
import Gallery.Query
import RemoteData exposing (RemoteData)

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

-- galleryView : Gallery -> Html AppMsg
galleryView gallery = div []
    [ div
        []
        [ p []
            [ a
                [ css [ color (hex "000")
                , textDecoration none
                ]
                , href gallery.id
                ]
                [ text gallery.title ] ]
        , a
            [ onClick (ChangeRoute (Navigation.Gallery gallery.id))
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

-- galleryListView : List Gallery -> Html msg
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


-- Requestish

-- galleryResp : SelectionSet Response RootQuery
-- galleryResp =
--     SelectionSet.map Response
--         (GalleryNode.title)
-- import Gallery.Query exposing (AllGalleriesOptionalArguments)

apiGallery : SelectionSet APIGallery Gallery.Object.GalleryNode
apiGallery =
    SelectionSet.succeed APIGallery
        -- |> with Gallery.Object.GalleryNode.id
        |> with Gallery.Object.GalleryNode.title
        -- |> with Gallery.Object.GalleryNode.description
        -- |> with Gallery.Object.GalleryNode.thumbnail


-- apiGalleryNode : SelectionSet Gallery.Object.GalleryNode GalleryNodeEdge
-- apiGalleryNode =
--     SelectionSet.succeed Gallery.Object.GalleryNode
--         |> with (Gallery.Object.GalleryNodeEdge.node |> SelectionSet.nonNullOrFail)

-- apiGalleries : SelectionSet AllGalleriesOptionalArguments GalleryNodeEdge
-- apiGalleries =
--     SelectionSet.succeed AllGalleriesOptionalArguments
--         |> with (Gallery.Object.GalleryNodeConnection.edges apiGalleryNode |> SelectionSet.nonNullOrFail |> SelectionSet.nonNullElementsOrFail)

-- apiGalleries = 

query : SelectionSet Response RootQuery
query =
    SelectionSet.succeed Response
        |> with (Gallery.Query.gallery { id = Id "R2FsbGVyeU5vZGU6YzI0OThmZDItODEzYy00MjQxLWFhYjItYWZlNDhiZTU3YmEx" } apiGallery |> SelectionSet.nonNullOrFail)
        -- |> with (Gallery.Query.allGalleries apiGalleries |> SelectionSet.nonNullOrFail)

makeRequest : Cmd AppMsg
makeRequest =
    query
        |> Graphql.Http.queryRequest "http://localhost:8000/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> ReceiveGalleries)
