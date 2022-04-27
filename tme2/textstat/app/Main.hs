{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# LANGUAGE DataKinds #-}
module Main where

import Lib
import Data.Text (Text)

-- Les fonctions de manipulation de textes
-- sont préfixées par `T` plutôt que `Data.Text`
import qualified Data.Text as T
-- Les fonctions d'entrées sorties pour les textes
import qualified Data.Text.IO as TIO

import System.Environment
import Data.Typeable

import Data.Map (Map , (!?))  -- on a aussi importé l'opérateur de "lookup"
-- il n'y a pas de constructeurs explicites, l'implémentation est "cachée"
import qualified Data.Map as Map

-- On utilise aussi quelques folds génériques
import Data.Foldable (foldr)

import Data.List (intercalate, sortBy)

import Debug.Trace

maybeToInt :: Maybe Integer -> Integer
maybeToInt (Just n) = n
maybeToInt Nothing = 0

-- ajoute 1 au compteur du caractere c dans la hasmap si existant sinon la creer et met a 1
countChar :: Map Char Integer -> Char -> Map Char Integer
countChar  allChar c = let value =  Map.lookup c allChar in
      Map.insert c (maybeToInt value + 1) allChar


-- >>> countChar Map.empty 'c'
-- fromList [('c',1)]

-- >>> countChar (Map.fromList [('c', 41)]) 'c'
-- fromList [('c',6)]

-- caractere pouvant separer les mot (a completer)
isSeparator :: Char -> Bool
isSeparator c = c == ' ' || c == '\n' || c == '\t'

-- compte le nombre de mot separer par des separateur si dessus 
countWords2 :: [Char] -> Char -> Integer -> Integer
countWords2 (x:xs) lastChar nbWords
    | null xs = nbWords
    | isSeparator x && not (isSeparator lastChar) = countWords2  xs x (nbWords + 1)
    | otherwise = countWords2 xs x nbWords

countWords :: [Char] -> Integer
countWords (x:xs) = countWords2 xs x 1


-- compte les differnent caractere et les ajoute dans une hashMap
countCharToMap :: [Char] -> Map Char Integer -> Map Char Integer
countCharToMap(x:xs) allChar
    | null xs = countChar allChar x
    | otherwise = countCharToMap xs (countChar allChar x)

-- >>> countAllChar "test simple" Map.empty
-- fromList [(' ',1),('e',2),('i',1),('l',1),('m',1),('p',1),('s',2),('t',2)]

hashMapChar = Map.fromList [('a', 0)]

printListCouple :: [(Char, Integer)] -> Integer
--printAllChar t = List.foldr (\(a,b) c -> putStr ("Nombre de \"" ++ show a ++ "\" de code " ++ show 13  ++ ": " ++ show b)) 0 t
printListCouple ((a,b):xs)
    | null xs = b
    | otherwise =  trace ("Nombre de \"" ++ show a ++ "\" de code " ++ show 13  ++ ": " ++ show b) $ b + printListCouple xs


allStatistics :: [Char] -> Integer
allStatistics all_text = printListCouple (Data.List.sortBy (\(_,a) (_,b) -> compare b a) (Map.toList  (countCharToMap all_text Map.empty)))

-- >>> printAllChar [('a', 12), ('b', 21)]
-- 33


-- >>> Data.List.sortBy (\(_,a) (_,b) -> compare b a) ( Map.toList  (countAllChar "test simple" Map.empty))
-- [('e',2),('s',2),('t',2),(' ',1),('i',1),('l',1),('m',1),('p',1)]

--[(1,"Hello"),(2,"world"),(4,"!")]

-- TODO faire en sorte qu'on parcours une seule fois le texte 
--      au risque d'avoir un code moins lisible ?? (fusion countWord et countAllChar)

main :: IO ()
main = do
    args <- getArgs                  -- IO [String]
    all_text <- readFile (head args)
    putStrLn ("Analyse du texte de: " ++ head args)
    putStrLn "==================="
    putStrLn ("Nombre de caractères" ++ show (length (head args)))
    -- la difference de resultat avec l'exemple est peut etre du au choix des charactere de separation d'un mot
    putStrLn ("Nombre de mots " ++ show (countWords all_text))
    --affiche (countAllChar all_text hashMapChar)
    putStrLn ("Nombre de caractères total " ++ show (allStatistics all_text))

    putStrLn "==================="
