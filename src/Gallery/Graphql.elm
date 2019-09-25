module Gallery.Graphql exposing (ImagesRequest, WebGalleries, imageEdges, imageSet, query)

import Gallery.Model exposing (ExifData, Gallery, Image, baseExifData)
import Gallery.Object
import Gallery.Object.ExifNode
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
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with, withDefault)
import Json.Decode exposing (decodeString, list, string)
import RemoteData exposing (RemoteData)


type alias WebGalleries =
    RemoteData (Graphql.Http.Error (List Gallery)) (List Gallery)


type alias ImagesRequest =
    RemoteData (Graphql.Http.Error (List Image)) (List Image)


apiGallery : SelectionSet Gallery Gallery.Object.GalleryNode
apiGallery =
    SelectionSet.succeed Gallery
        |> with Gallery.Object.GalleryNode.id
        |> with Gallery.Object.GalleryNode.title
        |> with Gallery.Object.GalleryNode.slug
        |> with (Gallery.Object.GalleryNode.thumbnailImage image)
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


query : SelectionSet (List Gallery) RootQuery
query =
    SelectionSet.succeed identity
        |> with (Gallery.Query.allGalleries (\opts -> opts) apiGalleries |> SelectionSet.nonNullOrFail)


exifDecoder : SelectionSet ExifData Gallery.Object.ExifNode
exifDecoder =
    SelectionSet.map8 ExifData
        Gallery.Object.ExifNode.cameraModel
        Gallery.Object.ExifNode.exposureProgram
        Gallery.Object.ExifNode.focalLength
        Gallery.Object.ExifNode.fStop
        Gallery.Object.ExifNode.iso
        Gallery.Object.ExifNode.lensModel
        Gallery.Object.ExifNode.shutterSpeed
        Gallery.Object.ExifNode.coordinates


decodeStringWithDefault : Result Json.Decode.Error (List String) -> List String
decodeStringWithDefault s =
    case s of
        Ok v ->
            v

        Err _ ->
            [ "default return after deconstruct" ]


getStringFromJsonString : Gallery.Scalar.JSONString -> String
getStringFromJsonString s =
    case s of
        Gallery.Scalar.JSONString a ->
            a


decodeJsonStringToListString : Gallery.Scalar.JSONString -> List String
decodeJsonStringToListString s =
    decodeStringWithDefault (decodeString (list string) (getStringFromJsonString s))


imageSizesDecoder : SelectionSet (List String) Gallery.Object.ImageNode
imageSizesDecoder =
    Gallery.Object.ImageNode.sizes
        |> SelectionSet.map (\n -> decodeJsonStringToListString n)


image : SelectionSet Image Gallery.Object.ImageNode
image =
    SelectionSet.succeed Image
        |> with Gallery.Object.ImageNode.title
        |> with Gallery.Object.ImageNode.imageUrl
        |> with (Gallery.Object.ImageNode.exif exifDecoder |> SelectionSet.withDefault baseExifData)
        |> with imageSizesDecoder


imageToNode : SelectionSet Image Gallery.Object.ImageNodeEdge
imageToNode =
    Gallery.Object.ImageNodeEdge.node image |> SelectionSet.nonNullOrFail


imageEdges : SelectionSet (List Image) Gallery.Object.ImageNodeConnection
imageEdges =
    Gallery.Object.ImageNodeConnection.edges imageToNode |> SelectionSet.nonNullElementsOrFail


imageSet : SelectionSet (List Image) Gallery.Object.GalleryNode
imageSet =
    Gallery.Object.GalleryNode.imageSet (\opts -> opts) imageEdges
