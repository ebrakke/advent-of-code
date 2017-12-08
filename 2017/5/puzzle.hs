import Data.Sequence as Seq
import Debug.Trace
main = do
  contents <- readFile "input.txt"
  let instructions = fromList . map (read::String->Int) $ lines contents
  let steps = walk instructions 0 0
  print steps

walk :: Seq Int -> Int -> Int -> Int
walk xs pos steps 
  | pos >= (Seq.length xs) = steps
  | otherwise = walk xs' (pos + val) (steps + 1)
  where
    val = index xs pos
    xs' = update pos ((\x -> if x > 2 then x - 1 else x + 1) val) xs

