module Types exposing (..)

import Animator exposing (Animator)
import Keyboard.Extra as KE
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


type alias BaseModel a =
    { a
        | textureStore : TextureStore
        , keyboard : KE.State
    }


type alias PlayingModel =
    BaseModel
        { animation : Animator
        }


type alias MainMenuModel =
    BaseModel {}


type alias OptionsModel =
    BaseModel {}


type Msg
    = NoOp
    | KeyboardMsg KE.Msg
    | TextureLoadingError WebGL.Texture.Error
    | TextureLoadedSuccessful (TextureEncoding Texture)
    | Tick Time


type TextureEncoding a
    = PlayerTexture a
    | TileMapTexture a


type alias TextureStore =
    { playerTexture : Maybe Texture
    }


blankTextureStore : TextureStore
blankTextureStore =
    { playerTexture = Nothing
    }
