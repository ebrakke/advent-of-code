policies = open('day2.txt').readlines()
# policies = ['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc']

def parse_password(policy):
    freq, letter, pwd = policy.split(' ')
    low, high = freq.split('-')
    return ((int(low), int(high)), letter[:-1], pwd)

# Takes in a parsed policy
def valid(policy):
    (low, high), letter, pwd = policy
    count = pwd.count(letter)
    return count >= low and count <= high

def valid_2(policy):
    (pos1, pos2), letter, pwd = policy
    match1 = pwd[pos1-1] == letter
    match2 = pwd[pos2-1] == letter
    return (match1 or match2) and not (match1 and match2)

def solve1(policies):
    parsed = [parse_password(pol) for pol in policies]
    valid_count = 0
    for policy in parsed:
        if valid(policy):
            valid_count = valid_count + 1
    return valid_count

def solve2(policies):
    parsed = [parse_password(pol) for pol in policies]
    valid_count = 0
    for policy in parsed:
        if valid_2(policy):
            valid_count = valid_count + 1
    return valid_count

print(solve1(policies))
print(solve2(policies))
