module WebRTC.MediaRecorder where

import Prelude
import Effect                   (Effect)
import Effect.Class             (class MonadEffect
                                ,liftEffect)
import Unsafe.Coerce            (unsafeCoerce)
import Web.Event.Event          as E
import Web.Event.Internal.Types (EventTarget)

import WebRTC.MediaStream       (MediaStream)

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

