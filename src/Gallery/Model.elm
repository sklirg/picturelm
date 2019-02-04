module Gallery.Model exposing (Gallery, Image)

type alias Gallery =
    { id: String
    , title: String
    , description: String
    -- , thumbnail: String
    -- , url: String
    -- , images: List Image
    }

type alias Image =
    { title: String
    , url: String
    , thumbnail: String
    }
