
-- le module `Main` correspond au point d'entrée
-- des programmes exécutables Haskell (ghc).
module Main where

-- On utilise quelques outils du module d'entrées/sorties.
import System.IO (hFlush, stdout)

import Debug.Trace
-- Un petit type somme pour les réponses
data Answer =
    Lower
    | Greater
    | Equal

message :: Answer -> String
message Lower = "Trop petit"
message Greater = "Trop grand"
message Equal = "Trouvé!"

-- Vérification des nombres candidats (à compléter)
checkGuess :: Integer -> Integer -> Answer
checkGuess secret guess
  | secret < guess = Greater
  | secret > guess = Lower
  | otherwise = Equal

-- first version -- checkGuess secret guess = if secret < guess then Greater else if secret > guess then Lower else Equal

instance Eq Answer where
     Lower == Lower = True
     Greater == Greater = True
     Equal == Equal = True
     _ == _ = False

--  checkGuess 100 50 == Lower
-- False

-- Stratégie de raffinement des candidats (à compléter)
-- Une stratégie simple est la suivante :
-- si le candidat est plus petit, alors on augmente de 1,
-- si c'est plus grand alors on divise par 2  (pour accélérer la recherche)
-- ===> une stratégie plus efficace serait la bienvenue, notamment en
--      introduisant une borne max pour le choix du nombre ...



refineGuess2 :: Integer -> Integer -> Integer

refineGuess2 secret guess -- = trace  ("Ok, je triche 2" ++ show initGuess)
 | guess < secret = guess + 1
 | guess > secret = div guess 2
 | otherwise = guess

refineGuess :: Integer -> Integer -> Integer
refineGuess secret guess = trace  ("tentative prog: " ++ show guess) (refineGuess2 secret guess)
-- >>> refineGuess 100 50 == 51
-- True

{-
find :: Integer  -> Integer -> Integer -> IO Integer 
find initGuess nb secret = do 
  putStrLn ("Ok, je triche 2" ++ show initGuess)
  let nextGuess = refineGuess secret initGuess
   in if initGuess == nextGuess
    then nb
  else find nextGuess (nb + 1) secret
-}
-- >>>findSecret 100 50 == 51

findSecret :: Integer -> Integer ->  Integer
findSecret secret initGuess =
  find initGuess 1
    --putStrLn ("Ok, je triche 2" ++ show initGuess)
    where find guess nb = 
           let guess2 = refineGuess secret guess
           in if guess2 == guess
              then nb
              else find guess2 (nb + 1)

-- >>>findSecret 100 50 == 51
-- True
-- >>> findSecret 100 150 == 27
-- True

-- >>> findSecret 100 100 == 1
-- True


-- La boucle principale du jeu,
-- qui prend en entrée le secret à trouver ainsi
-- que le nombre de tentatives (en fait le rang de
-- la tentative actuelle).
-- On y reviendra mais le type de retour `IO Integer`
-- correspond à une action d'entrées/sorties qui,
-- une fois exécutée par le runtime, retourne un entier.
gameLoop :: Integer -> Integer -> IO Integer
gameLoop secret nb = do -- ceci permet de chaîner des actions d'entrées/sorties en séquence
  putStrLn ("Tentative #" ++ show nb)    -- première action de la séquence
  putStr "Quel nombre ? "                  -- deuxième action
  hFlush stdout                            -- etc.
  -- on lit sur l'entrée standard et on récupère la valeur dans une variable `guessStr`
  guessStr <- getLine    -- ici c'est une action avec retour de valeur (une chaîne)

  if guessStr == "t"
  then do  -- triche
    putStrLn "Ok, je triche"
    pure $ findSecret secret 0
  else do
    -- on transforme la chaîne en un entier
    let guess = read guessStr :: Integer  -- en Haskell il est fréquent de "caster" des expressions
                                        -- mais la sémantique est très différente de C ou C++
                                        -- c'est nécessaire ici car `read` est polymorphe (cf. typeclasses)
  -- Remarque : l'instruction `read` est *unsafe*, elle lance une exception si l'entrée ne correspond
  -- pas à un nombre... Rendre ce petit bout de code *safe* est une extension intéressante.

    -- on vérifie le candidat
    let answer = checkGuess  secret guess
    -- on affiche la réponse
    putStrLn (message answer)
    case answer of
      Equal -> pure nb  -- on retourne le nombre de tentatives, une valeur "pure", dans le cadre des entrées/sorties ("impures")
      _ -> gameLoop secret (nb+1) -- sinon on n'a pas encore trouvé alors on démarre une nouvelle tentative


-- le point d'entrée du programme
-- la valeur `()` s'appelle *unit* et est du type `()` (également *Unit*).
-- cela correspond à des programmes d'entrées/sorties.
main :: IO ()
main = do
  putStrLn "Devine le nombre!"
  putStrLn "================="
  putStrLn "  -> un super jeu de PAF!"
  putStr "Donne un secret: "
  hFlush stdout
  secretStr <- getLine
  let secret = read secretStr :: Integer
  -- ici on affiche 40 retours de ligne pour faire disparaître la saisie du nombre (ce n'est pas très "propre" ...)
  newlines 40
  putStrLn "Merci ! Le secret est enregistré."
  putStrLn "Maintenant votre adversaire va devoir le deviner ..."
  nb <- gameLoop secret 1
  putStrLn ("Vous avez trouvé le secret en " ++ (show nb) ++ " tentative(s)")

-- une petite fonction auxiliaire pour ajouter des retours charriots.
newlines :: Int -> IO ()
newlines 0 = pure ()
newlines n = do
  putStrLn ""
  newlines (n-1)
