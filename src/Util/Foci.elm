module Util.Foci exposing (..)

import Util.Focus exposing (..)


x : Focus { r | x : a } a
x =
    create .x (\f r -> { r | x = f r.x })


y : Focus { r | y : a } a
y =
    create .y (\f r -> { r | y = f r.y })


vx : Focus { r | vx : a } a
vx =
    create .vx (\f r -> { r | vx = f r.vx })


vy : Focus { r | vy : a } a
vy =
    create .vy (\f r -> { r | vy = f r.vy })
