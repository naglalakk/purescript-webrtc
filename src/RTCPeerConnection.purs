module WebRTC.RTCPeerConnection where

import Prelude
import Control.Monad.Except             (runExcept)
import Control.Promise                  as P
import Data.Either                      (Either(..))
import Data.Maybe                       (Maybe(..))
import Data.Newtype                     (class Newtype, unwrap)
import Data.Options                     (Options, options)
import Effect                           (Effect)
import Effect.Aff                       (Aff)
import Effect.Aff.Class                 (class MonadAff)
import Effect.Class                     (class MonadEffect, liftEffect)
import Foreign                          (Foreign, MultipleErrors, unsafeToForeign)
import Unsafe.Coerce                    (unsafeCoerce)
import Web.Event.Event                  as E
import Web.Event.Internal.Types         (EventTarget)

import WebRTC.MediaStream               (MediaStream)
import WebRTC.MediaStreamTrack          (MediaStreamTrack)
import WebRTC.RTCConfiguration          (RTCConfiguration)
import WebRTC.RTCCertificate            (RTCCertificate, RTCCertificateConfig)
import WebRTC.RTCIceCandidate           (RTCIceCandidate)
import WebRTC.RTCRtpSender              (RTCRtpSender)
import WebRTC.RTCSessionDescription     (RTCSessionDescription(..), readRTCSessionDescription)

foreign import data RTCPeerConnection :: Type

newtype RTCOfferOptions = RTCOfferOptions
  { iceRestart :: Boolean
  , offerToReceiveAudio :: Boolean
  , offerToReceiveVideo :: Boolean
  , voiceActivityDetection :: Boolean
  }

derive instance newtypeRTCOfferOptions :: Newtype RTCOfferOptions _

foreign import _addTrack :: RTCPeerConnection -> MediaStreamTrack -> MediaStream -> Effect RTCRtpSender

addTrack :: forall m
          . MonadEffect m
         => RTCPeerConnection
         -> MediaStreamTrack 
         -> MediaStream
         -> m RTCRtpSender 
addTrack conn track stream = liftEffect $ _addTrack conn track stream

foreign import _createAnswer :: RTCPeerConnection -> Effect (P.Promise Foreign)

createAnswer :: RTCPeerConnection
             -> Aff (Either MultipleErrors RTCSessionDescription)
createAnswer conn = do
  resolv <- P.toAffE $ _createAnswer conn
  pure $ runExcept $ readRTCSessionDescription resolv

foreign import _createOffer :: RTCPeerConnection -> Foreign -> Effect (P.Promise Foreign)

createOffer :: RTCPeerConnection
            -> RTCOfferOptions
            -> Aff (Either MultipleErrors RTCSessionDescription)
createOffer conn opts = do
  resolv <- P.toAffE $ _createOffer conn fOpts
  pure $ runExcept $ readRTCSessionDescription resolv
  where
    fOpts = unsafeToForeign (unwrap opts)

foreign import _generateCertificate :: RTCCertificateConfig -> Effect RTCCertificate

generateCertificate :: forall m 
                     . MonadEffect m
                    => RTCCertificateConfig 
                    -> m RTCCertificate
generateCertificate config = liftEffect $ _generateCertificate config

foreign import _newRTCPeerConnection :: Foreign -> Effect RTCPeerConnection

newRTCPeerConnection :: forall m
                      . MonadEffect m 
                     =>  Options RTCConfiguration 
                     -> m RTCPeerConnection
newRTCPeerConnection config = liftEffect $ _newRTCPeerConnection (options config)

foreign import _setLocalDescription :: RTCPeerConnection -> Foreign -> Effect (P.Promise Unit)

setLocalDescription :: RTCPeerConnection
                    -> RTCSessionDescription
                    -> Aff Unit
setLocalDescription conn (RTCSessionDescription desc) = P.toAffE $ _setLocalDescription conn descForeign
  where
    descForeign = unsafeToForeign $
      { "type": (show desc.type)
      , "sdp": desc.sdp
      }

foreign import _setRemoteDescription :: RTCPeerConnection -> Foreign -> Effect (P.Promise Unit)

setRemoteDescription :: RTCPeerConnection
                    -> RTCSessionDescription
                    -> Aff Unit
setRemoteDescription conn (RTCSessionDescription desc) = P.toAffE $ _setRemoteDescription conn descForeign
  where
    descForeign = unsafeToForeign $
      { "type": (show desc.type)
      , "sdp": desc.sdp
      }

foreign import _addIceCandidate :: RTCPeerConnection -> RTCIceCandidate -> Effect (P.Promise Unit)

addIceCandidate :: RTCPeerConnection -> RTCIceCandidate -> Aff Unit
addIceCandidate conn candidate = P.toAffE $ _addIceCandidate conn candidate

foreign import _candidateFromString :: String -> RTCIceCandidate

-- Events
ontrack :: E.EventType
ontrack = E.EventType "ontrack"

icecandidate :: E.EventType
icecandidate = E.EventType "icecandidate"

iceconnectionstatechange :: E.EventType
iceconnectionstatechange = E.EventType "iceconnectionstatechange"

rtcPeerConnectionTarget :: RTCPeerConnection -> EventTarget
rtcPeerConnectionTarget = unsafeCoerce
