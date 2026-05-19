# AXI3-VIP-Verification-Intellectual-Property-
AXI3 Verification IP (VIP) developed using SystemVerilog and UVM for verifying AXI3 compliant designs. Supports read/write transactions, burst transfers, outstanding and out-of-order transactions, protocol checking, functional coverage, assertions, scoreboard validation, and reusable master/slave agents.
AXI3 VIP – Verification IP for AMBA AXI3 Protocol

A configurable and reusable AXI3 Verification IP (VIP) developed using SystemVerilog and UVM methodology for verifying AXI3-compliant master and slave designs.

This project supports generation, driving, monitoring, and checking of AXI3 transactions with protocol compliance validation and functional coverage.

Features:
-> Supports AMBA AXI3 Protocol
-> UVM-based verification environment
-> Configurable AXI3 Master and Slave Agents
-> Separate Read and Write Channel Verification
-> Burst Transfer Support
-> FIXED burst
-> INCR burst
-> WRAP burst
Supports Multiple Burst Lengths and Sizes
Randomized Transaction Generation
Functional Coverage Collection
Scoreboard for Data Checking
Protocol Assertions and Error Detection
Reusable and Scalable Architecture
Easy Integration with DUTs

=> AXI3 Channels Covered
Write Address Channel (AW)
Write Data Channel (W)
Write Response Channel (B)
Read Address Channel (AR)
Read Data Channel (R)

Verification Components
AXI3 Transaction Class
AXI3 Driver
AXI3 Monitor
AXI3 Sequencer
AXI3 Agent
AXI3 Scoreboard
AXI3 Coverage Collector
AXI3 Environment
AXI3 Testcases
Test Scenarios
Single Write Transfer
Single Read Transfer
Burst Write Transactions
Burst Read Transactions
Random Traffic Generation
Back-to-Back Transfers
Reset Verification
Invalid Address Handling
Protocol Violation Checks
Tools & Technologies
SystemVerilog
UVM

QuestaSim / VCS / Xcelium
Git & GitHub
Folder Structure
AXI3_VIP/
│── rtl/
│── tb/
│   ├── agent/
│   ├── driver/
│   ├── monitor/
│   ├── sequencer/
│   ├── sequences/
│   ├── scoreboard/
│   ├── coverage/
│   ├── env/
│   ├── tests/
│── sim/
│── docs/
│── README.md

How to Run

Compile
vlog *.sv

Simulate
vsim top
run -all

Applications:
Verification of AXI3-based SoCs
Memory Controller Verification
DMA Verification
Processor Subsystem Verification
Interconnect Verification
Future Enhancements
AXI4 Support
AXI-Lite Support
Performance Metrics Collection
Advanced Protocol Assertions
Register Model Integration (RAL)
