module tb_alu;
    reg clk, rst_n;
    reg [7:0] A, B;
    reg [3:0] ALU_Sel;
    wire [7:0] ALU_Out;
    wire CarryOut;

    // Instantiate the ALU
    alu #(.WIDTH(8)) dut (clk, rst_n, A, B, ALU_Sel, ALU_Out, CarryOut);

    // Clock Generation (10ns period = 100MHz)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars(1);
        
        // Initialize
        clk = 0; rst_n = 0; A = 0; B = 0; ALU_Sel = 0;
        #10 rst_n = 1; // Release Reset

        // Test 1: Addition
        A = 8'h10; B = 8'h05; ALU_Sel = 4'b0000;
        #10; // Wait for one clock cycle
        $display("Time %t: Add Result = %h", $time, ALU_Out);

        // Test 2: Subtraction
        A = 8'h20; B = 8'h05; ALU_Sel = 4'b0001;
        #10;
        $display("Time %t: Sub Result = %h", $time, ALU_Out);

        #20 $finish;
    end
endmodule
