module Update exposing (update)

import Animator
import Keyboard.Extra as KE
import Types exposing (..)
import WebGL


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
                    { model | animation = Animator.update time model.animation }
            in
                ( Playing nmodel, Cmd.none )

        _ ->
            ( Playing model, Cmd.none )


processTexture : TextureEncoding WebGL.Texture -> BaseModel a -> BaseModel a
processTexture encoding model =
    let
        tstore =
            model.textureStore

        tstore_ =
            case encoding of
                PlayerTexture texture ->
                    { tstore | playerTexture = Just texture }

                _ ->
                    tstore
    in
        { model | textureStore = tstore_ }
