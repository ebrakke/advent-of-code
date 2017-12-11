import Debug.Trace
main = do
  let input = 368078
  let distance = getDistance input
  print distance

getDistance :: Int -> Int
getDistance input =
  let
    completedSquare = closestOddSquare (input - 1)
    complete = completedSquare ^ 2
    center = (completedSquare + 2) `div` 2
    pos = (input - complete) `mod` (completedSquare + 1)
    distToCenter = abs (pos - center)
  in center + distToCenter

isCorner :: Int -> Int -> Bool
isCorner ring idx = 
  let 
    numbers = 8 * ring
    numberPerSide = numbers `div` 4
  in
    idx `mod` numberPerSide == 0

getCorner :: Int -> Int -> Int
getCorner 0 _ = 1
getCorner ring corner = 
  let
    numbersInRing = (ring * 8)
    startNumber = getRingStartNumber ring
    numPerSide = numbersInRing `div` 4
  in
    startNumber + (numPerSide * corner) - 1

getRingStartNumber :: Int -> Int
getRingStartNumber 0 = 1
getRingStartNumber 1 = 2
getRingStartNumber ring = ((ring - 1) * 8) + getRingStartNumber (ring - 1)

findAdjacent :: Int -> Int -> [Int]
findAdjacent ring input
  | ring == 0 = []
  | ring == 1 && input == 2 = [1]
  | input == startNumber =
      [ input - 1, getRingStartNumber (ring - 1) ]
  | isCorner ring idx && corner == 4 = 
      [input - 1, lowerRingCorner, getRingStartNumber ring]
  | isCorner ring idx = 
      [input - 1, lowerRingCorner]
  | isCorner ring (idx + 1) = 
      [input - 1, nextLowerRingCorner, nextLowerRingCorner - 1]
  | isCorner ring (idx - 1) = 
      [input - 1, input - 2, lowerRingCorner, lowerRingCorner + 1]
  | otherwise = [input - 1, ]
  where
    startNumber = getRingStartNumber ring
    idx = input - startNumber + 1
    numsInSide = (8 * ring) `div` 4
    corner = (idx `div` numsInSide)
    lowerRingCorner = getCorner (ring - 1) corner
    nextLowerRingCorner = getCorner (ring - 1) (corner + 1)
    adjacentInLowerRing = 

closestOddSquare :: Int -> Int
closestOddSquare x = 
  let s = floor $ sqrt $ fromIntegral x
  in if s `mod` 2 == 0 then s - 1 else s

