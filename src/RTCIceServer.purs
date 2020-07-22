module WebRTC.RTCIceServer where

import Prelude
import Data.Maybe           (Maybe(..), fromMaybe)
import Data.Symbol          (SProxy(..))
import Data.String.Common   (toLower)
import Record               as Record

data RTCIceCredentialType 
  = OAuth
  | Password

instance showRTCIceCredentialType :: Show RTCIceCredentialType where
  show OAuth = "oauth"
  show Password = "password"

newtype RTCIceServerConfig = RTCIceServerConfig
  { credential :: Maybe String
  , credentialType :: Maybe RTCIceCredentialType
  , urls :: Array String
  , username :: Maybe String
  }
