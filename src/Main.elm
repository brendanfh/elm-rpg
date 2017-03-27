module Main exposing (..)

import Html exposing (Html)
import Types exposing (..)
import Update exposing (update)
import View exposing (view)
import Task
import WebGL.Texture as Texture


init : {} -> ( State, Cmd Msg )
init _ =
    ( Playing
        { textureStore = blankTextureStore
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
subscriptions model =
    Sub.none


main : Program {} State Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }