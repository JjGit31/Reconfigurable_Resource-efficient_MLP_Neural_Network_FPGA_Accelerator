
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2025 18:27:30
// Design Name: 
// Module Name: neuron_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ns
module neural_network_testbench;
  	parameter input_neurons=784,hidden_layer_neurons=64,output_neurons=10,total_weights=26432,total_bias=74;
    parameter weight_width=16,bias_width=32,total_neurons=input_neurons+output_neurons+hidden_layer_neurons;
    parameter int_width=5,fract_width=weight_width-int_width;
    //reg signed [weight_width-1:0] inputs [input_neurons-1:0];  
    reg clk,start;
  	//wire signed [weight_width-1:0] out;
  	wire done,CA,CB,CC,CD,CE,CF,CG;
  	wire [3:0] AN; 
    
  	neural_network nn1(CA,CB,CC,CD,CE,CF,CG,AN,clk,start,done);
  	
	initial begin
  		clk=0;
      //$monitor($time,"  Output : %b | Done=%b ", out, done); 
      $dumpfile("neurons.vcd");
      $dumpvars(0,neural_network_testbench);
      
    end
  
  	always #5 clk=~clk;
  	
  	initial begin
         //$readmemb("test_input.txt",inputs);
         $monitor("done= %d",done);
         #90 start=1;
         #500000 $finish;
      
      	
    end
endmodule

