main = do
  content <- readFile "spreadsheet.txt"
  -- convert all strings to integers and split based on whitespace
  let rows = (\xs -> [map (read::String -> Int) x | x <- xs]) . map words $ lines content
  let maximums = map maxInRow rows
  let minimums = map minInRow rows
  let checksum = sum $ zipWith (-) maximums minimums
  let divisions = map (\xs -> head [(x `div` y) | x <- xs, y <- xs, evenlyDivides x y, x /= y]) rows
  let checksum2 = sum divisions
  print checksum
  print checksum2 

maxInRow xs = maximum xs
minInRow xs = minimum xs
evenlyDivides x y = x `mod` y == 0
