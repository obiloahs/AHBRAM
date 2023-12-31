`ifndef RKV_AHBRAM_SINGLE_WRITE_SEQ_SV
`define RKV_AHBRAM_SINGLE_WRITE_SEQ_SV

class rkv_ahbram_single_write_seq extends rkv_ahbram_base_element_sequence;
  rand bit [31:0]      addr;
  rand bit [31:0]      data;
  rand burst_size_enum bsize;
  constraint single_write_cstr {
    soft addr[1:0] == 0;
    soft bsize == BURST_SIZE_32BIT;
  }
  `uvm_object_utils(rkv_ahbram_single_write_seq)
  function new (string name = "rkv_ahbram_single_write_seq");
    super.new(name);
  endfunction
  virtual task body();
    lvc_ahb_master_single_trans ahb_single;
    `uvm_info("body", "Entered...", UVM_LOW)
    `uvm_do_on_with(ahb_single, p_sequencer.ahb_mst_sqr, /*在这里直接挂在到rkv_ahbram_virtual_seequencer上了，
															那么以后遇到的sing_write的seq都不需要另外挂载*/
                    {addr == local::addr; data == local::data; xact == WRITE; bsize == local::bsize;}
                   )
    `uvm_info("body", "Exiting...", UVM_LOW)
  endtask

endclass

`endif // RKV_AHBRAM_SINGLE_WRITE_SEQ_SV
