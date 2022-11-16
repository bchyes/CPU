module rob(
    input clk,
    input rst,
    input rdy,
    input [`INSIDE_OPCODE_WIDTH] in_decode_op,
    input [`REG_TAG_WIDTH] in_decode_rd,
    input [`DATA_WIDTH] in_decode_pc,

    //ALU solve the line in the reorder buffer
    input [`DATA_WIDTH] in_alu_value,
    input [`ROB_TAG_WIDTH] in_alu_reorder,

    output [`DATA_WIDTH] out_reg_value,
    output [`REG_TAG_WIDTH] out_reg_index,
    //Compare to the reorder in the reg to judge whether to change the value in the reg
    output [`ROB_TAG_WIDTH] out_reg_value_reorder
);
    //reg busy [(`ROB_SIZE - 1):0];
    reg ready [(`ROB_SIZE - 1):0];
    reg [`ROB_TAG_WIDTH] head;
    reg [`ROB_TAG_WIDTH] tail;
    wire [`ROB_TAG_WIDTH] head_next_ptr;
    wire [`ROB_TAG_WIDTH] tail_next_ptr;
    reg [`INSIDE_OPCODE_WIDTH] ops [(`ROB_SIZE - 1):0];
    reg [`DATA_WIDTH] pcs [(`ROB_SIZE - 1):0];
    reg [`REG_TAG_WIDTH] dest [(`ROB_SIZE - 1):0]; 
    reg [`DATA_WIDTH] value [(`ROB_SIZE - 1):0];

    assign head_next_ptr = (head % (`ROB_SIZE - 1)) + 1;
    assign tail_next_ptr = (tail % (`ROB_SIZE - 1)) + 1;

  always @(posedge clk) begin
    if (rst == `TRUE) begin
        head <= 0;
        tail <= 0;
    end else if (rdy == `TRUE) begin
        if (in_decode_op != `NOP) begin
            pcs[tail_next_ptr] <= in_decode_pc;
            ops[tail_next_ptr] <= in_decode_op;
            dest[tail_next_ptr] <= in_decode_rd;
            ready[tail_next_ptr] <= `FALSE;
            tail <= tail_next_ptr;
        end
        if (in_alu_reorder != `ROB_SIZE) begin
            value[in_alu_reorder] <= in_alu_value;
            ready[in_alu_reorder] <= `TRUE;
        end
        if (ready[head_next_ptr] == `TRUE && head != tail) begin
            ready[head_next_ptr] <= `FALSE;
            case (ops[head_next_ptr])
                `NOP:begin end
                `default:begin
                    out_reg_index <= dest[head_next_ptr];
                    out_reg_value <= value[head_next_ptr];
                    out_reg_value_reorder <= head_next_ptr;
                end
            endcase
        end
    end else begin
        //nothing to do when rdy == `FALSE
    end
  end
endmodule