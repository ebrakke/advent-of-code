main = do
  let input = 368078
  let completeSquare = closestOddSquare (input - 1)
  let complete = completeSquare ^ 2
  let ring = (completeSquare + 2) `div` 2
  let center = (completeSquare + 2) `div` 2
  let pos = (input - complete) `mod` (completeSquare + 1)
  let distToCenter = abs (pos - center)
  let distance = ring + distToCenter
  print distance

getSquare (x,y) = 
  | (0,0) = 1
  | (0,1) = getSquare (0,0)
  | otherwise = getSquare (x-1, y) + getSquare (x, y - 1) + getSquare (x-1, y-1)



closestOddSquare :: Int -> Int
closestOddSquare x = 
  let s = floor $ sqrt $ fromIntegral x
  in if s `mod` 2 == 0 then s - 1 else s

