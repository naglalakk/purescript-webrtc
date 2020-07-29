module WebRTC.RTCSessionDescription where

import Prelude
import Data.String.Common   (toLower)
import Foreign              (F, Foreign, readString)
import Foreign.Index        ((!))

data RTCSdpType
  = Answer
  | Offer
  | Pranswer
  | Rollback

instance showRTCSdpType :: Show RTCSdpType where
  show Answer = "answer"
  show Offer  = "offer"
  show Pranswer = "pranswer"
  show Rollback = "rollback"

newtype RTCSessionDescription = RTCSessionDescription
  { "type" :: RTCSdpType
  , sdp   :: String
  }

instance showRTCSessionDescription :: Show RTCSessionDescription where
  show (RTCSessionDescription desc) = "{ type: " <> (show desc.type) <> ", sdp: " <> desc.sdp <> " }"

strToRTCSdpType :: String -> RTCSdpType
strToRTCSdpType str
  | str == "offer" = Offer
  | str == "answer" = Answer
  | str == "pranswer" = Pranswer
  | str == "rollback" = Rollback
  | otherwise = Offer

readRTCSessionDescription :: Foreign -> F RTCSessionDescription
readRTCSessionDescription value = do
  type_ <- value ! "type" >>= readString
  sdp   <- value ! "sdp"  >>= readString
  pure $ RTCSessionDescription 
    { "type": strToRTCSdpType type_
    , sdp: sdp
    }

