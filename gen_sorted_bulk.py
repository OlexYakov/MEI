#!/usr/bin/env python3

import sys
import os
from sys import argv

if len(sys.argv) != 7:
    print("Usage: gen.py wkname nproc arrival_start arrival_step cpu_btime cpu_step")
    exit()

out_dir = "./outputs_gen"

wkname = sys.argv[1]
nproc = int(sys.argv[2])
astart = float(sys.argv[3])
astep = float(sys.argv[4])
cpu_btime = float(sys.argv[5])
cpu_step = float(sys.argv[6])

wk_path = out_dir+"/"+wkname
if not os.path.exists(wk_path):
    os.mkdir(wk_path)

with open(wk_path+"/1.csv", "w") as f:
    f.write("#atime cpu_btime")
    for i in range(int(nproc)):
        f.write(f"\n{astart} {cpu_btime}")
        astart = astart + astep
        cpu_btime += cpu_step
