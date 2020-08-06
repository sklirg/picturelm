module Navigation exposing (Route(..), internalPath, link, locationHrefToRoute, routeParser, routeToUrl)

import Html.Styled exposing (Attribute, Html, a)
import Html.Styled.Attributes
import Url
import Url.Parser as Url exposing ((</>), map, oneOf, parse, s, string, top)


type Route
    = Home
    | Gallery String
    | Image String String


link : String -> List (Attribute msg) -> List (Html msg) -> Html msg
link href attrs children =
    a (Html.Styled.Attributes.href href :: attrs) children


locationHrefToRoute : Url.Url -> Route
locationHrefToRoute url =
    case Url.parse routeParser url of
        Just u ->
            u

        Nothing ->
            Home


routeToUrl : Route -> String
routeToUrl route =
    case route of
        Home ->
            "/"

        Gallery slug ->
            "/gallery/" ++ slug

        Image gallerySlug imageSlug ->
            "/gallery/" ++ gallerySlug ++ "/" ++ imageSlug


routeParser : Url.Parser (Route -> Route) Route
routeParser =
    oneOf
        [ map Gallery (s "gallery" </> string)
        , map Image (s "gallery" </> string </> string)
        , map Home top
        ]



-- internalPath replaces the 'path' in the current location
-- used for keyboard events to trigger route changes


internalPath : Url.Url -> Route -> Url.Url
internalPath site route =
    { site | path = routeToUrl route }
