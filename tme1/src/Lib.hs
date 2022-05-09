module Lib
    ( someFunc
    , maxInt
    , factit
    , fibo
    ) where
import GHC.Base (minInt)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

maxInt :: Integer -> Integer -> Integer
maxInt a b = if a > b then a else b


fiboTerm :: Integer -> Integer -> Integer -> Integer -> Integer
fiboTerm n i lastvalue value  = if i > n then value 
                else fiboTerm n (i+1) value (lastvalue + value)

fibo ::  Integer -> Integer 
fibo 0 = 0
fibo 1 = 1
fibo x = if x < 0 then 0 else fiboTerm x 2 0 1


factit :: Integer -> Integer -> Integer
factit 0 acc = acc
factit n acc = factit (n - 1) (n * acc)