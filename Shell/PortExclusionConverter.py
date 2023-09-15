from sys import stdin
import itertools

def string_range_to_list(x):
    result = []
    for part in x.split(','):
        if '-' in part:
            a, b = part.split('-')
            a, b = int(a), int(b)
            result.extend(range(a, b + 1))
        else:
            a = int(part)
            result.append(a)
    return result

input_data = """
1-9
1000-1010
2000-2010
5000-5010
7000-7010

3389
33899
22,21
50
500
4500
22220-22240
25550-25570
5555
10086
1194
"""

def formatter(start, end, step):
    # return '{}-{}:{}'.format(start, end, step)
    return '{}-{}'.format(start, end)
    # return '{}-{}:{}'.format(start, end + step, step)

def helper(lst):
    if len(lst) == 1:
        return str(lst[0]), []
    if len(lst) == 2:
        return ','.join(map(str,lst)), []

    step = lst[1] - lst[0]
    for i,x,y in zip(itertools.count(1), lst[1:], lst[2:]):
        if y-x != step:
            if i > 1:
                return formatter(lst[0], lst[i], step), lst[i+1:]
            else:
                return str(lst[0]), lst[1:]
    return formatter(lst[0], lst[-1], step), []

def re_range(lst):
    result = []
    while lst:
        partial,lst = helper(lst)
        result.append(partial)
    return ','.join(result)

def _entry():
    exclusion_list = []
    for line in input_data.splitlines(): 
        if line.strip() == '':
            continue
        exclusion_list.extend(string_range_to_list(line))
    
    # print(exclusion_list)
    ports = list(range(1, 65536))
    for port in exclusion_list:
        ports.remove(port)
    
    print(re_range(ports))
    pass

if __name__ == "__main__":
    _entry()