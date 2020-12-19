#!/usr/bin/env python3
import sys
import os
from functools import cmp_to_key

if len(sys.argv) < 4:
    print("Wrong number of args")
    exit()


def check_exists(name):
    base_dir = "./outputs_gen"
    dir = base_dir + "/" + name
    if not os.path.exists(dir):
        print(f"Workload {name} does not exist")
        exit(1)

    return dir


def ensure_created(name):
    base_dir = "./outputs_gen"
    dir = base_dir + "/" + name
    if not os.path.exists(dir):
        try:
            os.mkdir(dir)
        except Exception as e:
            print("Something went wrong creating the new directory:" + e)
            exit()
    return dir


def compare_by_first(a, b):
    return a.split()[0] < b.split()[0]


wk_name1 = sys.argv[1]
wk_dir1 = check_exists(wk_name1)
wk_name2 = sys.argv[2]
wk_dir2 = check_exists(wk_name2)
wk_merged = sys.argv[3]
wk_dirm = ensure_created(wk_merged)

for fname in os.listdir(wk_dir1):
    f1 = open(wk_dir1 + "/" + fname, "r")
    f2 = open(wk_dir2 + "/" + fname, "r")
    fm = open(wk_dirm + "/" + fname, "w")

    lines = f1.readlines()
    lines.extend([i for i in f2.readlines() if "#" not in i])
    lines.sort(key=cmp_to_key(compare_by_first))

    fm.writelines(lines)

    f1.close()
    f2.close()
    fm.close()
