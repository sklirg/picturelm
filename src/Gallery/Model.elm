module Gallery.Model exposing (Gallery, Image)

import Gallery.Scalar exposing (Id(..))

type alias Gallery =
    { id: Id
    , title: String
    -- , description: String
    , thumbnail: String
    -- , url: String
    -- , images: List Image
    }

type alias Image =
    { title: String
    , url: String
    , thumbnail: String
    }
