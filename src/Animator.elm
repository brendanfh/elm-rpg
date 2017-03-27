module Animator exposing (..)

import Time exposing (Time)
import Tuple exposing (first, second)


type alias Animator =
    { fullWidth : Int
    , fullHeight : Int
    , frames : Int
    , startLoc : ( Int, Int )
    , frame : Int
    , frameWidth : Int
    , frameHeight : Int
    , currentLoc : ( Int, Int )
    , stepDirection : ( Int, Int )
    , frameDelay : Time
    , currentDelay : Time
    }


defaultAnimator : Animator
defaultAnimator =
    { fullWidth = 0
    , fullHeight = 0
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



--TODO: write the function that will be used to make the animator give the view the coordinates to draw
