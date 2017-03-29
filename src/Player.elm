module Player exposing (..)

import Time exposing (Time)
import Types exposing (..)
import View exposing (Renderer)


type alias Player =
    { x : Int
    , y : Int
    , size : Int
    }


update : Time -> Player -> Player
update time player =
    player


view : Player -> Renderer a
view player =
    View.whiteTexturedQuad
        PlayerTexture
        { x = 0, y = 0, width = 16, height = 16, maxWidth = 16, maxHeight = 16 }
        (View.rectToMatrix
            { x = player.x
            , y = player.y
            , width = player.size
            , height = player.size
            }
        )
