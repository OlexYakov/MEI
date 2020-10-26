#!/bin/bash
out_dir_generator="OutputsGen"
out_dir_simulator="OutputsSim"

#Round Robin Quantum Defautlt
quantum=100

if [ $# != 7 ]
then
    echo "Wrong amount of parameter passed"
else
    #Folder for Generator
    mkdir "Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7"
    mv "Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7" "$out_dir_generator"
    #Folder for Simulator
    mkdir "Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7"
    mv "Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7" "$out_dir_simulator"
    for i in {1..5}; do
        echo $i
        #Generator File
        python3 gen_workload.py $1 $2 $3 $4 $5 $6 $7 $i > "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7Seed$i.txt" 
        #FCFS
        < "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7Seed$i.txt" python3 simulator.py --cpu-scheduler fcfs > "$out_dir_simulator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/FCFSSeed$i.txt"
        #RR
        < "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7Seed$i.txt" python3 simulator.py --cpu-scheduler rr --quantum $quantum > "$out_dir_simulator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/RRSeed$i.txt"
        #SJF
        < "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7Seed$i.txt" python3 simulator.py --cpu-scheduler sjf > "$out_dir_simulator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/SJFSeed$i.txt"
        #SRTF
        < "$out_dir_generator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7Seed$i.txt" python3 simulator.py --cpu-scheduler srtf > "$out_dir_simulator/Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7/SRTFSeed$i.txt"
    done
fi
