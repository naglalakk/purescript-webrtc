module Example.Main where

import Prelude
import Control.Monad.Except         (runExcept)
import Data.Either                  (Either(..))
import Data.Foldable                (for_, fold)
import Data.Traversable             (traverse)
import Data.Options                 (Options, (:=))
import Data.Maybe                   (Maybe(..))
import Data.Generic.Rep             (class Generic)
import Data.Generic.Rep.Show        (genericShow)
import Effect                       (Effect)
import Effect.Aff                   (launchAff_)
import Effect.Class                 (liftEffect)
import Effect.Class.Console         (logShow)
import Effect.Ref                   as Ref
import Foreign                      (F, Foreign, readString)
import Foreign.Index                ((!))
import Foreign.JSON                 (decodeJSONWith)
import Unsafe.Coerce                (unsafeCoerce)
import Web.Event.EventTarget        as ET
import Web.Event.Internal.Types     (Event)

import WebRTC.MediaStream
import WebRTC.RTCPeerConnection
import WebRTC.RTCConfiguration
import WebRTC.RTCIceServer
import WebRTC.RTCSessionDescription (readRTCSessionDescription)

rtcConfig :: Options RTCConfiguration
rtcConfig = fold
  [ iceServers := [
      RTCIceServerConfig
        { credential: Nothing
        , credentialType: Nothing
        , urls: ["stun:stun.l.google.com:19302"]
        , username: Nothing
        }
    ]
  ]

main :: Effect Unit
main = launchAff_ do
  -- Create connection for pc1, pc2
  pc1 <- newRTCPeerConnection rtcConfig
  pc2 <- newRTCPeerConnection rtcConfig
  let 
    offerOptions = RTCOfferOptions
      { iceRestart: false
      , offerToReceiveAudio: true
      , offerToReceiveVideo: true
      , voiceActivityDetection: false
      }

  -- Get stream from user
  stream <- getUserMedia $ MediaStreamConstraints
    { audio: true
    , video: true 
    }

  -- Get tracks of stream
  tracks <- getTracks stream

  -- Add local stream to pc1
  for_ tracks \t ->
    addTrack pc1 t stream

  -- Create offer with pc1
  offer <- createOffer pc1 offerOptions
  case offer of
    Right desc -> do
      -- Set localDescription of pc1
      setLocalDescription pc1 desc

      -- Set remoteDescription of pc2
      setRemoteDescription pc2 desc

      -- Create an answer with pc2
      answer <- createAnswer pc2
      
      case answer of
        Right aDesc -> do
          -- Set localDescription of pc2
          setLocalDescription pc2 aDesc

          -- Set remoteDescription of pc1
          setRemoteDescription pc1 aDesc
        Left err -> logShow err
    Left err -> logShow err
