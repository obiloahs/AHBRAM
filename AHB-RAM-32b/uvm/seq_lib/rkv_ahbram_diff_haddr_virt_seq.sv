`ifndef RKV_AHBRAM_DIFF_HADDR_VIRT_SEQ_SV
`define RKV_AHBRAM_DIFF_HADDR_VIRT_SEQ_SV


class rkv_ahbram_diff_haddr_virt_seq extends rkv_ahbram_base_virtual_sequence;
  `uvm_object_utils(rkv_ahbram_diff_haddr_virt_seq)

  function new (string name = "rkv_ahbram_diff_haddr_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit [31:0] addr, data;
    super.body();
    `uvm_info("body", "Entered...", UVM_LOW)
    for(int i=0; i<(cfg.addr_end >>8); i++) begin /*默认的bsize是8bit，偏移地址可以是0，1,2，3；
												  这里为什么又仪8位（产生太多数据导致仿真速度下降？）*/
      std::randomize(addr) with {addr[1:0] == 0; addr inside {[cfg.addr_start:cfg.addr_end]};};
      std::randomize(wr_val) with {wr_val == (i << 8) + i;};// 这里只是随机化data的方式，随机出来的data inside{}
      data = wr_val;
      `uvm_do_with(single_write, {addr == local::addr; data == local::data;})
      `uvm_do_with(single_read, {addr == local::addr;})
      rd_val = single_read.data;
      compare_data(wr_val, rd_val);
    end
    `uvm_info("body", "Exiting...", UVM_LOW)
  endtask

endclass


`endif 
