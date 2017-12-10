main = do
  let input = 368078
  -- let completeSquare = closestOddSquare (input - 1)
  -- let complete = completeSquare ^ 2
  -- let ring = (completeSquare + 2) `div` 2
  -- let center = (completeSquare + 2) `div` 2
  -- let pos = (input - complete) `mod` (completeSquare + 1)
  -- let distToCenter = abs (pos - center)
  -- let distance = ring + distToCenter
  let pos = spiral 4 0 (0,0)
  print pos


spiral :: Int -> Int -> (Int, Int) -> (Int, Int)
spiral walk elapsed (x,y)
  | walk == 1 = (x,y)
  | otherwise = spiral (walk -1) (elapsed + 1) step
  where
    bound = (walk + elapsed) 
    step = 
      


 

closestOddSquare :: Int -> Int
closestOddSquare x = 
  let s = floor $ sqrt $ fromIntegral x
  in if s `mod` 2 == 0 then s - 1 else s

