module cift_yollu_bellek
#(
  parameter DATA_WIDTH = 4,
  parameter ADDR_WIDTH = 16,
  parameter DEPTH = 16
  )

  (
  input clk,
  input [ADDR_WIDTH-1:0] addr_0,
  input cs_0,
  input we_0,
  input oe_0, 
  input [ADDR_WIDTH-1:0] addr_1,
  input cs_1,
  input we_1,
  input oe_1,
  inout [DATA_WIDTH-1:0] data_0,
  inout [DATA_WIDTH-1:0] data_1
 );

  reg [DATA_WIDTH-1:0] data_0_out ; 
  reg [DATA_WIDTH-1:0] data_1_out ;
  reg [DATA_WIDTH -1:0] mem[DEPTH-1:0];

  always @ (posedge clk)
  begin : MEM_WRITE
    if ( cs_0 && we_0 ) begin
       mem[addr_0] <= data_0;
    end else if (cs_1 && we_1) begin 
       mem[addr_1] <= data_1;
    end
  end

  always @ (negedge clk)
  begin : MEM_READ_0
    if (cs_0 &&  ! we_0 && oe_0) 
      data_0_out <= mem[addr_0];  
  end 

  always @ (negedge clk)
  begin : MEM_READ_1
    if (cs_1 &&  ! we_1 && oe_1)
      data_1_out <= mem[addr_1]; 
  end

  assign data_0 = (cs_0 && oe_0 &&  ! we_0) ? data_0_out : 'hz; 
  assign data_1 = (cs_1 && oe_1 &&  ! we_1) ? data_1_out : 'hz; 

endmodule