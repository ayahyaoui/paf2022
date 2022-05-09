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

-- Note: 8 colors because it's the standard ANSI colors
data Peg =
  PEmpty
  | Black
  | Blue
  | Green
  | Yellow
  | Cyan
  | White
  | Magenta
  | Red
  deriving (Show, Eq, Ord)

data FeedbackMark =
  MarkedCorrect
  | MarkedPosition
  | Unmarked
  deriving (Show, Eq)

data Secret = Secret { pegs :: Seq Peg
                     , size :: Int }
            deriving (Show, Eq)


-- smart constructor for secrets
mkSecret :: Seq Peg -> Secret
mkSecret pegs = Secret pegs (length pegs)

type Guess = Seq Peg
type Feedback = Seq (Peg, FeedbackMark)

data Answer = Answer { correct :: Int, position :: Int }
  deriving (Show, Eq)



-- runtime error if not a good guess
safeGuess :: Secret -> Guess -> Guess
safeGuess secret guess =
  if (size secret) /= (length guess)
  then error "Wrong guess size (please report)"
  else guess

wrongGuess :: Secret -> Guess -> Bool
wrongGuess secret guess = (size secret) /= length guess

initFeedback :: Secret -> Feedback
initFeedback (Secret sec _) =
  fmap (\p -> (p, Unmarked)) sec

markCorrectOne :: Peg -> (Peg, FeedbackMark) -> (Peg, (Peg, FeedbackMark))
markCorrectOne gpeg (speg, mk) | gpeg == speg = (PEmpty, (speg, MarkedCorrect))
                               | otherwise = (gpeg, (speg, mk))

{-

testGuessMarkCorrectOne :: Peg -> (Peg, FeedbackMark) -> (Peg, (Peg, FeedbackMark))
testGuessMarkCorrectOne 
testFeedMarkCorrectOne :: Peg -> (Peg, FeedbackMark) -> (Peg, (Peg, FeedbackMark))
-}

markCorrect :: Guess -> Feedback ->  (Guess, Feedback)
markCorrect g f =  Seq.unzip $ fmap (uncurry markCorrectOne) (Seq.zip g f)

{-
-- fonction à définir (cf. tests)                      
markCorrect :: Guess -> Feedback -> (Guess, Feedback)
markCorrect g f = ((map fst (fmap ( \a -> markCorrectOne (fst a) (snd a)) (zip g f))) , ((map snd (fmap ( \a -> markCorrectOne (fst a) (snd a)) (zip g f)))) -- (map snd (fmap ( a, b -> (markCorrectOne a b)) (zip g f)))
-}

removeColorGuess :: Guess -> (Peg, FeedbackMark) -> Guess
removeColorGuess Seq.Empty speg = Seq.Empty
removeColorGuess (x :<|  xs) (speg, mk) | x == speg &&  mk /= MarkedCorrect = PEmpty :<| xs
                                  | otherwise = x :<| removeColorGuess xs (speg, mk)


markPositionOne :: Guess -> (Peg, FeedbackMark) -> (Peg, FeedbackMark)
markPositionOne g (speg, mk)  | mk == MarkedCorrect = (speg, mk)
                              | foldr  (\a acc -> a == speg || acc ) False g = (speg, MarkedPosition)
                              | otherwise = (speg, mk)

-- fonction à définir (cf. tests)

markPosition :: Guess -> Feedback -> Feedback
markPosition _ Empty = Empty
markPosition g (x :<| xs) = markPositionOne g x :<| markPosition (removeColorGuess g  x) xs

-- >>> markPosition (Seq.fromList [Blue, Red, Red, Blue]) (Seq.fromList [(Yellow, Unmarked), (Yellow, Unmarked), (Green, Unmarked), (Blue, MarkedCorrect)])
-- fromList [(Yellow,Unmarked),(Yellow,Unmarked),(Green,Unmarked),(Blue,MarkedCorrect)]

verify :: Secret -> Guess -> Answer
verify secret guess =
  let (guess', fb) = markCorrect (safeGuess secret guess) (initFeedback secret)
      fb' = markPosition guess' fb
  in foldr verifyAux (Answer 0 0) (fmap snd fb')
  where verifyAux :: FeedbackMark -> Answer -> Answer
        verifyAux MarkedCorrect (Answer cor pos)  = Answer (cor + 1) pos
        verifyAux MarkedPosition (Answer cor pos)  = Answer cor (pos + 1)
        verifyAux _ ans = ans


{- small test debug
exSecret = mkSecret $ Seq.fromList [Yellow, Yellow, Green, Blue ]
(testGuess, testFb) = markCorrect (safeGuess exSecret (Seq.fromList [Yellow, Blue, Green, Yellow])) (initFeedback exSecret)

-- >>> (testGuess,testFb)
-- (fromList [PEmpty,Blue,PEmpty,Yellow],fromList [(Yellow,MarkedCorrect),(Yellow,Unmarked),(Green,MarkedCorrect),(Blue,Unmarked)])

-- >>> markPosition testGuess testFb
-- fromList [(Yellow,MarkedCorrect),(Yellow,Unmarked),(Green,MarkedCorrect),(Blue,MarkedPosition)]

-- >>> verify exSecret (Seq.fromList [Yellow, Blue, Green, Yellow])
-- Answer {correct = 2, position = 1}
-}

winning :: Secret -> Answer -> Bool
winning (Secret _ size) (Answer cor _) = size == cor
