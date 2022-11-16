module alu(
    input clk,
    input rst,
    input rdy,
    input [`INSIDE_OPCODE_WIDTH] in_rs_op,
    input [`DATA_WIDTH] in_rs_value_rs1,
    input [`DATA_WIDTH] in_rs_value_rs2,
    input [`DATA_WIDTH] in_rs_value_imm,
    input [`DATA_WIDTH] in_rs_pc,

    output [`DATA_WIDTH] out_rob_value, //rd
    output [`ROB_TAG_WIDTH] out_update_reorder
);
  always @(posedge clk) begin
    if (rst == `TRUE) begin

    end else if (rdy == `TRUE) begin
        case(in_rs_op)
            `LUI:begin
                out_rob_value <= in_rs_value_imm;
            end
            `AUIPC:begin
                out_rob_value <= in_rs_pc + in_rs_value_imm;
            end
            `JAL:begin
                out_rob_value <= in_rs_pc + 4;
            end
            `JALR:begin
                out_rob_value <= in_rs_pc + 4;
            end


            `ADDI:begin
                out_rob_value <= in_rs_value_rs1 + in_rs_value_imm;
            end
            `SLTI:begin
                out_rob_value <= ($signed(in_rs_value_rs1) < $signed(in_rs_value_imm)) ? 1 : 0;
            end
            `SLTIU:begin
                out_rob_value <= (in_rs_value_rs1 < in_rs_value_imm) ? 1 : 0;
            end
            `XORI:begin
                out_rob_value <= in_rs_value_rs1 ^ in_rs_value_imm;
            end
            `ORI:begin
                out_rob_value <= in_rs_value_rs1 | in_rs_value_imm;
            end
            `ANDI:begin
                out_rob_value <= in_rs_value_rs1 & in_rs_value_imm;
            end
            `SLLI:begin
                out_rob_value <= in_rs_value_rs1 << in_rs_value_imm;
            end
            `SRLI:begin
                out_rob_value <= in_rs_value_rs1 >> in_rs_value_imm;
            end
            `SRAI:begin
                out_rob_value <= in_rs_value_rs1 >>> in_rs_value_imm;
            end
            `ADD:begin
                out_rob_value <= in_rs_value_rs1 + in_rs_value_rs2;
            end
            `SUB:begin
                out_rob_value <= in_rs_value_rs1 - in_rs_value_rs2;
            end
            `SLL:begin
                out_rob_value <= in_rs_value_rs1 << in_rs_value_rs2;
            end
            `SLT:begin
                out_rob_value <= ($signed(in_rs_value_rs1) < $signed(in_rs_value_rs2)) ? 1 : 0;
            end
            `SLTU:begin
                out_rob_value <= (in_rs_value_rs1 < in_rs_value_rs2) ? 1 : 0;
            end
            `XOR:begin
                out_rob_value <= in_rs_value_rs1 ^ in_rs_value_rs2;
            end
            `SRL:begin
                out_rob_value <= in_rs_value_rs1 >> in_rs_value_rs2;
            end
            `SRA:begin
                out_rob_value <= in_rs_value_rs1 >>> in_rs_value_rs2;
            end
            `OR:begin
                out_rob_value <= in_rs_value_rs1 | in_rs_value_rs2;
            end
            `AND:begin
                out_rob_value <= in_rs_value_rs1 & in_rs_value_rs2;
            end
        endcase
    end else begin

    end
  end
endmodule