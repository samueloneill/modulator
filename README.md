# Basys 3 Data Generator and Modulator
My first foray into VHDL, this project is a digital modulator designed for a Basys 3 FPGA dev board. The user can select data to be generated using switches on the board, which is then modulated. Varying degrees of error can be added to the transmitted data to simulate noise and other propagation effects within a communication system. This is then processed and displayed to enable the user to verify that the received data is aligned with the initially generated data.

The project provides a choice of two modulation schemes 'A' and 'B'.
Please note that this was a paired university project, however most work is mine. The only contributions from my partner are those related to modulation scheme 'A' (3 files). The rest of the work is my own.

# Design Record
A design record is also published here as a detailed explanation of the project.

# What I learned
- Introduction to programming an FPGA in VHDL
- Use of Vivado for writing, testing and debugging code
- Using testbenches
- Developing a pseudo-random number generator
- Modulating and demodulating data
