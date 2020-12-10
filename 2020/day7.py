regulations = open('day7.txt').readlines()

def parse_regulation(line):
    words = line.split(' ')
    color = ' '.join(words[:2])
    if words[4] == 'no':
        return (color, [])
    req_string = ' '.join(words[4:])
    reqs = req_string.split(', ') 
    return (color, [(' '.join(c.split(' ')[1:3]), int(c[0])) for c in reqs if c != ''])

def parse_regulations(regs):
    parsed = [parse_regulation(r) for r in regulations]
    reg_dict = {key: value for (key, value) in parsed}
    return reg_dict

def build_tree(color, colors, regs):
    dependencies = regs.get(color)
    # No more colors to fulfill
    if dependencies == []:
        return colors + [color]
    return colors + [color] + [c for cs in dependencies for c in build_tree(cs[0], [], regs)]

def traverse(color, regs):
    deps = regs.get(color)
    if len(deps) == 0:
        return 1
    nested_deps = [count * traverse(c, regs) for (c, count) in deps]
    return 1 + sum(nested_deps)

def solve_1(color, regs):
    parsed_regs = parse_regulations(regs)
    colors = [k for k in parsed_regs if k != color]
    bags = []
    for c in colors:
        tree = set(build_tree(c, [], parsed_regs))
        if color in tree:
            bags = bags + [c]
    return len(bags)

def solve_2(color, regs):
    parsed_regs = parse_regulations(regs)
    # Don't include the intial bag in the count
    return traverse(color, parsed_regs) - 1
    
    
print(solve_1('shiny gold', regulations))
print(solve_2('shiny gold', regulations))
        

