{-# LANGUAGE OverloadedStrings #-}
module Main where

import System.Environment
import System.Console.GetOpt
import qualified Data.Text as T

data Flag = Delimiter String
          | Header String
          | Source String
          | Query String
          | TableName String
          deriving Show

defaultTableName :: T.Text
defaultTableName = "tbl"

options :: [OptDescr Flag]
options =
    [
        Option ['d'] ["delimiter"]  (ReqArg Delimiter ",")              "Delimiter between fields -dlm tab for tab, -dlm 0x## to specify a character code in hex",
        Option ['h'] ["header"]     (ReqArg Header "false")             "Treat file as having the first row as a header row",
        Option ['s'] ["source"]     (ReqArg Source "stdin")             "Source file to load, or defaults to stdin",
        Option ['q'] ["query"]      (ReqArg Query "")                   "SQL Command(s) to run on the data",
        Option ['t'] ["table"]      (ReqArg TableName $ T.unpack defaultTableName) "Override the default table name (tbl)"
    ]

programOptions :: [String] -> IO ([Flag], [String])
programOptions argv =
    case getOpt Permute options argv of
          (o,n,[]  ) -> return (o,n)
          (_,_,errs) -> ioError (userError (concat errs ++ usageInfo header options))
      where header = "Usage: textql [OPTION...]"

main = getArgs >>= programOptions >>= print
