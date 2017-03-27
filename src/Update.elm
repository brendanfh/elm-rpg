module Update exposing (update)

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

        NoOp ->
            ( Playing model, Cmd.none )


processTexture :
    TextureEncoding
    -> { a | textureStore : TextureStore }
    -> { a | textureStore : TextureStore }
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
