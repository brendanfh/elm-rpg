module Types exposing (..)

import Animator exposing (Animator)
import Time exposing (Time)
import WebGL exposing (Texture)
import WebGL.Texture


{-
   Its easier to put both the model and the msg type in one file rather than have them be separate
-}


type State
    = Playing PlayingModel
    | MainMenu MainMenuModel
    | OptionsMenu OptionsModel


type alias PlayingModel =
    { textureStore : TextureStore
    , animation : Animator
    }


type alias MainMenuModel =
    {}


type alias OptionsModel =
    {}


type Msg
    = NoOp
    | TextureLoadingError WebGL.Texture.Error
    | TextureLoadedSuccessful TextureEncoding
    | Tick Time


type TextureEncoding
    = PlayerTexture Texture
    | TileMapTexture Texture


type alias TextureStore =
    { playerTexture : Maybe Texture
    }


blankTextureStore : TextureStore
blankTextureStore =
    { playerTexture = Nothing
    }
