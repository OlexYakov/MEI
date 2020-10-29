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


def gen_info(wk_name):
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
            outf.write("atime nbursts cpu_time io_time")
            while True:  # simultaneous read and write, dont need to keep all input in memory
                line = inf.readline()
                if not line:
                    break
                if "#" in line:
                    continue
                times = line.split()
                atime = times[0]
                nbursts = len(times)//2 - 1
                cpu_time = sum([float(i) for i in times[1:len(times):2]])
                io_time = sum([float(i) for i in times[2:len(times):2]])
                outf.write(f"\n{atime} {nbursts} {cpu_time} {io_time}")


out_dir = "./outputs_gen_info"
ensure_created(out_dir)
in_dir = "./outputs_gen"

if "-full" in sys.argv:
    wks = os.listdir(in_dir)
    for wk_name in wks:
        gen_info(wk_name)
else:
    if (len(sys.argv) != 2):
        print("Usage: gen_workload_info.py workloadname or -full")
        exit()
    wk_name = sys.argv[1]
    gen_info(wk_name)
