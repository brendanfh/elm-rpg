module Update exposing (update)

import Dict
import Keyboard.Extra as KE
import Player
import Types exposing (..)


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case state of
        Playing model ->
            updatePlaying msg model

        _ ->
            ( state, Cmd.none )


updatePlaying : Msg -> PlayingModel -> ( State, Cmd Msg )
updatePlaying msg model =
    case msg of
        TextureLoadingError _ ->
            ( Playing model, Cmd.none )

        TextureLoadedSuccessful encoding ->
            ( Playing <| processTexture encoding model, Cmd.none )

        KeyboardMsg keyMsg ->
            ( Playing <| { model | keyboard = KE.update keyMsg model.keyboard }
            , Cmd.none
            )

        Tick time ->
            let
                nmodel =
                    { model | player = Player.update time model }
            in
                ( Playing nmodel, Cmd.none )

        _ ->
            ( Playing model, Cmd.none )


processTexture : TextureEncoding -> BaseModel a -> BaseModel a
processTexture ( texture, name ) model =
    let
        tstore =
            if Dict.member name model.textureStore then
                model.textureStore
            else
                Dict.insert name texture model.textureStore
    in
        { model | textureStore = tstore }
