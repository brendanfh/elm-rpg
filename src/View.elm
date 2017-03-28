module View exposing (..)

import Animator
import Html exposing (Html)
import Html.Attributes as HA
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Math.Vector2 as Vec2 exposing (vec2, Vec2)
import Types exposing (..)
import WebGL exposing (Shader, Mesh, Entity, Texture)


view : State -> Html Msg
view state =
    case state of
        Playing model ->
            Html.div [] [ viewGL model ]

        _ ->
            Html.div [] []


viewGL : PlayingModel -> Html Msg
viewGL model =
    (case model.textureStore.playerTexture of
        Nothing ->
            []

        Just texture ->
            [ renderTexturedQuad
                texture
                (toTextureMatrix (Animator.toRectangle model.animation))
                (vec3 1 1 1)
                (Mat4.identity
                    |> Mat4.translate3 100 100 0
                    |> Mat4.scale3 64 64 1
                )
            ]
    )
        |> WebGL.toHtmlWith
            [ WebGL.clearColor 0 0 0 1
            ]
            [ HA.width 800
            , HA.height 600
            ]


renderQuad : Vec3 -> Mat4 -> Entity
renderQuad color objMat =
    WebGL.entity
        vertexShader
        fragmentShader
        quadMesh
        { perspective = perspective
        , object = objMat
        , color = color
        }


renderTexturedQuad : Texture -> Mat4 -> Vec3 -> Mat4 -> Entity
renderTexturedQuad texture textureMat color objMat =
    WebGL.entity
        textureVertexShader
        textureFragmentShader
        quadMesh
        { perspective = perspective
        , object = objMat
        , color = color
        , texture = texture
        , textureMat = textureMat
        }


toTextureMatrix :
    { a
        | x : Int
        , y : Int
        , width : Int
        , height : Int
        , maxWidth : Int
        , maxHeight : Int
    }
    -> Mat4
toTextureMatrix rect =
    Mat4.identity
        |> Mat4.scale3
            --Scale down
            (1.0 / (toFloat rect.maxWidth))
            (1.0 / (toFloat rect.maxHeight))
            1
        |> Mat4.translate3
            --Translate
            (toFloat rect.x)
            (toFloat rect.y)
            0
        |> Mat4.scale3
            --Scale up to width and height
            (toFloat rect.width)
            (toFloat rect.height)
            1


perspective : Mat4
perspective =
    Mat4.makeOrtho -1 800 600 0 -1 1


type alias Vertex =
    { position : Vec3
    }


quadMesh : Mesh Vertex
quadMesh =
    WebGL.triangles
        [ ( Vertex (vec3 0 0 0)
          , Vertex (vec3 1 0 0)
          , Vertex (vec3 1 1 0)
          )
        , ( Vertex (vec3 0 0 0)
          , Vertex (vec3 1 1 0)
          , Vertex (vec3 0 1 0)
          )
        ]


type alias Uniforms a =
    { a
        | perspective : Mat4
        , object : Mat4
        , color : Vec3
    }


type alias TexturedUniforms =
    Uniforms { texture : Texture, textureMat : Mat4 }


vertexShader : Shader Vertex (Uniforms {}) {}
vertexShader =
    [glsl|
        precision mediump float;

        attribute vec3 position;

        uniform mat4 perspective;
        uniform mat4 object;

        void main() {
            gl_Position = perspective * object * vec4(position, 1.0);
        }
    |]


fragmentShader : Shader {} (Uniforms {}) {}
fragmentShader =
    [glsl|
        precision mediump float;

        uniform vec3 color;

        void main() {
            gl_FragColor = vec4(color, 1.0);
        }
    |]


textureVertexShader : Shader Vertex TexturedUniforms { vcoord : Vec2 }
textureVertexShader =
    [glsl|
        precision mediump float;

        attribute vec3 position;

        uniform mat4 perspective;
        uniform mat4 object;

        varying vec2 vcoord;

        void main() {
            gl_Position = perspective * object * vec4(position, 1.0);
            vcoord = position.xy * vec2(1, -1);
        }
    |]


textureFragmentShader : Shader {} TexturedUniforms { vcoord : Vec2 }
textureFragmentShader =
    [glsl|
        precision mediump float;

        uniform vec3 color;
        uniform sampler2D texture;
        uniform mat4 textureMat;

        varying vec2 vcoord;

        void main() {
            vec2 coord = (textureMat * vec4(vcoord, 0.0, 1.0)).xy;
            gl_FragColor = texture2D(texture, coord) * vec4(color, 1.0);
        }
    |]
