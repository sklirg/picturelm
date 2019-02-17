module Gallery.Graphql exposing (APIGallery, APIModel, ImagesRequest, ImagesResponse, Response, imageEdges, imageSet, images)

import Gallery.Model exposing (Gallery, Image)
import Gallery.Object
import Gallery.Object.GalleryNode
import Gallery.Object.ImageNode
import Gallery.Object.ImageNodeConnection
import Gallery.Object.ImageNodeEdge
import Gallery.Scalar exposing (Id(..))
import Graphql.Http
import Graphql.SelectionSet exposing (SelectionSet, with)
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


type alias APIModel =
    RemoteData (Graphql.Http.Error Response) Response


type alias ImagesRequest =
    RemoteData (Graphql.Http.Error (List Image)) (List Image)


image : SelectionSet Image Gallery.Object.ImageNode
image =
    Graphql.SelectionSet.succeed Image
        |> with Gallery.Object.ImageNode.title
        |> with
            (Gallery.Object.ImageNode.imageUrl
                |> Graphql.SelectionSet.nonNullOrFail
            )


imageToNode : SelectionSet Image Gallery.Object.ImageNodeEdge
imageToNode =
    Gallery.Object.ImageNodeEdge.node image |> Graphql.SelectionSet.nonNullOrFail


imageEdges : SelectionSet (List Image) Gallery.Object.ImageNodeConnection
imageEdges =
    Gallery.Object.ImageNodeConnection.edges imageToNode |> Graphql.SelectionSet.nonNullElementsOrFail


imageSet : SelectionSet (List Image) Gallery.Object.GalleryNode
imageSet =
    Gallery.Object.GalleryNode.imageSet (\opts -> opts) imageEdges
        |> Graphql.SelectionSet.nonNullOrFail


images : SelectionSet ImagesResponse Gallery.Object.GalleryNode
images =
    Graphql.SelectionSet.map ImagesResponse
        imageSet
