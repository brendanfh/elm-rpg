module Types exposing (..)

import Animator exposing (Animator)
import Dict exposing (Dict)
import Keyboard.Extra as KE
import Time exposing (Time)
import WebGL exposing (Texture)
import WebGL.Texture


{-
   Its easier to put both the model and the msg type in one file rather than have them be separate
   Because of recursive dependencies, almost all models have to be stored in this file
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
        { player : Player
        }


type alias MainMenuModel =
    BaseModel {}


type alias OptionsModel =
    BaseModel {}


type Msg
    = NoOp
    | KeyboardMsg KE.Msg
    | TextureLoadingError WebGL.Texture.Error
    | TextureLoadedSuccessful TextureEncoding
    | Tick Time


type alias TextureEncoding =
    ( Texture, String )


type alias TextureStore =
    Dict String Texture


blankTextureStore : TextureStore
blankTextureStore =
    Dict.empty



{- PLAYING MODELS -}


type alias Player =
    { x : Int
    , y : Int
    , width : Int
    , height : Int
    , animator : Animator
    }
