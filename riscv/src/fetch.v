module fetcher(
    input clk,
    input rst,
    input rdy,
    //Fetcher has got instr from Mem
    input in_mem_get_instr, //bool
    input in_mem_instr,
    //Output instr for next stage.
    output reg [`DATA_WIDTH] out_instr,
    output reg [`DATA_WIDTH] out_pc,
    //Ask Mem to get instr from pc.
    output reg out_mem_get_instr, //bool
    output reg [`DATA_WIDTH] out_mem_pc,
);
    localparam IDLE = 2'b0,WAIT_MEM = 2'b1,WAIT_IDLE = 2'b10;//WAIT_IDLE -> RS,ROB,SLB
    reg [2:0] state;
    reg [24:0] icache_tag [(`ICACHE_SIZE-1):0]; //??? how to know 24
    reg [`DATA_WIDTH] icache_instr [(`ICACHE_SIZE-1):0];
    reg icache_valid [(`ICACHE_SIZE-1):0];
    reg [`DATA_WIDTH] pc;

    always @(posedge clk) begin
        if (rst == `TRUE) begin
            state <= IDLE;
            pc <= `ZREO_DATA;
            out_mem_get_instr <= `FALSE;
            out_mem_pc <= `ZREO_DATA;
            out_instr <= `ZREO_DATA;
            out_pc <= `ZREO_DATA;
        end else if (rdy == `TRUE) begin
            if (state == IDLE) begin
                if (icache_valid[pc[`ICACHE_TAG_WIDTH]] == `TRUE && icache_tag[pc[`ICACHE_INDEX_WIDTH]] == pc[`ICACHE_TAG_WIDTH]) begin
                    out_instr <= icache_instr[pc[`ICACHE_INDEX_WIDTH]];
                    out_pc <= pc;
                    if () begin
                        
                        state = IDLE;
                        if (icache_instr[pc[`ICACHE_INDEX_WIDTH][`OPCODE_WIDTH]] == 7'b1101111) begin //JAL

                        end else if (icache_instr[pc[`ICACHE_INDEX_WIDTH][`OPCODE_WIDTH]] == 7'b1100011) begin //B_type

                        end else begin
                            pc <= pc + 4;
                        end
                    end else begin
                    state = WAIT_IDLE;
                    end
                end else begin
                    state = WAIT_MEM;
                    out_mem_get_instr <= `TRUE;
                    out_mem_pc <= pc;
                end
            end else if (state == WAIT_MEM) begin
                if (in_mem_get_instr == `TRUE) begin
                    out_instr <= in_mem_instr;
                    out_pc <= pc;
                    icache_valid[pc[`ICACHE_INDEX_WIDTH]] <= `TRUE;
                    icache_tag[pc[`ICACHE_INDEX_WIDTH]] <= pc[`ICACHE_TAG_WIDTH];
                    icache_instr[pc[`ICACHE_INDEX_WIDTH]] <= in_mem_instr;
                    if () begin
                        
                        state = IDLE;
                        if (in_mem_instr[`OPCODE_WIDTH] == 7'b1101111) begin //JAL

                        end else if (in_mem_instr[`OPCODE_WIDTH] == 7'b1100011) begin //B_type

                        end else begin
                            pc <= pc + 4;
                        end
                    end else begin
                    state = WAIT_IDLE;
                    end
                end
            end else if (state == WAIT_IDLE ) begin
                state <= IDLE;
                if () begin
                    
                    state = IDLE;
                    if (out_instr[`OPCODE_WIDTH] == 7'b1101111) begin //JAL
                    
                    end else if (out_instr[`OPCODE_WIDTH] == 7'b1100011) begin //B_type

                    end else begin
                        pc <= pc + 4;
                    end
                end
            end
        end else begin

        end
    end
endmodule