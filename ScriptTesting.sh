#!/bin/bash
out_dir_generator="OutputsGen"
out_dir_simulator="OutputsSim"

#Round Robin Quantum Defautlt
quantum=100


if [ $# != 7 ]
then
    echo "Wrong amount of parameter passed"
else
    #Generator File
    python3 gen_workload.py $1 $2 $3 $4 $5 $6 $7> "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7.txt" 
    #Folder for Simulator
    mkdir "Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7"
    mv "Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7" "$out_dir_simulator"
    #FCFS
    < "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7.txt" python3 simulator.py --cpu-scheduler fcfs > "$out_dir_simulator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/FCFS.txt"
    #RR
    < "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7.txt" python3 simulator.py --cpu-scheduler rr --quantum $quantum > "$out_dir_simulator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/RR.txt"
    #SJF
    < "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7.txt" python3 simulator.py --cpu-scheduler sjf > "$out_dir_simulator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/SJF.txt"
    #SRTF
    < "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7.txt" python3 simulator.py --cpu-scheduler srtf > "$out_dir_simulator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/SRTF.txt"
fi
