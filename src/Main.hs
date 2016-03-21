{-# LANGUAGE OverloadedStrings #-}


module Main where

import qualified HDiff as HDiff (run) 

import System.Environment (getArgs)





main :: IO ()
main = do
   args <- getArgs
   --putStrLn $ show args
   res <- HDiff.run args
   putStrLn res