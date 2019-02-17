module Gallery.Model exposing (Gallery, Image)

import Gallery.Scalar exposing (Id(..))


type alias Gallery =
    { id : Id
    , title : String
    , thumbnail : String
    , description : String
    , images : List Image
    }


type alias Image =
    { title : String
    , imageUrl : String

    -- , thumbnail : String
    }
