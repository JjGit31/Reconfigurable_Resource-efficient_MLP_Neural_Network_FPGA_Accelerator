
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2025 18:28:53
// Design Name: 
// Module Name: neural_network 
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



module neural_network(CA,CB,CC,CD,CE,CF,CG,AN,clk,start,done);
    parameter input_neurons=784,hidden_layer_neurons=64,output_neurons=10,total_weights=26432,total_bias=74;
    parameter weight_width=16,bias_width=32,total_neurons=input_neurons+output_neurons+hidden_layer_neurons;
    parameter int_width=5,fract_width=weight_width-int_width;
    parameter index_width=$clog2(output_neurons);
    localparam layer0=input_neurons,layer1=32,layer2=32,layer3=10,hidden_layers=2;
    localparam [31:0] layer [0:hidden_layers+1]= '{layer0,layer1,layer2,layer3} ;
    
    input clk,start;
    output reg done;
    output CA,CB,CC,CD,CE,CF,CG;
    output [3:0] AN;
    
    wire [index_width-1:0] pred_digit;
    reg signed [weight_width-1:0] out;
    reg start_max_finder;
    wire [6:0] disp;
    assign CA=disp[0];
    assign CB=disp[1];
    assign CC=disp[2];
    assign CD=disp[3];
    assign CE=disp[4];
    assign CF=disp[5];
    assign CG=disp[6];
    assign AN= (start_max_finder==1)? 4'b1110:4'b1111 ;
   
    reg [3:0] state;
    reg [$clog2(total_weights)-1:0] counter1;
    reg [$clog2(total_bias)-1:0] counter2;
    reg [$clog2(hidden_layers+2)-1:0] layer_counter,next_layer_counter;
    reg [31:0] in_counter1,in_counter2,next_in_counter1,next_in_counter2;
    reg [31:0] in_index;
    reg [15:0] hidden_neurons_done;
    reg hidden_neurons_add_bool;
    wire signed [weight_width-1:0] wout;
    reg signed [bias_width-1:0] sum;
    reg signed [2*weight_width-1:0] mul;
    reg signed [bias_width-1:0] next_sum1;
    reg signed [2*bias_width-1:0] next_sum2;
    
    wire signed [bias_width-1:0] bias;
    reg signed [weight_width-1:0] outputs [total_neurons-input_neurons-1:0];
    reg signed [weight_width-1:0] inputs [input_neurons-1:0];
    integer i;
    initial begin
    for(i=0;i<784;i=i+1) begin
        inputs[i] = 16'h0000;
    end
    inputs[179] = 16'h01C2; inputs[180] = 16'h12B3; inputs[181] = 16'h1838; inputs[182] = 16'h00A1;
    inputs[206] = 16'h0B6B; inputs[207] = 16'h1C1C; inputs[208] = 16'h1FC0; inputs[209] = 16'h1FC0;
    inputs[210] = 16'h0262; inputs[233] = 16'h0384; inputs[234] = 16'h1D7D; inputs[235] = 16'h1FE0;
    inputs[236] = 16'h1FC0; inputs[237] = 16'h1FC0; inputs[238] = 16'h14D5; inputs[239] = 16'h0242;
    inputs[261] = 16'h1212; inputs[262] = 16'h1FC0; inputs[263] = 16'h1FE0; inputs[264] = 16'h1FC0;
    inputs[265] = 16'h1FC0; inputs[266] = 16'h1FC0; inputs[267] = 16'h1DDE; inputs[268] = 16'h0E6E;
    inputs[269] = 16'h00C1; inputs[288] = 16'h03E4; inputs[289] = 16'h1E3E; inputs[290] = 16'h1FC0;
    inputs[291] = 16'h1A1A; inputs[292] = 16'h1737; inputs[293] = 16'h1FC0; inputs[294] = 16'h1FC0;
    inputs[295] = 16'h1FC0; inputs[296] = 16'h1CFD; inputs[297] = 16'h0303; inputs[316] = 16'h09EA;
    inputs[317] = 16'h1FE0; inputs[318] = 16'h1838; inputs[320] = 16'h0101; inputs[321] = 16'h0C4C;
    inputs[322] = 16'h1B7B; inputs[323] = 16'h1FE0; inputs[324] = 16'h2000; inputs[325] = 16'h1939;
    inputs[326] = 16'h0242; inputs[344] = 16'h0ACB; inputs[345] = 16'h1FC0; inputs[346] = 16'h0A0A;
    inputs[350] = 16'h16D7; inputs[351] = 16'h1FC0; inputs[352] = 16'h1FE0; inputs[353] = 16'h17F8;
    inputs[354] = 16'h0182; inputs[372] = 16'h15F6; inputs[373] = 16'h1FC0; inputs[374] = 16'h1373;
    inputs[378] = 16'h1D5D; inputs[379] = 16'h1FC0; inputs[380] = 16'h1FE0; inputs[381] = 16'h10F1;
    inputs[400] = 16'h0ACB; inputs[401] = 16'h1FC0; inputs[402] = 16'h1A1A; inputs[403] = 16'h0505;
    inputs[404] = 16'h0AAB; inputs[405] = 16'h14D5; inputs[406] = 16'h1F7F; inputs[407] = 16'h1DBE;
    inputs[408] = 16'h1FE0; inputs[409] = 16'h1D9E; inputs[410] = 16'h0545; inputs[428] = 16'h0242;
    inputs[429] = 16'h1DDE; inputs[430] = 16'h1FC0; inputs[431] = 16'h1FE0; inputs[432] = 16'h1FC0;
    inputs[433] = 16'h1FC0; inputs[434] = 16'h1737; inputs[435] = 16'h0485; inputs[436] = 16'h1B1B;
    inputs[437] = 16'h1FC0; inputs[438] = 16'h1313; inputs[457] = 16'h0889; inputs[458] = 16'h1E1E;
    inputs[459] = 16'h2000; inputs[460] = 16'h1FE0; inputs[461] = 16'h1232; inputs[462] = 16'h0101;
    inputs[464] = 16'h10D1; inputs[465] = 16'h1FE0; inputs[466] = 16'h1BFC; inputs[467] = 16'h0464;
    inputs[486] = 16'h0889; inputs[487] = 16'h13D4; inputs[488] = 16'h11D2; inputs[489] = 16'h0182;
    inputs[492] = 16'h0121; inputs[493] = 16'h15F6; inputs[494] = 16'h1FC0; inputs[495] = 16'h1434;
    inputs[521] = 16'h0B0B; inputs[522] = 16'h1FC0; inputs[523] = 16'h1C5C; inputs[524] = 16'h0242;
    inputs[549] = 16'h0040; inputs[550] = 16'h14D5; inputs[551] = 16'h1FC0; inputs[552] = 16'h0FD0;
    inputs[578] = 16'h0606; inputs[579] = 16'h1EBF; inputs[580] = 16'h1FC0; inputs[581] = 16'h04C5;
    inputs[607] = 16'h0E6E; inputs[608] = 16'h1FE0; inputs[609] = 16'h1596; inputs[610] = 16'h0121;
    inputs[635] = 16'h02A3; inputs[636] = 16'h1B5B; inputs[637] = 16'h1FE0; inputs[638] = 16'h05C6;
    inputs[664] = 16'h03C4; inputs[665] = 16'h1FE0; inputs[666] = 16'h14B5; inputs[693] = 16'h1757;
    inputs[694] = 16'h1E9F; inputs[695] = 16'h0545; inputs[721] = 16'h01C2; inputs[722] = 16'h1BFC;
    inputs[723] = 16'h09CA;

    end
    
    blk_mem_gen_0 weight_bram (
        .clka(clk),    
        .wea(1'b0),      
        .addra(counter1),  
        .dina(16'b0),    
        .douta(wout)  
    );
    
    blk_mem_gen_1 bias_bram (
        .clka(clk),    
        .wea(1'b0),      
        .addra(counter2),  
        .dina(32'b0),    
        .douta(bias)  
    );

    parameter s0=4'b0000, s1=4'b0001, s2=4'b0010, s3=4'b0011, s4=4'b0100, s5=4'b0101,s6=4'b0110,s7=4'b0111,s8=4'b1000;

    always @(posedge clk) begin
        case(state) 
            s0: begin 
                start_max_finder<=0;
                start_max_finder<=0;
                if(start) begin
                    state<=s1;
                    counter1<=0;
                    counter2<=0;
                    in_counter1<=0;
                    in_counter2<=0;
                    next_in_counter2<=1;
                    next_in_counter1<=1;
                    layer_counter<=0;
                    next_layer_counter<=0;
                end else begin
                    state<=s0;
                end
            end

            s1: begin
                state<=s2;
                counter1<=counter1+1;
            end

            s2: begin
                state<=s3;
                sum<=0;
                mul<=0;
                in_index<=0;
                counter1<=counter1+1;
                next_layer_counter<=layer_counter+1;
                if(layer_counter<2) begin
                    hidden_neurons_done<=0;
                end else begin
                    if(hidden_neurons_add_bool)
                        hidden_neurons_done<=layer[layer_counter-1]+hidden_neurons_done;
                end
            end

            s3: begin
                in_counter1<=in_counter1+1;
                next_in_counter1<=next_in_counter1+1;
                in_index<=next_in_counter1%layer[layer_counter];
                if(layer_counter==0) begin
                    mul<=$signed(wout)*$signed(inputs[in_index]);
                end else begin
                    mul<=$signed(wout)*$signed(outputs[in_index+hidden_neurons_done]);
                end
                sum<=sum+mul;

                if(next_in_counter1==layer[layer_counter])  begin
                    in_counter1<=0;
                    next_in_counter1<=1;
                    state<=s4;
                end else begin
                    state<=s3;
                    if(next_in_counter1+1!=layer[layer_counter])
                        counter1<=counter1+1;
                end
            end

            s4: begin
                state<=s5;
                sum<=sum+mul;
            end

            s5: begin
                state<=s6;
                next_sum2<=sum+bias;
            end

            s6: begin
                state<=s7;
                if(bias[bias_width-1] & sum[bias_width-1] & !next_sum2[bias_width-1]) begin
                    sum[bias_width-1]<=0;
                    sum[bias_width-2:0]<={(bias_width-1){1'b1}};
                end else if(!bias[bias_width-1] & !sum[bias_width-1] & next_sum2[bias_width-1]) begin
                    sum[bias_width-1]<=1;
                    sum[bias_width-2:0]<={(bias_width-1){1'b1}};
                end else begin
                    sum<=sum+bias;
                end
            end

            s7: begin
                if(sum>0) begin
                    if(| sum[(bias_width-1)-:int_width+1]) begin
                        out<={1'b0,{(weight_width-1){1'b1}}};
                        outputs[counter2]<={1'b0,{(weight_width-1){1'b1}}};
                    end else begin
                        out<=sum[(bias_width-1-int_width)-:weight_width];
                        outputs[counter2]<=sum[(bias_width-1-int_width)-:weight_width];
                    end
                end else begin
                    out<=0;
                    outputs[counter2]<=0;
                end

                $display("current_layer= %d | out[%d] = %d",layer_counter,in_counter2,out);
                counter2<=counter2+1;
                counter1<=counter1+1;
                in_counter2<=in_counter2+1;
                next_in_counter2<=next_in_counter2+1;

                if(next_in_counter2==layer[next_layer_counter]) begin
                    in_counter2<=0;
                    next_in_counter2<=1;
                    if(layer_counter==hidden_layers) begin
                        state<=s8;
                    end else begin
                        state<=s2;
                        layer_counter<=next_layer_counter;
                        hidden_neurons_add_bool<=1;
                    end
                end else begin
                    state<=s2;
                    hidden_neurons_add_bool<=0;
                end
            end

            s8: begin
                state<=s8;
                start_max_finder<=1;
            end

            default: begin
                state<=s0;
                start_max_finder<=0;
                
            end
        endcase
    end 

    max_finder mf1(pred_digit,outputs[(total_neurons-input_neurons-1)-:output_neurons],clk,start_max_finder,done);
    display disp1(disp,pred_digit);
    
endmodule   
module max_finder #(weight_width=16,output_neurons=10)(max_index,outputs,clk,start_max_finder,done);
    localparam index_width=$clog2(output_neurons);
    output [index_width-1:0] max_index;
    input signed [weight_width-1:0] outputs [output_neurons-1:0];
    input clk,start_max_finder;
    reg [index_width-1:0] temp_max_index;
    reg [index_width-1:0] i;
    output reg done;
    always @(posedge clk) begin
        if(start_max_finder) begin
            temp_max_index=0;
            for(i=0;i<output_neurons;i=i+1) begin
                if($signed(outputs[i])>$signed(outputs[temp_max_index]))
                    temp_max_index=i;    
            end 
            done<=1;
        end
    end
    
    assign max_index=temp_max_index;
endmodule
		
		
module display #(output_neurons=10)(disp,pred_digit);
    localparam index_width=$clog2(output_neurons);
    input [index_width-1:0] pred_digit;
    output reg [6:0] disp;
    
    always @(*) begin
    
        if(pred_digit==4'b0000)
            disp=7'b1000000;
        else if(pred_digit==4'b0001)
            disp=7'b1111001;
        else if(pred_digit==4'b0010)
            disp=7'b0100100;
        else if(pred_digit==4'b0011)
            disp=7'b0110000;
        else if(pred_digit==4'b0100)
            disp=7'b0011001;
        else if(pred_digit==4'b0101)
            disp=7'b0010010;
        else if(pred_digit==4'b0110)
            disp=7'b0000010;
        else if(pred_digit==4'b0111)
            disp=7'b1111000;
        else if(pred_digit==4'b1000)
            disp=7'b0000000;
        else if(pred_digit==4'b1001)
            disp=7'b0010000;
        else
            disp=7'b1111110;
        end
    endmodule

//for simulation brams :

//module weight_memory #(weight_width=16,total_weights=26432) (data_out,clk,index);

//    input [$clog2(total_weights)-1:0] index;
//    input clk;
//    output reg signed [weight_width-1:0] data_out;
//    reg signed [weight_width-1:0] weight_mem [total_weights-1:0];
//    reg [$clog2(total_weights)-1:0] addr;
//    initial begin
//        $readmemb("weight.mem",weight_mem); 
//    end
//    always @(posedge clk)begin
//        addr <= index;
//        data_out<=weight_mem[addr]; end

//endmodule

//module bias_memory #(bias_width=32,total_bias=74) (data_out,clk,index);

//    input [$clog2(total_bias)-1:0] index;
//    input clk;
//    output reg signed [bias_width-1:0] data_out;
//    reg signed [bias_width-1:0] bias_mem [total_bias-1:0];
//    reg [$clog2(total_bias)-1:0] addr;
//    initial begin
//        $readmemb("bias.mem",bias_mem); 
//    end
//    always @(posedge clk) begin
//        addr<=index;
//        data_out<=bias_mem[addr];
//    end
//endmodule

//module input_memory #(weight_width=16,input_neurons=784) (data_out,clk,index);

//    input [$clog2(input_neurons)-1:0] index;
//    input clk;
//    output reg signed [weight_width-1:0] data_out;
//    reg signed [weight_width-1:0] input_mem [input_neurons-1:0];
//    initial begin
//        $readmemb("test_input.mem",input_mem); 
//    end
//    always @(posedge clk)
//        data_out<=input_mem[index];

//endmodule

