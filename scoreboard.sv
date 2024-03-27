`include "transaction.sv"

class scoreboard;
    
  // Creating mailbox handle
  mailbox #(transaction) mon2scb;
   
  // Used to count the number of transactions
  int no_transactions;
   
  // Constructor
  function new(mailbox #(transaction) mon2scb);
    // Getting the mailbox handles from environment
    this.mon2scb = mon2scb;
  endfunction
   
  // Compares the Actual result with the expected result
  task main();
    transaction trans;
    forever begin
      mon2scb.get(trans);
      if ((trans.a + trans.b) == trans.c)
          $display("Result is as Expected");
      else
        $error("Wrong Result.\n\tExpected: %0d Actual: %0d", (trans.a + trans.b), trans.c);
       
      no_transactions++;
      trans.display("[ Scoreboard ]");
    end
  endtask
   
endclass

