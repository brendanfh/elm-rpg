module Main exposing (..)

import AnimationFrame
import Html exposing (Html)
import Keyboard.Extra as KE
import Types exposing (..)
import Update exposing (update)
import View exposing (view)
import Task
import WebGL.Texture as Texture
import Player exposing (defaultPlayer)


init : {} -> ( State, Cmd Msg )
init _ =
    ( Playing
        { textureStore = blankTextureStore
        , keyboard = KE.initialState
        , player = defaultPlayer 0 0
        }
    , Cmd.batch [ loadTextures ]
    )


loadTextures : Cmd Msg
loadTextures =
    let
        options =
            Texture.defaultOptions
    in
        [ ( "res/player.png", "player" )
        , ( "bar", "tilemap" )
        ]
            |> List.map
                (\( path, name ) ->
                    Texture.loadWith
                        { options
                            | magnify = Texture.nearest
                            , minify = Texture.nearest
                        }
                        path
                        |> Task.map (\t -> ( t, name ))
                )
            |> List.map
                (Task.attempt
                    (\result ->
                        case result of
                            Err error ->
                                TextureLoadingError error

                            Ok texture ->
                                TextureLoadedSuccessful texture
                    )
                )
            |> Cmd.batch


subscriptions : State -> Sub Msg
subscriptions state =
    let
        stateBasedInputs =
            case state of
                Playing model ->
                    AnimationFrame.diffs Tick

                _ ->
                    Sub.none

        constantInputs =
            Sub.map KeyboardMsg KE.subscriptions
    in
        Sub.batch [ stateBasedInputs, constantInputs ]


main : Program {} State Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
