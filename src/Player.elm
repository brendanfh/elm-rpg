module Player exposing (..)

import Animator exposing (Animator, defaultAnimator)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
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


update : Time -> BaseModel { a | player : Player } -> Player
update time { player } =
    { player | animator = Animator.update time player.animator }


view : Player -> Renderer a
view player =
    ViewUtil.group
        [ ViewUtil.whiteTexturedQuad
            "player"
            (Animator.toRectangle player.animator)
            (ViewUtil.rectToMatrix player)
        , ViewUtil.group
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
        ]
