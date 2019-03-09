module Graphql exposing (makeRequest)

import Gallery.Graphql exposing (query)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Msg exposing (AppMsg(..))
import RemoteData


makeRequest : String -> Cmd AppMsg
makeRequest api =
    query
        |> Graphql.Http.queryRequest api
        |> Graphql.Http.send (RemoteData.fromResult >> ReceiveGalleries)



-- makeImagesRequest : SelectionSet ImagesResponse RootQuery -> Cmd AppMsg
-- makeImagesRequest query =
--     query
--         |> Graphql.Http.queryRequest "http://localhost:8000/graphql"
--         |> Graphql.Http.send (RemoteData.fromResult >> ReceiveImages)
