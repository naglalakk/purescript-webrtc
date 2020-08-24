module WebRTC.Utils where

import Prelude
import Data.Options             (Options(..)
                                ,Option
                                ,opt)
import Data.Op                  (Op(Op))
import Data.Tuple               (Tuple(Tuple), fst)
import Foreign                  (unsafeToForeign)

optWith :: forall opt a b . (a -> b) -> String -> Option opt a
optWith f = Op <<< \k v -> Options [ Tuple k (unsafeToForeign $ f v) ]
