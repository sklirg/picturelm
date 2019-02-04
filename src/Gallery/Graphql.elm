module Gallery.Graphql exposing (APIGallery, APIModel, Response)

import Gallery.Model exposing (Gallery)
import Gallery.Object exposing (GalleryNode)
import Gallery.Object.GalleryNode
import Gallery.Query exposing (AllGalleriesOptionalArguments)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Graphql.Http
import RemoteData exposing (RemoteData)


type alias APIGallery = {
    title: String
    }

-- OLD

type alias GalleryLookup = {
    title: String
    }

type alias Response = {
    gallery: Gallery
    }

type alias APIModel =
    RemoteData (Graphql.Http.Error Response) Response

---
