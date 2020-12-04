KEYS = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid', 'cid']
passports = open('day4.txt').read().split('\n\n')

def parse(entry):
    lines = entry.split('\n')
    entries = [f.split(':') for l in lines for f in l.split(' ') if f]
    passport = {e[0]: e[1] for e in entries}
    return passport

def is_valid_year(value, min_yr, max_yr):
    return value.isdigit() and int(value) >= min_yr and int(value) <= max_yr

def is_valid_height(value):
    units = value[-2:]
    if units != 'in' and units != 'cm':
        return False
    val = value[:-2]
    if units == 'in':
        return val.isdigit() and int(val) >= 59 and int(val) <= 76
    # cm
    return val.isdigit() and int(val) >= 150 and int(val) <= 193

def is_valid_hair_color(color):
    return color[0] == '#' and all([c in '0123456789abcdef' for c in color[1:]])

def is_valid_eye_color(color):
    return color in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']

def is_valid_pid(pid):
    return all([c in '0123456789' for c in pid]) and len(pid) == 9



# Validationl logic for part 2
def validate(passport):
    required_keys = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
    has_all_keys = all([passport.get(k) for k in required_keys])
    if not has_all_keys:
        return False
    validations = [
        is_valid_year(passport.get('byr'), 1920, 2002),
        is_valid_year(passport.get('iyr'), 2010, 2020),
        is_valid_year(passport.get('eyr'), 2020, 2030),
        is_valid_height(passport.get('hgt')),
        is_valid_hair_color(passport.get('hcl')),
        is_valid_eye_color(passport.get('ecl')),
        is_valid_pid(passport.get('pid'))]
    return all(validations)


def solve_1():
    required_keys = [k for k in KEYS if k != 'cid']
    parsed_passports = [parse(entry) for entry in passports]
    valid = [all([p.get(k) for k in required_keys]) for p in parsed_passports]
    return len([v for v in valid if v])

def solve_2():
    parsed_passports = [parse(entry) for entry in passports]
    valid = [validate(p) for p in parsed_passports]
    return len([v for v in valid if v])

print(solve_1())
print(solve_2())



