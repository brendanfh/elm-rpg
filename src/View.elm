module View exposing (view)

import Html exposing (Html)
import Html.Attributes as HA
import Types exposing (..)
import WebGL exposing (Entity)
import Player
import ViewUtil exposing (Renderer)


{-| The main view function
-}
view : State -> Html Msg
view state =
    (case state of
        Playing model ->
            [ viewGL model (viewPlaying model) ]

        _ ->
            []
    )
        |> Html.div []


viewPlaying : PlayingModel -> List (Renderer a)
viewPlaying model =
    [ Player.view model.player ]


{-| Renders everything having to do with the game
-}
viewGL : BaseModel a -> List (Renderer a) -> Html Msg
viewGL model renderers =
    let
        func : Maybe Entity -> List Entity
        func mEntity =
            case mEntity of
                Just e ->
                    [ e ]

                Nothing ->
                    []

        entities =
            renderers
                |> List.map (render model)
                |> List.concatMap func
    in
        WebGL.toHtmlWith
            [ WebGL.clearColor 0 0 0 1
            ]
            [ HA.width 800
            , HA.height 600
            ]
            entities


{-| A function used to run an encapsulated rendering action
-}
render : BaseModel a -> Renderer a -> Maybe Entity
render model renderer =
    renderer model
