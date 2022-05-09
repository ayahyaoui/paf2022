{-
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module MindEngine where

import Data.Foldable

-- utilitaires de séquences
-- utilitaires de séquences
import Data.Sequence (Seq, Seq (..), ViewL ((:<)))
import qualified Data.Sequence as Seq

-- utilitaires d'ensembles
import Data.Set (Set)
import qualified Data.Set as Set

import qualified Data.Foldable as F

import Debug.Trace
import qualified Control.Monad as Sequence
--import GHCi.Message (Message(Seq))
--import Distribution.Simple.Utils (xargs)

-}

data Serie a = Z a (Serie a)

--ddderiving (Show, Num, Functor)  
instance Show a => Show (Serie a) where
    show  (Z i serie) = showV2 (Z i serie) 0 where
         showV2 (Z i serie) nb  | nb == 10 = "..."
                                | nb == 0 = show i <> " + " <> showV2 serie (nb + 1)
                                | nb == 1 = show i <> ".Z" <> " + " <> showV2 serie (nb + 1)
                                | otherwise = show i <> ".Z^" <> show nb <> " + " <> showV2 serie (nb + 1)

uns :: Serie Integer
uns = Z 1 uns

gmap :: (a -> a) -> Serie a -> Serie a
gmap f (Z v serie) = Z (f v) (gmap f serie)

-- >>> show uns
-- "1 + 1.Z + 1.Z^2 + 1.Z^3 + 1.Z^4 + 1.Z^5 + 1.Z^6 + 1.Z^7 + 1.Z^8 + 1.Z^9 + ..."

instance Num a => Num (Serie a) where
    (+) (Z v1 serie1) (Z v2 serie2) = Z (v1 + v2) (serie1 + serie2)
    (*) (Z v1 serie1) (Z v2 serie2) = Z (v1 * v2) (gmap (*v1) serie2 + gmap (*v2) serie1 + Z 0 (serie1 * serie2))
    (negate) (Z v1 serie1)  = Z (negate v1) (negate serie1)
    (abs) (Z v serie)  = Z (abs v) (abs serie)
    (signum) (Z v serie) = Z (signum v) serie

-- instance Functor (* -> *) where 

-- = Z (c1 * c2) (gmap (*c1) s2 + gmap (*c2) s1 + Z 0 (s1 * s2))
