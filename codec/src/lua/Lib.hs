module Lib
    ( someFunc
    ) where
import qualified Data.EDN as EDN
import qualified Data.Text.IO as Text

sample = "test/two.edn"

main = do
  edn <- Text.readFile sample
  either error print $ EDN.parseText sample edn

someFunc :: IO ()
someFunc = putStrLn "someFunc"
