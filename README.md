# Recofigurable and Resource-efficient MLP Neural Network FPGA Hardware Accelerator

This Repo contains the Vivado project with TCL build script for a Recofigurable Resource-efficient MLP Neural Network FPGA Accelerator.

For testing and benchmark MNIST digit recognition model was trained and the parameters were converted to fixed-point format and were used in this MLP Neural Network.
The test inputs are also in fixed-point format and are hardcoded.

Steps to rebuild the vivado project:
1. Clone the repo onto your machine
2. In vivado tcl console write change the directory to the cloned project location on your local computer
3. Run "source scripts/nn_fpga_accelerator.tcl"
4. For functional check using the test input in simulation set the simulation time as 1ms and run the simulation
5. For FPGA deployment: Change the Project device to target FPGA and change the constraints file -> generate the bitstream -> connect the device
6. After uploading the bitstream switch the pin assigned to "start".

