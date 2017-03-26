module Types exposing (..)

import WebGL exposing (Texture)
import WebGL.Texture


{-
   Its easier to put both the model and the msg type in one file rather than have them be separate
-}


type alias TextureStore =
    { playerTexture : Maybe Texture
    }


blankTextureStore : TextureStore
blankTextureStore =
    { playerTexture = Nothing
    }


type alias Model =
    { textureStore : TextureStore
    }


type TextureEncoding
    = PlayerTexture Texture
    | TileMapTexture Texture


type Msg
    = NoOp
    | TextureLoadingError WebGL.Texture.Error
    | TextureLoadedSuccessful TextureEncoding
