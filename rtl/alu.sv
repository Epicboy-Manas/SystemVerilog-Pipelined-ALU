// Professional Parameterized Pipelined ALU
// Designed for ASIC/SoC Integration
module alu #(
    parameter WIDTH = 32 // Default to 32-bit, but can be changed to 8 or 64
)(
    input  logic              clk,     // System Clock
    input  logic              rst_n,   // Asynchronous Reset (Active Low)
    input  logic [WIDTH-1:0]  A, B,    // Data Inputs
    input  logic [3:0]        ALU_Sel, // Operation Select
    output logic [WIDTH-1:0]  ALU_Out, // Registered Output
    output logic              CarryOut,
    output logic              Zero,    // High if result is 0
    output logic              Negative // High if MSB is 1
);

    // Internal signals for combinational logic
    logic [WIDTH-1:0] alu_raw;
    logic             carry_raw;

    // --- Combinational Logic Stage ---
    always_comb begin
        alu_raw   = '0;
        carry_raw = 1'b0;
        case (ALU_Sel)
            4'b0000: {carry_raw, alu_raw} = A + B; // Addition
            4'b0001: {carry_raw, alu_raw} = A - B; // Subtraction
            4'b0010: alu_raw = A & B;              // Bitwise AND
            4'b0011: alu_raw = A | B;              // Bitwise OR
            4'b0100: alu_raw = A ^ B;              // Bitwise XOR
            4'b0101: alu_raw = ~(A | B);           // Bitwise NOR
            default: alu_raw = A + B;
        endcase
    end

    // --- Sequential Logic Stage (Pipelining) ---
    // This adds exactly 1 clock cycle of latency for better timing closure
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ALU_Out  <= '0;
            CarryOut <= 1'b0;
            Zero     <= 1'b0;
            Negative <= 1'b0;
        end else begin
            ALU_Out  <= alu_raw;
            CarryOut <= carry_raw;
            Zero     <= (alu_raw == '0);
            Negative <= alu_raw[WIDTH-1];
        end
    end

endmodule
