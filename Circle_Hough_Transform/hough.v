`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2017 12:09:39
// Design Name: 
// Module Name: hough
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


module hough(

   input SYSCLK_N,
       input SYSCLK_P,
        
      output  [7:0] led,
        output reg LCD_RS,
        output reg LCD_E,
        output reg LCD_RW,
        output reg LCD_DB7,
        output reg LCD_DB6,
        output reg LCD_DB5,
        output reg LCD_DB4

       
    );
   
wire clk200;
reg clk1;
wire clk;
// converting differential 200MHz clock to single ended 200MHz clock
IBUFGDS diff_clk_buffer(
      .I(SYSCLK_P),
      .IB(SYSCLK_N),
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
      
      //setting up the pixel array
      
      wire array[0:9][0:9];
    
           assign array[0][0]=0;
           assign array[0][1]=0;
           assign array[0][2]=0;
           assign array[0][3]=0;
           assign array[0][4]=0;
           assign array[0][5]=0;
           assign array[0][6]=0;
           assign array[0][7]=0;
           assign array[0][8]=0;
           assign array[0][9]=0;
               assign array[1][0]=0;
               assign array[1][1]=0;
               assign array[1][2]=0;
               assign array[1][3]=0;
               assign array[1][4]=0;
               assign array[1][5]=0;
               assign array[1][6]=0;
               assign array[1][7]=0;
               assign array[1][8]=0;
               assign array[1][9]=0;
           assign array[2][0]=0;
           assign array[2][1]=1;
           assign array[2][2]=1;
           assign array[2][3]=1;
           assign array[2][4]=0;
           assign array[2][5]=0;
           assign array[2][6]=0;
           assign array[2][7]=0;
           assign array[2][8]=0;
           assign array[2][9]=0;
             assign array[3][0]=1;
             assign array[3][1]=0;
             assign array[3][2]=0;
             assign array[3][3]=0;
             assign array[3][4]=1;
             assign array[3][5]=0;
             assign array[3][6]=0;
             assign array[3][7]=0;
             assign array[3][8]=0;
             assign array[3][9]=0;
         assign array[4][0]=1;
         assign array[4][1]=0;
         assign array[4][2]=0;
         assign array[4][3]=0;
         assign array[4][4]=1;
         assign array[4][5]=0;
         assign array[4][6]=0;
         assign array[4][7]=1;
         assign array[4][8]=0;
         assign array[4][9]=0;
             assign array[5][0]=1;
             assign array[5][1]=0;
             assign array[5][2]=0;
             assign array[5][3]=0;
             assign array[5][4]=1;
             assign array[5][5]=0;
             assign array[5][6]=0;
             assign array[5][7]=0;
             assign array[5][8]=0;
             assign array[5][9]=0;
         assign array[6][0]=0;
         assign array[6][1]=1;
         assign array[6][2]=1;
         assign array[6][3]=1;
         assign array[6][4]=0;
         assign array[6][5]=0;
         assign array[6][6]=0;
         assign array[6][7]=0;
         assign array[6][8]=0;
         assign array[6][9]=0;
             assign array[7][0]=0;
             assign array[7][1]=0;
             assign array[7][2]=0;
             assign array[7][3]=0;
             assign array[7][4]=0;
             assign array[7][5]=0;
             assign array[7][6]=1;
             assign array[7][7]=1;
             assign array[7][8]=1;
             assign array[7][9]=0;
         assign array[8][0]=0;
         assign array[8][1]=0;
         assign array[8][2]=0;
         assign array[8][3]=0;
         assign array[8][4]=0;
         assign array[8][5]=0;
         assign array[8][6]=1;
         assign array[8][7]=0;
         assign array[8][8]=1;
         assign array[8][9]=0;
            assign array[9][0]=0;
            assign array[9][1]=0;
            assign array[9][2]=0;
            assign array[9][3]=0;
            assign array[9][4]=0;
            assign array[9][5]=0;
            assign array[9][6]=1;
            assign array[9][7]=1;
            assign array[9][8]=1;
            assign array[9][9]=0;
                reg clk2;
                reg[31:0] count_0;
                always@(posedge clk) //6.25MHz for the radius 
                begin
                //under test. Stable for counter upto 16
                    if (count_0 == 32'h0000000F) begin
                        count_0 <= 32'h00;
                        clk2 <= clk2+1;
                        
                        end else begin
                        count_0 <= count_0 + 1;
                        end
                end
  reg [3:0] x_hit[0:31];
   reg [3:0] y_hit[0:31]; 
   reg[4:0] count_1;
   reg[4:0] i_0;
           reg[4:0] j_0;
           (* KEEP = "TRUE"*)//flag variables used to iterate a loop once. 
                   reg flag_0;//KEEP="TRUE" ESSENTIAL! prevents XST from hardwiring the flags
                   
   always@(posedge clk)begin//used to populate x_hit and y_hit with all the edge points,
       if(~flag_0)begin//  in a sequence from left to right, top to bottom indexed by count_1
           if(array[i_0][j_0])begin
           x_hit[count_1]<=j_0;
           y_hit[count_1]<=i_0;
           count_1<=count_1+1;
           end
           j_0<=j_0+1;
           if(j_0==10)begin
           j_0<=0;
           i_0<=i_0+1;
           end
           if(i_0==10)begin
           i_0<=0;
           flag_0<=1;
           end
       end
   end              
 
                   
 
     reg[3:0] x_accum[0:9];//used to accumulate the number of hits per x coordinate
     reg[9:0] x_cent;//if the accumulated value is high enough, the corresponding value in x_cent is set to '1'
      reg[4:0] i_1;
        reg[4:0] j_1;
        reg[4:0] a_i;
        reg[4:0] a_j;
       
        
       (* KEEP = "TRUE"*)
        reg flag_x;
       
  always@(posedge clk)begin
     if(~flag_x)begin
    if(array[i_1][j_1]==1)begin
        
            if(array[i_1][a_j])begin
             x_accum[(j_1+a_j)>>1]<=x_accum[(j_1+a_j)>>1]+1;
            end
           end 
            a_j<=a_j+1;
            if(a_j==10)begin
                j_1<=j_1+1;
                a_j<=j_1+2;
            end 
            if(j_1==10)begin
              j_1<=0;
               a_j<=1;
               i_1<=i_1+1;
               end
               if(i_1==10)begin
               flag_x<=1;
              end
           end  
           if(flag_x)begin
               if(x_accum[a_i]>2)begin
                    x_cent[a_i]<=1;
               end else begin
               x_cent[a_i]<=0;
               end
             a_i<=a_i+1;
               if(a_i==10)begin
              a_i<=0;
                if(x_cent==10'b0)begin//if none of the x-coordinates gets a high enough accumulator value, we search in the centre 
                x_cent[4]<=1;
                x_cent[5]<=1;
                end
            end
          end
       end
      

  
     reg[3:0] y_accum[0:9];
reg [9:0] y_cent;
 reg[4:0] i_2;
   reg[4:0] j_2;
   reg[4:0] y_i;
   reg[4:0] y_j;
   
   (* KEEP = "TRUE"*)
   reg flag_y;
always@(posedge clk)begin
   if(~flag_y)begin
   if(array[i_2][j_2]==1)begin
          if(array[y_i][j_2])begin
           y_accum[(i_2+y_i)>>1]<=y_accum[(i_2+y_i)>>1]+1;
          end
         end 
        y_i<=y_i+1;
          if(y_i==10)begin
              i_2<=i_2+1;
              y_i<=i_2+2;
          end 
          if(i_2==10)begin
            i_2<=0;
             y_i<=1;
             j_2<=j_2+1;
             end
             if(j_2==10)begin
             flag_y<=1;
            end
         end  
         if(flag_y)begin
             if(y_accum[y_j]>1)begin
                  y_cent[y_j]<=1;
             end else begin
             y_cent[y_j]<=0;
             end
             y_j<=y_j+1;
             if(y_j==10)begin
            y_j<=0;
            if(y_cent==10'b0)begin
            y_cent[4]<=1;
            y_cent[5]<=1;
            end
          end
         
         end
           
     end
     reg[3:0] x;//to hold each of the possible centre coordinates
     reg[3:0] y;
     reg [7:0] sq_sum;//to hold (x-x_cent)^2+(y-y_cent)^2. Input to Square root core
     reg[4:0] i_3;
     reg [4:0] j_3;
     reg[7:0] count_2;
     reg in_check;
     wire out_check;     
     wire [5:0] sqroot;// to hold the radius value
     reg[7:0] rad[0:15];// holds the number of hits per radius value. maxima correspond to possible radii of arcs
     reg[9:0]x_rad[0:9];
      reg[9:0]y_rad[0:9];
      (* KEEP = "TRUE"*)
        reg flag; 
       always@(posedge clk2)begin//opoerates at a lower frequency
       if(~flag)begin
         if(x_cent[i_3])begin
            if(y_cent[j_3])begin
                x<=i_3;
                y<=j_3;
                in_check<=1;
               sq_sum<=(x-x_hit[count_2])*(x-x_hit[count_2])+(y-y_hit[count_2])*(y-y_hit[count_2]);
               if(out_check)begin//checks validity of output of CORDIC
                   rad[sqroot]<=rad[sqroot]+1;
                   end
              end
           end
           if(rad[1]>=4)begin
               x_rad[i_3]<=x_rad[i_3]|10'b0000000010;
               y_rad[j_3]<=y_rad[j_3]|10'b0000000010;
           end
           if(rad[2]>=4)begin
              x_rad[i_3]<=x_rad[i_3]|10'b0000000100;
              y_rad[j_3]<=y_rad[j_3]|10'b0000000100;
            end
          if(rad[3]>=8)begin
            x_rad[i_3]<=x_rad[i_3]|10'b0000001000;
            y_rad[j_3]<=y_rad[j_3]|10'b0000001000;
           end
           if(rad[4]>=10)begin
               x_rad[i_3]<=x_rad[i_3]|10'b0000010000;
               y_rad[j_3]<=y_rad[j_3]|10'b0000010000;
             end
           if(rad[5]>=12)begin
               x_rad[i_3]<=x_rad[i_3]|10'b0000100000;
               y_rad[j_3]<=y_rad[j_3]|10'b0000100000;
             end  
            if(rad[6]>=13)begin
                x_rad[i_3]<=x_rad[i_3]|10'b0001000000;
                y_rad[j_3]<=y_rad[j_3]|10'b0001000000;
              end    
           count_2<=count_2+1;
        if(count_2==count_1)begin//at present only tested first eight edge points.modified so that it searches for every signal hit
         j_3<=j_3+1;
         rad[0]<=8'b00000000;
         rad[1]<=8'b00000000;
         rad[2]<=8'b00000000;
         rad[3]<=8'b00000000;
         rad[4]<=8'b00000000;
          rad[5]<=8'b00000000;
          rad[6]<=8'b00000000;
          rad[7]<=8'b00000000;
         count_2<=0;        
        end
         if(j_3==10)begin
         j_3<=0;
         i_3<=i_3+1;
         end
         if(i_3==10)begin
         i_3<=0;
     
         in_check<=0;
         flag<=1;
         end
        end 
     end
//      assign led[3:0]={out_check,flag,flag_y,flag_x};
      assign led[3:0]=x_hit[0];
      assign led[7:4]=y_hit[0];
      
//      assign led = rad[1];
         reg [5:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
               wire [9:0] read_upper;
               assign  read_upper =x_rad[2];//{3'b0,sqroot} ;
               wire [9:0] read_lower;
               assign read_lower =y_rad[4];
                always@(posedge clk) begin
                                 case(read_upper[0])
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
                                 case(read_upper[1])
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
                                 case(read_upper[2])
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
                                 case(read_upper[3])
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
                                 case(read_upper[4])
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
                                 case(read_upper[5])
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
                                 case(read_upper[6])
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
                                 case(read_upper[7])
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
                                  case(read_upper[8])
                                     0:r8 <= 6'b100000;
                                     1:r8 <= 6'b100001;
                                     2:r8 <= 6'b100010;
                                     3:r8 <= 6'b100011;
                                     4:r8 <= 6'b100100;
                                     5:r8 <= 6'b100101;
                                     6:r8 <= 6'b100110;
                                     7:r8 <= 6'b100111;
                                     8:r8 <= 6'b101000;
                                     9:r8 <= 6'b101001;
                                     default : r8 <= 6'b100000;
                                 endcase                             
                                  case(read_upper[9])
                                       0:r9 <= 6'b100000;
                                       1:r9 <= 6'b100001;
                                       2:r9 <= 6'b100010;
                                       3:r9 <= 6'b100011;
                                       4:r9 <= 6'b100100;
                                       5:r9 <= 6'b100101;
                                       6:r9 <= 6'b100110;
                                       7:r9 <= 6'b100111;
                                       8:r9 <= 6'b101000;
                                       9:r9 <= 6'b101001;
                                    default : r9 <= 6'b100000;
                                endcase      
                                 end
                                 reg [5:0] t0,t1,t2,t3,t4,t5,t6,t7,t8,t9;
                     always@(posedge clk) begin
                                   case(read_lower[0])
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
                                   case(read_lower[1])
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
                                   case(read_lower[2])
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
                                   case(read_lower[3])
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
                                   case(read_lower[4])
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
                                   case(read_lower[5])
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
                                   case(read_lower[6])
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
                                   case(read_lower[7])
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
                                    case(read_lower[8])
                                      0:t8 <= 6'b100000;
                                      1:t8 <= 6'b100001;
                                      2:t8 <= 6'b100010;
                                      3:t8 <= 6'b100011;
                                      4:t8 <= 6'b100100;
                                      5:t8 <= 6'b100101;
                                      6:t8 <= 6'b100110;
                                      7:t8 <= 6'b100111;
                                      8:t8 <= 6'b101000;
                                      9:t8 <= 6'b101001;
                                      default : t8 <= 6'b100000;
                                  endcase                             
                                   case(read_lower[9])
                                        0:t9 <= 6'b100000;
                                        1:t9 <= 6'b100001;
                                        2:t9 <= 6'b100010;
                                        3:t9 <= 6'b100011;
                                        4:t9 <= 6'b100100;
                                        5:t9 <= 6'b100101;
                                        6:t9 <= 6'b100110;
                                        7:t9 <= 6'b100111;
                                        8:t9 <= 6'b101000;
                                        9:t9 <= 6'b101001;
                                     default : t9 <= 6'b100000;
                                 endcase  
                                end
               reg [28:0] count = 0;     
               reg [5:0] code;    // 6-bits different signals to give out
               reg refresh;    // refresh LCD rate @ about 25Hz
               reg [31:0] counter =0;
               reg  tick;
               
               always @ (posedge clk) begin
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
               13:code <= r9; //  high nibble
               14:code <= 6'h23; //  high nibble
               15:code <= r8; //  high nibble
               16: code <= 6'h23; //  high nibble 
               17: code <= r7; //  low nibble 
               18: code <= 6'h23; // e 
               19: code <= r6; 
               20: code <= 6'h23; // 1 
               21: code <= r5; 
               22: code <= 6'h23; // 1 
               23: code <= r4;
               24: code <= 6'h23;  
               25: code <= r3; 
               26: code <= 6'h23;  
               27: code <= r2;
               28: code <= 6'h23;  
               29: code <= r1;
               30: code <= 6'h23;  
               31: code <= r0;   
               32: code <= 6'b001100; // pos cursor to 2nd line upper nibble 
               33: code <= 6'b000000; // lower nibble: h0
               34:code <= 6'h23; //  high nibble
               35:code <= t9; //  high nibble
               36:code <= 6'h23; //  high nibble
               37:code <= t8; //  high nibble
               38: code <= 6'h23; //  high nibble 
               39: code <= t7; //  low nibble 
               40: code <= 6'h23; // e 
               41: code <= t6; 
               42: code <= 6'h23; // 1 
               43: code <= t5; 
               44: code <= 6'h23; // 1 
               45: code <= t4;
               46: code <= 6'h23;  
               47: code <= t3; 
               48: code <= 6'h23;  
               49: code <= t2;
               50: code <= 6'h23;  
               51: code <= t1;
               52: code <= 6'h23;  
               53: code <= t0;     
               
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
               
                         cordic_0 root (
                           .aclk(clk),                                        // input wire aclk
                           .s_axis_cartesian_tvalid(in_check),  // input wire s_axis_cartesian_tvalid
                           .s_axis_cartesian_tdata(sq_sum),    // input wire [7 : 0] s_axis_cartesian_tdata
                           .m_axis_dout_tvalid(out_check),            // output wire m_axis_dout_tvalid
                           .m_axis_dout_tdata(sqroot)              // output wire [7 : 0] m_axis_dout_tdata
                         );
endmodule
