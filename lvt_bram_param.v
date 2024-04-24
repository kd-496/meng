`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2024 01:35:07 AM
// Design Name: 
// Module Name: Lvt_bram
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


module lvt_bram #(
    parameter ADDR_WIDTH = 14,
    parameter DATA_WIDTH = 32
)(
    input wire [ADDR_WIDTH-1:0] wr0_addr, wr1_addr,
    input wire [DATA_WIDTH-1:0] wr0_data, wr1_data,
    input wire [ADDR_WIDTH-1:0] rd0_addr,
    output wire [DATA_WIDTH-1:0] rd0_data,
    input wire clk,
    input wire rst, // Reset input
    input wire wr0_en,
    input wire wr1_en,
    input wire rd0_en
);


// Wire Declarations
wire [DATA_WIDTH-1:0] temp_rd0;
wire [DATA_WIDTH-1:0] temp_rd1;
wire lvt_out;

// Instantiate the LVT module
LiveValueTable #(ADDR_WIDTH) L1 (
    .clk(clk),
    .rst(rst),
    .write_addr_0(wr0_addr),
    .write_addr_1(wr1_addr),
    .write_enable_0(wr0_en),
    .write_enable_1(wr1_en),
    .read_addr(rd0_addr),
    .read_enable(rd0_en),
    .lvt_out(lvt_out)
);

// Instantiating BRAM modules
BRAM #(ADDR_WIDTH, DATA_WIDTH) B0 (
    .clk(clk), .rst(rst), .w_en(wr0_en), .rd_en(rd0_en),
    .wr_addr(wr0_addr), .rd_addr(rd0_addr), .data_in(wr0_data), .data_out(temp_rd0)
);
BRAM #(ADDR_WIDTH, DATA_WIDTH) B1 (
    .clk(clk), .rst(rst), .w_en(wr1_en), .rd_en(rd0_en),
    .wr_addr(wr1_addr), .rd_addr(rd0_addr), .data_in(wr1_data), .data_out(temp_rd1)
);

// Assign output data based on LVT selection
assign rd0_data = lvt_out ? temp_rd1 : temp_rd0;

endmodule

module LiveValueTable #(parameter ADDR_WIDTH = 7) (
    input wire clk,
    input wire rst,
    input wire [ADDR_WIDTH-1:0] write_addr_0,
    input wire [ADDR_WIDTH-1:0] write_addr_1,
    input wire write_enable_0,
    input wire write_enable_1,
    input wire [ADDR_WIDTH-1:0] read_addr,
    input wire read_enable,
    output reg lvt_out
);

reg [1:0] lvt_memory [0:(2**ADDR_WIDTH)-1];
integer i;

// Handling reset and updates
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i=0; i<(2**ADDR_WIDTH) ;i = i + 1) begin
            lvt_memory[i] <= 2'b00;
        end
    end else begin
        if (write_enable_0)begin
         lvt_memory[write_addr_0] <= 2'b00;
         end
        if (write_enable_1) begin 
        lvt_memory[write_addr_1] <= 2'b01;
        end
    end
end

// Update output based on the LVT state
always @(posedge clk or posedge rst) begin
    if (rst) begin
        lvt_out <= 0;
    end else if (read_enable) begin
        lvt_out <= lvt_memory[read_addr][0];
    end
end

endmodule

module BRAM #(parameter ADDR_WIDTH = 7, parameter DATA_WIDTH = 32) (
    input wire clk,
    input wire rst,
    input wire w_en,
    input wire rd_en,
    input wire [ADDR_WIDTH-1:0] wr_addr,
    input wire [ADDR_WIDTH-1:0] rd_addr,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out
);

// Internal memory
reg [ADDR_WIDTH-1:0] ram [0:(2**ADDR_WIDTH)-1];
integer i;

// Memory operations
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i<(2**ADDR_WIDTH);i = i+1) begin
            ram[i] <= 0;
        end
    end else begin
        if (w_en) begin 
        ram[wr_addr] <= data_in;
        end
        else if (rd_en) begin
         data_out <= ram[rd_addr];
         end
    end
