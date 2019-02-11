module Gallery.Model exposing (Gallery, Image)

import Gallery.Scalar exposing (Id(..))

type alias Gallery =
    { id: Id
    , title: String
    , thumbnail: String
    , description: String
    -- , url: String
    -- , images: List Image
    }

type alias Image =
    { title: String
    , url: String
    , thumbnail: String
    }
