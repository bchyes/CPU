module decode(
    input clk,
    input rst,
    input rdy,
    //Decode get instr & pc from fetcher
    input in_fetcher_get, //bool
    input [`DATA_WIDTH] in_fetcher_instr,
    input [`DATA_WIDTH] in_fetcher_pc,
    
    output [`REG_TAG_WIDTH] out_reg_rs1,
    output [`REG_TAG_WIDTH] out_reg_rs2,
    output reg [`INSIDE_OPCODE_WIDTH] out_rob_op,
    output reg [`REG_TAG_WIDTH] out_rob_rd,

    output reg [`INSIDE_OPCODE_WIDTH] out_rs_op
);
    wire [6:0] opcode; 
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;
    assign opcode = in_fetcher_instr[`OPCODE_WIDTH];
    assign rd = in_fetcher_instr[11:7];
    assign funct3 = in_fetcher_instr[14:12];
    assign funct7 = in_fetcher_instr[31:25];
    assign out_reg_rs2 = in_fetcher_instr[24:20];
    assign out_reg_rs1 = in_fetcher_instr[19:15];

    always @(posedge clk) begin
        if (rst == `TRUE) begin

        end else if (rdy == `TRUE) begin
            case (opcode) 
                7'b110111:begin //LUI
                    out_rob_op <= `LUI;
                    out_rs_op <= `LUI;
                    out_rob_rd <= rd;
                end
                7'b10111:begin //AUIPC
                    out_rob_op <= `AUIPC;
                    out_rs_op <= `AUIPC;
                end
                7'b1101111:begin //JAL
                    out_rob_op <= `JAL;
                end
                7'b1100111:begin //JALR
                    out_rob_op <= `JALR;
                end
                7'b1100011:begin //B-type
                    case (funct3)
                        3'b0:begin //BEQ
                            out_rob_op <= `BEQ;
                            out_rs_op <= `BEQ;
                        end
                        3'b1:begin //BNE
                            out_rob_op <= `BNE;
                            out_rs_op <= `BNE;
                        end
                        3'b100:begin //BLT
                            out_rob_op <= `BLT;
                            out_rs_op <= `BLT;
                        end
                        3'b101:begin //BGE
                            out_rob_op <= `BGE;
                            out_rs_op <= `BGE;
                        end
                        3'b110:begin //BLTU
                            out_rob_op <= `BLTU;
                            out_rs_op <= `BLTU;
                        end
                        3'b111:begin //BGEU
                            out_rob_op <= `BGEU;
                            out_rs_op <= `BGEU;
                        end
                    endcase
                end
                7'b11:begin //L-type
                    case (funct3)
                        3'b0:begin //LB
                            
                        end
                        3'b1:begin //LH

                        end
                        3'b10:begin //LW

                        end
                        3'b100:begin //LBU

                        end
                        3'b101:begin //LHU
                        
                        end
                    endcase
                end
                7'b100011:begin //S-type
                    case (funct3)
                        3'b0:begin //SB

                        end
                        3'b1:begin //SH

                        end
                        3'b10:begin //SW

                        end
                    endcase
                end
                7'b10011:begin //I-type
                    case (funct3)
                        3'b0:begin //ADDI
                            out_rob_op <= `ADDI;
                            out_rs_op <= `ADDI;
                        end
                        3'b10:begin //SLTI
                            out_rob_op <= `SLTI;
                            out_rs_op <= `SLTI;
                        end
                        3'b11:begin //SLTIU
                            out_rob_op <= `SLTIU;
                            out_rs_op <= `SLTIU;
                        end
                        3'b100:begin //XORI
                            out_rob_op <= `XORI;
                            out_rs_op <= `XORI;
                        end
                        3'b110:begin //ORI
                            out_rob_op <= `ORI;
                            out_rs_op <= `ORI;
                        end
                        3'b110:begin //ANDI
                            out_rob_op <= `ANDI;
                            out_rs_op <= `ANDI;
                        end
                        3'b1:begin //SLLI
                            out_rob_op <= `SLLI;
                            out_rs_op <= `SLLI;
                        end
                        3'b101:begin 
                            case (funct7)
                                7'b0:begin //SRLI
                                    out_rob_op <= `SRLI;
                                    out_rs_op <= `SRLI;
                                end
                                7'b100000:begin //SRAI
                                    out_rob_op <= `SRAI;
                                    out_rs_op <= `SRAI;
                                end
                            endcase
                        end
                    endcase
                end
                7'b110011:begin //R-type
                    case (funct3)
                        3'b0:begin 
                            case (funct7)
                                7'b0:begin //ADD
                                    out_rob_op <= `ADD;
                                    out_rs_op <= `ADD;
                                end
                                7'b100000:begin //SUB
                                    out_rob_op <= `SUB;
                                    out_rs_op <= `SUB;
                                end
                            endcase
                        end
                        3'b1:begin //SLL
                            out_rob_op <= `SLL;
                            out_rs_op <= `SLL;
                        end
                        3'b10:begin //SLT
                            out_rob_op <= `SLT;
                            out_rs_op <= `SLT;
                        end
                        3'b11:begin //SLTU
                            out_rob_op <= `SLTU;
                            out_rs_op <= `SLTU;
                        end
                        3'b100:begin //XOR
                            out_rob_op <= `XOR;
                            out_rs_op <= `XOR;
                        end
                        3'b101:begin 
                            case (funct7)
                                7'b0:begin //SRL
                                    out_rob_op <= `SRL;
                                    out_rs_op <= `SRL;
                                end
                                7'b100000:begin //SRA
                                    out_rob_op <= `SRA;
                                    out_rs_op <= `SRA;
                                end
                            endcase
                        end
                        3'b110:begin //OR
                            out_rob_op <= `OR;
                            out_rs_op <= `OR;
                        end
                        3'b111:begin //AND
                            out_rob_op <= `AND;
                            out_rs_op <= `AND;
                        end
                    endcase
                end
            endcase
        end else begin

        end
    end
endmodule