module Main exposing (..)

import AnimationFrame
import Animator exposing (defaultAnimator)
import Html exposing (Html)
import Keyboard.Extra as KE
import Types exposing (..)
import Update exposing (update)
import View exposing (view)
import Task
import WebGL.Texture as Texture
import Player


init : {} -> ( State, Cmd Msg )
init _ =
    ( Playing
        { textureStore = blankTextureStore
        , keyboard = KE.initialState
        , animation =
            { defaultAnimator
                | maxWidth = 32
                , maxHeight = 32
                , frameWidth = 16
                , frameHeight = 16
                , frames = 2
                , startLoc = ( 0, 1 )
                , frameDelay = 1000
            }
        }
    , Cmd.batch [ loadTextures ]
    )


loadTextures : Cmd Msg
loadTextures =
    let
        options =
            Texture.defaultOptions
    in
        [ ( "res/player.png", PlayerTexture )
        , ( "bar", TileMapTexture )
        ]
            |> List.map
                (\( path, encoder ) ->
                    Texture.loadWith
                        { options
                            | magnify = Texture.nearest
                            , minify = Texture.nearest
                        }
                        path
                        |> Task.map encoder
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
