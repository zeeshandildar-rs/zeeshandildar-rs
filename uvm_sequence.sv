class mem_sequence_item extends uvm_sequence_item;
    rand bit [3:0] mem_addr;
    rand bit       wr_en;
    rand bit       rd_en;

    rand bit [7:0] wr_data;

         bit [7:0] rd_data;
    
    `uvm_object_utils_begin(mem_sequence_item)
        `uvm_field_int(mem_addr, UVM_ALL_ON)
        `uvm_field_int(wr_en, UVM_ALL_ON)
        `uvm_field_int(rd_en, UVM_ALL_ON)
        `uvm_field_int(wr_data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "mem_sequence_item");
        super.new(name);
    endfunction

    constraint wr_rd_c { wr_en != rd_en; };

    endclass

class mem_sequence extends uvm_sequence#( uvm_sequence_item);

    `uvm_object_utils(mem_sequence_item)

    //constructor
    function new(string name = "mem_sequence_item);
        super.new(name);
    endfunction

    virtual task body();
        req = mem_sequence_item::type_id::create("req"); //create the req (seq_item)

        wait_for_grant();
        assert(req.randomize());
        send_request(req);
        wait_for_item_done();
        get_response(rsp);
    endtask
endclass

    // simple testbench
    
    module seq_item_tb;

    mem_sequence_item seq_item;

    initial begin
        seq_item = mem_sequence_item::type_id::create("seq_item")'
        seq_item.randomize();
        seq_item.print();
    end

    endmodule
