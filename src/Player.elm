module Player exposing (..)

import Animator exposing (Animator, defaultAnimator)
import Time exposing (Time)
import Types exposing (..)
import ViewUtil exposing (Renderer)


defaultPlayer : Int -> Int -> Player
defaultPlayer x y =
    { x = x
    , y = y
    , width = 64
    , height = 96
    , animator =
        { defaultAnimator
            | frames = 3
            , frameWidth = 8
            , frameHeight = 24
            , startLoc = ( 0, 0 )
            , frameDelay = 1000
            , maxWidth = 24
            , maxHeight = 24
        }
    }


update : Time -> Player -> Player
update time player =
    { player | animator = Animator.update time player.animator }


view : Player -> Renderer a
view player =
    ViewUtil.whiteTexturedQuad
        PlayerTexture
        (Animator.toRectangle player.animator)
        (ViewUtil.rectToMatrix player)
