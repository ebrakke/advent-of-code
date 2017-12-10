import Data.List
import Debug.Trace
import Data.Maybe

type Instruction = (String, String, Int, String, Int -> Int -> Bool, Int)

parseLine :: [String] -> Instruction
parseLine (r1:cmd:v1:_:r2:">":v2:xs) = (r1, cmd, read v1, r2, (>), read v2)
parseLine (r1:cmd:v1:_:r2:"<":v2:xs) = (r1, cmd, read v1, r2, (<), read v2)
parseLine (r1:cmd:v1:_:r2:"==":v2:xs) = (r1, cmd, read v1, r2, (==), read v2)
parseLine (r1:cmd:v1:_:r2:"!=":v2:xs) = (r1, cmd, read v1, r2, (/=), read v2)
parseLine (r1:cmd:v1:_:r2:">=":v2:xs) = (r1, cmd, read v1, r2, (>=), read v2)
parseLine (r1:cmd:v1:_:r2:"<=":v2:xs) = (r1, cmd, read v1, r2, (<=), read v2)

parseInput text = map words $ lines text

runInstruction :: Instruction -> (Int, [(String, Int)]) -> (Int, [(String, Int)])
runInstruction (r1, cmd, v1, r2, cond, v2) (m, registers)
  | cmd == "inc" = (m', updatedRegisters (+))
  | otherwise = (m', updatedRegisters (-))
  where 
    reg2Val = fromJust $ lookup r2 registers
    update cmd (r,v) = if (r == r1 && cond reg2Val v2) then (r, cmd v v1) else (r, v)
    updatedRegisters cmd = map (update cmd) registers
    m' = foldr (\(r,v) acc -> max acc v) m registers
    
runInstructions :: [Instruction] -> (Int, [(String, Int)])-> (Int, [(String, Int)])
runInstructions (i:ins) (m, registers)
  | null ins = updated
  | otherwise = runInstructions ins updated
  where
    updated = runInstruction i (m, registers)

initRegisters :: [Instruction] -> [(String, Int)]
initRegisters xs = 
  map (\x-> (x, 0)) $ 
    nub $ 
    foldr (\(r1,_,_,r2,_,_) acc -> r1:r2:acc) [] xs

   
main = do
  raw <- readFile "input.txt"
  let commands = map parseLine $ parseInput raw 
  let registers = initRegisters commands
  let (m, final) = runInstructions commands (0, registers)
  let max = foldr1 (\(r1,v1) (r2,v2) -> if (v1 > v2) then (r1,v1) else (r2, v2)) final
  print m
