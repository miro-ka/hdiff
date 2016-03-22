{-# LANGUAGE OverloadedStrings #-}

module InputChecker( 
   checkArgs,
   InputError(..)
)where


--import qualified Data.Text as T
--import System.Directory


data InputError = InputError String deriving (Show) 


usageText :: String
usageText = "Usage: 2 file inputs"


errorText :: String
errorText = "Invalid error parameters!"


invalidInputText :: String
invalidInputText = errorText ++ " " ++ usageText


checkArgs :: [a] -> IO (Maybe InputError)
checkArgs [] = return $ Just error
   where error = InputError invalidInputText
checkArgs (x:[]) = return $ Just error
   where error = InputError invalidInputText
checkArgs (x:y:[]) = return Nothing  
checkArgs (_:xs) = return $ Just error
   where error = InputError invalidInputText