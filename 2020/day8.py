boot_code = open('day8.txt').readlines()

def parse_instruction(instr_str):
    op, arg = instr_str.split(' ')
    return (op, int(arg))

def run(instrs):
    acc = 0
    visited = {}
    current_position = 0
    while True:
        op, arg = instrs[current_position]
        # Infinite loop detected
        if visited.get(current_position):
            break
        # End of program
        # Execute final instruction and then break!
        if current_position == len(instrs) - 1:
            # Don't update current position as we neeed to know that
            # the program terminated successfully
            (_, acc) = execute((op, arg), current_position, acc)
            break
        # Continue with the program
        visited[current_position] = True
        current_position, acc = execute((op, arg), current_position, acc)
    return acc, current_position

def execute(instr, current_position, acc):
    op, arg = instr
    if op == "nop":
        current_position = current_position + 1
    elif op == "acc":
        acc = acc + arg
        current_position = current_position + 1
    else:
        current_position = current_position + arg
    return current_position, acc

def solve_1():
    instrs = [parse_instruction(i) for i in boot_code]
    acc, current_position = run(instrs)
    return acc

def solve_2():
    instrs = [parse_instruction(i) for i in boot_code]
    nop_pos = [i for i, instr in enumerate(instrs) if instr[0] == "nop"]
    jmp_pos = [i for i, instr in enumerate(instrs) if instr[0] == "jmp"]
    
    # Nop change attempts
    for index in nop_pos:
        changed_instr = instrs[:index] + [("jmp", instrs[index][1])] + instrs[index+1:]
        acc, current_position = run(changed_instr)
        if current_position == len(instrs) - 1:
            return acc

    # Jmp change
    for index in jmp_pos:
        changed_instr = instrs[:index] + [("nop", instrs[index][1])] + instrs[index+1:]
        acc, current_position = run(changed_instr)
        if current_position == len(instrs) - 1:
            return acc


print(solve_1())
print(solve_2())


