module Animator exposing (..)

import Time exposing (Time)
import Tuple exposing (first, second)


type alias Animator =
    { maxWidth : Int
    , maxHeight : Int
    , frames : Int
    , startLoc : ( Int, Int )
    , frameWidth : Int
    , frameHeight : Int
    , frameDelay : Time
    , stepDirection : ( Int, Int )
    , frame : Int
    , currentLoc : ( Int, Int )
    , currentDelay : Time
    }


defaultAnimator : Animator
defaultAnimator =
    { maxWidth = 0
    , maxHeight = 0
    , frames = 0
    , startLoc = ( 0, 0 )
    , frame = 0
    , frameWidth = 0
    , frameHeight = 0
    , currentLoc = ( 0, 0 )
    , stepDirection = ( 1, 0 )
    , frameDelay = 0
    , currentDelay = 0
    }


update : Time -> Animator -> Animator
update time animator =
    let
        currentDelay1 =
            animator.currentDelay - time

        ( nextFrame, currentDelay2 ) =
            if currentDelay1 <= 0 then
                ( (animator.frame + 1) % animator.frames
                , animator.frameDelay + currentDelay1
                )
            else
                ( animator.frame, currentDelay1 )

        newLoc =
            ( nextFrame
                * (first animator.stepDirection)
                + (first animator.startLoc)
            , nextFrame
                * (second animator.stepDirection)
                + (second animator.startLoc)
            )
    in
        { animator
            | currentDelay = currentDelay2
            , frame = nextFrame
            , currentLoc = newLoc
        }


jumpToLoc : ( Int, Int ) -> Animator -> Animator
jumpToLoc loc animator =
    { animator
        | startLoc = loc
        , currentLoc = loc
        , frame = 0
        , currentDelay = animator.frameDelay
    }


toRectangle :
    Animator
    -> { x : Int
       , y : Int
       , width : Int
       , height : Int
       , maxWidth : Int
       , maxHeight : Int
       }
toRectangle animator =
    { x = (first animator.currentLoc) * animator.frameWidth
    , y = (second animator.currentLoc) * animator.frameHeight
    , width = animator.frameWidth
    , height = animator.frameHeight
    , maxWidth = animator.maxWidth
    , maxHeight = animator.maxHeight
    }
