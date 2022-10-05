\TLV_version 1d: tl-x.org
\SV
/* verilator lint_off UNUSED*/  /* verilator lint_off DECLFILENAME*/  /* verilator lint_off BLKSEQ*/  /* verilator lint_off WIDTH*/  /* verilator lint_off SELRANGE*/  /* verilator lint_off PINCONNECTEMPTY*/  /* verilator lint_off DEFPARAM*/  /* verilator lint_off IMPLICIT*/  /* verilator lint_off COMBDLY*/  /* verilator lint_off SYNCASYNCNET*/  /* verilator lint_off UNOPTFLAT */  /* verilator lint_off UNSIGNED*/  /* verilator lint_off CASEINCOMPLETE*/  /* verilator lint_off UNDRIVEN*/  /* verilator lint_off VARHIDDEN*/  /* verilator lint_off CASEX*/  /* verilator lint_off CASEOVERLAP*/  /* verilator lint_off PINMISSING*/  /* verilator lint_off LATCH*/  /* verilator lint_off BLKANDNBLK*/  /* verilator lint_off MULTIDRIVEN*/  /* verilator lint_off NULLPORT*/  /* verilator lint_off EOFNEWLINE*/  /* verilator lint_off WIDTHCONCAT*/  /* verilator lint_off ASSIGNDLY*/  /* verilator lint_off MODDUP*/  /* verilator lint_off STMTDLY*/  /* verilator lint_off LITENDIAN*/  /* verilator lint_off INITIALDLY*/  /* verilator lint_off */  

//Your Verilog/System Verilog Code Starts Here:
`timescale 1ns/1ps

module pavan_handshake_pulse_sync_update(
output reg ff_b2_out,
output not_out,
output busy,
input clk_a,
input clk_b,
input rst,
input pulse_in,
);
 


wire mux1_out;
wire mux2_out;

reg ff_a1_out;
reg ff_a2_out;
reg ff_a3_out;   
reg ff_b1_out;
//reg ff_b2_out;
reg ff_b3_out;   

// combo block  
  
  assign mux1_out=(ff_a3_out)?1'b0:ff_a1_out;
assign mux2_out=(pulse_in)?1'b1:mux1_out;
  
// seq block

always @ (posedge clk_a or posedge rst)
 begin
   if(rst)
     begin
       ff_a1_out <= 1'b0;
  	   ff_a2_out <= 1'b0;
       ff_a3_out <= 1'b0;  
     
     end
   else
     begin
  		ff_a1_out <= mux2_out;
  		ff_a2_out <= ff_b2_out;
 	    ff_a3_out <= ff_a2_out;    
     end
 end
  
always @ (posedge clk_b or posedge rst)
 begin
   if(rst)
     begin
       ff_b1_out <= 1'b0;
  	   ff_b2_out <= 1'b0;
       ff_b3_out <= 1'b0;  
     
     end
   else
     begin
  ff_b1_out <= ff_a1_out;
  ff_b2_out <= ff_b1_out;
  ff_b3_out <= ff_b2_out;    
     end
  end
   

// not gate output 

assign not_out = ~ff_b3_out;

// busy signal to pulse generator

assign busy = ff_a3_out | ff_a1_out;
  
endmodule


//Top Module Code Starts here:
	module top(input logic clk, input logic reset, input logic [31:0] cyc_cnt, output logic passed, output logic failed);
		logic  ff_b2_out;//output
		logic  not_out;//output
		logic  busy;//output
		logic  clk_a;//input
		logic  clk_b;//input
		logic  rst;//input
		logic  pulse_in;//input
//The $random() can be replaced if user wants to assign values
		assign clk_a = $random();
		assign clk_b = $random();
		assign rst = $random();
		assign pulse_in = $random();
		pavan_handshake_pulse_sync_update pavan_handshake_pulse_sync_update(.ff_b2_out(ff_b2_out), .not_out(not_out), .busy(busy), .clk_a(clk_a), .clk_b(clk_b), .rst(rst), .pulse_in(pulse_in));
	
\TLV
//Add \TLV here if desired                                     
\SV
endmodule

