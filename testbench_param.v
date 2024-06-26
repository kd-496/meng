`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 05:48:33 PM
// Design Name: 
// Module Name: lvt_testbench
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


module tb_lvt_bram#(
    parameter ADDR_WIDTH = 14,
    parameter DATA_WIDTH = 32
);

    // Parameters
   // parameter CLK_PERIOD = 10; // Clock period in time units
    
    // Signals
    reg clk;
    reg rst;
    reg [ADDR_WIDTH-1:0] wr0_addr, wr1_addr,rd0_addr;
    reg [DATA_WIDTH-1:0] wr0_data, wr1_data;
    reg wr0_en; 
    reg wr1_en;
    reg rd0_en;
    wire [DATA_WIDTH-1:0] rd0_data;
    reg [5:0] test_cases_passed;
    
    // Instantiate the DUT
    lvt_bram DUT (
        .wr0_addr(wr0_addr),
        .wr1_addr(wr1_addr),
        .wr0_data(wr0_data),
        .wr1_data(wr1_data),
        .rd0_addr(rd0_addr),
        .rd0_data(rd0_data),
        .clk(clk),
        .rst(rst),
        .wr0_en(wr0_en),
        .wr1_en(wr1_en),
        .rd0_en(rd0_en)
    );
    
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

  
    // Initializations
    initial begin
        rst <= 1;
        wr0_addr <= 0;
        wr1_addr <= 0;
        wr0_data <= 0;
        wr1_data <= 0;
        wr0_en <= 0;
        wr1_en <= 0;
        rd0_addr <= 0;
        rd0_en <= 0;
        test_cases_passed <= 0;
        
        // Wait for a few clock cycles after reset
        #15;
        
        // Release reset
        rst <= 0;
        #20;
        // Test case 1: Write data to wr0_addr, wr1_addr and read from rd0_addr
        wr0_addr <= 10;
        wr0_data <= 5;
        wr0_en <= 1;
        #10;
        wr0_en <= 0;
        #10;
        
        wr1_addr <= 20;
        wr1_data <= 10;
        wr1_en <= 1;
        #10;
        wr1_en <= 0;
        #10;
        
        rd0_addr <= 10;
        rd0_en <= 1;
        #10;
        rd0_en <= 0;
        
        // Check expected vs actual results for test case 1
        if (rd0_data === 5)
            test_cases_passed = test_cases_passed + 1;
        if (rd0_data === 5)
            $display("Test case 1 passed");
        #10;
        
        // Test case 2: Write data to wr0_addr, wr1_addr and read from rd0_addr with different addresses
        wr0_addr <= 30;
        wr0_data <= 15;
        wr0_en <= 1;
        #10;
        wr0_en <= 0;
        #10;
        
        wr1_addr <= 40;
        wr1_data <= 20;
        wr1_en <= 1;
        #10;
        wr1_en <= 0;
        #10;
        
        rd0_addr <= 20;
        rd0_en <= 1;
        #10;
        rd0_en <= 0;
        
        // Check expected vs actual results for test case 2
        if (rd0_data === 15)
            test_cases_passed = test_cases_passed + 1;
        if (rd0_data === 15)
            $display("Test case 2 passed");
       //     $display("Test case 2 passed");}
        #50;
        // Test case 3: Only read from rd0_addr without any prior write operations
        rd0_addr <= 5;
        rd0_en <= 1;
        #10;
        rd0_en <= 0;
        
        // Check expected vs actual results for test case 3 (should be 0, as no write operations were performed)
        if (rd0_data === 0)
            test_cases_passed = test_cases_passed + 1;
        if (rd0_data === 0)
            $display("Test case 3 passed");
         #10;
        
        // Test case 4: Write to same wr0_addr and wr1_addr, then read from same rd0_addr 
        wr0_addr <= 50;
        wr0_data <= 25;
        wr0_en <= 1;
        #10;
        wr0_en <= 0;
        #10;
        wr1_addr <= 50;
        wr1_data <= 30;
        wr1_en <= 1;
        #10;
        wr1_en <= 0;
        #10;
        
        rd0_addr <= 50;
        rd0_en <= 1;
        #10;
        rd0_en <= 0;
        
        // Check expected vs actual results for test case 4
        if (rd0_data === 30)
            test_cases_passed = test_cases_passed + 1;
        if (rd0_data === 30)
          $display("Test case 4 passed");
         #10;
        
        // Test case 5: Write to wr0_addr, wr1_addr, and rd0_addr, then read from rd0_addr
        wr0_addr <= 70;
        wr0_data <= 35;
        wr0_en <= 1;
        #10;
        wr0_en <= 0;
        #10;

        wr1_addr <= 80;
        wr1_data <= 40;
        wr1_en <= 1;
        #10;
        wr1_en <= 0;
        #10;

        rd0_addr <= 70;
        rd0_en <= 1;
        #10;
        rd0_en <= 0;

        // Check expected vs actual results for test case 5
        if (rd0_data === 35)
            test_cases_passed = test_cases_passed + 1;
        if (rd0_data === 35)
            $display("Test case 5 passed");

        #10;
        // Test case 6: Write to wr0_addr, wr1_addr, and rd0_addr, then read from rd0_addr with different address
        wr0_addr <= 90;
        wr0_data <= 45;
        wr0_en <= 1;
        #10;
        wr0_en <= 0;
        #10;

        wr1_addr <= 100;
        wr1_data <= 50;
        wr1_en <= 1;
        #10;
        wr1_en <= 0;
         #10;
        rd0_addr <= 95;
        rd0_en <= 1;
        #10;
        rd0_en <= 0;

        // Check expected vs actual results for test case 6
        if (rd0_data === 0)
            test_cases_passed = test_cases_passed + 1;
        if (rd0_data === 0)
            $display("Test case 6 passed");
         
         #10;   
        
        // Display test results
        $display("Test cases passed: %d", test_cases_passed);
        
        // End of simulation
        #10;
        $finish;
    end
    
endmodule
