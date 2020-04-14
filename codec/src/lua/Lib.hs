{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( main3
    ) where
import qualified Data.EDN as EDN
import qualified Data.Text.IO as Text
import qualified Data.Yaml as Y
import qualified Data.ByteString.Char8 as BS
-- import GHC.Generics
-- import Data.Map

------------------------------------------------------------------------
-- Given block parameters, construct a program fragment

type NodeFragment = [Char]
type EdgeFragment = [Char]

data Fragment = NodeFragment | EdgeFragment


  -- what gets read from grc file
data Node = Node [String]
data Edge = Edge Node Node
data Graph = Graph [Node] [Edge]
type Spec = String


top :: Spec -> String
top s
  | s == "" = ""
  | otherwise = ""

preamble :: IO ()
preamble = putStrLn "local radio = require('radio')\n"

body :: IO ()
body = putStrLn (top "")

postamble :: IO ()
postamble = putStrLn "top:run()"

main2 :: IO ()
main2 = do
  preamble
  body
  postamble

------------------------------------------------------------------------

-- data GRC = GRC { options :: Map
--                      , blocks :: Map
--                      , connections :: Map
--                      } deriving (Show, Generic)
-- instance Y.FromJSON GRC


sampleYaml = "test/two-yaml.grc"

main3 :: IO ()
main3 = do
  yamls <- BS.readFile sampleYaml
  res <- Y.decodeThrow yamls :: IO Y.Value
  putStrLn (show res)

------------------------------------------------------------------------

sample = "test/two.edn"
main :: IO ()
main = do
  edn <- Text.readFile sample
  either error print $ EDN.parseText sample edn

