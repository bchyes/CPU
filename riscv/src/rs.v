module rs(
    input clk,
    input rst,
    input rdy.
    //input in_decode_get,//Bool, to know whether a instr in coming.
    input [`INSIDE_OPCODE_WIDTH] in_decode_op,
    input [`DATA_WIDTH] in_decode_pc;
    //input [`REG_TAG_WIDTH] in_decode_rs1,//TAG
    //input [`REG_TAG_WIDTH] in_decode_rs2,//TAG
    input [`ROB_TAG_WIDTH] in_rob_reorder,//to know whether a instr in coming.(No by reorder == `ZERO_ROB_TAG)
    input [`DATA_WIDTH] in_decode_imm,
    input in_reg_get_rs1,//Bool, to know if we can get the data from reg(reorder == 0)
    //input in_reg_wait_rs1,//Bool, reg reorder != 0
    input in_reg_get_rs2,//Bool, to know if we can get the data from reg(reorder == 0)
    //input in_reg_wait_rs2,//Bool, reg reorder != 0
    input [`DATA_WIDTH] in_reg_value_rs1,
    input [`DATA_WIDTH] in_reg_value_rs2,
    input [`ROB_TAG_WIDTH] in_reg_reorder_rs1,
    input [`ROB_TAG_WIDTH] in_reg_reorder_rs2,
    
    input in_rob_ready_rs1,//Bool, if we can't get data from reg, then we wait the ROB to commit the data
    input in_rob_ready_rs2,//Bool, if we can't get data from reg, then we wait the ROB to commit the data
    input [`DATA_WIDTH] in_rob_value_rs1,
    input [`DATA_WIDTH] in_rob_value_rs2,

    //When reorder buffer refresh, then we change the value
    input [`DATA_WIDTH] in_rob_update_value,
    input [`ROB_TAG_WIDTH] in_rob_update_reorder,

    //output for ALU
    output reg [`INSIDE_OPCODE_WIDTH] out_alu_op, //NOP means no operation
    output reg [`DATA_WIDTH] out_alu_value_rs1,
    output reg [`DATA_WIDTH] out_alu_value_rs2,
    output reg [`DATA_WIDTH] out_alu_imm,
    output reg [`DATA_WIDTH] out_alu_pc,
    output reg [`ROB_TAG_WIDTH] out_alu_reorder
);
    reg busy [`RS_SIZE]; // to know line in RS has instr which has not been operated.
    reg [`RS_TAG_WIDTH] free_line; // the place where new instr put. 
    // reg [`RS_TAG_WIDTH] head;
    // reg [`RS_TAG_WIDTH] tail;
    reg ready [`RS_SIZE]; // to know whether rs1 and rs2 are ready or not. 
    reg [`RS_TAG_WIDTH] ready_line;
    reg [`DATA_WIDTH] pcs [(`RS_SIZE-1):0];
    reg [`DATA_WIDTH] rs1_value [(`RS_SIZE-1):0];
    reg [`DATA_WIDTH] rs2_value [(`RS_SIZE-1):0];
    reg [`ROB_TAG_WIDTH] rs1_reorder [(`RS_SIZE-1):0];
    reg [`ROB_TAG_WIDTH] rs2_reorder [(`RS_SIZE-1):0];
    reg [`DATA_WIDTH] imms [(`RS_SIZE-1):0];
    reg [`INSIDE_OPCODE_WIDTH] ops [(`RS_SIZE-1):0];
    reg [`ROB_TAG_WIDTH] reorder [(`RS_SIZE-1):0];
    
    genvar j;
    generate
        for (j = 1;j < `RS_SIZE;j++) begin
            assign ready[j] = (busy[j] == `TRUE) && (rs1_reorder[j] == `ZERO_ROB_TAG) && (rs2_reorder[j] == `ZERO_ROB_TAG);
        end
    endgenerate

    assign free_line =  ~busy[1] ? 1 :
                        ~busy[2] ? 2 :
                        ~busy[3] ? 3 :
                        ~busy[4] ? 4 :
                        ~busy[5] ? 5 :
                        ~busy[6] ? 6 :
                        ~busy[7] ? 7 :
                        ~busy[8] ? 8 :
                        ~busy[9] ? 9 :
                        ~busy[10] ? 10 :
                        ~busy[11] ? 11 :
                        ~busy[12] ? 12 :
                        ~busy[13] ? 13 :
                        ~busy[14] ? 14 :
                        ~busy[15] ? 15 : `ZERO_REG_TAG;

    assign ready_line = ready[1] ? 1 :
                        ready[2] ? 2 :
                        ready[3] ? 3 :
                        ready[4] ? 4 :
                        ready[5] ? 5 :
                        ready[6] ? 6 :
                        ready[7] ? 7 :
                        ready[8] ? 8 :
                        ready[9] ? 9 :
                        ready[10] ? 10 :
                        ready[11] ? 11 :
                        ready[12] ? 12 :
                        ready[13] ? 13 :
                        ready[14] ? 14 :
                        ready[15] ? 15 : `ZERO_REG_TAG;

    integer i;
  always @(posedge clk) begin
    if (rst == `TRUE) begin
        out_alu_op <= `NOP;
        for (i = 1;i < `RS_SIZE;i++) begin
            busy[i] <= `FALSE;
            op[i] <= `NOP;
        end
    end else if (rdy == `TRUE) begin
        out_alu_op <= `NOP;
        if (ready_line != `ZERO_RS_TAG) begin
            out_alu_op <= ops[ready_line];
            out_alu_imm <= imms[ready_line];
            out_alu_pc <= pcs[ready_line];
            out_alu_reorder <= reorder[ready_line];
            out_alu_value_rs1 <= rs1_value[ready_line];
            out_alu_value_rs2 <= rs2_value[ready_line];
        end
        if (in_rob_reorder != `ZERO_ROB_TAG && free_line != `ZERO_REG_TAG && in_reg_get_rs1 == `TRUE && in_reg_get_rs2 == `TRUE) begin
            busy[free_line] <= `TRUE;
            //ready[free_line] <= `FALSE;
            pcs[free_line] <= in_decode_pc;
            imms[free_line] <= in_decode_imm;
            ops[free_line] <= in_decode_op;
            reorder[free_line] <= in_rob_reorder;
            rs1[free_line] <= in_reg_value_rs1;
            rs2[free_line] <= in_reg_value_rs2;
            rs1_reorder[free_line] <= in_reg_reorder_rs1;
            rs2_reorder[free_line] <= in_reg_reorder_rs2;
        end
        if (in_rob_update_reorder != `ZERO_ROB_TAG) begin
            for (i = 1; i < RS_SIZE; i = i + 1) begin
                if (busy[i] == `TRUE && (rs1_reorder[i] == in_rob_update_reorder)) begin
                    rs1_reorder[i] <= `ZERO_ROB_TAG;
                    rs1_value[i] <= in_rob_update_value;
                end
                if (busy[i] == `TRUE && (rs2_reorder[i] == in_rob_update_reorder)) begin
                    rs2_reorder[i] <= `ZERO_ROB_TAG;
                    rs2_value[i] <= in_rob_update_value;
                end
            end
        end
    end else begin
        // nothing to do when rdy == `FALSE
    end
  end
endmodule