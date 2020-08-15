module WebRTC.MediaStream where

import Prelude
import Control.Promise              as P
import Effect                       (Effect)
import Effect.Aff                   (Aff())
import Effect.Class                 (class MonadEffect, liftEffect)
import Unsafe.Coerce                (unsafeCoerce)
import Web.Event.Event              as E
import Web.Event.Internal.Types     (EventTarget)
import Web.File.Blob                (Blob)
import Web.HTML.HTMLMediaElement    (HTMLMediaElement)
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

-- Recorder
foreign import data MediaRecorder :: Type

foreign import pause :: MediaRecorder -> Effect Unit
foreign import requestData :: MediaRecorder -> Effect Unit
foreign import resume :: MediaRecorder -> Effect Unit
foreign import start :: MediaRecorder -> Effect Unit
foreign import stop :: MediaRecorder -> Effect Unit

foreign import _newMediaRecorder :: MediaStream -> Effect MediaRecorder

newMediaRecorder :: forall m
                  . MonadEffect m 
                 => MediaStream 
                 -> m MediaRecorder
newMediaRecorder stream = liftEffect $ _newMediaRecorder stream

-- Recorder Event handler types
dataavailable :: E.EventType
dataavailable = E.EventType "dataavailable"

mediaRecorderEventTarget :: MediaRecorder -> EventTarget
mediaRecorderEventTarget = unsafeCoerce

foreign import _setSrcObject :: String -> MediaStream -> Effect Unit

setSrcObject :: forall m
              . MonadEffect m
             => String 
             -> MediaStream
             -> m Unit
setSrcObject element stream = liftEffect $ _setSrcObject element stream
