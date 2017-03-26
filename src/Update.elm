module Update exposing (update)

import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextureLoadingError _ ->
            ( model, Cmd.none )

        TextureLoadedSuccessful encoding ->
            ( processTexture encoding model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


processTexture : TextureEncoding -> Model -> Model
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
