module Player exposing (..)

import Animator exposing (Animator, defaultAnimator)
import Keyboard.Extra as KE
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Time exposing (Time)
import Types exposing (..)
import Util.AbstractPhysicsObj as APO
import ViewUtil exposing (Renderer)


defaultPlayer : Float -> Float -> Player
defaultPlayer x y =
    { x = x
    , y = y
    , vx = 0
    , vy = 0
    , ax = 0
    , ay = 0
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


applyArrows : { a | x : Int, y : Int } -> Player -> Player
applyArrows arrows player =
    { player
        | vx = (toFloat arrows.x) * 100.0
        , vy = (toFloat arrows.y) * -100.0
    }


update : Time -> BaseModel { a | player : Player } -> Player
update time { player, keyboard } =
    let
        arrows =
            KE.arrows keyboard

        player0 =
            player
                |> applyArrows arrows
                |> APO.step time
    in
        { player0 | animator = Animator.update time player0.animator }


view : Player -> Renderer a
view player =
    ViewUtil.group
        [ ViewUtil.whiteTexturedQuad
            "player"
            (Animator.toRectangle player.animator)
            (ViewUtil.rectToMatrix player)
          {- , ViewUtil.group
             [ ViewUtil.quad
                 (vec3 0 0 1)
                 (Mat4.identity
                     |> Mat4.translate3 125 100 0
                     |> Mat4.scale3 50 50 1
                 )
             , ViewUtil.quad
                 (vec3 1 0 0)
                 (Mat4.identity
                     |> Mat4.translate3 100 100 0
                     |> Mat4.scale3 50 50 1
                 )
             ]
          -}
        ]
