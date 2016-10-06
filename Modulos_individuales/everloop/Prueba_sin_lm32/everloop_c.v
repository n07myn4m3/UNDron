module everloop (
  input clk,rst,
  // Memory signals
  output reg [7:0] address,
  input [7:0] data_RGB,
  // Led control signal
  output reg everloop_d
);

reg [14:0]clk_cnt;

reg send_hi;
reg send_low;
reg send_rst;
reg start_send;
reg finish_send;
reg [3:0] bit_count;
reg [7:0]data;


//type state_type is (INIT, LD_DATA, CHECK, SEND_ONE,
//                    SEND_ZERO, SEND_RESET, NEXT_BIT, WAIT_SEND, 
//                    NEXT_BYTE, WAIT_RESET);
//);


parameter INIT      = 4'b0000, LD_DATA    = 4'b0001, CHECK    = 4'b0010, SEND_ONE  = 4'b0011,
          SEND_ZERO = 4'b0100, SEND_RESET = 4'b0101, NEXT_BIT = 4'b0110, WAIT_SEND = 4'b0111, 
          NEXT_BYTE = 4'b1000, WAIT_RESET = 4'b1001;

reg [3:0] state;


always @ (posedge clk) begin
  if (rst) begin
    send_hi    <= 0;
    send_low   <= 0;
    send_rst   <= 0;
    start_send <= 0;
    address    <= 0;
    bit_count  <= 0;
    data       <= 0;
    state      <= INIT;    
  end // end main if
  else begin
    case(state)
      INIT: begin
        send_hi    <= 0;
        send_low   <= 0;
        send_rst   <= 0;
        start_send <= 0;
        address    <= 0;
        bit_count  <= 0;
        data       <= 0;
        state      <= LD_DATA;
      end

      LD_DATA: begin
        send_hi    <= 0;
        send_low   <= 0;
        send_rst   <= 0;
        start_send <= 0;
        address    <= address;
        bit_count  <= 0;
        data       <= data_RGB;
        state      <= CHECK;
      end

      CHECK: begin
        send_hi    <= 0;
        send_low   <= 0;
        send_rst   <= 0;
        start_send <= 0;
        address    <= address;
        bit_count  <= bit_count;
        data       <= data;
        if (data[7])
          state      <= SEND_ONE;
        else
          state      <= SEND_ZERO;
      end


      SEND_ONE: begin
        send_hi    <= 1;
        send_low   <= 0;
        send_rst   <= 0;
        start_send <= 0;
        address    <= address;
        bit_count  <= bit_count;
        data       <= data;
        state      <= WAIT_SEND;
      end

      SEND_ZERO: begin
        send_hi    <= 0;
        send_low   <= 1;
        send_rst   <= 0;
        start_send <= 0;
        address    <= address;
        bit_count  <= bit_count;
        data       <= data;
        state      <= WAIT_SEND;
      end

      WAIT_SEND: begin
        send_hi    <= 0;
        send_low   <= 0;
        send_rst   <= 0;
        start_send <= 0;
        address    <= address;
        if (finish_send) begin
          bit_count <= bit_count + 1;
          data      <= data << 1;
          state     <= NEXT_BIT;
        end else begin
          bit_count <= bit_count;
          data      <= data;
          state     <= WAIT_SEND;
        end
      end


      NEXT_BIT: begin
        send_hi    <= 0;
        send_low   <= 0;
        send_rst   <= 0;
        start_send <= 0;
        bit_count  <= bit_count;
        data       <= data;
        if (bit_count == 4'b1000) begin
          state    <= NEXT_BYTE;
          address  <= address + 1;
        end else begin
          state    <= CHECK;
          address  <= address;
        end
      end

      NEXT_BYTE: begin
        send_hi    <= 0;
        send_low   <= 0;
        send_rst   <= 0;
        start_send <= 0;
        address    <= address;
        bit_count  <= bit_count;
        data       <= data;
        if (address == 8'd141)
          state    <= SEND_RESET;
        else
          state    <= LD_DATA;
      end


      SEND_RESET: begin
        send_hi    <= 0;
        send_low   <= 0;
        send_rst   <= 1;
        start_send <= 0;
        address    <= address;
        bit_count  <= bit_count;
        data       <= data;
        state      <= WAIT_RESET;
      end

      WAIT_RESET: begin
        send_hi    <= 0;
        send_low   <= 0;
        send_rst   <= 0;
        start_send <= 0;
        address    <= address;
        bit_count  <= bit_count;
        data       <= data;
        if (finish_send)  
          state    <= INIT;
        else
          state    <= WAIT_RESET;
      end

      default: begin
        send_hi    <= 0;
        send_low   <= 0;
        send_rst   <= 0;
        start_send <= 0;
        address    <= 0;
        bit_count  <= 0;
        data       <= 0;
        state      <= INIT;
      end
   endcase

  end // end else 
end


//clk_cnt


parameter WAIT_INIT = 2'b00, WAIT_ONE =2'b01, WAIT_ZERO = 2'b10, EXIT = 2'b11;
reg [1:0] send_state;
reg [7:0] ones_count;
reg [14:0] zeros_count;


always @ (negedge clk) begin
  if (rst) begin
    finish_send  <= 1'b0;
    send_state   <= WAIT_INIT;
    clk_cnt      <= 0;  
    everloop_d   <= 0;  
    ones_count   <= 0;
    zeros_count  <= 0;
  end // end main if
  else begin
    case (send_state)
      WAIT_INIT: begin
        finish_send  <= 1'b0;
        clk_cnt      <= 0;
        everloop_d   <= 1;           // Always start with 1  4 clock cicles before count increment
        if(send_hi || send_low || send_rst) begin
          case ({send_hi, send_low, send_rst})
            3'b100: begin
              ones_count  <= 8'd30;  //Debe durar 6 us
              zeros_count <= 13'd30; //Debe durar 6 us
            end
            3'b010: begin
              ones_count  <= 8'd15;   //Debe durar 3 us
              zeros_count <= 13'd45; //Debe durar 9 us
            end
            3'b001: begin
              ones_count  <= 0;
              zeros_count <= 15'd400; //Debe durar 80 us
            end
             default: begin
              ones_count  <= 0;
              zeros_count <= 0;
             end
          endcase
          send_state   <= WAIT_ONE;
        end else
          send_state   <= WAIT_INIT;
      end

      WAIT_ONE: begin
        zeros_count  <= zeros_count;
        ones_count   <= ones_count;
        finish_send  <= 1'b0;
        everloop_d   <= 1;
        clk_cnt      <= clk_cnt + 1;
        if (clk_cnt == ones_count) begin
          send_state   <= WAIT_ZERO;
          clk_cnt      <= 0;
        end else
          send_state   <= WAIT_ONE;
      end
      
      WAIT_ZERO: begin
        zeros_count  <= zeros_count;
        ones_count   <= ones_count;
        finish_send  <= 1'b0;
        everloop_d   <= 0;
        clk_cnt      <= clk_cnt + 1;
        if (clk_cnt == zeros_count) begin
          send_state   <= EXIT;
          clk_cnt      <= 0;
        end else
          send_state   <= WAIT_ZERO;
      end

      EXIT: begin
        zeros_count  <= zeros_count;
        ones_count   <= ones_count;
        finish_send  <= 1'b1;
        everloop_d   <= 0;
        clk_cnt      <= 0;
        send_state   <= WAIT_INIT;
      end

      default: begin
        zeros_count  <= zeros_count;
        ones_count   <= ones_count;
        finish_send  <= 1'b0;
        everloop_d   <= 0;
        clk_cnt      <= 0;
        send_state   <= WAIT_INIT;
      end
    endcase
  end // end else
end // end always


endmodule
