def parse_input(input_string):
    floor = 0
    for i in input_string:
        if i == '(':
            floor = floor + 1
        if i == ')':
            floor = floor - 1
    return floor

def first_pos_enter_floor(floor, input_string):
    f = 0
    for i in range(len(input_string)):
        if input_string[i] == '(':
            f = f + 1
        if input_string[i] == ')':
            f = f - 1
        if f == floor:
            return i + 1


with open('puzzle1input.txt') as f:
    floor = parse_input(f.read())
    print floor
    pos = first_pos_enter_floor(-1, ')')
    print pos
