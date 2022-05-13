module Hitbox where
import Mouve
import Data.Sequence
import qualified Data.Sequence as Seq
import qualified Control.Monad as Seq
--import qualified Control.Monad as Seq
--import Data.Sequence


data Hitbox = Rect Coord Integer Integer
        | Composite (Seq Hitbox)


mkRectangle :: Coord -> Coord -> Hitbox
mkRectangle (Coord x1 y1) (Coord x2 y2) = Rect (Coord x1 y1) (x2 - x1) (y2 - y1)


mkHitbox :: [(Coord, Coord)] -> Hitbox
mkHitbox [] = Composite Seq.empty
mkHitbox ((c1, c2):xs) = Composite $  Seq.singleton (mkRectangle c1 c2) Seq.|> mkHitbox xs


appartient :: Coord -> Hitbox -> Bool
appartient (Coord x y)  (Rect (Coord x' y') w h) = x >= x' && x <= x' + w && y > y' && y < y' + h
appartient c  (Composite s) = foldr (\hit  acc -> acc || appartient c hit) False s


bougeHitbox :: Hitbox -> Mouvement -> Hitbox
bougeHitbox (Composite hits) m = Composite (fmap (\x -> bougeHitbox x m) hits)
bougeHitbox (Rect (Coord x y) w h) m = Rect (bougeCoord (Coord x y) m) w h

isValidHitbox :: Hitbox -> Zone -> Bool
isValidHitbox (Rect (Coord x y) w h) z = isInZone (Coord x y) z && isInZone (Coord (x + w) (y + h)) z
isValidHitbox (Composite hits) z = foldr (\h acc -> acc && isValidHitbox h z)  True hits

bougeHitboxSafe :: Hitbox -> Mouvement -> Zone -> Maybe Hitbox
bougeHitboxSafe h m z = let nextHit = bougeHitbox h m in if isValidHitbox nextHit z then Just nextHit else Nothing

-- TODO
collision :: Hitbox -> Hitbox -> Bool
collision = undefined