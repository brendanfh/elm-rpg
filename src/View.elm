module View exposing (..)

import Html exposing (Html)
import Html.Attributes as HA
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)


-- import Math.Vector2 as Vec2 exposing (vec2, Vec2)

import Types exposing (..)
import WebGL exposing (Shader, Mesh, Entity, Texture)


view : Model -> Html Msg
view model =
    Html.div [] [ viewGL model ]


viewGL : Model -> Html Msg
viewGL model =
    WebGL.toHtmlWith
        [ WebGL.clearColor 0 0 0 1
        ]
        [ HA.width 800
        , HA.height 600
        ]
        [ renderQuad (vec3 1 1 1)
            (Mat4.identity
                |> Mat4.translate3 100 100 0
                |> Mat4.scale3 50 50 1
            )
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


renderTexturedQuad : Texture -> Vec3 -> Mat4 -> Entity
renderTexturedQuad texture color objMat =
    WebGL.entity
        textureVertexShader
        textureFragmentShader
        quadMesh
        { perspective = perspective
        , object = objMat
        , color = color
        , texture = texture
        }


perspective : Mat4
perspective =
    Mat4.makeOrtho 0 800 600 0 -1 1


type alias Vertex =
    { position : Vec3
    }


quadMesh : Mesh Vertex
quadMesh =
    WebGL.triangles
        [ ( Vertex (vec3 -0.5 -0.5 0)
          , Vertex (vec3 0.5 -0.5 0)
          , Vertex (vec3 0.5 0.5 0)
          )
        , ( Vertex (vec3 -0.5 -0.5 0)
          , Vertex (vec3 0.5 0.5 0)
          , Vertex (vec3 -0.5 0.5 0)
          )
        ]


type alias Uniforms a =
    { a
        | perspective : Mat4
        , object : Mat4
        , color : Vec3
    }


type alias TexturedUniforms =
    Uniforms { texture : Texture }


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


textureVertexShader : Shader Vertex TexturedUniforms {}
textureVertexShader =
    [glsl|
        precision mediump float;

        attribute vec3 position;

        uniform mat4 perspective;
        uniform mat4 object;

        void main() {
            gl_Position = perspective * object * vec4(position, 1.0);
        }
    |]


textureFragmentShader : Shader {} TexturedUniforms {}
textureFragmentShader =
    [glsl|
        precision mediump float;

        uniform vec3 color;
        uniform sampler2d texture;

        void main() {
            //use the texture
            gl_FragColor = vec4(color, 1.0);
        }
    |]
