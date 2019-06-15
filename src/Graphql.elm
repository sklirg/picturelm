module Graphql exposing (makeRequest)

import Gallery.Graphql exposing (query)
import Graphql.Http
import Msg exposing (AppMsg(..))
import RemoteData


makeRequest : String -> Cmd AppMsg
makeRequest api =
    query
        |> Graphql.Http.queryRequest api
        |> Graphql.Http.send (RemoteData.fromResult >> ReceiveGalleries)
