module Main exposing (..)

import Html exposing (Html)
import Types exposing (..)
import Update exposing (update)
import View exposing (view)


init : {} -> ( Model, Cmd Msg )
init _ =
    ( { textureStore = { blankTexture = Nothing }
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program {} Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
