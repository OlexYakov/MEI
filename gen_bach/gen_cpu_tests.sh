#!/bin/bash

gen="./ScriptTesting.sh"

# $gen cpu_tests_a1 1000 10 10 0.1 0.2 1 2
# $gen cpu_tests_a2 1000 10 10 0.1 1 1 2
# $gen cpu_tests_b1 1000 10 10 1 2 1 2
# $gen cpu_tests_b2 1000 10 10 1 10 1 2
$gen cpu_tests_b3 1000 10 10 1 100 1 2
$gen cpu_tests_c 1000 10 10 10 20 1 2