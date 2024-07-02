`include "define.sv"
class ram_reference_model;
//PROPERTIES
 //Ram transaction class handle
 ram_transaction ref_trans;
 //Mailbox for reference model to scoreboard connection
 mailbox #(ram_transaction) mbx_rs;
 //Mailbox for driver to reference model connection
 mailbox #(ram_transaction) mbx_dr;
 //Virtual interface with reference model modport and its instance
 virtual ram_if.REF_SB vif;
 //2-D array used for RAM storage
 reg [`DATA_WIDTH-1:0] MEM [`DATA_DEPTH-1:0];
//METHODS
 //Explicitly overriding the constructor to make a mailbox connection from driver
 //to reference model, a mailbox connection from reference model to scoreboard
 //and to connect the virtual interface from reference model to enviornment 
 function new(mailbox #(ram_transaction) mbx_dr,
 mailbox #(ram_transaction) mbx_rs,
 virtual ram_if.REF_SB vif);
 this.mbx_dr=mbx_dr;
 this.mbx_rs=mbx_rs;
 this.vif=vif;
 endfunction
   //Task which mimics the functionality of the RAM
 task start();
 for(int i=0;i<`num_transactions;i++)
 begin
 ref_trans=new();
 //getting the driver transaction from mailbox 
 mbx_dr.get(ref_trans);
 repeat(1) @(vif.ref_cb)
 begin 
 if(ref_trans.write_enb)
 MEM[ref_trans.address]=ref_trans.data_in;
 $display("REFERENCE MODEL DATA IN MEMORY MEM[%0h]=%0h",
ref_trans.address,MEM[ref_trans.address],$time);
 if(ref_trans.read_enb)
 ref_trans.data_out=MEM[ref_trans.address];
 $display("REFERENCE MODEL DATA OUT FROM MEMORY data_out=%0h",ref_trans.data_out,$time);
 end
 //Putting the reference model transaction to mailbox 
 mbx_rs.put(ref_trans);
 end 
 endtask
endclass


