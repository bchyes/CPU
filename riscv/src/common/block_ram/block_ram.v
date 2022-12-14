/***************************************************************************************************
*
*  Copyright (c) 2012, Brian Bennett
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification, are permitted
*  provided that the following conditions are met:
*
*  1. Redistributions of source code must retain the above copyright notice, this list of conditions
*     and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright notice, this list of
*     conditions and the following disclaimer in the documentation and/or other materials provided
*     with the distribution.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
*  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
*  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
*  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
*  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
*  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
*  WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
*  Various generic, inferred block ram descriptors.
***************************************************************************************************/

// Dual port RAM with synchronous read.  Modified version of listing 12.4 in "FPGA Prototyping by
// Verilog Examples," itself a modified version of XST 8.11 v_rams_11.
module dual_port_ram_sync
#(
  parameter ADDR_WIDTH = 6,
  parameter DATA_WIDTH = 8
)
(
  input  wire                  clk,
  input  wire                  we,
  input  wire [ADDR_WIDTH-1:0] addr_a,
  input  wire [ADDR_WIDTH-1:0] addr_b,
  input  wire [DATA_WIDTH-1:0] din_a,
  output wire [DATA_WIDTH-1:0] dout_a,
  output wire [DATA_WIDTH-1:0] dout_b
);

reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
reg [ADDR_WIDTH-1:0] q_addr_a;
reg [ADDR_WIDTH-1:0] q_addr_b;

always @(posedge clk)
  begin
    if (we)
        ram[addr_a] <= din_a;
    q_addr_a <= addr_a;
    q_addr_b <= addr_b;
  end

assign dout_a = ram[q_addr_a];
assign dout_b = ram[q_addr_b];

endmodule

// Single port RAM with synchronous read.
module single_port_ram_sync
#(
  parameter ADDR_WIDTH = 6,
  parameter DATA_WIDTH = 8
)
(
  input  wire                  clk,
  input  wire                  we,
  input  wire [ADDR_WIDTH-1:0] addr_a,
  input  wire [DATA_WIDTH-1:0] din_a,
  output wire [DATA_WIDTH-1:0] dout_a
);

reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
reg [ADDR_WIDTH-1:0] q_addr_a;

wire [DATA_WIDTH-1:0] debug_ram;
wire [DATA_WIDTH-1:0] debug_ram1;
wire [DATA_WIDTH-1:0] debug_ram2;
wire [DATA_WIDTH-1:0] debug_ram3;
wire [DATA_WIDTH-1:0] debug_ram4;
wire [DATA_WIDTH-1:0] debug_ram5;
wire [DATA_WIDTH-1:0] debug_ram6;
wire [DATA_WIDTH-1:0] debug_ram7;
wire [DATA_WIDTH-1:0] debug_ram8;
wire [DATA_WIDTH-1:0] debug_ram9;
wire [DATA_WIDTH-1:0] debug_ram10;
wire [DATA_WIDTH-1:0] debug_ram11;
wire [DATA_WIDTH-1:0] debug_ram12;
wire [DATA_WIDTH-1:0] debug_ram13;
wire [DATA_WIDTH-1:0] debug_ram14;
wire [DATA_WIDTH-1:0] debug_ram15;
wire [DATA_WIDTH-1:0] debug_ram16;
wire [DATA_WIDTH-1:0] debug_ram17;
assign debug_ram = ram[131068];
assign debug_ram1 = ram[130876];
assign debug_ram2 = ram[130908];
assign debug_ram3 = ram[130904];
assign debug_ram4 = ram[130900];
assign debug_ram5 = ram[130896];
assign debug_ram6 = ram[196612];
`define basic_add 4996
assign debug_ram7 = ram[`basic_add];
assign debug_ram8 = ram[`basic_add+4];
assign debug_ram9 = ram[`basic_add+8];
assign debug_ram10 = ram[`basic_add+12];
assign debug_ram11 = ram[`basic_add+16];
assign debug_ram12 = ram[`basic_add+20];
assign debug_ram13 = ram[`basic_add+24];
assign debug_ram14 = ram[`basic_add+28];
assign debug_ram15 = ram[`basic_add+32];
assign debug_ram16 = ram[`basic_add+36];
assign debug_ram17 = ram[`basic_add+40];

always @(posedge clk)
  begin
    if (we)
        ram[addr_a] <= din_a;
    q_addr_a <= addr_a;
  end

assign dout_a = ram[q_addr_a];

// initialize ram content (for simulation)
integer i;
initial begin
  for (i=0;i<2**ADDR_WIDTH;i=i+1) begin
    ram[i] = 0;
  end
  $readmemh("test.data", ram); // add test.data to vivado project or specify a valid file path
end

endmodule

