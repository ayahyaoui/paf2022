module Split where
import qualified Data.Sequence as String

splitV3 :: Char -> String -> String -> [String]
splitV3 c (x:xs) actual
                    | null (x:xs) = [actual]
                    | c == x = actual : splitV3 c xs ""
                    | otherwise = splitV3 c xs (actual <> [x])

splitV3 _ [] s = [s] -- null (x:xs) <=?=> [] je le pensais equivalent


split :: Char -> String -> [String]
split c s = splitV3 c s ""


{-
    Precedente version: que je preferrais mais j'ai un probleme de "Pattern match(es) are non-exhaustive" que 
    je ne pensais pas possible avec otherwise
split :: Char -> String -> [String]
split c s = splitV2 c s ""
            where  splitV2 c (x:xs) actual
                                            | null (x:xs) = [actual]
                                            | c == x = actual : split c xs
                                            | otherwise = splitV2 c xs (actual <> [x])
-}


-- >>> split ' ' "1 2 3  4  5  6  7  "
-- ["1","2","3","","4","","5","","6","","7","",""]

unsplit :: Char -> [String] -> String
unsplit _ [] = ""
unsplit c tab = head tab <> foldr (\a acc ->  ([c] <> a) <> acc) "" (tail tab)

-- >>> unsplit ' ' ["1","2","3","","4","","5","","6","","7","",""]
-- "1 2 3  4  5  6  7  "

prop_split_unsplit :: Char -> String -> Bool
prop_split_unsplit c str = unsplit c (split c str) == str

-- >>> prop_split_unsplit ' ' "premier test   marche"
-- True
