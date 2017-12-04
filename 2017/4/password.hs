import Data.List
main = do
  contents <- readFile "input.txt"
  let passphrases = map words $ lines contents
  let validCount = sum $ map noRepeats passphrases
  let alphabeticalWords = map (\xs -> map (\w -> sort w) xs) passphrases
  let noAnagramCount = sum $ map noRepeats alphabeticalWords
  print noAnagramCount

noRepeats xs 
  | (length $ nub xs) == length xs = 1
  | otherwise = 0
