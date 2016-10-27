module adc (clk, reset, ena, cs, out, in, clk_out);

/*
                   ____________
 clk     -------->|            |--------> busy                          |
 reset   -------->|            |--------> ack_error                     |CONTROL SIGNALS 
 ena     -------->|            |                                        |
                  | i2c_master |
                  |            |--------> data_rd                       |
                  |            |<-------> sda                           |DATA SIGNALS
                  |____________|                                        |

*/


endmodule
