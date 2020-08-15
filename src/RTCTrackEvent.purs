module WebRTC.RTCTrackEvent where

import Prelude
import Effect                   (Effect)
import Effect.Class             (class MonadEffect, liftEffect)

import WebRTC.MediaStream       (MediaStream)

foreign import data RTCTrackEvent :: Type
foreign import _streams :: RTCTrackEvent -> Effect (Array MediaStream)

streams :: forall m
         . MonadEffect m
        => RTCTrackEvent
        -> m (Array MediaStream)
streams rtcTrackEvent = liftEffect $ _streams rtcTrackEvent
