import Data.Char
import Data.Bits
import Numeric (showHex)
import Debug.Trace
main = do
  let input = [227,169,3,166,246,201,0,47,1,255,2,254,96,3,97,144]
  let ((h:s:xs), skip, curr) = run input [0..255] 0 0
  let product = h * s

  -- Day 2
  let input = "227,169,3,166,246,201,0,47,1,255,2,254,96,3,97,144"
  let hash = getKnotHash input
  print product
  print hash


flipArr :: [Int] -> Int -> Int -> Int -> [Int]
flipArr current selection skip start = 
  let
    (t, h) = splitAt start current
    intermediate = foldr (:) t h
    section = reverse $ take selection intermediate
    rest = drop selection intermediate
    rev = foldr (:) rest section
    (t', h') = splitAt (256 - start) rev
  in
    foldr (:) t' h' 

run :: [Int] -> [Int] -> Int -> Int -> ([Int], Int, Int)
run [] arr skip curr = (arr, skip, curr)
run (x:xs) arr skip curr = 
  let 
    result = flipArr arr x skip curr
    nextStart = (curr + x + skip) `mod` 256
  in 
    run xs result (skip + 1) nextStart

sparseHash :: [Int] -> [Int] -> Int -> Int -> Int -> [Int]
sparseHash xs arr skip curr 0 = arr
sparseHash xs arr skip curr runs = 
  let 
    (result, newSkip, newCurr) = run xs arr skip curr
  in
    sparseHash xs result newSkip newCurr (runs - 1)

convertToAscii :: String -> [Int]
convertToAscii [] = [17,31,73,47,23]
-- convertToAscii(' ':xs) = convertToAscii xs
convertToAscii (x:xs) = ord x:(convertToAscii xs)

denseHash :: [Int] -> [Int]
denseHash xs 
  | length xs == 16 = 
      [foldl1 xor xs] 
  | otherwise = denseHash s1 ++ denseHash s2
  where
    (s1, s2) = splitAt ((length xs) `div` 2) xs

toHexString :: [Int] -> String
toHexString xs = 
  (foldl1 (.) $ map (\x -> if x < 16 then ("0" ++) . (showHex x) else (showHex x))  xs) ""

getKnotHash :: String -> String
getKnotHash input = 
  let
    ascii = convertToAscii input
    sparse = sparseHash ascii [0..255] 0 0 64
    dense = denseHash sparse
  in
    toHexString dense
