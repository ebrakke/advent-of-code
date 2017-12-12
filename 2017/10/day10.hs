import Debug.Trace
main = do
  let input = [227,169,3,166,246,201,0,47,1,255,2,254,96,3,97,144]
  let (h:s:xs) = run input [0..255] 0 0 
  let product = h * s
  print product


hash :: [Int] -> Int -> Int -> Int -> [Int]
hash current selection skip start = 
  let
    (t, h) = splitAt start current
    intermediate = foldr (:) t h
    section = reverse $ take selection intermediate
    rest = drop selection intermediate
    rev = foldr (:) rest section
    (t', h') = splitAt (256 - start) rev
  in
    foldr (:) t' h' 

run :: [Int] -> [Int] -> Int -> Int -> [Int]
run [] arr skip _ = arr
run (x:xs) arr skip curr = 
  let 
    result = hash arr x skip curr
    nextStart = (curr + x + skip) `mod` 256
  in 
    run xs result (skip + 1) nextStart
