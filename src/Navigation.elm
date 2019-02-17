port module Navigation exposing (Route(..), link, locationHrefToRoute, pushUrl, routeToUrl)

import Html.Styled exposing (Attribute, Html, a)
import Html.Styled.Events exposing (preventDefaultOn)
import Json.Decode as D
import Url
import Url.Parser as Url exposing ((</>), map, oneOf, parse, s, string, top)


type Route
    = Home
    | Gallery String
    | Image String


link : msg -> List (Attribute msg) -> List (Html msg) -> Html msg
link href attrs children =
    a (preventDefaultOn "click" (D.succeed ( href, True )) :: attrs) children


locationHrefToRoute : String -> Maybe Route
locationHrefToRoute locationHref =
    case Url.fromString locationHref of
        Just url ->
            Url.parse myParser url

        _ ->
            Nothing


routeToUrl : Route -> String
routeToUrl route =
    case route of
        Home ->
            "/"

        Gallery param ->
            "/gallery/" ++ param

        Image param ->
            "/image/" ++ param


myParser : Url.Parser (Route -> Route) Route
myParser =
    oneOf
        [ map Gallery (s "gallery" </> string)
        , map Home top
        ]


port pushUrl : String -> Cmd msg
