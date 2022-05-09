module SplitSpec where

import Test.Hspec
import Test.QuickCheck

import Split

splitSpec0 = do
  describe "split" $ do
    it "splits a string wrt. a given character into a list of words" $ -- 
      (split '/' "aa/bb/ccc/dd d") `shouldBe` ["aa", "bb", "ccc", "dd d"] -- On verifie qu'appliquer a la fonction slpit '/' "aa/bb/ccc/dd d" 
                                                                          -- on obtient bien la liste ["aa", "bb", "ccc", "dd d"]

splitSpec1 = do
  describe "split" $ do
    it "can be undone with unsplit (v1)" $ property $ 
      \c xs -> collect (length xs) $ -- On affiche la taille de la chaine de caraectere (que l'on veut slpit)
       prop_split_unsplit c xs -- on vérifie la propriété pour un cas 


splitSpec2 = do
  describe "split" $ do
    it "can be undone with unsplit (v2)" $ property $
      \xs -> forAll (elements xs) $
      \c -> collect (length xs) $ -- On affiche la taille de la chaine de caraectere (que l'on veut slpit)
      prop_split_unsplit c xs -- on verifie pour tout caractere de la chaine de la String(2eme parametre de split) 
                                    -- que la propriete prop_split_unsplit est valide

-- Remarque : on utilise comme caractère de split les éléments des listes `xs` en entrée,
--            cf. la doc QuickCheck sur `forAll`, `elements`, etc.

splitSpec3 = do
  describe "split" $ do
    it "can be undone with unsplit (v3)" $ property $
      forAll (oneof [return "bla bla bli"
                     , return "toto"
                     , return ""
                     , return "un    deux trois   quatre"]) $
      \xs -> prop_split_unsplit ' ' xs  -- on vérifie la propriété pour une liste predefinie de chaine de caractere 
                                            -- dont une chaine vide , une chaine ne contenant pas le caractere 
                                            -- plusieur fois d'affiler le caractere et un test basique 
