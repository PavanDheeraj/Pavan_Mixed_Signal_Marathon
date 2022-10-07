// Author: Pavan Dheeraj K
// Version: 1

`timescale 1ns/1ps

module pavan_handshake_pulse_sync_update(
output reg ff_b2_out,
output not_out,
output busy,
input clk_a,
input clk_b,
input rst,
input pulse_in
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
