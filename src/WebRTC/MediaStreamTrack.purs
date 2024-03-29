module WebRTC.MediaStreamTrack where

import Prelude
import Effect           (Effect)
import Effect.Class     (class MonadEffect, liftEffect)

foreign import data MediaStreamTrack :: Type

foreign import _stop :: MediaStreamTrack -> Effect Unit

stopTrack :: forall m
           . MonadEffect m
          => MediaStreamTrack
          -> m Unit
stopTrack track = liftEffect $ _stop track
