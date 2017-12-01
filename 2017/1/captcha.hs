import System.IO
import Data.Char
import Data.List

main = do
  -- Problem 1
  contents <- readFile "captcha-input.txt"
  let s = map digitToInt $ init contents
  let shifted = shiftBy s 1
  let zipped = zip s shifted
  let output = sum $ map (\(x, y) -> if x == y then x else 0) zipped
  -- Problem 2
  contents2 <- readFile "captcha-input2.txt"
  let s2 = map digitToInt $ init contents
  let shifted2 = shiftBy s2 $ length s2 `div` 2
  let zipped2 = zip s2 shifted2
  let output2 = sum $ map (\(x, y) -> if x == y then x else 0) zipped2
  print zipped2
  print output
  print output2

shiftBy :: [Int] -> Int -> [Int]
shiftBy arr num = 
  let (a,b) = splitAt num arr
  in b ++ a
