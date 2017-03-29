module Main exposing (..)

import AnimationFrame
import Animator exposing (defaultAnimator)
import Html exposing (Html)
import Types exposing (..)
import Update exposing (update)
import View exposing (view)
import Task
import WebGL.Texture as Texture
import World


init : {} -> ( State, Cmd Msg )
init _ =
    ( Playing
        { textureStore = blankTextureStore
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
    case state of
        Playing model ->
            AnimationFrame.diffs Tick

        _ ->
            Sub.none


main : Program {} State Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
