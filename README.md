# Mixed Signal Circuit Design and Simulation Marathon using eSim and SKY130.
# Handshake Based Pulse Synchronizer
- [Abstract](#abstract)
- [Reference Circuit Diagram](#reference-circuit-diagram)
- [Reference Waveform](#reference-waveform)
- [Circuit Details](#circuit-details)
- [Software Used](#software-used)
  * [eSim](#esim)
  * [NgSpice](#ngspice)
  * [Makerchip](#makerchip)
  * [Verilator](#verilator)
- [Circuit Diagram in eSim](#circuit-diagram-in-esim)
- [Verilog Code](#verilog-code)
- [Makerchip](#makerchip-1)
- [Makerchip Plots](#makerchip-plots)
- [Netlists](#netlists)
- [NgSpice Plots](#ngspice-plots)
- [Steps to run generate NgVeri Model](#steps-to-run-generate-ngveri-model)
- [Steps to run this project](#steps-to-run-this-project)
- [Acknowlegdements](#acknowlegdements)
- [References](#references)

## Abstract
A modern SoC has multiple clock domains. If these different clock domains are not properly synchronized, metastability events are bound to happen and may result in inappropriate behavior of the SoC. A Synchronizer help us to mitigate/reduce the effect of metastability. A synchronizer is a digital circuit that converts signal from a different clock domain into the recipient clock domain so that it can be captured without introducing any metastability failure. There are different types of synchronizers used in various situations such as:
• Flip-flop based synchronizer (Two flip-flop synchronizer)
• Handshaking based synchronizers
• Mux based synchronizers
• Two clock FIFO synchronizer.

This project presents the design of a handshake based pulse synchronizer that is used to synchronize a pulse generated in source clock domain to destination clock domain. A pulse cannot be synchronized directly using 2 Flip Flop synchronizer, while synchronizing from fast clock domain to slow clock domain using 2 Flip Flop synchronizer, the pulse can be skipped which can cause the loss of pulse detection & hence subsequent circuit which depends upon it, may not function properly. In handshake based pulse synchronizer, synchronization of a pulse generated into source clock domain is guaranteed into destination clock domain by providing an acknowledgement. This method of providing an acknowledgement overcomes the drawback of pulse synchronizer.

## Reference Circuit Diagram
![image](https://user-images.githubusercontent.com/58168687/194339951-9dfbf521-ee26-4ba6-b2ab-0aaa0eb063c5.png)
## Reference Waveform
![image](https://user-images.githubusercontent.com/58168687/194340000-98516602-2577-45dd-8ebb-ee8b41cd6e03.png)

## Circuit Details
The circuit is divided into two namely, digital and analog part which cumulatively makes up the mixed signal circuit. The digital part is composed of a set of flip flops clocked at different frequencies, a set of 2:1 MUX, a NOT gate and an OR gate. The analog portion is comprised of AND gate implemented using CMOS logic. The pulse signal in clock domain A cannot be directly passed to clock domain B, so we first convert the pulse to a level signal. This method ensures that pulse signal is passed from fast clock domain to a slower clock domain without any error. On the other side, we use an AND gate to recreate the pulse signal in another clock domain. 

## Software Used
### eSim
It is an Open Source EDA developed by FOSSEE, IIT Bombay. It is used for electronic circuit simulation. It is made by the combination of two software namely NgSpice and KiCAD.
</br>
For more details refer:
</br>
https://esim.fossee.in/home
### NgSpice
It is an Open Source Software for Spice Simulations. For more details refer:
</br>
http://ngspice.sourceforge.net/docs.html
### Makerchip
It is an Online Web Browser IDE for Verilog/System-verilog/TL-Verilog Simulation. Refer
</br> https://www.makerchip.com/
### Verilator
It is a tool which converts Verilog code to C++ objects. Refer:
https://www.veripool.org/verilator/

## Circuit Diagram in eSim
The following is the schematic in eSim:
![hbp_sync_schematic](https://user-images.githubusercontent.com/58168687/194341578-be5da844-6085-4b90-9631-d5e0e5818577.PNG)
## Verilog Code
```
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

```
## Makerchip
```
\TLV_version 1d: tl-x.org
\SV
/* verilator lint_off UNUSED*/  /* verilator lint_off DECLFILENAME*/  /* verilator lint_off BLKSEQ*/  /* verilator lint_off WIDTH*/  /* verilator lint_off SELRANGE*/  /* verilator lint_off PINCONNECTEMPTY*/  /* verilator lint_off DEFPARAM*/  /* verilator lint_off IMPLICIT*/  /* verilator lint_off COMBDLY*/  /* verilator lint_off SYNCASYNCNET*/  /* verilator lint_off UNOPTFLAT */  /* verilator lint_off UNSIGNED*/  /* verilator lint_off CASEINCOMPLETE*/  /* verilator lint_off UNDRIVEN*/  /* verilator lint_off VARHIDDEN*/  /* verilator lint_off CASEX*/  /* verilator lint_off CASEOVERLAP*/  /* verilator lint_off PINMISSING*/    /* verilator lint_off BLKANDNBLK*/  /* verilator lint_off MULTIDRIVEN*/    /* verilator lint_off WIDTHCONCAT*/  /* verilator lint_off ASSIGNDLY*/  /* verilator lint_off MODDUP*/  /* verilator lint_off STMTDLY*/  /* verilator lint_off LITENDIAN*/  /* verilator lint_off INITIALDLY*/ 

//Your Verilog/System Verilog Code Starts Here:
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
		assign clk_a = clk;
		
		assign rst = reset;
		integer count;
      always @ (posedge clk) begin
         count =count+1;
         if(count%3==0)begin
         assign clk_b = count;
            end
		if(busy == 1) begin
      assign pulse_in = 0;   
      end
         else begin
		assign pulse_in = 1;
            end
         end
		pavan_handshake_pulse_sync_update pavan_handshake_pulse_sync_update(.ff_b2_out(ff_b2_out), .not_out(not_out), .busy(busy), .clk_a(clk_a), .clk_b(clk_b), .rst(rst), .pulse_in(pulse_in));
	
\TLV
//Add \TLV here if desired                                     
\SV
endmodule

```
## Makerchip Plots
![makerchip_out](https://user-images.githubusercontent.com/58168687/194343073-c5b45276-d64a-46e6-ba63-c520ead94a24.PNG)

## Netlists
![netlist_1](https://user-images.githubusercontent.com/58168687/194343976-0781bc7e-037e-4e22-93f7-71ca6820a543.PNG)
![netlist_2](https://user-images.githubusercontent.com/58168687/194344041-2643cd50-6cbc-4c6d-8a9f-bac749e012f9.PNG)

## NgSpice Plots
![hbp_sync_out](https://user-images.githubusercontent.com/58168687/194344113-41d6a9f3-5ab3-49bf-baeb-10298ee73cbd.PNG)
```
From the waveform, it is observed that the pulse signal is synchronized from clock domain A to clock domain B. 
"**and_out**" is the synchronized output in clock domain B. Also, it is noted that busy signal is asserted to indicate source of the pulse to not generate another pulse until the current pulse is synchronized.
```
![image](https://user-images.githubusercontent.com/58168687/194345005-ef0042a4-124d-44c6-9b98-bf1b02da3af1.png)
![image](https://user-images.githubusercontent.com/58168687/194345271-e258b231-a41c-4fd9-a8b0-2c616c648d66.png)

## Steps to run generate NgVeri Model
1. Open eSim
2. Run NgVeri-Makerchip 
3. Add top level verilog file in Makerchip Tab
4. Click on NgVeri tab
5. Add dependency files
6. Click on Run Verilog to NgSpice Converter
7. Debug if any errors
8. Model created successfully
## Steps to run this project
1. Open a new terminal
2. Clone this project using the following command:</br>
```git clone https://github.com/PavanDheeraj/Pavan_Mixed_Signal_Marathon.git ```</br>
3. Change directory:</br>
```cd hbp_sync```</br>
4. Run ngspice:</br>
```ngspice hbp_sync.cir.out```</br>
5. To run the project in eSim:

  - Run eSim</br>
  - Load the project</br>
  - Open eeSchema</br>
## Acknowlegdements
1. FOSSEE, IIT Bombay
2. Steve Hoover, Founder, Redwood EDA
3. Kunal Ghosh, Co-founder, VSD Corp. Pvt. Ltd. - kunalpghosh@gmail.com
4. Sumanto Kar, eSim Team, FOSSEE

## References
1. https://www.edn.com/synchronizer-techniques-for-multi-clock-domain-socs-fpgas
2. https://github.com/Eyantra698Sumanto/Two-in-One-Low-power-XOR-XNOR-Gate.git

