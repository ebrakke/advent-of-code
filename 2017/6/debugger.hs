import Data.List
import Data.Maybe

main = do
  let input = [4, 1, 15, 12, 0, 9, 9, 5, 5, 8, 7, 3, 14, 5, 12, 3]
  let steps = findRepeat input [] 0
  print steps

findRepeat :: [Int] -> [([Int], Int)] -> Int -> Int
findRepeat input seen steps
  | lookup input seen /= Nothing
      = steps - (fromJust (lookup input seen))
  | otherwise
      = findRepeat reallocatedList (seen ++ [(input, steps)]) (steps + 1)
  where
    max = maximum input
    maxIdx = fromJust (elemIndex max input)
    adj = adjustments max (length input) (maxIdx + 1)
    zeroedInput = take maxIdx input ++ [0] ++ drop (maxIdx + 1) input
    reallocatedList = applyAdjustment zeroedInput adj

applyAdjustment :: [Int] -> [Int] -> [Int]
applyAdjustment xs adjustments =
  map (\(x,y) -> x+y) (zip xs adjustments)

adjustments :: Int -> Int -> Int -> [Int]
adjustments val len start =
  let
    wholeAdditions = val `div` len
    partialAdditions = val `mod` len
    partials = map (\x -> 1) [1..partialAdditions] ++ map (\x -> 0) [1..(len - partialAdditions)]
    adj = map (+wholeAdditions) partials
  in
    drop (len - start) adj ++ take (len - start) adj
    
