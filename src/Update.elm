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

        Paused model ->
            case msg of
                KeyboardMsg keyMsg ->
                    let
                        ( keyState, keyChange ) =
                            KE.updateWithKeyChange keyMsg model.keyboard

                        state =
                            if keyChange == Just (KE.KeyDown KE.CharP) then
                                Playing
                            else
                                Paused
                    in
                        ( state <| { model | keyboard = keyState }
                        , Cmd.none
                        )

                _ ->
                    ( Paused model, Cmd.none )

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
            let
                ( keyState, keyChange ) =
                    KE.updateWithKeyChange keyMsg model.keyboard

                state =
                    if keyChange == Just (KE.KeyDown KE.CharP) then
                        Paused
                    else
                        Playing
            in
                ( state <| { model | keyboard = keyState }
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
