module Util.AbstractPhysicsObj exposing (..)

import Time exposing (Time)


type alias PhysicsObj a =
    { a
        | x : Float
        , y : Float
        , vx : Float
        , vy : Float
        , ax : Float
        , ay : Float
    }


step : Time -> PhysicsObj a -> PhysicsObj a
step time obj =
    let
        t =
            time / 1000

        vx1 =
            obj.vx + obj.ax * t

        vy1 =
            obj.vy + obj.ay * t

        x1 =
            obj.x + vx1 * t

        y1 =
            obj.y + vy1 * t
    in
        { obj
            | x = x1
            , y = y1
            , vx = vx1
            , vy = vy1
        }


applyForce : { b | x : Float, y : Float } -> PhysicsObj a -> PhysicsObj a
applyForce { x, y } obj =
    { obj | ax = obj.ax + x, ay = obj.ay + y }
