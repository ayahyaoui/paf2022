module Model where

import SDL

import Keyboard (Keyboard)
import qualified Keyboard as K

step_lateral = 5
step_vertical = 5

data GameState = GameState { persoX :: Int
                           , persoY :: Int
                           , speed :: Int }
  deriving (Show)

initGameState :: GameState
initGameState = GameState 200 300 4

moveLeft :: GameState -> GameState
moveLeft gs@(GameState persoX persoY speed) = GameState (persoX - (step_lateral * speed))  persoY  speed

moveRight :: GameState -> GameState
moveRight gs@(GameState persoX persoY speed) = GameState (persoX + (step_lateral * speed))  persoY  speed
                              
moveUp :: GameState -> GameState
moveUp gs@(GameState persoX persoY speed) = GameState persoX  (persoY - (step_lateral * speed))   speed                             

moveDown :: GameState -> GameState
moveDown gs@(GameState persoX persoY speed) = GameState persoX  (persoY + (step_lateral * speed))   speed                             

gameStep :: RealFrac a => GameState -> Keyboard -> a -> GameState
gameStep gstate kbd deltaTime =
  let modif = (if K.keypressed KeycodeLeft kbd
               then moveLeft else id)
              .
              (if K.keypressed KeycodeRight kbd
               then moveRight else id)
              .
              (if K.keypressed KeycodeUp kbd
               then moveUp else id)
              .
              (if K.keypressed KeycodeDown kbd
               then moveDown else id)
  in modif gstate

