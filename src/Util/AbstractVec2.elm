module Util.AbstractVec2 exposing (..)


type alias Vec2 a =
    { a | x : Float, y : Float }


add : Vec2 a -> Vec2 b -> Vec2 a
add v1 v2 =
    { v1 | x = v1.x + v2.x, y = v1.y + v2.y }


sub : Vec2 a -> Vec2 b -> Vec2 a
sub v1 v2 =
    { v1 | x = v1.x - v2.x, y = v1.y - v2.y }


scale : Vec2 a -> Float -> Vec2 a
scale v s =
    { v | x = v.x * s, y = v.y * s }


dot : Vec2 a -> Vec2 b -> Float
dot v1 v2 =
    v1.x * v2.x + v1.y * v2.y


length : Vec2 a -> Float
length v =
    sqrt <| dot v v
