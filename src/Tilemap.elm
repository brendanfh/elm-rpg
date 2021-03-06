module Tilemap exposing (..)

import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Matrix exposing (Matrix)
import ViewUtil exposing (Renderer)


type alias Tilemap =
    Matrix {}


render : Renderer a
render =
    (List.range 0 16)
        |> List.concatMap
            (\y ->
                (List.range 0 20
                    |> List.concatMap
                        (\x ->
                            [ ( x, y ) ]
                        )
                )
            )
        |> List.map
            (\( x, y ) ->
                ViewUtil.quad
                    (vec3 0 1 0)
                    (Mat4.identity
                        |> Mat4.translate3 ((toFloat x) * 17.0) ((toFloat y) * 17.0) 0.0
                        |> Mat4.scale3 16 16 1
                    )
            )
        |> ViewUtil.group
