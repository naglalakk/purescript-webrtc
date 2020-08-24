module WebRTC.RTCCertificate where

import Prelude

foreign import data RTCCertificate :: Type

newtype RTCCertificateConfig = RTCCertificateConfig 
  { name :: String
  , hash :: String
  , modulusLength :: Int
  , publicExponent :: Array Int
  }

