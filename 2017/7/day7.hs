import qualified Debug.Trace as DT
import Data.Maybe
import Data.List
parse :: String -> [Program]
parse input = 
  map parseLine $ map words $ lines input

data Program = Program {
  name :: String
  , weight :: Int
  , children ::[String]
  } deriving (Show)

data Tree a = 
  Leaf a
  | Branch [ Tree a ]
  deriving (Show)

parseLine :: [String] -> Program
parseLine (x:y:z:xs) = 
  Program
    x 
    ((read::String -> Int) . tail $ init y)
    (map (\x -> if elem ',' x then init x else x)  xs)
parseLine (x:y:xs) =
  Program
    x 
    ((read::String -> Int) . tail $ init y)
    []


bottom (p:ps) allPs
  | children p == [] = bottom ps allPs
  | otherwise = if result == True then bottom ps allPs else p
  where
    result = any (\x -> x == True) 
      $ map (\x -> elem (name p) (children x)) allPs

buildTree :: Program -> [(String, Program)] -> Tree Int
buildTree p lookupTable  
  | children p == [] = Leaf $ weight p
  | otherwise = Branch [Leaf $ weight p, Branch $ map (\c -> buildTree (getChild c) lookupTable) $ children p ]
  where
    getChild name = fromJust $ lookup name lookupTable

foldTree tree = 
  

main = do
  raw <- readFile "test.txt"
  let input = parse raw
  let b = bottom input input
  let lookupTable = map (\x -> ((name x), x)) input
  let tree = buildTree b lookupTable
  let folded = foldTree tree
  print folded
