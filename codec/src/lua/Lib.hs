module Lib
    ( someFunc
    ) where
import qualified Data.EDN as EDN
import qualified Data.Text.IO as Text

main = do
  edn <- Text.readFile "example.edn"
  either error print $ EDN.parseText "example.edn" edn

someFunc :: IO ()
someFunc = putStrLn "someFunc"
