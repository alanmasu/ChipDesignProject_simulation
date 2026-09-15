#!/bin/sh
xrun -64bit -sv -access +rwc -gui \
  ../rtl/fifo.v ../tb/fifo_tb.sv -top fifo_tb
