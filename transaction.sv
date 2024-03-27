// transaction.sv
`ifndef TRANSACTION_SV
`define TRANSACTION_SV

class transaction;
    rand bit [1:0] a,b;
    bit [2:0] c;

    function void display(string str);
        $display("%0s",str);
        $display("a = %0d b = %0d c=%0d",a,b,c);
    endfunction

    function void randm;
        a = $random;
        b = $random;
    endfunction
endclass

`endif // TRANSACTION_SV

