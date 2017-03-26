module Types exposing (..)

import WebGL exposing (Texture)


{-
   Its easier to put both the model and the msg type in one file rather than have them be separate
-}


type alias TextureStore =
    { blankTexture : Maybe Texture }


type alias Model =
    { textureStore : TextureStore
    }


type Msg
    = NoOp
