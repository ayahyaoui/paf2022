module Mouve where

data Zone = Zone Integer Integer
data Coord = Coord Integer Integer
            deriving Eq
data Mouvement = Mouv Direction Integer
data Direction = H | B | G | D
            deriving Eq

bougeCoord :: Coord -> Mouvement -> Coord
bougeCoord (Coord x y) (Mouv d v)
            | d == H = Coord x (y - v)
            | d == B = Coord x (y + v)
            | d == G = Coord (x - v) y
            | d == D = Coord (x + v) y
            | otherwise = Coord x y

isInZone :: Coord -> Zone -> Bool
isInZone (Coord x y) (Zone width height) =  x >= 0 && x <= width && y >= 0 && y <= height

bougeCoordSafe :: Coord -> Mouvement -> Zone -> Maybe Coord
bougeCoordSafe (Coord x y) (Mouv d v) (Zone width height)
    | isInZone (Coord x' y') (Zone width height) = Just (Coord x' y') 
    | otherwise = Nothing
    where (Coord x' y') = bougeCoord (Coord x y) (Mouv d v)

-- second version of boogeCoordSafe when it return Nothing we just return the first Coors
bougeCoordSafe2 :: Coord -> Mouvement -> Zone -> Coord
bougeCoordSafe2 c m z = case (bougeCoordSafe c m z) of
        Nothing -> c
        Just c' -> c'

prop_gaucucheGroite_bougeCoord :: Coord -> Integer -> Bool
prop_gaucucheGroite_bougeCoord (Coord x y) d = Coord x y == bougeCoord (bougeCoord (Coord x y) (Mouv G d)) (Mouv D d)

