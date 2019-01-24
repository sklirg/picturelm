module Main exposing (main)

import Browser
import Home exposing (view)
import Model exposing (AppModel, baseModel)
import Msg exposing (AppMsg)
import Update exposing (update)


main : Program AppModel AppModel AppMsg
main =
    Browser.element
        { init = baseModel
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


subscriptions : AppModel -> Sub AppMsg
subscriptions _ =
    Sub.none
