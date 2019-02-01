module Gallery.Model exposing (Gallery, Image)

type alias Gallery =
    { title: String
    , thumbnail: String
    , url: String
    , id: String
    , images: List Image
    }

type alias Image =
    { title: String
    , url: String
    , thumbnail: String
    }
