{-# LANGUAGE OverloadedStrings #-}

module HDiff(
   run
)where


--import qualified Data.Text as T
import System.Directory
import System.IO (IOMode( ReadMode ), openFile, hClose, hGetLine, Handle(..))
import Data.List (isInfixOf)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Control.Monad (when)
import Data.String.Utils (strip)



data InputError = InputError T.Text deriving (Show) 

data InputParams = InputParams{
   file_1 :: T.Text,
   file_2 :: T.Text,
   start_elements :: [T.Text]
}deriving (Show)







-- |Returns True if one of given strings are contained in given string
contains :: [T.Text] -> T.Text -> Bool
contains elements search_elem
   | trueListCount == 0 = False
   | otherwise = True
   where
      stripped = [T.stripStart (T.strip elem) | elem <- elements]
      isInStringList =  [T.isInfixOf elem search_elem | elem <- stripped, (T.length elem) > 0]
      onlyTrueList = [elem | elem <- isInStringList, elem == True]
      trueListCount = length onlyTrueList



contains' :: [T.Text] -> T.Text -> IO (Bool)
contains' elements search_elem = do
   --putStrLn $ show elements
   let stripped = [T.stripStart (T.strip elem) | elem <- elements]
   let isInStringList = [T.isInfixOf elem search_elem | elem <- stripped, (T.length elem) > 0]
   putStrLn $ show isInStringList
   let onlyTrueList = [elem | elem <- isInStringList, elem == True]
       trueListCount = length onlyTrueList
   putStrLn $ "trueListCount: " ++ show trueListCount
   if(trueListCount > 0) then 
      return True
   else
      return False

            
missingAction' :: T.Text -> [T.Text] -> [T.Text] -> IO()
missingAction' x elemStartStrings f2_lines = do
   isStartingElement <- contains' elemStartStrings x
   if (isStartingElement) then do
      putStrLn $ "-----------------------:"  ++ "checking: " ++ T.unpack x
      --mapM_ putStrLn f2_lines
      isInFile2 <- contains' f2_lines x
      when (isInFile2 == False) (putStrLn $ "Missing: " ++ T.unpack x)
   else return ()
            

missingAction :: T.Text -> [T.Text] -> [T.Text] -> IO()
missingAction x elemStartStrings f2_lines = do
   let isStartingElement = contains elemStartStrings x
   if (isStartingElement) then do
      --putStrLn $ "-----------------------:"  ++ "checking: " ++ x
      --mapM_ putStrLn f2_lines
      let isInFile2 = contains f2_lines x
      when (isInFile2 == False) (putStrLn $ "Missing: " ++ T.unpack x)
   else return ()



findMissing :: [T.Text] -> [T.Text] -> [T.Text] -> IO()
findMissing [] elemStartStrings f2_lines = return ()
findMissing [x] elemStartStrings f2_lines = 
   missingAction x elemStartStrings f2_lines
findMissing (x:xs) elemStartStrings f2_lines = do
   missingAction x elemStartStrings f2_lines  
   findMissing xs elemStartStrings f2_lines
   




diffFiles :: InputParams -> IO()
diffFiles (InputParams file_1 file_2 cfgData) = do
   putStrLn $ "Starting diff on files: " ++ T.unpack file_1 ++ ", " ++ T.unpack file_2
   f1_handle <- openFile (T.unpack file_1) ReadMode
   f2_handle <- openFile (T.unpack file_2) ReadMode
   f1_contents <- TIO.hGetContents f1_handle
   f2_contents <- TIO.hGetContents f2_handle
   let f1_lines = T.lines f1_contents
       f2_lines = T.lines f2_contents
   putStrLn "-----------------------"          
   putStrLn "Checking missing tags.."
   putStrLn "-----------------------"   
   l <- findMissing f1_lines cfgData f2_lines
   hClose f1_handle
   hClose f2_handle
   

run :: [T.Text] -> IO (T.Text)
run args = do
   input <- processInputArgs args
   case input of
      Left (InputError err) -> return err
      Right inData -> do
         _ <- diffFiles inData
         return "done"


testFiles :: [T.Text]
--testFiles = ["f1.out_x", "f2.out_x", "hdiff.cfg"]
testFiles = ["fm_sim.out", "fm_pc.out", "hdiff.cfg"]




-- INPUT CHECKER

invalidInputText :: T.Text
invalidInputText = "Invalid input parameters! Usage: <file_1> <file_2> \
                   \<config_file>"


filesNotPresent :: T.Text
filesNotPresent = "files does not seem to present or are invalid"


processInputArgs :: [T.Text] -> IO (Either InputError InputParams)
processInputArgs args = do
   let argsOk = checkArgs args
   case argsOk of
      Just (InputError errorMsg) -> return $ Left (InputError errorMsg)
      Nothing -> do
         allFilesPresent <- allFilesPresent args
         case allFilesPresent of 
            False -> return $ Left (InputError filesNotPresent)
            True -> do
            configData <- parseConfig (args !! 2)
            putStrLn $ show configData
            let inputParams = InputParams (args !! 0) (args !! 1) configData
            return $ Right inputParams
               


parseConfig :: T.Text -> IO [T.Text]
parseConfig file = do
   let startingElemString = "starting_elements: "
   handle <- openFile (T.unpack file) ReadMode
   contents <- TIO.hGetContents handle
   let cfg_lines = T.lines contents
   putStrLn $ show cfg_lines   
   let l = [line | line <- cfg_lines, T.isInfixOf startingElemString line]
       l2 = T.drop (T.length startingElemString) (head l)
       l3 = T.splitOn ", " l2
   return l3


allFilesPresent :: [T.Text] -> IO Bool
allFilesPresent files = do 
   let filePaths = [T.unpack file | file <- files]
   filesPresent <- mapM doesFileExist filePaths
   return (and filesPresent)




checkArgs :: [a] -> Maybe InputError
checkArgs [] = Just error
   where error = InputError invalidInputText
checkArgs (x:[]) = Just error
   where error = InputError invalidInputText
checkArgs (x:y:[]) = Just error
   where error = InputError invalidInputText 
checkArgs (x:y:z:[]) = Nothing  
checkArgs (_:xs) = Just error
   where error = InputError invalidInputText