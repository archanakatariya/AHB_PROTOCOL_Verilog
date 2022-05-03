//*********************************************************************************************************************************************************************************************//
//********************************************************************************************************************************************************************************************// 
//************************************************ 	PROJECT     :	 AHB PROTOCOL 		     ****************************************************************************************//
//************************************************	FILE NAME   :	 AHB_v3.v 		     ***************************************************************************************//
//************************************************	DESCRIPTION :	 DESIGN FOR AHB PROTOCOL     **************************************************************************************//
//************************************************	DATE	    :	 09/03/2022		     *************************************************************************************//
//**************************************************************************************************************************************************************************************//
//*************************************************************************************************************************************************************************************//
`timescale 1ns/1ns
module ahb_slave(
  input hclk,
  input hresetn,
  input hsel,
  input [31:0] haddr,
  input hwrite,
  input [2:0] hsize,
  input [2:0] hburst,
  input [1:0] htrans,
  input [63:0] hwdata,
  output reg hready,
  output reg hresp,
  output reg [63:0] hrdata);

//----------------------------------------------------------------------
// 		The definitions for intern registers for data storge
//----------------------------------------------------------------------
reg [7:0] mem [1023:0];
reg [9:0] waddr;
reg [9:0] raddr;

//----------------------------------------------------------------------
// 		The definition for state machine for HTRANS 
//----------------------------------------------------------------------
reg [1:0] previous_state = 0;
parameter  IDLE = 2'b00,
	    BUSY = 2'b01,
	    NONSEQ = 2'b10,
	    SEQ = 2'b11;

//----------------------------------------------------------------------
// 		The state machine
//----------------------------------------------------------------------
always @(posedge hclk, negedge hresetn) begin
  if(!hresetn) begin
    hrdata = 64'd0;
    hready = 1'd0;
    hresp = 1'd0;
  end
end

always @(posedge hclk) begin
  if(hsel == 1) begin
  case(htrans)
    IDLE:begin
   	hready = 1;
    	hresp = 0;
    		case(previous_state)
    		IDLE:begin
	    	   	@(posedge hclk);	
    			end

    		NONSEQ:begin
		        Data_Phase;		
    			end
 
    		SEQ:begin
    			Data_Phase;		
    			end

    		endcase
		previous_state = htrans;
    	end
    	
    BUSY:begin
    	hready =0;
    	hresp =0;
    
    		case(previous_state)
    		BUSY:begin 	
			hready = 1;	
    			end

    		NONSEQ:begin
	 		hready = 1;		 
    			end
    			
    		SEQ:begin
			hready = 1;	
    			end

    		endcase
		previous_state = htrans;
		
           end
    NONSEQ:begin
    	hready =1;
    	hresp =0;

    		case(previous_state)
    		IDLE:begin
    			waddr = haddr;
			raddr = haddr;
    			end

    		NONSEQ:begin 
    			 Data_Phase;
    			end

    		SEQ:begin
    			Data_Phase;		
    			end

    		endcase
		previous_state = htrans;
    	end
    SEQ:begin
    	hready =1;
    	hresp =0;
    		case(previous_state)
    		BUSY:begin
			Data_Phase;					
    			end

    		NONSEQ:begin 
    			Data_Phase;		
    			end
    	
    		SEQ:begin
		       Data_Phase;
    		       end

    		endcase
		previous_state = htrans;
    	end
endcase
end
end
//---------------------------------------------------------------
//		DATA_PHASE task created
//---------------------------------------------------------------
task Data_Phase;
begin
	if(hready == 1)begin
    			case(hsize)
			3'b000:begin
				//----------- 8-bits Write Operation -----------
				if(hwrite == 1) begin
					mem[waddr+0] = hwdata[7:0];
					$display("waddr = %0d hwdata = %0d", waddr, hwdata);	
            				waddr = haddr;
    				end

				//----------- 8-bits Read Operation -----------
    				else begin
    					hrdata[7:0] = mem[raddr+0];
					$display("raddr = %0d hrdata = %0d", raddr, hrdata);	
            				raddr = haddr;
				end
				end

			3'b001:begin
				
				//---------- 16-bits Write Operation -----------
				if(hwrite == 1) begin
					mem[waddr+0] = hwdata[7:0];
					mem[waddr+1] = hwdata[15:8];
					$display("waddr = %0d hwdata = %0d", waddr, hwdata);	
            				waddr = haddr;
    				end

				//----------- 16-bits Read Operation -----------
    				else begin
    					hrdata[7:0] = mem[raddr+0];
					hrdata[15:8] = mem[raddr+1];
					$display("raddr = %0d hrdata = %0d", raddr, hrdata);	
            				raddr = haddr;
				end
				end
			3'b010:begin
				
				//----------- 32-bits Write Operation -----------
				if(hwrite == 1) begin
					mem[waddr+0] = hwdata[7:0];
					mem[waddr+1] = hwdata[15:8];
					mem[waddr+2] = hwdata[23:16];
					mem[waddr+3] = hwdata[31:24];
					$display("waddr = %0d hwdata = %0d", waddr, hwdata);	
            				waddr = haddr;
    				end
				
				//----------- 32-bits Read Operation -----------
    				else begin 
    					hrdata[7:0] = mem[raddr+0];
					hrdata[15:8] = mem[raddr+1];
					hrdata[23:16] = mem[raddr+2];
					hrdata[31:24] = mem[raddr+3];
					$display("raddr = %0d hrdata = %0d", raddr, hrdata);	
            				raddr = haddr;
				end
				end
			3'b011:begin
				
				//----------- 32-bits Write Operation -----------
				if(hwrite == 1) begin
					mem[waddr+0] = hwdata[7:0];
					mem[waddr+1] = hwdata[15:8];
					mem[waddr+2] = hwdata[23:16];
					mem[waddr+3] = hwdata[31:24];
					mem[waddr+4] = hwdata[39:32];
					mem[waddr+5] = hwdata[47:40];
					mem[waddr+6] = hwdata[55:48];
					mem[waddr+7] = hwdata[63:56];
					$display("waddr = %0d hwdata = %0d", waddr, hwdata);	
            				waddr = haddr;
    				end
				
				//----------- 32-bits Read Operation -----------
    				else begin 
    					hrdata[7:0] = mem[raddr+0];
					hrdata[15:8] = mem[raddr+1];
					hrdata[23:16] = mem[raddr+2];
					hrdata[31:24] = mem[raddr+3];
    					hrdata[39:32] = mem[raddr+4];
					hrdata[47:40] = mem[raddr+5];
					hrdata[55:48] = mem[raddr+6];
					hrdata[63:56] = mem[raddr+7];
					$display("raddr = %0d hrdata = %0d", raddr, hrdata);	
            				raddr = haddr;
				end
				end
			endcase
		end
	end
endtask
endmodule
            			   
			     

