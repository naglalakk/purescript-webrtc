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
import Web.Socket.Event.EventTypes  as WEventTypes
import Web.Socket.WebSocket         as WS
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

type Message =
  { data :: String
  }

type Response =
  { "type" :: String
  , "sdp"  :: String
  }

strToResponse :: String -> Response
strToResponse = unsafeCoerce

eventToStr :: Event -> Message
eventToStr = unsafeCoerce

newtype MessageData = MessageData
  { from    :: String
  , to      :: String
  , "type"  :: String
  , "data"  :: String
  }

derive instance genericMessageData :: Generic MessageData _

instance showMessageData :: Show MessageData where
  show (MessageData message) = show message

readMessageData :: Foreign -> F MessageData
readMessageData value = do
  from <- value ! "from" >>= readString
  to   <- value ! "to"   >>= readString
  type_ <- value ! "type" >>= readString
  data_ <- value ! "data" >>= readString
  pure $ MessageData { from: from, to: to, "type":type_, "data": data_}

onMessage :: Event -> Effect Unit
onMessage e = do
  let 
    msg = eventToStr e
    de = decodeJSONWith readMessageData msg.data
    resp = runExcept de
  case resp of
    Right (MessageData msg) -> do
      logShow $ MessageData msg
      case msg.type of
        "offer" ->  pure unit
        "answer" -> pure unit
        _ -> pure unit
    Left err -> do
      logShow err
      pure unit

openCallback :: Event -> Effect Unit
openCallback e = do
  logShow "On open"

onRecorderData :: Event -> Effect Unit
onRecorderData event = do
  logShow "record data"

main :: Effect Unit
main = launchAff_ do
  ws <- liftEffect $ WS.create "ws://localhost:1234" []
  let 
    wsTarget = WS.toEventTarget ws
  el <- liftEffect $ ET.eventListener openCallback
  msg <- liftEffect $ ET.eventListener onMessage
  _ <- liftEffect $ ET.addEventListener WEventTypes.onMessage msg true wsTarget
  _ <- liftEffect $ ET.addEventListener WEventTypes.onOpen el true wsTarget
  let 
    offerOptions = RTCOfferOptions
      { iceRestart: false
      , offerToReceiveAudio: true
      , offerToReceiveVideo: true
      , voiceActivityDetection: false
      }

  logShow "Getting stream"
  stream <- getUserMedia $ MediaStreamConstraints
    { audio: true
    , video: true 
    }
  -- Pass stream to recorder
  recorder <- newMediaRecorder stream
  onRecorderDataListener <- liftEffect $ ET.eventListener onRecorderData
  _ <- liftEffect $ ET.addEventListener dataavailable onRecorderDataListener true (mediaRecorderEventTarget recorder)
  logShow "Done"
