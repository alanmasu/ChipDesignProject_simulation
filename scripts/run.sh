#!/bin/sh
set -e
mkdir -p sim
xrun -64bit -sv -access +rwc -timescale 1ns/1ps \
  ../rtl/fifo.v ../tb/fifo_tb.sv \
  -top fifo_tb \
  -l sim/xrun.log
