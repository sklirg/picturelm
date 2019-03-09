module Gallery.Graphql exposing (APIGallery, ImagesRequest, ImagesResponse, Response, WebGalleries, imageEdges, imageSet, images, query)

import Gallery.Model exposing (Gallery, Image)
import Gallery.Object
import Gallery.Object.GalleryNode
import Gallery.Object.GalleryNodeConnection
import Gallery.Object.GalleryNodeEdge
import Gallery.Object.ImageNode
import Gallery.Object.ImageNodeConnection
import Gallery.Object.ImageNodeEdge
import Gallery.Query
import Gallery.Scalar exposing (Id(..))
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)


type alias APIGallery =
    { title : String
    }


type alias Response =
    { galleries : List Gallery
    }


type alias ImagesResponse =
    { images : List Image
    }


type alias WebGalleries =
    RemoteData (Graphql.Http.Error Response) Response


type alias ImagesRequest =
    RemoteData (Graphql.Http.Error (List Image)) (List Image)


apiGallery : SelectionSet Gallery Gallery.Object.GalleryNode
apiGallery =
    SelectionSet.succeed Gallery
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


image : SelectionSet Image Gallery.Object.ImageNode
image =
    SelectionSet.succeed Image
        |> with Gallery.Object.ImageNode.title
        |> with Gallery.Object.ImageNode.imageUrl


imageToNode : SelectionSet Image Gallery.Object.ImageNodeEdge
imageToNode =
    Gallery.Object.ImageNodeEdge.node image |> SelectionSet.nonNullOrFail


imageEdges : SelectionSet (List Image) Gallery.Object.ImageNodeConnection
imageEdges =
    Gallery.Object.ImageNodeConnection.edges imageToNode |> SelectionSet.nonNullElementsOrFail


imageSet : SelectionSet (List Image) Gallery.Object.GalleryNode
imageSet =
    Gallery.Object.GalleryNode.imageSet (\opts -> opts) imageEdges
        |> SelectionSet.nonNullOrFail


images : SelectionSet ImagesResponse Gallery.Object.GalleryNode
images =
    SelectionSet.map ImagesResponse
        imageSet
