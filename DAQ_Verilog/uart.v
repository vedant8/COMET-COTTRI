`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2017 15:23:39
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart(
        input clk200_p,
        input uart_rx,
        output uart_tx,
        input clk200_n,
        input spi_miso,
        input cpu_rst,
        output [7:0] led,
        output reg spi_mosi,
        output reg spi_cs_b,
        output reg LCD_RS,
        output reg LCD_E,
        output reg LCD_RW,
        output reg LCD_DB7,
        output reg LCD_DB6,
        output reg LCD_DB5,
        output reg LCD_DB4

       
    );
   
wire        clk200;

reg clk1;
wire clk;
// converting differential 200MHz clock to single ended 200MHz clock
IBUFGDS diff_clk_buffer(
      .I(clk200_p),
      .IB(clk200_n),
      .O(clk200));
      
//converting single ended 200MHz clock to single ended 100MHz clock      
always@(posedge clk200)
begin
clk1<=~clk1;
end

   //BUFG used to reach the entire device with 100MHz
  BUFG clock_divide ( 
      .I(clk1),
      .O(clk));
      
      
 
                // Signals used to connect UART_TX6
                //
                reg[7:0] a[0:15];
                wire [7:0]   uart_tx_data_in ;
                wire write_to_uart_tx;
                wire uart_tx_data_present ;
                wire  uart_tx_half_full ;
                wire uart_tx_full;
                reg    uart_tx_reset;
                
                // Signals used to connect UART_RX6
                
                wire [7:0]   uart_rx_data_out;
                reg read_from_uart_rx ;
                wire uart_rx_data_present ;
                wire  uart_rx_half_full ;
                wire uart_rx_full;
                reg    uart_rx_reset;
                
                //Signals used to define baud rate
                reg [53:0] baud_count ; 
                reg  en_16_x_baud=0 ;
                
              //uart protocols-baud rate
              always@(posedge clk)
              begin
              if(baud_count==54)//115200 baud rate, 54 clock cycles at 100MHz
              begin
              baud_count<=0;
              en_16_x_baud<=1;
              end else begin
              baud_count<=baud_count+1;
              en_16_x_baud<=0;
              end
              end  
              reg spi_clk;
                            
                      //CCLK driver
                       STARTUPE2
                      #(
                      .PROG_USR("FALSE"),
                      .SIM_CCLK_FREQ(0.0)
                      )
                        STARTUPE2_inst
                      (
                        .CFGCLK     (),//so that it doesn't get deleted
                        .CFGMCLK    (),
                        .EOS        (),
                        .PREQ       (),
                        .CLK        (1'b0),
                        .GSR        (1'b0),
                        .GTS        (1'b0),
                        .KEYCLEARB  (1'b0),
                        .PACK       (1'b0),
                        .USRCCLKO   (spi_clk),  // First three cycles after config ignored, see AR# 52626
                        .USRCCLKTS  (1'b0),     // 0 to enable CCLK output
                        .USRDONEO   (1'b1),     // Shouldn't matter if tristate is high, but generates a warning if tied low.
                        .USRDONETS  (1'b1)      // 1 to tristate DONE output
                      );
              //UART Transmitter Instantiation
              uart_tx6 tx(
              .data_in(uart_tx_data_in),
              .en_16_x_baud(en_16_x_baud),
              .serial_out(uart_tx),
              .buffer_write(write_to_uart_tx),
              .buffer_data_present(uart_tx_data_present),
              .buffer_half_full(uart_tx_half_full),
              .buffer_full(uart_tx_full),
              .buffer_reset(uart_tx_reset),
              .clk(clk)
              );
              
              //UART Receiver Instantiation
                uart_rx6 rx(
                .serial_in(uart_rx),
                .en_16_x_baud(en_16_x_baud),
                .data_out(uart_rx_data_out),
                .buffer_read(read_from_uart_rx),
                .buffer_data_present(uart_rx_data_present),
                .buffer_half_full(uart_rx_half_full),
                .buffer_full(uart_rx_full),
                .buffer_reset(uart_rx_reset),
                .clk(clk)
                );
                //signals for KCPSM6     
                    wire    [11:0]  address;
                    wire    [17:0]    instruction;
                    wire            bram_enable;
                    wire   [7:0]    port_id;
                    wire   [7:0]    out_port;
                    reg    [7:0]    in_port;
                    wire            write_strobe;
                    wire            k_write_strobe;
                    wire            read_strobe;
                    wire            interrupt;            //See note above
                    wire            interrupt_ack;
                    wire            kcpsm6_sleep;         //See note above
                    wire            kcpsm6_reset;         //See note above
                        wire rdl;
                        
                    kcpsm6 #(
                         .hwbuild        (8'h42),
                        .interrupt_vector    (12'h7F0),
                        .scratch_pad_memory_size(256)
                        )
                      processor (
                        .address         (address),
                        .instruction     (instruction),
                        .bram_enable     (bram_enable),
                        .port_id         (port_id),
                        .write_strobe     (write_strobe),
                        .k_write_strobe     (k_write_strobe),
                        .out_port         (out_port),
                        .read_strobe     (read_strobe),
                        .in_port         (in_port),
                        .interrupt         (interrupt),
                        .interrupt_ack     (interrupt_ack),
                        .reset         (kcpsm6_reset),
                        .sleep        (kcpsm6_sleep),
                        .clk             (clk)); 
                         
                         assign  kcpsm6_reset = cpu_rst || rdl;
                         assign kcpsm6_sleep = write_strobe && k_write_strobe;
                         assign interrupt = interrupt_ack;
                         
                         
                        //signals for N25Q128 interface
                                
                                      
                        core #(
                        .C_JTAG_LOADER_ENABLE(1),
                        .C_FAMILY("7S"),
                        .C_RAM_SIZE_KWORDS(2)
                        )
                        program_rom (
                        .address(address),
                        .instruction(instruction),
                        .enable(bram_enable),
                        .rdl(rdl),
                        .clk(clk)
                        );
                        
                
                            /////////////////////////////////////////////////////////////////////////////////////////
                            // General Purpose Input Ports. 
                            /////////////////////////////////////////////////////////////////////////////////////////
                            //
                            // Two input ports are used with the UART macros. The first is used to monitor the flags
                            // on both the transmitter and receiver. The second is used to read the data from the 
                            // receiver and generate the 'buffer_read' pulse.
                            //
                            
                      assign led= out_port;
                            always@(posedge clk)
                                      begin
                                      case(port_id[1:0])
                                       2'b00:begin
                                                  in_port[0] <= uart_tx_data_present;
                                                 in_port[1] <= uart_tx_half_full;
                                                 in_port[2] <= uart_tx_full; 
                                                 in_port[3] <= uart_rx_data_present;
                                                 in_port[4] <= uart_rx_half_full;
                                                 in_port[5] <= uart_rx_full;
                                              end
                                        2'b01: begin
                                              in_port <= uart_rx_data_out;
                                              end
                                       2'b11: begin
                                       
                                               in_port <= {spi_miso,7'b0000000};  
                                               end
                                         default:
                                              in_port <= 8'b11111111; 
                                        endcase 
                                        
                                        if((port_id[1:0]==2'b01)&&(read_strobe==1))begin
                                        read_from_uart_rx <=1'b1;
                                        end else begin
                                        read_from_uart_rx <= 1'b0;
                                        end          
                                      end
                         
                       

                        always@(posedge clk)
                begin
                if (write_strobe==1)
                    begin
                     if(port_id[2]==1)begin
                     spi_clk<=out_port[0];
                     spi_cs_b<=out_port[1];
                     spi_mosi<=out_port[7];
                     end
                      end                
                end
                             
//                            end
                            
//                            end
                            //
                            /////////////////////////////////////////////////////////////////////////////////////////
                            // General Purpose Output Ports 
                            /////////////////////////////////////////////////////////////////////////////////////////
                            //
                            // In this simple example there is only one output port and that it involves writing 
                            // directly to the FIFO buffer within 'uart_tx6'. As such the only requirements are to 
                            // connect the 'out_port' to the transmitter macro and generate the write pulse.
                            // 
                          
                            assign uart_tx_data_in = out_port;
                          
                            assign write_to_uart_tx = write_strobe & port_id[0];
                          
                          
                            //
                          
                            //
                            /////////////////////////////////////////////////////////////////////////////////////////
                            // Constant-Optimised Output Ports 
                            /////////////////////////////////////////////////////////////////////////////////////////
                            //
                            // One constant-optimised output port is used to facilitate resetting of the UART macros.
                            //
                          
                            always @ (posedge clk)
                            begin
                          
                              if (k_write_strobe == 1'b1) begin
                          
                                if (port_id[0] == 1'b1) begin
                                    uart_tx_reset <= out_port[0];
                                    uart_rx_reset <= out_port[1];
                                end
                          
                              end
                            end
                               
                                    
     
reg [5:0] r0,r1,r2,r3,r4,r5,r6,r7;
 always@(posedge clk200) begin
            case(uart_rx_data_out[0])
                0:r0 <=6'b100000 ;
                1:r0 <= 6'b100001;
                2:r0 <= 6'b100010;
                3:r0 <= 6'b100011;
                4:r0 <= 6'b100100;
                5:r0 <= 6'b100101;
                6:r0 <= 6'b100110;
                7:r0 <= 6'b100111;
                8:r0 <= 6'b101000;
                9:r0 <= 6'b101001;
                default : r0 <= 6'b100000;
            endcase  
            case(uart_rx_data_out[1])
                0:r1 <= 6'b100000;
                1:r1 <= 6'b100001;
                2:r1 <= 6'b100010;
                3:r1 <= 6'b100011;
                4:r1 <= 6'b100100;
                5:r1 <= 6'b100101;
                6:r1 <= 6'b100110;
                7:r1 <= 6'b100111;
                8:r1 <= 6'b101000;
                9:r1 <= 6'b101001;
                default : r1 <= 6'b100000;
            endcase  
            case(uart_rx_data_out[2])
                0:r2 <= 6'b100000;
                1:r2 <= 6'b100001;
                2:r2 <= 6'b100010;
                3:r2 <= 6'b100011;
                4:r2 <= 6'b100100;
                5:r2 <= 6'b100101;
                6:r2 <= 6'b100110;
                7:r2 <= 6'b100111;
                8:r2 <= 6'b101000;
                9:r2 <= 6'b101001;
                default : r2 <= 6'b100000;
            endcase  
            case(uart_rx_data_out[3])
                0:r3 <= 6'b100000;
                1:r3 <= 6'b100001;
                2:r3 <= 6'b100010;
                3:r3 <= 6'b100011;
                4:r3 <= 6'b100100;
                5:r3 <= 6'b100101;
                6:r3 <= 6'b100110;
                7:r3 <= 6'b100111;
                8:r3 <= 6'b101000;
                9:r3 <= 6'b101001;
                default : r3 <= 6'b100000;
            endcase  
            case(uart_rx_data_out[4])
                0:r4 <= 6'b100000;
                1:r4 <= 6'b100001;
                2:r4 <= 6'b100010;
                3:r4 <= 6'b100011;
                4:r4 <= 6'b100100;
                5:r4 <= 6'b100101;
                6:r4 <= 6'b100110;
                7:r4 <= 6'b100111;
                8:r4 <= 6'b101000;
                9:r4 <= 6'b101001;
                default : r4 <= 6'b100000;
            endcase  
            case(uart_rx_data_out[5])
                0:r5 <= 6'b100000;
                1:r5 <= 6'b100001;
                2:r5 <= 6'b100010;
                3:r5 <= 6'b100011;
                4:r5 <= 6'b100100;
                5:r5 <= 6'b100101;
                6:r5 <= 6'b100110;
                7:r5 <= 6'b100111;
                8:r5 <= 6'b101000;
                9:r5 <= 6'b101001;
                default : r5 <= 6'b100000;
            endcase  
            case(uart_rx_data_out[6])
                0:r6 <= 6'b100000;
                1:r6 <= 6'b100001;
                2:r6 <= 6'b100010;
                3:r6 <= 6'b100011;
                4:r6 <= 6'b100100;
                5:r6 <= 6'b100101;
                6:r6 <= 6'b100110;
                7:r6 <= 6'b100111;
                8:r6 <= 6'b101000;
                9:r6 <= 6'b101001;
                default : r6 <= 6'b100000;
            endcase  
            case(uart_rx_data_out[7])
                0:r7 <= 6'b100000;
                1:r7 <= 6'b100001;
                2:r7 <= 6'b100010;
                3:r7 <= 6'b100011;
                4:r7 <= 6'b100100;
                5:r7 <= 6'b100101;
                6:r7 <= 6'b100110;
                7:r7 <= 6'b100111;
                8:r7 <= 6'b101000;
                9:r7 <= 6'b101001;
                default : r7 <= 6'b100000;
            endcase                              
            end
            reg [5:0] t0,t1,t2,t3,t4,t5,t6,t7;
always@(posedge clk200) begin
              case(out_port[0])
                  0:t0 <=6'b100000 ;
                  1:t0 <= 6'b100001;
                  2:t0 <= 6'b100010;
                  3:t0 <= 6'b100011;
                  4:t0 <= 6'b100100;
                  5:t0 <= 6'b100101;
                  6:t0 <= 6'b100110;
                  7:t0 <= 6'b100111;
                  8:t0 <= 6'b101000;
                  9:t0 <= 6'b101001;
                  default : t0 <= 6'b100000;
              endcase  
              case(out_port[1])
                  0:t1 <= 6'b100000;
                  1:t1 <= 6'b100001;
                  2:t1 <= 6'b100010;
                  3:t1 <= 6'b100011;
                  4:t1 <= 6'b100100;
                  5:t1 <= 6'b100101;
                  6:t1 <= 6'b100110;
                  7:t1 <= 6'b100111;
                  8:t1 <= 6'b101000;
                  9:t1 <= 6'b101001;
                  default : t1 <= 6'b100000;
              endcase  
              case(out_port[2])
                  0:t2 <= 6'b100000;
                  1:t2 <= 6'b100001;
                  2:t2 <= 6'b100010;
                  3:t2 <= 6'b100011;
                  4:t2 <= 6'b100100;
                  5:t2 <= 6'b100101;
                  6:t2 <= 6'b100110;
                  7:t2 <= 6'b100111;
                  8:t2 <= 6'b101000;
                  9:t2 <= 6'b101001;
                  default : t2 <= 6'b100000;
              endcase  
              case(out_port[3])
                  0:t3 <= 6'b100000;
                  1:t3 <= 6'b100001;
                  2:t3 <= 6'b100010;
                  3:t3 <= 6'b100011;
                  4:t3 <= 6'b100100;
                  5:t3 <= 6'b100101;
                  6:t3 <= 6'b100110;
                  7:t3 <= 6'b100111;
                  8:t3 <= 6'b101000;
                  9:t3 <= 6'b101001;
                  default : t3 <= 6'b100000;
              endcase  
              case(out_port[4])
                  0:t4 <= 6'b100000;
                  1:t4 <= 6'b100001;
                  2:t4 <= 6'b100010;
                  3:t4 <= 6'b100011;
                  4:t4 <= 6'b100100;
                  5:t4 <= 6'b100101;
                  6:t4 <= 6'b100110;
                  7:t4 <= 6'b100111;
                  8:t4 <= 6'b101000;
                  9:t4 <= 6'b101001;
                  default : t4 <= 6'b100000;
              endcase  
              case(out_port[5])
                  0:t5 <= 6'b100000;
                  1:t5 <= 6'b100001;
                  2:t5 <= 6'b100010;
                  3:t5 <= 6'b100011;
                  4:t5 <= 6'b100100;
                  5:t5 <= 6'b100101;
                  6:t5 <= 6'b100110;
                  7:t5 <= 6'b100111;
                  8:t5 <= 6'b101000;
                  9:t5 <= 6'b101001;
                  default : t5 <= 6'b100000;
              endcase  
              case(out_port[6])
                  0:t6 <= 6'b100000;
                  1:t6 <= 6'b100001;
                  2:t6 <= 6'b100010;
                  3:t6 <= 6'b100011;
                  4:t6 <= 6'b100100;
                  5:t6 <= 6'b100101;
                  6:t6 <= 6'b100110;
                  7:t6 <= 6'b100111;
                  8:t6 <= 6'b101000;
                  9:t6 <= 6'b101001;
                  default : t6 <= 6'b100000;
              endcase  
              case(out_port[7])
                  0:t7 <= 6'b100000;
                  1:t7 <= 6'b100001;
                  2:t7 <= 6'b100010;
                  3:t7 <= 6'b100011;
                  4:t7 <= 6'b100100;
                  5:t7 <= 6'b100101;
                  6:t7 <= 6'b100110;
                  7:t7 <= 6'b100111;
                  8:t7 <= 6'b101000;
                  9:t7 <= 6'b101001;
                  default : t7 <= 6'b100000;
              endcase  
         
           end
reg [28:0] count = 0;     
reg [5:0] code;    // 6-bits different signals to give out
reg refresh;    // refresh LCD rate @ about 25Hz
reg [31:0] counter =0;
reg  tick;

always @ (posedge clk200) begin
count <= count + 1;

case (count [28:23])    // as top 6 bits change
// power-on init can be carried out befor this loop to avoid the flickers
0: code <= 6'h03;    // power-on init sequence
1: code <= 6'h03;    // this is needed at least once
2: code <= 6'h03;    // when LCD's powered on
3: code <= 6'h02;    // it flickers existing char dislay
// Table 5-3, Function Set 
// Send 00 and upper nibble 0010, then 00 and lower nibble 10xx
4: code <= 6'h02; // Function Set, upper nibble 0010 
5: code <= 6'h08; // lower nibble 1000 (10xx)
// Table 5-3, Entry Mode 
// send 00 and upper nibble: I/D bit (Incr 1, Decr 0), S bit (Shift 1, 0 no) 
6: code <= 6'h00; // see table, upper nibble 0000, then lower nibble: 
7: code <= 6'h06; // 0110: Incr, Shift disabled
// Table 5-3, Display On/Off 
// send 00 and upper nibble 0000, then 00 and lower nibble 1 DCB 
// D: 1, show char represented by code in DDR, 0 don't, but code remains 
// C: 1, show cursor, 0 don't 
// B: 1, cursor blinks (if shown), 0 don't blink (if shown) 
8: code <= 6'h00; // Display On/Off, upper nibble 0000 
9: code <= 6'h0F; // lower nibble 1100 (1 D C B)
// Table 5-3 Clear Display, 00 and upper nibble 0000, 00 and lower nibble 0001 
10: code <= 6'h00; // Clear Display, 00 and upper nibble 0000 
11: code <= 6'h01; // then 00 and lower nibble 0001
// Chararters are then given out, the cursor will advance to the right 
// Table 5-3, Write Data to DD RAM (or CG RAM) 
// Fig 5-4, 'H' send 10 and upper nibble 0100, then 10 and lower nibble 
12: code <= 6'h23; //  high nibble 
13: code <= r7; //  low nibble 
14: code <= 6'h23; // e 
15: code <= r6; 
16: code <= 6'h23; // 1 
17: code <= r5; 
18: code <= 6'h23; // 1 
19: code <= r4;
20: code <= 6'h23;  
21: code <= r3; 
22: code <= 6'h23;  
23: code <= r2;
24: code <= 6'h23;  
25: code <= r1;
26: code <= 6'h23;  
27: code <= r0;   
28: code <= 6'b001100; // pos cursor to 2nd line upper nibble 
29: code <= 6'b000000; // lower nibble: h0
30: code <= 6'h23; //  high nibble 
31: code <= t7; //  low nibble 
32: code <= 6'h23; // e 
33: code <= t6; 
34: code <= 6'h23; // 1 
35: code <= t5; 
36: code <= 6'h23; // 1 
37: code <= t4;
38: code <= 6'h23;  
39: code <= t3; 
40: code <= 6'h23;  
41: code <= t2;
42: code <= 6'h23;  
43: code <= t1;
44: code <= 6'h23;  
45: code <= t0;     

// Characters are then given out, the cursor will advance to the right 
// Table 5-3, Read Busy Flag and Address 
// send 01 BF (Busy Flag) x x x, then 01xxxx 
// idling

default: code <= 6'h10; // the restun-used time 
endcase 
// refresh (enable) the LCD when bit 20 of the count is 1 
// (it flips when counted upto 2M, and flips again after another 2M) 
refresh <= count[ 22 ]; // flip rate about 25 (50MHz/2*21=2M) 
LCD_E <= refresh; 
LCD_RS <= code[5]; LCD_RW <= code[4]; 
LCD_DB7 <= code[3]; LCD_DB6 <= code[2]; 
LCD_DB5 <= code[1]; LCD_DB4 <= code[0]; 
end // always



            
endmodule
