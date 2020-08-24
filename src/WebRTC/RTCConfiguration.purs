module WebRTC.RTCConfiguration where

import Prelude
import Data.Maybe               (Maybe(..), fromMaybe)
import Data.Options             (Options(..)
                                ,Option
                                ,options, opt)
import Data.Op                  (Op(Op))
import Data.Tuple               (Tuple(Tuple), fst)
import Foreign                  (unsafeToForeign)
import Foreign.Object           as Object

import WebRTC.RTCCertificate    (RTCCertificate)
import WebRTC.RTCIceServer      (RTCIceServerConfig(..), RTCIceCredentialType(..))
import WebRTC.Utils             (optWith)

data RTCConfiguration

data RTCBundlePolicy
  = Balanced
  | MaxCompat
  | MaxBundle

instance showRTCBundlePolicy :: Show RTCBundlePolicy where
  show Balanced = "balanced"
  show MaxCompat = "max-compat"
  show MaxBundle = "max-bundle"

data RTCIceTransportPolicy
  = All
  | Public
  | Relay

instance showRTCIceTransportPolicy :: Show RTCIceTransportPolicy where
  show All = "all"
  show Public = "public"
  show Relay = "relay"

data RTCRtcpMuxPolicy
  = Negotiate
  | Require

instance showRTCRtcpMuxPolicy :: Show RTCRtcpMuxPolicy where
  show Negotiate = "negotiate"
  show Require = "require"

bundlePolicy :: Option RTCConfiguration RTCBundlePolicy
bundlePolicy = optWith show "bundlePolicy"

certificates :: Option RTCConfiguration (Array RTCCertificate)
certificates = opt "certificates"

iceCandidatePoolSize :: Option RTCConfiguration Int
iceCandidatePoolSize = opt "iceCandidatePoolSize"

-- TODO: Make more generic optWith thing
iceServers :: Option RTCConfiguration (Array RTCIceServerConfig)
iceServers = optWith iceFormat "iceServers"
  where
    iceFormat = map (\(RTCIceServerConfig config) -> {credential: (fromMaybe "" config.credential)
      , credentialType: (show $ fromMaybe Password config.credentialType)
      , username: (fromMaybe "" config.username)
      , urls: config.urls })

iceTransportPolicy :: Option RTCConfiguration RTCIceTransportPolicy 
iceTransportPolicy = optWith show "iceTransportPolicy"

peerIdentity :: Option RTCConfiguration String
peerIdentity = opt "peerIdentity"

rtcpMuxPolicy :: Option RTCConfiguration RTCRtcpMuxPolicy 
rtcpMuxPolicy = optWith show "rtcpMuxPolicy"
