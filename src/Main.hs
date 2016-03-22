{-# LANGUAGE OverloadedStrings #-}


module Main where

import qualified HDiff as HDiff (run) 
import System.Environment (getArgs)
import qualified Data.Text as T




main :: IO ()
main = do
   args <- getArgs
   --putStrLn $ show args
   let argsText = map T.pack args
   res <- HDiff.run argsText
   putStrLn $ T.unpack res