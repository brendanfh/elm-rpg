module Main exposing (..)

import Html exposing (Html)


type alias Model =
    ()


init : {} -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.text "Hello World!"


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
