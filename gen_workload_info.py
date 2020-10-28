#!/usr/bin/env python3
import sys
import os


def ensure_created(dir):
    if not os.path.exists(dir):
        try:
            os.mkdir(dir)
        except Exception as e:
            print("Something went wrong creating the new directory:" + e)
            exit()


out_dir = "./outputs_gen_info"
ensure_created(out_dir)
in_dir = "./outputs_gen"

if (len(sys.argv) != 2):
    print("Usage: gen_workload_info.py workloadname")
    exit()

wk_name = sys.argv[1]
wk_in_dir = in_dir+"/"+wk_name
if not os.path.exists(wk_in_dir):
    print(f"Workload {wk_name} not found. Aborting.")
    exit()

wk_out_dir = out_dir+"/"+wk_name
ensure_created(wk_out_dir)

wk_file_names = os.listdir(wk_in_dir)

for wk_file_name in wk_file_names:
    inf_dir = wk_in_dir+"/"+wk_file_name
    otf_dir = wk_out_dir+"/"+wk_file_name
    with open(inf_dir, "r") as inf, open(otf_dir, "w") as outf:
        while True:  # simultaneous read and write, dont need to keep all input in memory
            line = inf.readline()
            if not line:
                break
            if "#" in line:
                continue
            times = line.split()
            nbursts = len(times)//2
            cpu_time = sum([float(i) for i in times[0:-1:2]])
            io_time = sum([float(i) for i in times[1:-1:2]])
            outf.write(f"{nbursts} {cpu_time} {io_time}\n")
