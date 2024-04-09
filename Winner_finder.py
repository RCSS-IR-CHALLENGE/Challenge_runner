# Copied from https://github.com/RCSS-IR/SS2D-Docker-Tournament-Runner/blob/main/winnerfinder.py


'''

import os
import sys

args = sys.argv
path = args[1]
send_result = False
if len(args) == 3 and args[2] == 'result':
    send_result = True

print('Path = ', path)
files = os.listdir(path)
logfile = ''
left_team_code = None
right_team_code = None
for f in files:
    if f.endswith('rcg'):
        print(f)
        logfile = f
    if f.endswith('log') and f.find('player1') != -1:
        if f.find('.l_') != -1:
            left_team_code = f.split('.l_')[1].split('player')[0][:-1]
        if f.find('.r_') != -1:
            right_team_code = f.split('.r_')[1].split('player')[0][:-1]
log = open(os.path.join(path, logfile), 'r').readlines()[-1]
line = log.strip()[:-1].split()
left_pen_result = 0
right_pen_result = 0
if len(line) == 6:
    left_result = int(line[4])
    right_result = int(line[5])
else:
    left_result = int(line[4])
    right_result = int(line[5])
    left_pen_result = int(line[6])
    right_pen_result = int(line[8])

if send_result:
    if len(line) == 6:
        print(f'{left_result} - {right_result}')
    else:
        print(f'{left_result} ({left_pen_result}) - {right_result} ({right_pen_result})')
else:
    if left_result > right_result:
        print(left_team_code)
    elif left_result > right_result:
        print(right_team_code)
    else:
        if left_pen_result > right_pen_result:
            print(left_team_code)
        else:
            print(right_team_code)
        
sys.exit(0)


'''





import os
import sys

# Get the path of the directory containing the .rcg file
path = os.path.dirname(os.path.realpath(__file__))

# Look for .rcg files in the directory
for file in os.listdir(path):
    if file.endswith('.rcg'):
        with open(os.path.join(path, file), 'r') as f:
            for line in f:
                if 'won' in line:
                    result = line.strip().split(' ')
                    winner = result[2]  # Extract the winner's name
                    print(f"{winner}")
                    break