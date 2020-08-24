module WebRTC.MediaStream where

import Prelude
import Control.Promise              as P
import Effect                       (Effect)
import Effect.Aff                   (Aff())
import Effect.Class                 (class MonadEffect, liftEffect)
import Unsafe.Coerce                (unsafeCoerce)
import Web.File.Blob                (Blob)

import WebRTC.MediaStreamTrack      (MediaStreamTrack)

foreign import data MediaStream :: Type

newtype MediaStreamConstraints 
  = MediaStreamConstraints
    { audio :: Boolean
    , video :: Boolean
    }

foreign import _getTracks :: MediaStream -> Effect (Array MediaStreamTrack)

getTracks :: forall m
           . MonadEffect m
          => MediaStream
          -> m (Array MediaStreamTrack)
getTracks ms = liftEffect $ _getTracks ms

foreign import _getUserMedia :: MediaStreamConstraints -> Effect (P.Promise MediaStream)

getUserMedia :: MediaStreamConstraints -> Aff MediaStream
getUserMedia = _getUserMedia >>> P.toAffE

mediaStreamToBlob :: MediaStream -> Blob
mediaStreamToBlob = unsafeCoerce
