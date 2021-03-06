module Gallery.Model exposing (ExifData, Gallery, Image, baseExifData)

import Gallery.Scalar exposing (Id(..))


type alias Gallery =
    { id : Id
    , title : String
    , slug : String
    , thumbnailImage : Image
    , description : String
    , images : List Image
    }


type alias Image =
    { title : String
    , imageUrl : String
    , exif : ExifData
    , sizes : List String
    }


type alias ExifData =
    { cameraModel : String
    , exposureProgram : String
    , focalLength : String
    , fStop : Float
    , iso : String
    , lensModel : String
    , shutterSpeed : String
    , coordinates : List Float
    }


baseExifData : ExifData
baseExifData =
    { cameraModel = ""
    , exposureProgram = ""
    , focalLength = ""
    , fStop = 0.0
    , iso = ""
    , lensModel = ""
    , shutterSpeed = ""
    , coordinates = []
    }
