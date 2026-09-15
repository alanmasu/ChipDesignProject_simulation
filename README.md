# Simulation & RTL Verification Lab — Synchronous FIFO

## Objective
Learn RTL simulation, self-checking testbenches, waveform debugging, corner-case testing, and intentional bug diagnosis using Cadence Xcelium.

## Files
- rtl/fifo.v — clean synthesizable DUT
- tb/fifo_tb.sv — self-checking SystemVerilog testbench
- bugs/ — intentionally faulty DUTs
- scripts/run.sh — batch simulation
- scripts/run_gui.sh — Xcelium GUI


## Prerequisites
Cadence Xcelium (`xrun`) available in PATH and a licensed installation.

## Run
From the lab root:
    ./scripts/run.sh
For GUI:
    ./scripts/run_gui.sh

## Expected clean result
The simulation should complete without `$error`/`$fatal` and print `SIMULATION COMPLETE`.

## Suggested student workflow
1. Read the interface/specification, not the implementation.
2. Run the clean design.
3. Inspect clk, reset, wr_en, rd_en, data_in, data_out, full, empty.
4. Explain why each test is present.
5. Run one buggy version at a time.
6. Find the first failing transaction.
7. Use the waveform to locate the first divergence from expected behavior.
8. Identify and fix the RTL bug.
9. Re-run the full regression.

## Important caveat
The DUT is intentionally compact for teaching. It is a synchronous FIFO with a registered read-data output; simultaneous read/write is defined so occupancy remains unchanged. Students should distinguish the course specification from implementation choices.
