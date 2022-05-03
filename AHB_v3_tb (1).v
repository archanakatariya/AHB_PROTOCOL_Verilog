//********************************************************************************************************************************************************************************//
//*******************************************************************************************************************************************************************************// 
//************************************************ 	PROJECT     :	 AHB PROTOCOL 		     ***************************************************************************//
//************************************************	FILE NAME   :	 AHB_v3_TB.v 		     **************************************************************************//
//************************************************	DESCRIPTION :	 TESTBENCH FOR AHB PROTOCOL     *************************************************************************//
//************************************************	DATE	    :	 09/03/2022		     ************************************************************************//
//*************************************************************************************************************************************************************************//
//************************************************************************************************************************************************************************//

`include "AHB_v3.v" 		// INCLUDING DESIGN FILE
`timescale 1ns/1ns     
//NORMAL OPERATION MACRO DEFINE  
`define READ 0; 
`define WRITE 1; 
`define HIGH 1; 
`define LOW 0; 
`define SET 1; 
`define RESET 0; 
 
module ahb_master_tb(); 
reg hclk; 
reg hresetn; 
reg wr; 
reg enable; 
reg hsel; 
reg [1:0] slave_sel; 
reg [31:0] haddr; 
reg [63:0] hwdata; 
reg [63:0] dout; 
reg hwrite; 
reg [2:0] hsize; 
reg [2:0] hburst; 
reg [1:0] htrans,trans,busy; 
wire hresp; 
wire [63:0] hrdata; 
wire hready; 
reg [31:0]allign_addr,boundary; 
integer count,i,j,k,total;
reg dummy,dummy1; 
reg [20 * 8:1]test_case;
///////// Trans Bust model defined  
parameter  IDLE = 2'b00, 
    BUSY = 2'b01, 
    NONSEQ = 2'b10, 
    SEQ = 2'b11;
///////// FOR BURST OPERATION //////
parameter SINGLE = 3'b000, 
	  INCR = 3'b001,
	  WRAP4 = 3'b010,
	  INCR4 = 3'b011,
	  WRAP8 = 3'b100,
	  INCR8 = 3'b101,
	  WRAP16 = 3'b110,
	  INCR16 = 3'b111;
/////////// FOR SIZE OPERATION /////
parameter BYTE = 000, 
 	  HALF_WORD = 001, 
	  WORD = 010,
	  DOUBLE_WORD = 011,
	  WORD_LINE_4 = 100, 
	  WORD_LINE_8 = 101, 
  	  WORD_LINE_16 = 110, 
	  WORD_LINE_32 = 111;

///////// INSATNTIATION MODULE ////////////
ahb_slave DUT( 
  .hclk(hclk), 
  .hresetn(hresetn), 
  .hsel(hsel), 
  .haddr(haddr), 
  .hwrite(hwrite), 
  .hsize(hsize), 
  .hburst(hburst), 
  .htrans(htrans), 
  .hready(hready), 
  .hwdata(hwdata), 
  .hresp(hresp), 
  .hrdata(hrdata)); 
  
initial begin 
  hclk = `LOW; 
  hresetn = `SET; 
  hsel = `LOW; 
  haddr = `LOW; 
  hwrite = `WRITE; 
  hburst = `LOW; 
  hsize = `LOW; 
  htrans = `LOW; 
  hwdata = `LOW; 
  count = `SET; 
//////// ////////RESET LOGIC ////////////////////////
  hresetn = `RESET; 
      #2 hresetn = `SET;  
end 
  
initial begin
///////////////// COMMAND LINE ARGUMENT ////////////////////
  dummy = $value$plusargs("test_case=%s",test_case);
	 $display("test_case = %s",test_case);
/////////////////// TEST CASES //////////////////////////
  case(test_case)
	"sanity_test_1_byte" : begin
		hsize = BYTE;
		Sanity_Test(32'd10,hsize,busy);
	end
	"incr4_1_byte" : begin
		hsize = BYTE;
		incr4(32'd10,hsize,busy);
	end
	"incr8_1_byte" : begin
		hsize = BYTE;
		incr8(32'd10,hsize,busy);
	end
	"incr16_1_byte" : begin
		hsize = BYTE;
		incr16(32'd10,hsize,busy);
	end
	"wrap4_1_byte" : begin
		hsize = BYTE;	
		wrap4(32'd10,hsize,busy);
	end
	"wrap8_1_byte" : begin
		hsize = BYTE;
		wrap8(32'd10,hsize,busy);
	end
	"wrap16_1_byte" : begin
		hsize = BYTE;
		wrap16(32'd10,hsize,busy);
	end
	"sanity_test_2_byte" : begin
		hsize = HALF_WORD; 
		Sanity_Test(32'd10,hsize,busy);
	end
	"incr4_2_byte" : begin
		hsize = HALF_WORD; 
		incr4(32'd10,hsize,busy);
	end
	"incr8_2_byte" : begin
		hsize = HALF_WORD; 
		incr8(32'd10,hsize,busy);
	end
	"incr16_2_byte" : begin
		hsize = HALF_WORD; 
		incr16(32'd10,hsize,busy);
	end
	"wrap4_2_byte" : begin
		hsize = HALF_WORD; 
		wrap4(32'd10,hsize,busy);
	end
	"wrap8_2_byte" : begin
		hsize = HALF_WORD; 
		wrap8(32'd10,hsize,busy);
	end
	"wrap16_2_byte" : begin
		hsize = HALF_WORD; 
		wrap16(32'd10,hsize,busy);
	end
	"sanity_test_4_byte" : begin
		hsize = WORD; 
		Sanity_Test(32'd10,hsize,busy);
	end
	"incr4_4_byte" : begin
		hsize = WORD;
		incr4(32'd10,hsize,busy);
	end
	"incr8_4_byte" : begin
		hsize = WORD;
		incr8(32'd10,hsize,busy);
	end
	"incr16_4_byte" : begin
		hsize = WORD; 
		incr16(32'd10,hsize,busy);
	end
	"wrap4_4_byte" : begin
		hsize = WORD; 
		wrap4(32'd10,hsize,busy);
	end
	"wrap8_4_byte" : begin
		hsize = WORD; 
		wrap8(32'd10,hsize,busy);
	end
	"wrap16_4_byte" : begin
		hsize = WORD; 
		wrap16(32'd10,hsize,busy);
	end
	"sanity_test_8_byte" : begin
		hsize = DOUBLE_WORD; 
		Sanity_Test(32'd10,hsize,busy);
	end
	"incr4_8_byte" : begin
		hsize = DOUBLE_WORD;
		incr4(32'd10,hsize,busy);
	end
	"incr8_8_byte" : begin
		hsize = DOUBLE_WORD;
		incr8(32'd10,hsize,busy);
	end
	"incr16_8_byte" : begin
		hsize = DOUBLE_WORD;
		incr16(32'd10,hsize,busy);
	end
	"wrap4_8_byte" : begin
		hsize = DOUBLE_WORD;
		wrap4(32'd10,hsize,busy);
	end
	"wrap8_8_byte" : begin
		hsize = DOUBLE_WORD;
		wrap8(32'd10,hsize,busy);
	end
	"wrap16_8_byte" : begin
		hsize = DOUBLE_WORD;
		wrap16(32'd10,hsize,busy);
	end
	"incr_1_byte" : begin
		hsize = BYTE;
		un_incr(32'd10,hsize);
	end
	"incr_2_byte" : begin
		hsize = HALF_WORD;
		un_incr(32'd10,hsize);
	end
	"incr_4_byte" : begin
		hsize = WORD;
		un_incr(32'd10,hsize);
	end
	"incr_8_byte": begin
		hsize = DOUBLE_WORD;
		un_incr(32'd10,hsize);
	end
	"incr4_1_busy" : begin
		hsize = BYTE;
		busy = BUSY;
		incr4(32'd10,hsize,busy); 
	end
	"incr4_2_busy" : begin
		hsize = HALF_WORD;
		busy = BUSY;
		incr4(32'd10,hsize,busy); 
	end
	"incr4_4_busy" : begin
		hsize = WORD;
		busy = BUSY;
		incr4(32'd10,hsize,busy); 
	end
	"incr4_8_busy" : begin
		hsize = DOUBLE_WORD;
		busy = BUSY;
		incr4(32'd10,hsize,busy); 
	end
	"incr8_1_busy" : begin
		hsize = BYTE;
		busy = BUSY;
		incr8(32'd10,hsize,busy); 
	end
	"incr8_2_busy" : begin
		hsize = HALF_WORD;;
		busy = BUSY;
		incr8(32'd10,hsize,busy); 
	end
	"incr8_4_busy" : begin
		hsize = WORD;
		busy = BUSY;
		incr8(32'd10,hsize,busy); 
	end
	"incr8_8_busy" : begin
		hsize = DOUBLE_WORD;
		busy = BUSY;
		incr8(32'd10,hsize,busy); 
	end
	"incr16_1_busy" : begin
		hsize = BYTE;
		busy = BUSY;
		incr16(32'd10,hsize,busy); 
	end
	"incr16_2_busy" : begin
		hsize = HALF_WORD;
		busy = BUSY;
		incr16(32'd10,hsize,busy); 
	end
	"incr16_4_busy" : begin
		hsize = WORD;
		busy = BUSY;
		incr16(32'd10,hsize,busy); 
	end
	"incr16_8_busy" : begin
		hsize = DOUBLE_WORD;
		busy = BUSY;
		incr16(32'd10,hsize,busy); 
	end
	"wrap4_1_busy" : begin 
		busy = BUSY;
		hsize = BYTE;  
		wrap4(32'd10,hsize,busy); 
	end
	"wrap4_2_busy" : begin 
		busy = BUSY;
		hsize = HALF_WORD;  
		wrap4(32'd10,hsize,busy); 
	end
	"wrap4_4_busy" : begin 
		busy = BUSY;
		hsize = WORD;  
		wrap4(32'd10,hsize,busy); 
	end
	"wrap4_8_busy" : begin 
		busy = BUSY;
		hsize = DOUBLE_WORD;  
		wrap4(32'd10,hsize,busy); 
	end
	"wrap8_1_busy" : begin 
		busy = BUSY;
		hsize = BYTE;  
		wrap8(32'd10,hsize,busy); 
	end
	"wrap8_2_busy" : begin 
		busy = BUSY;
		hsize = HALF_WORD;  
		wrap8(32'd10,hsize,busy); 
	end
	"wrap8_4_busy" : begin 
		busy = BUSY;
		hsize = WORD;  
		wrap8(32'd10,hsize,busy); 
	end
	"wrap8_8_busy" : begin 
		busy = BUSY;
		hsize = DOUBLE_WORD;  
		wrap8(32'd10,hsize,busy); 
	end
	"wrap16_1_busy" : begin 
		busy = BUSY;
		hsize = BYTE;  
		wrap16(32'd10,hsize,busy); 
	end
	"wrap16_2_busy" : begin 
		busy = BUSY;
		hsize = HALF_WORD;  
		wrap16(32'd10,hsize,busy); 
	end
	"wrap16_4_busy" : begin 
		busy = BUSY;
		hsize = WORD;  
		wrap16(32'd10,hsize,busy); 
	end
	"wrap16_8_busy" : begin 
		busy = BUSY;
		hsize = DOUBLE_WORD;  
		wrap16(32'd10,hsize,busy); 
	end
endcase
end
///////////////////    Sanity operation task created  ///////////////////////// 
task Sanity_Test(input [31:0]addr,input [2:0]size,input[1:0]busy); 
begin  
hburst = SINGLE;
repeat(5) begin
	Write(addr,size,hburst,busy); 
	Read(addr,size,hburst,busy);
	addr=addr+1;
end
end 
endtask 
  
////////////////////// INCREMENT WRITE TASK /////////////
task incr_write(input [31:0]addr,input [2:0]size,input [2:0]burst,input[1:0]busy);
begin
	Write(addr,size,burst,busy);
end
endtask
//////////////////// INCREMENT READ TASK ////////////////
task incr_read(input [31:0]addr,input [2:0]size,input [2:0]burst,input[1:0]busy);
begin
	Read(addr,size,burst,busy);
end
endtask
////////////////////// INCR4 TASK /////////////////
task incr4(input [31:0]addr,input [2:0]size,input[1:0]busy);
begin
	hburst = INCR4;
	incr_write(addr,size,hburst,busy);
	incr_read(addr,size,hburst,busy);
end
endtask

////////////////////// INCR8 TASK /////////////////
task incr8(input [31:0]addr,input [2:0]size,input[1:0]busy);
begin
	hburst = INCR8;
	incr_write(addr,size,hburst,busy);
	incr_read(addr,size,hburst,busy);
end
endtask

////////////////////// INCR16 TASK ////////////////
task incr16(input [31:0]addr,input [2:0]size,input[1:0]busy);
begin
	hburst = INCR16;
	incr_write(addr,size,hburst,busy);
	incr_read(addr,size,hburst,busy);
end
endtask

////////////////////// WRAP4 TASK//////////////////
task wrap4(input [31:0]addr,input [2:0]size,input[1:0]busy);
begin
	hburst = WRAP4;
	wrap_write(addr,size,hburst,busy);
	wrap_read(addr,size,hburst,busy);
end
endtask

////////////////////WRAP8 TASK//////////////////
task wrap8(input [31:0]addr,input [2:0]size,input[1:0]busy);
begin
	hburst = WRAP8;
	wrap_write(addr,size,hburst,busy);
	wrap_read(addr,size,hburst,busy);
end
endtask

//////////////////WRAP16 TASK/////////////////
task wrap16(input [31:0]addr,input [2:0]size,input[1:0]busy);
begin
	hburst = WRAP16;
	wrap_write(addr,size,hburst,busy);
	wrap_read(addr,size,hburst,busy);
end
endtask

//------------------------------------------------------------------------------------------------------------------------------ 
//    Basic Write operation task created  
//------------------------------------------------------------------------------------------------------------------------------ 
// Write operation task created 
task Write(input [31:0] addr,input [2:0] size,input [2:0] burst,input[1:0]busy); 
begin 
  @(negedge hclk); 
  hsel = `HIGH; 
  htrans = NONSEQ; 
  hwrite = `WRITE; 
  hsize = size; 
  hburst = burst; 
  haddr = addr; 
  if(hburst <= SINGLE) begin 
  	i=1; 
  end 
  else if(hburst <= INCR4) begin 
  	i=4;
  	trans = SEQ; 
  end 
  else if(hburst <= INCR8) begin 
  	i=8;
	trans = SEQ; 
  end  
  else begin 
  	i=16;
	trans = SEQ;  
  end 
  repeat(i)begin 
  	@(negedge hclk); 
  	htrans = trans; 
  	if(hready == 1)  begin 
  		hwdata = $random; 
		if(count < i) begin 
			if(busy == BUSY && count == 3) begin
				htrans = BUSY;
				hwdata = hwdata;
				haddr = haddr;
				@(negedge hclk);
				busy = trans;
			end
			htrans = trans;
			haddr = (haddr + (2**size)); 
			count = (count + 1); 
		end 
 	end 
 end 
 i = 0; 
 count = 3'd1; 
 htrans = IDLE; 
end 
endtask 
  
//------------------------------------------------------------------------------------------------------------------------------ 
//    Basic Read operation task created 
//------------------------------------------------------------------------------------------------------------------------------   
// Read operation task created 
task Read(input [31:0] addr,input [2:0] size,input [2:0] burst,input[1:0]busy); 
begin 
  @(negedge hclk); 
  hsel = `HIGH; 
  htrans = NONSEQ; 
  hwrite = `READ; 
  hsize = size; 
  hburst = burst; 
  haddr = addr; 
  if(hburst <= SINGLE) begin 
  	i=1; 
  end 
  else if(hburst <= INCR4)begin 
  	i=4;
  	trans = SEQ; 
  end 
  else if(hburst <= INCR8) begin 
  	i=8;
	trans = SEQ;
  end  
  else begin 
  	i=16;
	trans = SEQ; 
  end  
  repeat(i)begin 
  	@(negedge hclk); 
  	htrans = trans; 
  	if(hready == 1)  begin 
		if(count<i) begin 
			if(busy == BUSY && count == 3) begin
				htrans = BUSY;
				hwdata = hwdata;
				haddr = haddr;
				@(negedge hclk);
				busy = trans;
			end
			htrans = trans;
			haddr = (haddr+(2**size)); 
			count = (count+1); 
			dout = hrdata; 
		end 
	end 
end 
  i=`LOW; 
  count = `SET; 
  htrans = IDLE; 
end 
endtask
///////////////////////// WRAP WRITE TASK ////////////////////////
task wrap_write(input [31:0]addr,input [2:0]size,input [2:0]burst,input[1:0]busy);
begin
  @(negedge hclk);
  haddr = addr;
  hwrite = `HIGH;
  hburst = burst;
  hsize = size;
  hsel = `HIGH;
  htrans = NONSEQ;
  if(hburst <= WRAP4) begin 
  	i=4;
	trans = SEQ; 
  end 
  else if(hburst <= WRAP8) begin 
  	i=8;
	trans = SEQ; 
  end 
  else begin 
  	i=16;
	trans = SEQ;
  end  
  j = 2 ** size;				// FOR ADDRESS INCREMENT 
  k = 2 ** ((hburst / 2) + 1);
  total = j * k; 				// FOR FINDING ALLIGN ADDRESS AND BOUNDARY
  allign_addr = haddr - (haddr % total);	// ALLIGN ADDRESS EQUATION
  boundary = allign_addr + total;		// BOUNDARY ADDRESS EQUATION
  repeat(i) begin
  	@(negedge hclk);
	htrans = trans;
 	if(hready == 1) begin
		hwdata = $random;
		if(count < i) begin 
			if(busy == BUSY && count == 3) begin
				htrans = BUSY;
				hwdata = hwdata;
				haddr = haddr;
				@(negedge hclk);
				busy = trans;
			end
			htrans = trans;
			if(haddr < boundary-1) begin
				haddr = (haddr + j); 
			end
			else begin
				haddr = allign_addr;
			end		
			count = (count + 1); 
		end 
	  end
  end
  count = `SET;
  i = `LOW;
  htrans = IDLE;
end
endtask

//reading data
task wrap_read(input [31:0]addr,input [2:0]size,input [2:0]burst,input[1:0]busy);
begin
  @(negedge hclk);
  hsel = `HIGH;
  hwrite = `LOW;
  hburst = burst;
  haddr = addr;
  htrans = NONSEQ;
  if(hburst <= WRAP4)begin 
  	i=4;
	trans = SEQ; 
  end 
  else if(hburst <= WRAP8)begin 
  	i=8;
	trans = SEQ; 
  end 
  else begin 
  	i=16;
 	trans = SEQ; 
  end 
  j = 2 ** size;
  k = 2 ** ((hburst / 2) + 1);
  total = j * k; 
  allign_addr = haddr - (haddr % total);
  boundary = allign_addr + total;
  repeat(i) begin
	@(negedge hclk);
	htrans = SEQ;
	if(hready == 1) begin
		if(count < i) begin
		if(busy == BUSY && count == 3) begin
				htrans = BUSY;
				hwdata = hwdata;
				haddr = haddr;
				@(negedge hclk);
				busy = trans;
				end
				htrans = trans;
		if(haddr < boundary - 1) begin
			haddr = (haddr + j);
			dout = hrdata; 
					end
		else begin
			haddr = allign_addr;
			dout = hrdata;
		end
		count = count + 1;	
	end
end 
end
  htrans = IDLE;
  @(negedge hclk); 
  dout = hrdata;
  i = `LOW;
  hsel = `LOW;
end
endtask



//////////////// UNDEFINE INCR //////////////
task un_incr(input [31:0]addr,input [2:0]size);
begin
 @(negedge hclk); 
  hsel = `HIGH; 
  htrans = NONSEQ; 
  hwrite = `WRITE; 
  hsize = size; 
  hburst = INCR; 
  haddr = addr; 
  i=$urandom_range(1,10);
  $display("i=%d",i);
  count=1; 
  repeat(i)begin 
  	@(negedge hclk); 
 	htrans = SEQ;  
	if(hready == 1) begin 
  		hwdata = $random; 
		if(count < i) begin 
			haddr = (haddr + (2**size)); 
			count = (count + 1); 
		end 
	end 
  end  
  count = 32'd1; 
  htrans = IDLE; 
/////////////////// FOR READING ////////////
  @(negedge hclk); 
  hsel = `HIGH; 
  htrans = NONSEQ; 
  hwrite = `READ; 
  hsize = size; 
  hburst = INCR; 
  haddr = addr; 
  repeat(i)begin 
  	@(negedge hclk); 
	htrans = SEQ; 
  	if(hready == 1)  begin 
		if(count<i) begin 
			haddr = (haddr+(2**size)); 
			count = (count+1); 
			dout = hrdata; 
		 end 
	end 
  end 
  i = `LOW; 
  count = `SET; 
  htrans = IDLE; 
end
endtask
// clock generate   
always #2 hclk = ~hclk; 
  
initial begin 
	$dumpfile("AHB.vcd"); 
	$dumpvars(0); 
	#2000 $finish; 
end 
endmodule 
