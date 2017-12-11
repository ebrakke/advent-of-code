import Debug.Trace
parse :: String -> Int -> Bool -> Bool -> Int -> Int -> (Int, Int)
parse [] _ _ _ score garbageCount = (score, garbageCount)
parse (x:xs) nestCount True True score garbageCount = 
  parse xs nestCount True False score garbageCount
parse('<':xs) nestCount False False score garbageCount = 
  parse xs nestCount True False score garbageCount
parse('>':xs) nestCount True False score garbageCount = 
  parse xs nestCount False False score garbageCount
parse ('!':xs) nestCount True _ score garbageCount = 
  parse xs nestCount True True score garbageCount
parse (x:xs) nestCount True False score garbageCount = 
  parse xs nestCount True False score (garbageCount + 1) 
parse('{':xs) nestCount isGarbage isCancel score garbageCount = 
  parse xs (nestCount + 1) isGarbage isCancel score garbageCount 
parse('}':xs) nestCount False False score garbageCount = 
  parse xs (nestCount - 1) False False (score + nestCount) garbageCount
parse(',':xs) nestCount False False score garbageCount = 
  parse xs nestCount False False score garbageCount
parse(x:xs) nestCount isGarbage isCancel score garbageCount = 
  parse xs nestCount isGarbage isCancel score garbageCount

main = do
  contents <- readFile "input.txt"
  let (score, garbageCount) = parse contents 0 False False 0 0
  print score
  print garbageCount
