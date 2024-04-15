
module lvt_bram (
    input wire wr0_addr, wr1_addr,
    input wire wr0_data, wr1_data,
    input wire rd0_addr,
    output wire rd0_data,
    input wire clk,
    input wire rst, // Reset input
    input wire wr0_en,
    input wire wr1_en,
    input wire rd0_en
);

// Wire Declarations
wire [31:0] temp_rd0;
wire [31:0] temp_rd1;
wire lvt_out;

// Instantiate the LVT module
LiveValueTable L1 (
    .clk(clk),
    .rst(rst),
    .write_addr_0(wr0_addr),
    .write_addr_1(wr1_addr),
    .write_enable_0(wr0_en),
    .write_enable_1(wr1_en),
    .read_addr(rd0_addr),
    .read_enable(rd0_en),
    .data_out(lvt_out)
);

// Instantiating BRAM modules
BRAM B0 (.clk(clk), .rst(rst), .w_en(wr0_en), .addr(wr0_addr), .data_in(wr0_data), .data_out(temp_rd0));
BRAM B1 (.clk(clk), .rst(rst), .w_en(wr1_en), .addr(wr1_addr), .data_in(wr1_data), .data_out(temp_rd1));

// Assign output data based on LVT selection
assign rd0_data = lvt_out ? temp_rd0 : temp_rd1;

endmodule

module LiveValueTable (
    input wire clk,
    input wire rst,
    input wire [6:0] write_addr_0,
    input wire [6:0] write_addr_1,
    input wire write_enable_0,
    input wire write_enable_1,
    input wire [6:0] read_addr,
    input wire read_enable,
    output reg lvt_out
);

parameter ADDR_WIDTH = 7; // Adjust this according to your memory address width

reg [1:0] lvt_memory [0:(2**ADDR_WIDTH)-1];

// Sequential block for LVT memory updates
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset LVT memory to 0
        for (int i = 0; i < (2**ADDR_WIDTH); i = i + 1) begin
            lvt_memory[i] <= 2'b00;
        end
    end else begin
        // Update LVT memory based on write operations
        if (write_enable_0) begin
            lvt_memory[write_addr_0] <= 2'b00; // Update entry for write_addr_0 to 0
        end
        if (write_enable_1) begin
            lvt_memory[write_addr_1] <= 2'b01; // Update entry for write_addr_1 to 1
        end
    end
end

// Sequential block for LVT output generation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        lvt_out <= 1'b0; // Reset output on reset
    end else begin
        if (read_enable) begin
            lvt_out <= (lvt_memory[read_addr] == 2'b00) ? 1'b0 : 1'b1; // Select data based on LVT entry
        end
    end
end

endmodule

module BRAM (
    input wire clk,
    input wire rst,
    input wire w_en,
    input wire [6:0] addr,
    input wire [4:0] data_in,
    output reg [6:0] data_out
);

// Internal memory
reg [6:0] ram [0:127];

// Sequential block for BRAM operations
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the memory on reset
        for (int i = 0; i < 128; i = i + 1) begin
            ram[i] <= 7'b0;
        end
    end else begin
        // Write operation
        if (w_en) begin
            ram[addr] <= data_in;
        end
        // Read operation
        data_out <= ram[addr];
    end
end

endmodule

