module Gallery.Graphql exposing (APIGallery, APIModel, Response)

import Gallery.Model exposing (Gallery)
import Graphql.Http
import RemoteData exposing (RemoteData)


type alias APIGallery =
    { title : String
    }


type alias Response =
    { galleries : List Gallery
    }


type alias APIModel =
    RemoteData (Graphql.Http.Error Response) Response
