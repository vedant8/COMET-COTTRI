//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2010-2013, Xilinx, Inc.
// This file contains confidential and proprietary information of Xilinx, Inc. and is
// protected under U.S. and international copyright and other intellectual property laws.
///////////////////////////////////////////////////////////////////////////////////////////
//
// Disclaimer:
// This disclaimer is not a license and does not grant any rights to the materials
// distributed herewith. Except as otherwise provided in a valid license issued to
// you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
// MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
// DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
// INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
// OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
// (whether in contract or tort, including negligence, or under any other theory
// of liability) for any loss or damage of any kind or nature related to, arising
// under or in connection with these materials, including for any direct, or any
// indirect, special, incidental, or consequential loss or damage (including loss
// of data, profits, goodwill, or any type of loss or damage suffered as a result
// of any action brought by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-safe, or for use in any
// application requiring fail-safe performance, such as life-support or safety
// devices or systems, Class III medical devices, nuclear facilities, applications
// related to the deployment of airbags, or any other applications that could lead
// to death, personal injury, or severe property or environmental damage
// (individually and collectively, "Critical Applications"). Customer assumes the
// sole risk and liability of any use of Xilinx products in Critical Applications,
// subject only to applicable laws and regulations governing limitations on product
// liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
//
///////////////////////////////////////////////////////////////////////////////////////////
//
//
// Definition of a program memory for KCPSM6 including generic parameters for the 
// convenient selection of device family, program memory size and the ability to include 
// the JTAG Loader hardware for rapid software development.
//
// This file is primarily for use during code development and it is recommended that the 
// appropriate simplified program memory definition be used in a final production design. 
//
//
//    Generic                  Values             Comments
//    Parameter                Supported
//  
//    C_FAMILY                 "S6"               Spartan-6 device
//                             "V6"               Virtex-6 device
//                             "7S"               7-Series device 
//                                                  (Artix-7, Kintex-7, Virtex-7 or Zynq)
//
//    C_RAM_SIZE_KWORDS        1, 2 or 4          Size of program memory in K-instructions
//
//    C_JTAG_LOADER_ENABLE     0 or 1             Set to '1' to include JTAG Loader
//
// Notes
//
// If your design contains MULTIPLE KCPSM6 instances then only one should have the 
// JTAG Loader enabled at a time (i.e. make sure that C_JTAG_LOADER_ENABLE is only set to 
// '1' on one instance of the program memory). Advanced users may be interested to know 
// that it is possible to connect JTAG Loader to multiple memories and then to use the 
// JTAG Loader utility to specify which memory contents are to be modified. However, 
// this scheme does require some effort to set up and the additional connectivity of the 
// multiple BRAMs can impact the placement, routing and performance of the complete 
// design. Please contact the author at Xilinx for more detailed information. 
//
// Regardless of the size of program memory specified by C_RAM_SIZE_KWORDS, the complete 
// 12-bit address bus is connected to KCPSM6. This enables the generic to be modified 
// without requiring changes to the fundamental hardware definition. However, when the 
// program memory is 1K then only the lower 10-bits of the address are actually used and 
// the valid address range is 000 to 3FF hex. Likewise, for a 2K program only the lower 
// 11-bits of the address are actually used and the valid address range is 000 to 7FF hex.
//
// Programs are stored in Block Memory (BRAM) and the number of BRAM used depends on the 
// size of the program and the device family. 
//
// In a Spartan-6 device a BRAM is capable of holding 1K instructions. Hence a 2K program 
// will require 2 BRAMs to be used and a 4K program will require 4 BRAMs to be used. It 
// should be noted that a 4K program is not such a natural fit in a Spartan-6 device and 
// the implementation also requires a small amount of logic resulting in slightly lower 
// performance. A Spartan-6 BRAM can also be split into two 9k-bit memories suggesting 
// that a program containing up to 512 instructions could be implemented. However, there 
// is a silicon errata which makes this unsuitable and therefore it is not supported by 
// this file.
//
// In a Virtex-6 or any 7-Series device a BRAM is capable of holding 2K instructions so 
// obviously a 2K program requires only a single BRAM. Each BRAM can also be divided into 
// 2 smaller memories supporting programs of 1K in half of a 36k-bit BRAM (generally 
// reported as being an 18k-bit BRAM). For a program of 4K instructions, 2 BRAMs are used.
//
//
// Program defined by 'C:\altera\core.psm'.
//
// Generated by KCPSM6 Assembler: 03 Jul 2017 - 15:48:26. 
//
// Assembler used ROM_form template: ROM_form_JTAGLoader_14March13.v
//
//
`timescale 1ps/1ps
module core (address, instruction, enable, rdl, clk);
//
parameter integer C_JTAG_LOADER_ENABLE = 1;                        
parameter         C_FAMILY = "S6";                        
parameter integer C_RAM_SIZE_KWORDS = 1;                        
//
input         clk;        
input  [11:0] address;        
input         enable;        
output [17:0] instruction;        
output        rdl;
//
//
wire [15:0] address_a;
wire        pipe_a11;
wire [35:0] data_in_a;
wire [35:0] data_out_a;
wire [35:0] data_out_a_l;
wire [35:0] data_out_a_h;
wire [35:0] data_out_a_ll;
wire [35:0] data_out_a_lh;
wire [35:0] data_out_a_hl;
wire [35:0] data_out_a_hh;
wire [15:0] address_b;
wire [35:0] data_in_b;
wire [35:0] data_in_b_l;
wire [35:0] data_in_b_ll;
wire [35:0] data_in_b_hl;
wire [35:0] data_out_b;
wire [35:0] data_out_b_l;
wire [35:0] data_out_b_ll;
wire [35:0] data_out_b_hl;
wire [35:0] data_in_b_h;
wire [35:0] data_in_b_lh;
wire [35:0] data_in_b_hh;
wire [35:0] data_out_b_h;
wire [35:0] data_out_b_lh;
wire [35:0] data_out_b_hh;
wire        enable_b;
wire        clk_b;
wire [7:0]  we_b;
wire [3:0]  we_b_l;
wire [3:0]  we_b_h;
//
wire [11:0] jtag_addr;
wire        jtag_we;
wire        jtag_clk;
wire [17:0] jtag_din;
wire [17:0] jtag_dout;
wire [17:0] jtag_dout_1;
wire [0:0]  jtag_en;
//
wire [0:0]  picoblaze_reset;
wire [0:0]  rdl_bus;
//
parameter integer BRAM_ADDRESS_WIDTH = addr_width_calc(C_RAM_SIZE_KWORDS);
//
//
function integer addr_width_calc;
  input integer size_in_k;
    if (size_in_k == 1) begin addr_width_calc = 10; end
      else if (size_in_k == 2) begin addr_width_calc = 11; end
      else if (size_in_k == 4) begin addr_width_calc = 12; end
      else begin
        if (C_RAM_SIZE_KWORDS != 1 && C_RAM_SIZE_KWORDS != 2 && C_RAM_SIZE_KWORDS != 4) begin
          //#0;
          $display("Invalid BlockRAM size. Please set to 1, 2 or 4 K words..\n");
          $finish;
        end
    end
endfunction
//
//
generate
  if (C_RAM_SIZE_KWORDS == 1) begin : ram_1k_generate 
    //
    if (C_FAMILY == "S6") begin: s6 
      //
      assign address_a[13:0] = {address[9:0], 4'b0000};
      assign instruction = {data_out_a[33:32], data_out_a[15:0]};
      assign data_in_a = {34'b0000000000000000000000000000000000, address[11:10]};
      assign jtag_dout = {data_out_b[33:32], data_out_b[15:0]};
      //
      if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b = {2'b00, data_out_b[33:32], 16'b0000000000000000, data_out_b[15:0]};
        assign address_b[13:0] = 14'b00000000000000;
        assign we_b[3:0] = 4'b0000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
      if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b = {2'b00, jtag_din[17:16], 16'b0000000000000000, jtag_din[15:0]};
        assign address_b[13:0] = {jtag_addr[9:0], 4'b0000};
        assign we_b[3:0] = {jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
      // 
      RAMB16BWER #(.DATA_WIDTH_A        (18),
                   .DOA_REG             (0),
                   .EN_RSTRAM_A         ("FALSE"),
                   .INIT_A              (9'b000000000),
                   .RST_PRIORITY_A      ("CE"),
                   .SRVAL_A             (9'b000000000),
                   .WRITE_MODE_A        ("WRITE_FIRST"),
                   .DATA_WIDTH_B        (18),
                   .DOB_REG             (0),
                   .EN_RSTRAM_B         ("FALSE"),
                   .INIT_B              (9'b000000000),
                   .RST_PRIORITY_B      ("CE"),
                   .SRVAL_B             (9'b000000000),
                   .WRITE_MODE_B        ("WRITE_FIRST"),
                   .RSTTYPE             ("SYNC"),
                   .INIT_FILE           ("NONE"),
                   .SIM_COLLISION_CHECK ("ALL"),
                   .SIM_DEVICE          ("SPARTAN6"),
                   .INIT_00             (256'hF718F8BAD92002E90470030D02E90480030D02E90490046B030F0303045A04D0),
                   .INIT_01             (256'h20F8D54420F5D5452041D5572028D5522011D548045D02D72012046203CE2011),
                   .INIT_02             (256'h048002E90490030116100301170002BF2012045D045D153F21C8D54C21B3D54F),
                   .INIT_03             (256'h0301202B60369601A03F1701030D02E904200475030D030D030D02E9047002E9),
                   .INIT_04             (256'h204E0462604AD590204A04620458045D1552045604931700180019A303012011),
                   .INIT_05             (256'h205E046248004706380007509530205404621700180019A31A401668604ED552),
                   .INIT_06             (256'h48004706380007509530206904626065D5202065046248004706380007509530),
                   .INIT_07             (256'h380007509530207B04626077D520207704624800470638000750953020700462),
                   .INIT_08             (256'h9530208D04626089D52020890462480047063800075095302082046248004706),
                   .INIT_09             (256'h380007509530209B046248004706380007509530209404624800470638000750),
                   .INIT_0A             (256'h4800470638000750953020A904624800470638000750953020A2046248004706),
                   .INIT_0B             (256'h60BCD52020BC046238000750953020B704624800470638000750953020B00462),
                   .INIT_0C             (256'h046242060250953020CA046242060250953020C5046242060250953020C00462),
                   .INIT_0D             (256'h20DE046242060250953020D9046242060250953020D4046242060250953020CF),
                   .INIT_0E             (256'h6053960160549A0160E8D52020E8046204800250953020E30462420602509530),
                   .INIT_0F             (256'h045604931F001E001700180019A203012011049302BF201160F0D59C20F00462),
                   .INIT_10             (256'h025002DD210C046216036107D572210704626103D590210304620458045D1572),
                   .INIT_11             (256'h611C9B01430042061B043300025002DD2116046261129B01430042061B043300),
                   .INIT_12             (256'h08303300025002DD212A046261269B01430042061B043300025002DD21200462),
                   .INIT_13             (256'h07A008B00A20047519A10B20047519A061349A014708480E1A020E200F300720),
                   .INIT_14             (256'h614CD59C214C0462610C96016146D52021460462048002E019A5048002F019A4),
                   .INIT_15             (256'h615C9A01410049061A0261579A0149084C0E1A0219000C2004751700180019A5),
                   .INIT_16             (256'h49061A02616A9A0149084C0E1A0219000C20047519A50D2004753800170119A4),
                   .INIT_17             (256'h9A0149084C0E1A0219000C2004750370058019A5160138001701616F9A014100),
                   .INIT_18             (256'h19A3618A9A01480047004D064D061A070CD0071061829A01410049061A02617D),
                   .INIT_19             (256'h02E09780048002F03E000FB00F20047517800E20047507C0180019A20B200475),
                   .INIT_1A             (256'h3800170161AB9A01410E1A0461A79A0141061A040D20047519A4073008500480),
                   .INIT_1B             (256'h030102E9042021C3D2FF04750458045D155704561700180019A2201161769601),
                   .INIT_1C             (256'h19A104931F001E001700180019A0030120110458045D1577045621BA38001701),
                   .INIT_1D             (256'h1800134E144061D9D57221D9046261D5D59021D504620458045D157204560493),
                   .INIT_1E             (256'h470638000750953021EA04624800470638000750953021DF04621F001E001700),
                   .INIT_1F             (256'h04624800470638000750953021F804624800470638000750953021F104624800),
                   .INIT_20             (256'h9530220D046248004706380007509530220604624800470638000750953021FF),
                   .INIT_21             (256'h046248004706380007509530221804626214D520221404624800470638000750),
                   .INIT_22             (256'h9530222D0462480047063800075095302226046248004706380007509530221F),
                   .INIT_23             (256'h380007509530223B046248004706380007509530223404624800470638000750),
                   .INIT_24             (256'h3F000E509530224B04624F004E063F000E509530224404626240D52022400462),
                   .INIT_25             (256'h4F004E063F000E509530225904624F004E063F000E509530225204624F004E06),
                   .INIT_26             (256'h3F000E509530226B04626267D520226704624F004E063F000E50953022600462),
                   .INIT_27             (256'h4F004E063F000E509530227904624F004E063F000E509530227204624F004E06),
                   .INIT_28             (256'h228E04624F004E063F000E509530228704624F004E063F000E50953022800462),
                   .INIT_29             (256'h0E509530229C04624F004E063F000E509530229504624F004E063F000E509530),
                   .INIT_2A             (256'h19A1048002F019A062A8D52022A804623F000E50953022A304624F004E063F00),
                   .INIT_2B             (256'h1E06500002A002C51E02201162B6D59C22B6046261DE940161DF9301048002E0),
                   .INIT_2C             (256'h4C004B004A061004900002DD02D7045D22C604621A00500007A008B009C002C5),
                   .INIT_2D             (256'h95E9900015B9500035DFD000D57B9000D561500062C69E014A5062CD90014D00),
                   .INIT_2E             (256'h045D02F5450E450E450E450E05405000150A500095F690001507E2E795119000),
                   .INIT_2F             (256'h3B001A01045D1000D5004BA05000153A1507A2F8950A5000045D02F5350F0540),
                   .INIT_30             (256'h1B03245D15205000045D155B045D151B045D154A045D15320308245D150D22FA),
                   .INIT_31             (256'h155F155F155F155F155F15201520155F1520152050000301045D458002FA1A16),
                   .INIT_32             (256'h155F155F15201520155F155F155F155F15201520155F155F155F155F1520155F),
                   .INIT_33             (256'h152F1520152F157C1520157C1520150D155F155F15201520155F155F15201520),
                   .INIT_34             (256'h157C155F155F155F1520152F155C1520155F15201520157C155F155F155F1520),
                   .INIT_35             (256'h1520157C1520150D155F152F1520152F157C15201520152F155C15201520157C),
                   .INIT_36             (256'h155F155C15201529155F157C1520157C152015201520157C1520152F15201527),
                   .INIT_37             (256'h1520155F15271520157C1520157C152F155C157C1520157C155C1520155F155F),
                   .INIT_38             (256'h15201520157C155F155F155F157C1520155C1520152E1520157C1520150D155C),
                   .INIT_39             (256'h1520157C15201520157C1520157C15201529155F155F155F1520152F155F155F),
                   .INIT_3A             (256'h155F155C155F155C157C155F157C1520150D152915201529155F15281520157C),
                   .INIT_3B             (256'h157C152F155F155F155F155F157C152015201520157C155F157C155F155F155F),
                   .INIT_3C             (256'h1AD21B031500150D152F155F155F155F155C157C155F157C15201520157C155F),
                   .INIT_3D             (256'h156915441520152D152015481520150D1575156E1565154D150D150D500002FA),
                   .INIT_3E             (256'h150D1575156E1565156D15201573156915681574152015791561156C15701573),
                   .INIT_3F             (256'h152915451554155915421528152015641561156515521520152D152015521520),
                   .INITP_00            (256'h57B7955E557B7955E557800DEDEA280AADDA2AA22222A8DDDDDDDAEB5628A2AA),
                   .INITP_01            (256'hA002AADEDDDE9795E5795E5795E5795EDE57955E557955E557955E557B7955E5),
                   .INITP_02            (256'h540801754D502094D5354080DEDDE8200208D50016ED516ED516ED516E37B7A8),
                   .INITP_03            (256'h955E557955E55780037B7A8A2002A8A5A36A202D5D4D42021852480235540D53),
                   .INITP_04            (256'h557955E557B7955E557955E557955EDE57955E557955E557955EDE557955E557),
                   .INITP_05            (256'h5B6976A0A552677776376D3554EAE202222DEDD820DE57955E557955E557955E),
                   .INITP_06            (256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA98228888A2),
                   .INITP_07            (256'hAAAAAAAAAAAAAAAAAAAAAAAA0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA))
       kcpsm6_rom( .ADDRA               (address_a[13:0]),
                   .ENA                 (enable),
                   .CLKA                (clk),
                   .DOA                 (data_out_a[31:0]),
                   .DOPA                (data_out_a[35:32]), 
                   .DIA                 (data_in_a[31:0]),
                   .DIPA                (data_in_a[35:32]), 
                   .WEA                 (4'b0000),
                   .REGCEA              (1'b0),
                   .RSTA                (1'b0),
                   .ADDRB               (address_b[13:0]),
                   .ENB                 (enable_b),
                   .CLKB                (clk_b),
                   .DOB                 (data_out_b[31:0]),
                   .DOPB                (data_out_b[35:32]), 
                   .DIB                 (data_in_b[31:0]),
                   .DIPB                (data_in_b[35:32]), 
                   .WEB                 (we_b[3:0]),
                   .REGCEB              (1'b0),
                   .RSTB                (1'b0));
    end // s6;
    // 
    //
    if (C_FAMILY == "V6") begin: v6 
      //
      assign address_a[13:0] = {address[9:0], 4'b1111};
      assign instruction = data_out_a[17:0];
      assign data_in_a[17:0] = {16'b0000000000000000, address[11:10]};
      assign jtag_dout = data_out_b[17:0];
      //
      if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b[17:0] = data_out_b[17:0];
        assign address_b[13:0] = 14'b11111111111111;
        assign we_b[3:0] = 4'b0000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
      if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b[17:0] = jtag_din[17:0];
        assign address_b[13:0] = {jtag_addr[9:0], 4'b1111};
        assign we_b[3:0] = {jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
      // 
      RAMB18E1 #(.READ_WIDTH_A              (18),
                 .WRITE_WIDTH_A             (18),
                 .DOA_REG                   (0),
                 .INIT_A                    (18'b000000000000000000),
                 .RSTREG_PRIORITY_A         ("REGCE"),
                 .SRVAL_A                   (18'b000000000000000000),
                 .WRITE_MODE_A              ("WRITE_FIRST"),
                 .READ_WIDTH_B              (18),
                 .WRITE_WIDTH_B             (18),
                 .DOB_REG                   (0),
                 .INIT_B                    (18'b000000000000000000),
                 .RSTREG_PRIORITY_B         ("REGCE"),
                 .SRVAL_B                   (18'b000000000000000000),
                 .WRITE_MODE_B              ("WRITE_FIRST"),
                 .INIT_FILE                 ("NONE"),
                 .SIM_COLLISION_CHECK       ("ALL"),
                 .RAM_MODE                  ("TDP"),
                 .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
                 .SIM_DEVICE                ("VIRTEX6"),
                 .INIT_00                   (256'hF718F8BAD92002E90470030D02E90480030D02E90490046B030F0303045A04D0),
                 .INIT_01                   (256'h20F8D54420F5D5452041D5572028D5522011D548045D02D72012046203CE2011),
                 .INIT_02                   (256'h048002E90490030116100301170002BF2012045D045D153F21C8D54C21B3D54F),
                 .INIT_03                   (256'h0301202B60369601A03F1701030D02E904200475030D030D030D02E9047002E9),
                 .INIT_04                   (256'h204E0462604AD590204A04620458045D1552045604931700180019A303012011),
                 .INIT_05                   (256'h205E046248004706380007509530205404621700180019A31A401668604ED552),
                 .INIT_06                   (256'h48004706380007509530206904626065D5202065046248004706380007509530),
                 .INIT_07                   (256'h380007509530207B04626077D520207704624800470638000750953020700462),
                 .INIT_08                   (256'h9530208D04626089D52020890462480047063800075095302082046248004706),
                 .INIT_09                   (256'h380007509530209B046248004706380007509530209404624800470638000750),
                 .INIT_0A                   (256'h4800470638000750953020A904624800470638000750953020A2046248004706),
                 .INIT_0B                   (256'h60BCD52020BC046238000750953020B704624800470638000750953020B00462),
                 .INIT_0C                   (256'h046242060250953020CA046242060250953020C5046242060250953020C00462),
                 .INIT_0D                   (256'h20DE046242060250953020D9046242060250953020D4046242060250953020CF),
                 .INIT_0E                   (256'h6053960160549A0160E8D52020E8046204800250953020E30462420602509530),
                 .INIT_0F                   (256'h045604931F001E001700180019A203012011049302BF201160F0D59C20F00462),
                 .INIT_10                   (256'h025002DD210C046216036107D572210704626103D590210304620458045D1572),
                 .INIT_11                   (256'h611C9B01430042061B043300025002DD2116046261129B01430042061B043300),
                 .INIT_12                   (256'h08303300025002DD212A046261269B01430042061B043300025002DD21200462),
                 .INIT_13                   (256'h07A008B00A20047519A10B20047519A061349A014708480E1A020E200F300720),
                 .INIT_14                   (256'h614CD59C214C0462610C96016146D52021460462048002E019A5048002F019A4),
                 .INIT_15                   (256'h615C9A01410049061A0261579A0149084C0E1A0219000C2004751700180019A5),
                 .INIT_16                   (256'h49061A02616A9A0149084C0E1A0219000C20047519A50D2004753800170119A4),
                 .INIT_17                   (256'h9A0149084C0E1A0219000C2004750370058019A5160138001701616F9A014100),
                 .INIT_18                   (256'h19A3618A9A01480047004D064D061A070CD0071061829A01410049061A02617D),
                 .INIT_19                   (256'h02E09780048002F03E000FB00F20047517800E20047507C0180019A20B200475),
                 .INIT_1A                   (256'h3800170161AB9A01410E1A0461A79A0141061A040D20047519A4073008500480),
                 .INIT_1B                   (256'h030102E9042021C3D2FF04750458045D155704561700180019A2201161769601),
                 .INIT_1C                   (256'h19A104931F001E001700180019A0030120110458045D1577045621BA38001701),
                 .INIT_1D                   (256'h1800134E144061D9D57221D9046261D5D59021D504620458045D157204560493),
                 .INIT_1E                   (256'h470638000750953021EA04624800470638000750953021DF04621F001E001700),
                 .INIT_1F                   (256'h04624800470638000750953021F804624800470638000750953021F104624800),
                 .INIT_20                   (256'h9530220D046248004706380007509530220604624800470638000750953021FF),
                 .INIT_21                   (256'h046248004706380007509530221804626214D520221404624800470638000750),
                 .INIT_22                   (256'h9530222D0462480047063800075095302226046248004706380007509530221F),
                 .INIT_23                   (256'h380007509530223B046248004706380007509530223404624800470638000750),
                 .INIT_24                   (256'h3F000E509530224B04624F004E063F000E509530224404626240D52022400462),
                 .INIT_25                   (256'h4F004E063F000E509530225904624F004E063F000E509530225204624F004E06),
                 .INIT_26                   (256'h3F000E509530226B04626267D520226704624F004E063F000E50953022600462),
                 .INIT_27                   (256'h4F004E063F000E509530227904624F004E063F000E509530227204624F004E06),
                 .INIT_28                   (256'h228E04624F004E063F000E509530228704624F004E063F000E50953022800462),
                 .INIT_29                   (256'h0E509530229C04624F004E063F000E509530229504624F004E063F000E509530),
                 .INIT_2A                   (256'h19A1048002F019A062A8D52022A804623F000E50953022A304624F004E063F00),
                 .INIT_2B                   (256'h1E06500002A002C51E02201162B6D59C22B6046261DE940161DF9301048002E0),
                 .INIT_2C                   (256'h4C004B004A061004900002DD02D7045D22C604621A00500007A008B009C002C5),
                 .INIT_2D                   (256'h95E9900015B9500035DFD000D57B9000D561500062C69E014A5062CD90014D00),
                 .INIT_2E                   (256'h045D02F5450E450E450E450E05405000150A500095F690001507E2E795119000),
                 .INIT_2F                   (256'h3B001A01045D1000D5004BA05000153A1507A2F8950A5000045D02F5350F0540),
                 .INIT_30                   (256'h1B03245D15205000045D155B045D151B045D154A045D15320308245D150D22FA),
                 .INIT_31                   (256'h155F155F155F155F155F15201520155F1520152050000301045D458002FA1A16),
                 .INIT_32                   (256'h155F155F15201520155F155F155F155F15201520155F155F155F155F1520155F),
                 .INIT_33                   (256'h152F1520152F157C1520157C1520150D155F155F15201520155F155F15201520),
                 .INIT_34                   (256'h157C155F155F155F1520152F155C1520155F15201520157C155F155F155F1520),
                 .INIT_35                   (256'h1520157C1520150D155F152F1520152F157C15201520152F155C15201520157C),
                 .INIT_36                   (256'h155F155C15201529155F157C1520157C152015201520157C1520152F15201527),
                 .INIT_37                   (256'h1520155F15271520157C1520157C152F155C157C1520157C155C1520155F155F),
                 .INIT_38                   (256'h15201520157C155F155F155F157C1520155C1520152E1520157C1520150D155C),
                 .INIT_39                   (256'h1520157C15201520157C1520157C15201529155F155F155F1520152F155F155F),
                 .INIT_3A                   (256'h155F155C155F155C157C155F157C1520150D152915201529155F15281520157C),
                 .INIT_3B                   (256'h157C152F155F155F155F155F157C152015201520157C155F157C155F155F155F),
                 .INIT_3C                   (256'h1AD21B031500150D152F155F155F155F155C157C155F157C15201520157C155F),
                 .INIT_3D                   (256'h156915441520152D152015481520150D1575156E1565154D150D150D500002FA),
                 .INIT_3E                   (256'h150D1575156E1565156D15201573156915681574152015791561156C15701573),
                 .INIT_3F                   (256'h152915451554155915421528152015641561156515521520152D152015521520),
                 .INITP_00                  (256'h57B7955E557B7955E557800DEDEA280AADDA2AA22222A8DDDDDDDAEB5628A2AA),
                 .INITP_01                  (256'hA002AADEDDDE9795E5795E5795E5795EDE57955E557955E557955E557B7955E5),
                 .INITP_02                  (256'h540801754D502094D5354080DEDDE8200208D50016ED516ED516ED516E37B7A8),
                 .INITP_03                  (256'h955E557955E55780037B7A8A2002A8A5A36A202D5D4D42021852480235540D53),
                 .INITP_04                  (256'h557955E557B7955E557955E557955EDE57955E557955E557955EDE557955E557),
                 .INITP_05                  (256'h5B6976A0A552677776376D3554EAE202222DEDD820DE57955E557955E557955E),
                 .INITP_06                  (256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA98228888A2),
                 .INITP_07                  (256'hAAAAAAAAAAAAAAAAAAAAAAAA0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA))
     kcpsm6_rom( .ADDRARDADDR               (address_a[13:0]),
                 .ENARDEN                   (enable),
                 .CLKARDCLK                 (clk),
                 .DOADO                     (data_out_a[15:0]),
                 .DOPADOP                   (data_out_a[17:16]), 
                 .DIADI                     (data_in_a[15:0]),
                 .DIPADIP                   (data_in_a[17:16]), 
                 .WEA                       (2'b00),
                 .REGCEAREGCE               (1'b0),
                 .RSTRAMARSTRAM             (1'b0),
                 .RSTREGARSTREG             (1'b0),
                 .ADDRBWRADDR               (address_b[13:0]),
                 .ENBWREN                   (enable_b),
                 .CLKBWRCLK                 (clk_b),
                 .DOBDO                     (data_out_b[15:0]),
                 .DOPBDOP                   (data_out_b[17:16]), 
                 .DIBDI                     (data_in_b[15:0]),
                 .DIPBDIP                   (data_in_b[17:16]), 
                 .WEBWE                     (we_b[3:0]),
                 .REGCEB                    (1'b0),
                 .RSTRAMB                   (1'b0),
                 .RSTREGB                   (1'b0));
    end // v6;  
    // 
    //
    if (C_FAMILY == "7S") begin: akv7 
      //
      assign address_a[13:0] = {address[9:0], 4'b1111};
      assign instruction = data_out_a[17:0];
      assign data_in_a[17:0] = {16'b0000000000000000, address[11:10]};
      assign jtag_dout = data_out_b[17:0];
      //
      if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b[17:0] = data_out_b[17:0];
        assign address_b[13:0] = 14'b11111111111111;
        assign we_b[3:0] = 4'b0000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
      if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b[17:0] = jtag_din[17:0];
        assign address_b[13:0] = {jtag_addr[9:0], 4'b1111};
        assign we_b[3:0] = {jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
      // 
      RAMB18E1 #(.READ_WIDTH_A              (18),
                 .WRITE_WIDTH_A             (18),
                 .DOA_REG                   (0),
                 .INIT_A                    (18'b000000000000000000),
                 .RSTREG_PRIORITY_A         ("REGCE"),
                 .SRVAL_A                   (18'b000000000000000000),
                 .WRITE_MODE_A              ("WRITE_FIRST"),
                 .READ_WIDTH_B              (18),
                 .WRITE_WIDTH_B             (18),
                 .DOB_REG                   (0),
                 .INIT_B                    (18'b000000000000000000),
                 .RSTREG_PRIORITY_B         ("REGCE"),
                 .SRVAL_B                   (18'b000000000000000000),
                 .WRITE_MODE_B              ("WRITE_FIRST"),
                 .INIT_FILE                 ("NONE"),
                 .SIM_COLLISION_CHECK       ("ALL"),
                 .RAM_MODE                  ("TDP"),
                 .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
                 .SIM_DEVICE                ("7SERIES"),
                 .INIT_00                   (256'hF718F8BAD92002E90470030D02E90480030D02E90490046B030F0303045A04D0),
                 .INIT_01                   (256'h20F8D54420F5D5452041D5572028D5522011D548045D02D72012046203CE2011),
                 .INIT_02                   (256'h048002E90490030116100301170002BF2012045D045D153F21C8D54C21B3D54F),
                 .INIT_03                   (256'h0301202B60369601A03F1701030D02E904200475030D030D030D02E9047002E9),
                 .INIT_04                   (256'h204E0462604AD590204A04620458045D1552045604931700180019A303012011),
                 .INIT_05                   (256'h205E046248004706380007509530205404621700180019A31A401668604ED552),
                 .INIT_06                   (256'h48004706380007509530206904626065D5202065046248004706380007509530),
                 .INIT_07                   (256'h380007509530207B04626077D520207704624800470638000750953020700462),
                 .INIT_08                   (256'h9530208D04626089D52020890462480047063800075095302082046248004706),
                 .INIT_09                   (256'h380007509530209B046248004706380007509530209404624800470638000750),
                 .INIT_0A                   (256'h4800470638000750953020A904624800470638000750953020A2046248004706),
                 .INIT_0B                   (256'h60BCD52020BC046238000750953020B704624800470638000750953020B00462),
                 .INIT_0C                   (256'h046242060250953020CA046242060250953020C5046242060250953020C00462),
                 .INIT_0D                   (256'h20DE046242060250953020D9046242060250953020D4046242060250953020CF),
                 .INIT_0E                   (256'h6053960160549A0160E8D52020E8046204800250953020E30462420602509530),
                 .INIT_0F                   (256'h045604931F001E001700180019A203012011049302BF201160F0D59C20F00462),
                 .INIT_10                   (256'h025002DD210C046216036107D572210704626103D590210304620458045D1572),
                 .INIT_11                   (256'h611C9B01430042061B043300025002DD2116046261129B01430042061B043300),
                 .INIT_12                   (256'h08303300025002DD212A046261269B01430042061B043300025002DD21200462),
                 .INIT_13                   (256'h07A008B00A20047519A10B20047519A061349A014708480E1A020E200F300720),
                 .INIT_14                   (256'h614CD59C214C0462610C96016146D52021460462048002E019A5048002F019A4),
                 .INIT_15                   (256'h615C9A01410049061A0261579A0149084C0E1A0219000C2004751700180019A5),
                 .INIT_16                   (256'h49061A02616A9A0149084C0E1A0219000C20047519A50D2004753800170119A4),
                 .INIT_17                   (256'h9A0149084C0E1A0219000C2004750370058019A5160138001701616F9A014100),
                 .INIT_18                   (256'h19A3618A9A01480047004D064D061A070CD0071061829A01410049061A02617D),
                 .INIT_19                   (256'h02E09780048002F03E000FB00F20047517800E20047507C0180019A20B200475),
                 .INIT_1A                   (256'h3800170161AB9A01410E1A0461A79A0141061A040D20047519A4073008500480),
                 .INIT_1B                   (256'h030102E9042021C3D2FF04750458045D155704561700180019A2201161769601),
                 .INIT_1C                   (256'h19A104931F001E001700180019A0030120110458045D1577045621BA38001701),
                 .INIT_1D                   (256'h1800134E144061D9D57221D9046261D5D59021D504620458045D157204560493),
                 .INIT_1E                   (256'h470638000750953021EA04624800470638000750953021DF04621F001E001700),
                 .INIT_1F                   (256'h04624800470638000750953021F804624800470638000750953021F104624800),
                 .INIT_20                   (256'h9530220D046248004706380007509530220604624800470638000750953021FF),
                 .INIT_21                   (256'h046248004706380007509530221804626214D520221404624800470638000750),
                 .INIT_22                   (256'h9530222D0462480047063800075095302226046248004706380007509530221F),
                 .INIT_23                   (256'h380007509530223B046248004706380007509530223404624800470638000750),
                 .INIT_24                   (256'h3F000E509530224B04624F004E063F000E509530224404626240D52022400462),
                 .INIT_25                   (256'h4F004E063F000E509530225904624F004E063F000E509530225204624F004E06),
                 .INIT_26                   (256'h3F000E509530226B04626267D520226704624F004E063F000E50953022600462),
                 .INIT_27                   (256'h4F004E063F000E509530227904624F004E063F000E509530227204624F004E06),
                 .INIT_28                   (256'h228E04624F004E063F000E509530228704624F004E063F000E50953022800462),
                 .INIT_29                   (256'h0E509530229C04624F004E063F000E509530229504624F004E063F000E509530),
                 .INIT_2A                   (256'h19A1048002F019A062A8D52022A804623F000E50953022A304624F004E063F00),
                 .INIT_2B                   (256'h1E06500002A002C51E02201162B6D59C22B6046261DE940161DF9301048002E0),
                 .INIT_2C                   (256'h4C004B004A061004900002DD02D7045D22C604621A00500007A008B009C002C5),
                 .INIT_2D                   (256'h95E9900015B9500035DFD000D57B9000D561500062C69E014A5062CD90014D00),
                 .INIT_2E                   (256'h045D02F5450E450E450E450E05405000150A500095F690001507E2E795119000),
                 .INIT_2F                   (256'h3B001A01045D1000D5004BA05000153A1507A2F8950A5000045D02F5350F0540),
                 .INIT_30                   (256'h1B03245D15205000045D155B045D151B045D154A045D15320308245D150D22FA),
                 .INIT_31                   (256'h155F155F155F155F155F15201520155F1520152050000301045D458002FA1A16),
                 .INIT_32                   (256'h155F155F15201520155F155F155F155F15201520155F155F155F155F1520155F),
                 .INIT_33                   (256'h152F1520152F157C1520157C1520150D155F155F15201520155F155F15201520),
                 .INIT_34                   (256'h157C155F155F155F1520152F155C1520155F15201520157C155F155F155F1520),
                 .INIT_35                   (256'h1520157C1520150D155F152F1520152F157C15201520152F155C15201520157C),
                 .INIT_36                   (256'h155F155C15201529155F157C1520157C152015201520157C1520152F15201527),
                 .INIT_37                   (256'h1520155F15271520157C1520157C152F155C157C1520157C155C1520155F155F),
                 .INIT_38                   (256'h15201520157C155F155F155F157C1520155C1520152E1520157C1520150D155C),
                 .INIT_39                   (256'h1520157C15201520157C1520157C15201529155F155F155F1520152F155F155F),
                 .INIT_3A                   (256'h155F155C155F155C157C155F157C1520150D152915201529155F15281520157C),
                 .INIT_3B                   (256'h157C152F155F155F155F155F157C152015201520157C155F157C155F155F155F),
                 .INIT_3C                   (256'h1AD21B031500150D152F155F155F155F155C157C155F157C15201520157C155F),
                 .INIT_3D                   (256'h156915441520152D152015481520150D1575156E1565154D150D150D500002FA),
                 .INIT_3E                   (256'h150D1575156E1565156D15201573156915681574152015791561156C15701573),
                 .INIT_3F                   (256'h152915451554155915421528152015641561156515521520152D152015521520),
                 .INITP_00                  (256'h57B7955E557B7955E557800DEDEA280AADDA2AA22222A8DDDDDDDAEB5628A2AA),
                 .INITP_01                  (256'hA002AADEDDDE9795E5795E5795E5795EDE57955E557955E557955E557B7955E5),
                 .INITP_02                  (256'h540801754D502094D5354080DEDDE8200208D50016ED516ED516ED516E37B7A8),
                 .INITP_03                  (256'h955E557955E55780037B7A8A2002A8A5A36A202D5D4D42021852480235540D53),
                 .INITP_04                  (256'h557955E557B7955E557955E557955EDE57955E557955E557955EDE557955E557),
                 .INITP_05                  (256'h5B6976A0A552677776376D3554EAE202222DEDD820DE57955E557955E557955E),
                 .INITP_06                  (256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA98228888A2),
                 .INITP_07                  (256'hAAAAAAAAAAAAAAAAAAAAAAAA0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA))
     kcpsm6_rom( .ADDRARDADDR               (address_a[13:0]),
                 .ENARDEN                   (enable),
                 .CLKARDCLK                 (clk),
                 .DOADO                     (data_out_a[15:0]),
                 .DOPADOP                   (data_out_a[17:16]), 
                 .DIADI                     (data_in_a[15:0]),
                 .DIPADIP                   (data_in_a[17:16]), 
                 .WEA                       (2'b00),
                 .REGCEAREGCE               (1'b0),
                 .RSTRAMARSTRAM             (1'b0),
                 .RSTREGARSTREG             (1'b0),
                 .ADDRBWRADDR               (address_b[13:0]),
                 .ENBWREN                   (enable_b),
                 .CLKBWRCLK                 (clk_b),
                 .DOBDO                     (data_out_b[15:0]),
                 .DOPBDOP                   (data_out_b[17:16]), 
                 .DIBDI                     (data_in_b[15:0]),
                 .DIPBDIP                   (data_in_b[17:16]), 
                 .WEBWE                     (we_b[3:0]),
                 .REGCEB                    (1'b0),
                 .RSTRAMB                   (1'b0),
                 .RSTREGB                   (1'b0));
    end // akv7;  
    // 
  end // ram_1k_generate;
endgenerate
//  
generate
  if (C_RAM_SIZE_KWORDS == 2) begin : ram_2k_generate 
    //
    if (C_FAMILY == "S6") begin: s6 
      //
      assign address_a[13:0] = {address[10:0], 3'b000};
      assign instruction = {data_out_a_h[32], data_out_a_h[7:0], data_out_a_l[32], data_out_a_l[7:0]};
      assign data_in_a = {35'b00000000000000000000000000000000000, address[11]};
      assign jtag_dout = {data_out_b_h[32], data_out_b_h[7:0], data_out_b_l[32], data_out_b_l[7:0]};
      //
      if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b_l = {3'b000, data_out_b_l[32], 24'b000000000000000000000000, data_out_b_l[7:0]};
        assign data_in_b_h = {3'b000, data_out_b_h[32], 24'b000000000000000000000000, data_out_b_h[7:0]};
        assign address_b[13:0] = 14'b00000000000000;
        assign we_b[3:0] = 4'b0000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
      if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b_h = {3'b000, jtag_din[17], 24'b000000000000000000000000, jtag_din[16:9]};
        assign data_in_b_l = {3'b000, jtag_din[8],  24'b000000000000000000000000, jtag_din[7:0]};
        assign address_b[13:0] = {jtag_addr[10:0], 3'b000};
        assign we_b[3:0] = {jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
      // 
      RAMB16BWER #(.DATA_WIDTH_A        (9),
                   .DOA_REG             (0),
                   .EN_RSTRAM_A         ("FALSE"),
                   .INIT_A              (9'b000000000),
                   .RST_PRIORITY_A      ("CE"),
                   .SRVAL_A             (9'b000000000),
                   .WRITE_MODE_A        ("WRITE_FIRST"),
                   .DATA_WIDTH_B        (9),
                   .DOB_REG             (0),
                   .EN_RSTRAM_B         ("FALSE"),
                   .INIT_B              (9'b000000000),
                   .RST_PRIORITY_B      ("CE"),
                   .SRVAL_B             (9'b000000000),
                   .WRITE_MODE_B        ("WRITE_FIRST"),
                   .RSTTYPE             ("SYNC"),
                   .INIT_FILE           ("NONE"),
                   .SIM_COLLISION_CHECK ("ALL"),
                   .SIM_DEVICE          ("SPARTAN6"),
                   .INIT_00             (256'hF844F5454157285211485DD71262CE1118BA20E9700DE9800DE9906B0F035AD0),
                   .INIT_01             (256'h012B36013F010DE920750D0D0DE970E980E99001100100BF125D5D3FC84CB34F),
                   .INIT_02             (256'h5E62000600503054620000A340684E524E624A904A62585D5256930000A30111),
                   .INIT_03             (256'h0050307B62772077620006005030706200060050306962652065620006005030),
                   .INIT_04             (256'h0050309B620006005030946200060050308D6289208962000600503082620006),
                   .INIT_05             (256'hBC20BC62005030B7620006005030B0620006005030A9620006005030A2620006),
                   .INIT_06             (256'hDE62065030D962065030D462065030CF62065030CA62065030C562065030C062),
                   .INIT_07             (256'h569300000000A2011193BF11F09CF06253015401E820E862805030E362065030),
                   .INIT_08             (256'h1C010006040050DD166212010006040050DD0C62030772076203900362585D72),
                   .INIT_09             (256'hA0B02075A12075A03401080E02203020300050DD2A6226010006040050DD2062),
                   .INIT_0A             (256'h5C010006025701080E020020750000A54C9C4C620C014620466280E0A580F0A4),
                   .INIT_0B             (256'h01080E020020757080A50100016F010006026A01080E02002075A520750001A4),
                   .INIT_0C             (256'hE08080F000B02075802075C000A22075A38A010000060607D01082010006027D),
                   .INIT_0D             (256'h01E920C3FF75585D57560000A21176010001AB010E04A70106042075A4305080),
                   .INIT_0E             (256'h004E40D972D962D590D562585D725693A19300000000A00111585D7756BA0001),
                   .INIT_0F             (256'h620006005030F8620006005030F1620006005030EA620006005030DF62000000),
                   .INIT_10             (256'h62000600503018621420146200060050300D62000600503006620006005030FF),
                   .INIT_11             (256'h0050303B620006005030346200060050302D620006005030266200060050301F),
                   .INIT_12             (256'h000600503059620006005030526200060050304B620006005030446240204062),
                   .INIT_13             (256'h000600503079620006005030726200060050306B626720676200060050306062),
                   .INIT_14             (256'h50309C620006005030956200060050308E620006005030876200060050308062),
                   .INIT_15             (256'h0600A0C50211B69CB662DE01DF0180E0A180F0A0A820A862005030A362000600),
                   .INIT_16             (256'hE900B900DF007B006100C60150CD01000000060400DDD75DC6620000A0B0C0C5),
                   .INIT_17             (256'h00015D0000A0003A07F80A005DF50F405DF50E0E0E0E40000A00F60007E71100),
                   .INIT_18             (256'h5F5F5F5F5F20205F202000015D80FA16035D20005D5B5D1B5D4A5D32085D0DFA),
                   .INIT_19             (256'h2F202F7C207C200D5F5F20205F5F20205F5F20205F5F5F5F20205F5F5F5F205F),
                   .INIT_1A             (256'h207C200D5F2F202F7C20202F5C20207C7C5F5F5F202F5C205F20207C5F5F5F20),
                   .INIT_1B             (256'h205F27207C207C2F5C7C207C5C205F5F5F5C20295F7C207C2020207C202F2027),
                   .INIT_1C             (256'h207C20207C207C20295F5F5F202F5F5F20207C5F5F5F7C205C202E207C200D5C),
                   .INIT_1D             (256'h7C2F5F5F5F5F7C2020207C5F7C5F5F5F5F5C5F5C7C5F7C200D2920295F28207C),
                   .INIT_1E             (256'h6944202D2048200D756E654D0D0D00FAD203000D2F5F5F5F5C7C5F7C20207C5F),
                   .INIT_1F             (256'h2945545942282064616552202D2052200D756E656D20736968742079616C7073),
                   .INIT_20             (256'h5328206573617245202D2045200D29454C494628206574697257202D2057200D),
                   .INIT_21             (256'h754F202D204F200D295455504E49282061746144202D2044200D29726F746365),
                   .INIT_22             (256'h5D04000001315D9C5D90000D50554B4F4F4C202D204C200D474F4C2074757074),
                   .INIT_23             (256'hA8ABAB70AB80AB90AB03A8A820AB20AB20ABAB9FA80001630001690800A70001),
                   .INIT_24             (256'h01BBA8AB70AB80AB90ABD8C0A800C48E01BBA8ABD0AB70AB80AB90AB02C0A820),
                   .INIT_25             (256'hA8ABAB05A80004FE040100AC01B60080030480200800040200A401B608A8009E),
                   .INIT_26             (256'h00000000000000D400000100D4809698D4400D03D4102700A8AB04A8A8AB06A8),
                   .INIT_27             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_28             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_29             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_30             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_31             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_32             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_33             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_34             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_35             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_36             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_37             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_38             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_39             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_00            (256'h2B04042108421084462C58B162C588B1622C588B165110968638161F5542A48C),
                   .INITP_01            (256'h2E5CB9755DC4AB1590AA6AAC4696CE6D49CDA933B525EB898DA34BB2ECBB2771),
                   .INITP_02            (256'h8DA33EAAAA81400A012C94A54A952A54A952A254A952A54462C58B162C458B17),
                   .INITP_03            (256'hFFFFFFFFFFFC7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD4A55A),
                   .INITP_04            (256'h0000000000422200000988280000000100088245017FFFFFFFFFFFFFFFFFFFFF),
                   .INITP_05            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_06            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_07            (256'h0000000000000000000000000000000000000000000000000000000000000000))
     kcpsm6_rom_l( .ADDRA               (address_a[13:0]),
                   .ENA                 (enable),
                   .CLKA                (clk),
                   .DOA                 (data_out_a_l[31:0]),
                   .DOPA                (data_out_a_l[35:32]), 
                   .DIA                 (data_in_a[31:0]),
                   .DIPA                (data_in_a[35:32]), 
                   .WEA                 (4'b0000),
                   .REGCEA              (1'b0),
                   .RSTA                (1'b0),
                   .ADDRB               (address_b[13:0]),
                   .ENB                 (enable_b),
                   .CLKB                (clk_b),
                   .DOB                 (data_out_b_l[31:0]),
                   .DOPB                (data_out_b_l[35:32]), 
                   .DIB                 (data_in_b_l[31:0]),
                   .DIPB                (data_in_b_l[35:32]), 
                   .WEB                 (we_b[3:0]),
                   .REGCEB              (1'b0),
                   .RSTB                (1'b0));
      // 
      RAMB16BWER #(.DATA_WIDTH_A        (9),
                   .DOA_REG             (0),
                   .EN_RSTRAM_A         ("FALSE"),
                   .INIT_A              (9'b000000000),
                   .RST_PRIORITY_A      ("CE"),
                   .SRVAL_A             (9'b000000000),
                   .WRITE_MODE_A        ("WRITE_FIRST"),
                   .DATA_WIDTH_B        (9),
                   .DOB_REG             (0),
                   .EN_RSTRAM_B         ("FALSE"),
                   .INIT_B              (9'b000000000),
                   .RST_PRIORITY_B      ("CE"),
                   .SRVAL_B             (9'b000000000),
                   .WRITE_MODE_B        ("WRITE_FIRST"),
                   .RSTTYPE             ("SYNC"),
                   .INIT_FILE           ("NONE"),
                   .SIM_COLLISION_CHECK ("ALL"),
                   .SIM_DEVICE          ("SPARTAN6"),
                   .INIT_00             (256'h90EA90EA90EA90EA90EA020190020190FBFCEC01020101020101020201010202),
                   .INIT_01             (256'h0110B0CBD08B01010202010101010201020102010B010B011002020A90EA90EA),
                   .INIT_02             (256'h9002A4A39C83CA90020B0C0C0D0BB0EA9002B0EA900202020A02020B0C0C0110),
                   .INIT_03             (256'h9C83CA9002B0EA9002A4A39C83CA9002A4A39C83CA9002B0EA9002A4A39C83CA),
                   .INIT_04             (256'h9C83CA9002A4A39C83CA9002A4A39C83CA9002B0EA9002A4A39C83CA9002A4A3),
                   .INIT_05             (256'hB0EA90029C83CA9002A4A39C83CA9002A4A39C83CA9002A4A39C83CA9002A4A3),
                   .INIT_06             (256'h9002A181CA9002A181CA9002A181CA9002A181CA9002A181CA9002A181CA9002),
                   .INIT_07             (256'h02020F0F0B0C0C0110020110B0EA9002B0CBB0CDB0EA90020281CA9002A181CA),
                   .INIT_08             (256'hB0CDA1A10D9981019002B0CDA1A10D99810190020BB0EA9002B0EA900202020A),
                   .INIT_09             (256'h030405020C05020CB0CDA3A40D070703049981019002B0CDA1A10D9981019002),
                   .INIT_0A             (256'hB0CDA0A40DB0CDA4A60D0C06020B0C0CB0EA9002B0CBB0EA900202010C02010C),
                   .INIT_0B             (256'hCDA4A60D0C060201020C0B9C8BB0CDA0A40DB0CDA4A60D0C06020C06029C8B0C),
                   .INIT_0C             (256'h01CB02019F8707028B0702030C0C05020CB0CDA4A3A6A60D0603B0CDA0A40DB0),
                   .INIT_0D             (256'h01010290E90202020A020B0C0C10B0CB9C8BB0CDA00DB0CDA00D06020C030402),
                   .INIT_0E             (256'h0C090AB0EA9002B0EA900202020A02020C020F0F0B0C0C011002020A02109C8B),
                   .INIT_0F             (256'h02A4A39C83CA9002A4A39C83CA9002A4A39C83CA9002A4A39C83CA90020F0F0B),
                   .INIT_10             (256'h02A4A39C83CA9102B1EA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA90),
                   .INIT_11             (256'h9C83CA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA91),
                   .INIT_12             (256'hA7A79F87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102B1EA9102),
                   .INIT_13             (256'hA7A79F87CA9102A7A79F87CA9102A7A79F87CA9102B1EA9102A7A79F87CA9102),
                   .INIT_14             (256'h87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102),
                   .INIT_15             (256'h0F2801010F10B1EA9102B0CAB0C902010C02010CB1EA91029F87CA9102A7A79F),
                   .INIT_16             (256'hCAC88A281AE8EAC8EA28B1CF25B1C8A6A6A5A508C801010291020D2803040401),
                   .INIT_17             (256'h9D8D0288EA25288A8AD1CA2802011A020201A2A2A2A202288A28CAC88AF1CAC8),
                   .INIT_18             (256'h0A0A0A0A0A0A0A0A0A0A280102A2010D0D120A28020A020A020A020A01120A11),
                   .INIT_19             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1A             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1B             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1C             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1D             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1E             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A28010D0D0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1F             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_20             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_21             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_22             (256'hB26848285858120A120A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_23             (256'h120202010201020102090212030204020402020902284A1288C8B2684808286A),
                   .INIT_24             (256'h690202020102010201020902022802B269020202010201020102010209020206),
                   .INIT_25             (256'h1202020902286818682828B2C802A169496818000828680828B2C802080228B2),
                   .INIT_26             (256'h00000000000028B2D9D8C8001208080912080809120808091202090212020902),
                   .INIT_27             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_28             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_29             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_30             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_31             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_32             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_33             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_34             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_35             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_36             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_37             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_38             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_39             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_00            (256'hC1FBAB98C6318C63B183060C1830760C1D830760C182EF63EB7D55EAAABF16DF),
                   .INITP_01            (256'h83060C18177B41ECD746221121214021020420488408BAE412801E0781E075DE),
                   .INITP_02            (256'h365CC15555640FD156EA4B183060C183060C1D83060C183B183060C183B060C1),
                   .INITP_03            (256'hFFFFFFFFFFFF3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5AAD),
                   .INITP_04            (256'h00000000030888DDEEB446D7755F7556EAB56DA39EBFFFFFFFFFFFFFFFFFFFFF),
                   .INITP_05            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_06            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_07            (256'h0000000000000000000000000000000000000000000000000000000000000000))
     kcpsm6_rom_h( .ADDRA               (address_a[13:0]),
                   .ENA                 (enable),
                   .CLKA                (clk),
                   .DOA                 (data_out_a_h[31:0]),
                   .DOPA                (data_out_a_h[35:32]), 
                   .DIA                 (data_in_a[31:0]),
                   .DIPA                (data_in_a[35:32]), 
                   .WEA                 (4'b0000),
                   .REGCEA              (1'b0),
                   .RSTA                (1'b0),
                   .ADDRB               (address_b[13:0]),
                   .ENB                 (enable_b),
                   .CLKB                (clk_b),
                   .DOB                 (data_out_b_h[31:0]),
                   .DOPB                (data_out_b_h[35:32]), 
                   .DIB                 (data_in_b_h[31:0]),
                   .DIPB                (data_in_b_h[35:32]), 
                   .WEB                 (we_b[3:0]),
                   .REGCEB              (1'b0),
                   .RSTB                (1'b0));
    end // s6;
    // 
    // 
    if (C_FAMILY == "V6") begin: v6 
      //
      assign address_a = {1'b1, address[10:0], 4'b1111};
      assign instruction = {data_out_a[33:32], data_out_a[15:0]};
      assign data_in_a = {35'b00000000000000000000000000000000000, address[11]};
      assign jtag_dout = {data_out_b[33:32], data_out_b[15:0]};
      //
      if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b = {2'b00, data_out_b[33:32], 16'b0000000000000000, data_out_b[15:0]};
        assign address_b = 16'b1111111111111111;
        assign we_b = 8'b00000000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
      if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b = {2'b00, jtag_din[17:16], 16'b0000000000000000, jtag_din[15:0]};
        assign address_b = {1'b1, jtag_addr[10:0], 4'b1111};
        assign we_b = {jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
      // 
      RAMB36E1 #(.READ_WIDTH_A              (18),
                 .WRITE_WIDTH_A             (18),
                 .DOA_REG                   (0),
                 .INIT_A                    (36'h000000000),
                 .RSTREG_PRIORITY_A         ("REGCE"),
                 .SRVAL_A                   (36'h000000000),
                 .WRITE_MODE_A              ("WRITE_FIRST"),
                 .READ_WIDTH_B              (18),
                 .WRITE_WIDTH_B             (18),
                 .DOB_REG                   (0),
                 .INIT_B                    (36'h000000000),
                 .RSTREG_PRIORITY_B         ("REGCE"),
                 .SRVAL_B                   (36'h000000000),
                 .WRITE_MODE_B              ("WRITE_FIRST"),
                 .INIT_FILE                 ("NONE"),
                 .SIM_COLLISION_CHECK       ("ALL"),
                 .RAM_MODE                  ("TDP"),
                 .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
                 .EN_ECC_READ               ("FALSE"),
                 .EN_ECC_WRITE              ("FALSE"),
                 .RAM_EXTENSION_A           ("NONE"),
                 .RAM_EXTENSION_B           ("NONE"),
                 .SIM_DEVICE                ("VIRTEX6"),
                 .INIT_00                   (256'hF718F8BAD92002E90470030D02E90480030D02E90490046B030F0303045A04D0),
                 .INIT_01                   (256'h20F8D54420F5D5452041D5572028D5522011D548045D02D72012046203CE2011),
                 .INIT_02                   (256'h048002E90490030116100301170002BF2012045D045D153F21C8D54C21B3D54F),
                 .INIT_03                   (256'h0301202B60369601A03F1701030D02E904200475030D030D030D02E9047002E9),
                 .INIT_04                   (256'h204E0462604AD590204A04620458045D1552045604931700180019A303012011),
                 .INIT_05                   (256'h205E046248004706380007509530205404621700180019A31A401668604ED552),
                 .INIT_06                   (256'h48004706380007509530206904626065D5202065046248004706380007509530),
                 .INIT_07                   (256'h380007509530207B04626077D520207704624800470638000750953020700462),
                 .INIT_08                   (256'h9530208D04626089D52020890462480047063800075095302082046248004706),
                 .INIT_09                   (256'h380007509530209B046248004706380007509530209404624800470638000750),
                 .INIT_0A                   (256'h4800470638000750953020A904624800470638000750953020A2046248004706),
                 .INIT_0B                   (256'h60BCD52020BC046238000750953020B704624800470638000750953020B00462),
                 .INIT_0C                   (256'h046242060250953020CA046242060250953020C5046242060250953020C00462),
                 .INIT_0D                   (256'h20DE046242060250953020D9046242060250953020D4046242060250953020CF),
                 .INIT_0E                   (256'h6053960160549A0160E8D52020E8046204800250953020E30462420602509530),
                 .INIT_0F                   (256'h045604931F001E001700180019A203012011049302BF201160F0D59C20F00462),
                 .INIT_10                   (256'h025002DD210C046216036107D572210704626103D590210304620458045D1572),
                 .INIT_11                   (256'h611C9B01430042061B043300025002DD2116046261129B01430042061B043300),
                 .INIT_12                   (256'h08303300025002DD212A046261269B01430042061B043300025002DD21200462),
                 .INIT_13                   (256'h07A008B00A20047519A10B20047519A061349A014708480E1A020E200F300720),
                 .INIT_14                   (256'h614CD59C214C0462610C96016146D52021460462048002E019A5048002F019A4),
                 .INIT_15                   (256'h615C9A01410049061A0261579A0149084C0E1A0219000C2004751700180019A5),
                 .INIT_16                   (256'h49061A02616A9A0149084C0E1A0219000C20047519A50D2004753800170119A4),
                 .INIT_17                   (256'h9A0149084C0E1A0219000C2004750370058019A5160138001701616F9A014100),
                 .INIT_18                   (256'h19A3618A9A01480047004D064D061A070CD0071061829A01410049061A02617D),
                 .INIT_19                   (256'h02E09780048002F03E000FB00F20047517800E20047507C0180019A20B200475),
                 .INIT_1A                   (256'h3800170161AB9A01410E1A0461A79A0141061A040D20047519A4073008500480),
                 .INIT_1B                   (256'h030102E9042021C3D2FF04750458045D155704561700180019A2201161769601),
                 .INIT_1C                   (256'h19A104931F001E001700180019A0030120110458045D1577045621BA38001701),
                 .INIT_1D                   (256'h1800134E144061D9D57221D9046261D5D59021D504620458045D157204560493),
                 .INIT_1E                   (256'h470638000750953021EA04624800470638000750953021DF04621F001E001700),
                 .INIT_1F                   (256'h04624800470638000750953021F804624800470638000750953021F104624800),
                 .INIT_20                   (256'h9530220D046248004706380007509530220604624800470638000750953021FF),
                 .INIT_21                   (256'h046248004706380007509530221804626214D520221404624800470638000750),
                 .INIT_22                   (256'h9530222D0462480047063800075095302226046248004706380007509530221F),
                 .INIT_23                   (256'h380007509530223B046248004706380007509530223404624800470638000750),
                 .INIT_24                   (256'h3F000E509530224B04624F004E063F000E509530224404626240D52022400462),
                 .INIT_25                   (256'h4F004E063F000E509530225904624F004E063F000E509530225204624F004E06),
                 .INIT_26                   (256'h3F000E509530226B04626267D520226704624F004E063F000E50953022600462),
                 .INIT_27                   (256'h4F004E063F000E509530227904624F004E063F000E509530227204624F004E06),
                 .INIT_28                   (256'h228E04624F004E063F000E509530228704624F004E063F000E50953022800462),
                 .INIT_29                   (256'h0E509530229C04624F004E063F000E509530229504624F004E063F000E509530),
                 .INIT_2A                   (256'h19A1048002F019A062A8D52022A804623F000E50953022A304624F004E063F00),
                 .INIT_2B                   (256'h1E06500002A002C51E02201162B6D59C22B6046261DE940161DF9301048002E0),
                 .INIT_2C                   (256'h4C004B004A061004900002DD02D7045D22C604621A00500007A008B009C002C5),
                 .INIT_2D                   (256'h95E9900015B9500035DFD000D57B9000D561500062C69E014A5062CD90014D00),
                 .INIT_2E                   (256'h045D02F5450E450E450E450E05405000150A500095F690001507E2E795119000),
                 .INIT_2F                   (256'h3B001A01045D1000D5004BA05000153A1507A2F8950A5000045D02F5350F0540),
                 .INIT_30                   (256'h1B03245D15205000045D155B045D151B045D154A045D15320308245D150D22FA),
                 .INIT_31                   (256'h155F155F155F155F155F15201520155F1520152050000301045D458002FA1A16),
                 .INIT_32                   (256'h155F155F15201520155F155F155F155F15201520155F155F155F155F1520155F),
                 .INIT_33                   (256'h152F1520152F157C1520157C1520150D155F155F15201520155F155F15201520),
                 .INIT_34                   (256'h157C155F155F155F1520152F155C1520155F15201520157C155F155F155F1520),
                 .INIT_35                   (256'h1520157C1520150D155F152F1520152F157C15201520152F155C15201520157C),
                 .INIT_36                   (256'h155F155C15201529155F157C1520157C152015201520157C1520152F15201527),
                 .INIT_37                   (256'h1520155F15271520157C1520157C152F155C157C1520157C155C1520155F155F),
                 .INIT_38                   (256'h15201520157C155F155F155F157C1520155C1520152E1520157C1520150D155C),
                 .INIT_39                   (256'h1520157C15201520157C1520157C15201529155F155F155F1520152F155F155F),
                 .INIT_3A                   (256'h155F155C155F155C157C155F157C1520150D152915201529155F15281520157C),
                 .INIT_3B                   (256'h157C152F155F155F155F155F157C152015201520157C155F157C155F155F155F),
                 .INIT_3C                   (256'h1AD21B031500150D152F155F155F155F155C157C155F157C15201520157C155F),
                 .INIT_3D                   (256'h156915441520152D152015481520150D1575156E1565154D150D150D500002FA),
                 .INIT_3E                   (256'h150D1575156E1565156D15201573156915681574152015791561156C15701573),
                 .INIT_3F                   (256'h152915451554155915421528152015641561156515521520152D152015521520),
                 .INIT_40                   (256'h154C1549154615281520156515741569157215571520152D152015571520150D),
                 .INIT_41                   (256'h155315281520156515731561157215451520152D152015451520150D15291545),
                 .INIT_42                   (256'h15611574156115441520152D152015441520150D15291572156F157415631565),
                 .INIT_43                   (256'h1575154F1520152D1520154F1520150D1529155415551550154E154915281520),
                 .INIT_44                   (256'h154F154C1520152D1520154C1520150D1547154F154C15201574157515701574),
                 .INIT_45                   (256'h645DD00490005000B001B031245D159C245D15901500150D15501555154B154F),
                 .INIT_46                   (256'h092004AB04AB129F04A8500095012463100091016469D008900011A75000D501),
                 .INIT_47                   (256'h24A804AB04AB027004AB028004AB029004AB120304A824A8072004AB082004AB),
                 .INIT_48                   (256'hD20104BB04A804AB02D004AB027004AB028004AB029004AB120204C004A80D20),
                 .INIT_49                   (256'hD20104BB04A804AB027004AB028004AB029004AB12D804C004A8500004C4648E),
                 .INIT_4A                   (256'h9303D0043080002011085000D0041002500064A4910104B6110804A85000649E),
                 .INIT_4B                   (256'h24A804AB04AB120504A85000D00430FED0045001500064AC910104B64200D380),
                 .INIT_4C                   (256'h24D41040110D120324D410101127120024A804AB120404A824A804AB120604A8),
                 .INIT_4D                   (256'h000000000000000000000000500064D4B200B1009001000024D4108011961298),
                 .INIT_4E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_50                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_51                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_52                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_53                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_54                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_55                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_56                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_57                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_58                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_59                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_60                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_61                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_62                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_63                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_64                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_65                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_66                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_67                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_68                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_69                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_70                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_71                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_72                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_73                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_74                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_75                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_76                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_77                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_78                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_79                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_00                  (256'h57B7955E557B7955E557800DEDEA280AADDA2AA22222A8DDDDDDDAEB5628A2AA),
                 .INITP_01                  (256'hA002AADEDDDE9795E5795E5795E5795EDE57955E557955E557955E557B7955E5),
                 .INITP_02                  (256'h540801754D502094D5354080DEDDE8200208D50016ED516ED516ED516E37B7A8),
                 .INITP_03                  (256'h955E557955E55780037B7A8A2002A8A5A36A202D5D4D42021852480235540D53),
                 .INITP_04                  (256'h557955E557B7955E557955E557955EDE57955E557955E557955EDE557955E557),
                 .INITP_05                  (256'h5B6976A0A552677776376D3554EAE202222DEDD820DE57955E557955E557955E),
                 .INITP_06                  (256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA98228888A2),
                 .INITP_07                  (256'hAAAAAAAAAAAAAAAAAAAAAAAA0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA),
                 .INITP_08                  (256'hA8888A2228A2DC0AC2A88AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA),
                 .INITP_09                  (256'h0000000000000000000B54808080A2A2A8A88B642028B62B2A2222AB2A222228),
                 .INITP_0A                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0B                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0C                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0D                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0E                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0F                  (256'h0000000000000000000000000000000000000000000000000000000000000000))
     kcpsm6_rom( .ADDRARDADDR               (address_a),
                 .ENARDEN                   (enable),
                 .CLKARDCLK                 (clk),
                 .DOADO                     (data_out_a[31:0]),
                 .DOPADOP                   (data_out_a[35:32]), 
                 .DIADI                     (data_in_a[31:0]),
                 .DIPADIP                   (data_in_a[35:32]), 
                 .WEA                       (4'b0000),
                 .REGCEAREGCE               (1'b0),
                 .RSTRAMARSTRAM             (1'b0),
                 .RSTREGARSTREG             (1'b0),
                 .ADDRBWRADDR               (address_b),
                 .ENBWREN                   (enable_b),
                 .CLKBWRCLK                 (clk_b),
                 .DOBDO                     (data_out_b[31:0]),
                 .DOPBDOP                   (data_out_b[35:32]), 
                 .DIBDI                     (data_in_b[31:0]),
                 .DIPBDIP                   (data_in_b[35:32]), 
                 .WEBWE                     (we_b),
                 .REGCEB                    (1'b0),
                 .RSTRAMB                   (1'b0),
                 .RSTREGB                   (1'b0),
                 .CASCADEINA                (1'b0),
                 .CASCADEINB                (1'b0),
                 .CASCADEOUTA               (),
                 .CASCADEOUTB               (),
                 .DBITERR                   (),
                 .ECCPARITY                 (),
                 .RDADDRECC                 (),
                 .SBITERR                   (),
                 .INJECTDBITERR             (1'b0),       
                 .INJECTSBITERR             (1'b0));   
    end // v6;  
    // 
    // 
    if (C_FAMILY == "7S") begin: akv7 
      //
      assign address_a = {1'b1, address[10:0], 4'b1111};
      assign instruction = {data_out_a[33:32], data_out_a[15:0]};
      assign data_in_a = {35'b00000000000000000000000000000000000, address[11]};
      assign jtag_dout = {data_out_b[33:32], data_out_b[15:0]};
      //
      if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b = {2'b00, data_out_b[33:32], 16'b0000000000000000, data_out_b[15:0]};
        assign address_b = 16'b1111111111111111;
        assign we_b = 8'b00000000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
      if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b = {2'b00, jtag_din[17:16], 16'b0000000000000000, jtag_din[15:0]};
        assign address_b = {1'b1, jtag_addr[10:0], 4'b1111};
        assign we_b = {jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
      // 
      RAMB36E1 #(.READ_WIDTH_A              (18),
                 .WRITE_WIDTH_A             (18),
                 .DOA_REG                   (0),
                 .INIT_A                    (36'h000000000),
                 .RSTREG_PRIORITY_A         ("REGCE"),
                 .SRVAL_A                   (36'h000000000),
                 .WRITE_MODE_A              ("WRITE_FIRST"),
                 .READ_WIDTH_B              (18),
                 .WRITE_WIDTH_B             (18),
                 .DOB_REG                   (0),
                 .INIT_B                    (36'h000000000),
                 .RSTREG_PRIORITY_B         ("REGCE"),
                 .SRVAL_B                   (36'h000000000),
                 .WRITE_MODE_B              ("WRITE_FIRST"),
                 .INIT_FILE                 ("NONE"),
                 .SIM_COLLISION_CHECK       ("ALL"),
                 .RAM_MODE                  ("TDP"),
                 .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
                 .EN_ECC_READ               ("FALSE"),
                 .EN_ECC_WRITE              ("FALSE"),
                 .RAM_EXTENSION_A           ("NONE"),
                 .RAM_EXTENSION_B           ("NONE"),
                 .SIM_DEVICE                ("7SERIES"),
                 .INIT_00                   (256'hF718F8BAD92002E90470030D02E90480030D02E90490046B030F0303045A04D0),
                 .INIT_01                   (256'h20F8D54420F5D5452041D5572028D5522011D548045D02D72012046203CE2011),
                 .INIT_02                   (256'h048002E90490030116100301170002BF2012045D045D153F21C8D54C21B3D54F),
                 .INIT_03                   (256'h0301202B60369601A03F1701030D02E904200475030D030D030D02E9047002E9),
                 .INIT_04                   (256'h204E0462604AD590204A04620458045D1552045604931700180019A303012011),
                 .INIT_05                   (256'h205E046248004706380007509530205404621700180019A31A401668604ED552),
                 .INIT_06                   (256'h48004706380007509530206904626065D5202065046248004706380007509530),
                 .INIT_07                   (256'h380007509530207B04626077D520207704624800470638000750953020700462),
                 .INIT_08                   (256'h9530208D04626089D52020890462480047063800075095302082046248004706),
                 .INIT_09                   (256'h380007509530209B046248004706380007509530209404624800470638000750),
                 .INIT_0A                   (256'h4800470638000750953020A904624800470638000750953020A2046248004706),
                 .INIT_0B                   (256'h60BCD52020BC046238000750953020B704624800470638000750953020B00462),
                 .INIT_0C                   (256'h046242060250953020CA046242060250953020C5046242060250953020C00462),
                 .INIT_0D                   (256'h20DE046242060250953020D9046242060250953020D4046242060250953020CF),
                 .INIT_0E                   (256'h6053960160549A0160E8D52020E8046204800250953020E30462420602509530),
                 .INIT_0F                   (256'h045604931F001E001700180019A203012011049302BF201160F0D59C20F00462),
                 .INIT_10                   (256'h025002DD210C046216036107D572210704626103D590210304620458045D1572),
                 .INIT_11                   (256'h611C9B01430042061B043300025002DD2116046261129B01430042061B043300),
                 .INIT_12                   (256'h08303300025002DD212A046261269B01430042061B043300025002DD21200462),
                 .INIT_13                   (256'h07A008B00A20047519A10B20047519A061349A014708480E1A020E200F300720),
                 .INIT_14                   (256'h614CD59C214C0462610C96016146D52021460462048002E019A5048002F019A4),
                 .INIT_15                   (256'h615C9A01410049061A0261579A0149084C0E1A0219000C2004751700180019A5),
                 .INIT_16                   (256'h49061A02616A9A0149084C0E1A0219000C20047519A50D2004753800170119A4),
                 .INIT_17                   (256'h9A0149084C0E1A0219000C2004750370058019A5160138001701616F9A014100),
                 .INIT_18                   (256'h19A3618A9A01480047004D064D061A070CD0071061829A01410049061A02617D),
                 .INIT_19                   (256'h02E09780048002F03E000FB00F20047517800E20047507C0180019A20B200475),
                 .INIT_1A                   (256'h3800170161AB9A01410E1A0461A79A0141061A040D20047519A4073008500480),
                 .INIT_1B                   (256'h030102E9042021C3D2FF04750458045D155704561700180019A2201161769601),
                 .INIT_1C                   (256'h19A104931F001E001700180019A0030120110458045D1577045621BA38001701),
                 .INIT_1D                   (256'h1800134E144061D9D57221D9046261D5D59021D504620458045D157204560493),
                 .INIT_1E                   (256'h470638000750953021EA04624800470638000750953021DF04621F001E001700),
                 .INIT_1F                   (256'h04624800470638000750953021F804624800470638000750953021F104624800),
                 .INIT_20                   (256'h9530220D046248004706380007509530220604624800470638000750953021FF),
                 .INIT_21                   (256'h046248004706380007509530221804626214D520221404624800470638000750),
                 .INIT_22                   (256'h9530222D0462480047063800075095302226046248004706380007509530221F),
                 .INIT_23                   (256'h380007509530223B046248004706380007509530223404624800470638000750),
                 .INIT_24                   (256'h3F000E509530224B04624F004E063F000E509530224404626240D52022400462),
                 .INIT_25                   (256'h4F004E063F000E509530225904624F004E063F000E509530225204624F004E06),
                 .INIT_26                   (256'h3F000E509530226B04626267D520226704624F004E063F000E50953022600462),
                 .INIT_27                   (256'h4F004E063F000E509530227904624F004E063F000E509530227204624F004E06),
                 .INIT_28                   (256'h228E04624F004E063F000E509530228704624F004E063F000E50953022800462),
                 .INIT_29                   (256'h0E509530229C04624F004E063F000E509530229504624F004E063F000E509530),
                 .INIT_2A                   (256'h19A1048002F019A062A8D52022A804623F000E50953022A304624F004E063F00),
                 .INIT_2B                   (256'h1E06500002A002C51E02201162B6D59C22B6046261DE940161DF9301048002E0),
                 .INIT_2C                   (256'h4C004B004A061004900002DD02D7045D22C604621A00500007A008B009C002C5),
                 .INIT_2D                   (256'h95E9900015B9500035DFD000D57B9000D561500062C69E014A5062CD90014D00),
                 .INIT_2E                   (256'h045D02F5450E450E450E450E05405000150A500095F690001507E2E795119000),
                 .INIT_2F                   (256'h3B001A01045D1000D5004BA05000153A1507A2F8950A5000045D02F5350F0540),
                 .INIT_30                   (256'h1B03245D15205000045D155B045D151B045D154A045D15320308245D150D22FA),
                 .INIT_31                   (256'h155F155F155F155F155F15201520155F1520152050000301045D458002FA1A16),
                 .INIT_32                   (256'h155F155F15201520155F155F155F155F15201520155F155F155F155F1520155F),
                 .INIT_33                   (256'h152F1520152F157C1520157C1520150D155F155F15201520155F155F15201520),
                 .INIT_34                   (256'h157C155F155F155F1520152F155C1520155F15201520157C155F155F155F1520),
                 .INIT_35                   (256'h1520157C1520150D155F152F1520152F157C15201520152F155C15201520157C),
                 .INIT_36                   (256'h155F155C15201529155F157C1520157C152015201520157C1520152F15201527),
                 .INIT_37                   (256'h1520155F15271520157C1520157C152F155C157C1520157C155C1520155F155F),
                 .INIT_38                   (256'h15201520157C155F155F155F157C1520155C1520152E1520157C1520150D155C),
                 .INIT_39                   (256'h1520157C15201520157C1520157C15201529155F155F155F1520152F155F155F),
                 .INIT_3A                   (256'h155F155C155F155C157C155F157C1520150D152915201529155F15281520157C),
                 .INIT_3B                   (256'h157C152F155F155F155F155F157C152015201520157C155F157C155F155F155F),
                 .INIT_3C                   (256'h1AD21B031500150D152F155F155F155F155C157C155F157C15201520157C155F),
                 .INIT_3D                   (256'h156915441520152D152015481520150D1575156E1565154D150D150D500002FA),
                 .INIT_3E                   (256'h150D1575156E1565156D15201573156915681574152015791561156C15701573),
                 .INIT_3F                   (256'h152915451554155915421528152015641561156515521520152D152015521520),
                 .INIT_40                   (256'h154C1549154615281520156515741569157215571520152D152015571520150D),
                 .INIT_41                   (256'h155315281520156515731561157215451520152D152015451520150D15291545),
                 .INIT_42                   (256'h15611574156115441520152D152015441520150D15291572156F157415631565),
                 .INIT_43                   (256'h1575154F1520152D1520154F1520150D1529155415551550154E154915281520),
                 .INIT_44                   (256'h154F154C1520152D1520154C1520150D1547154F154C15201574157515701574),
                 .INIT_45                   (256'h645DD00490005000B001B031245D159C245D15901500150D15501555154B154F),
                 .INIT_46                   (256'h092004AB04AB129F04A8500095012463100091016469D008900011A75000D501),
                 .INIT_47                   (256'h24A804AB04AB027004AB028004AB029004AB120304A824A8072004AB082004AB),
                 .INIT_48                   (256'hD20104BB04A804AB02D004AB027004AB028004AB029004AB120204C004A80D20),
                 .INIT_49                   (256'hD20104BB04A804AB027004AB028004AB029004AB12D804C004A8500004C4648E),
                 .INIT_4A                   (256'h9303D0043080002011085000D0041002500064A4910104B6110804A85000649E),
                 .INIT_4B                   (256'h24A804AB04AB120504A85000D00430FED0045001500064AC910104B64200D380),
                 .INIT_4C                   (256'h24D41040110D120324D410101127120024A804AB120404A824A804AB120604A8),
                 .INIT_4D                   (256'h000000000000000000000000500064D4B200B1009001000024D4108011961298),
                 .INIT_4E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_50                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_51                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_52                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_53                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_54                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_55                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_56                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_57                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_58                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_59                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_60                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_61                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_62                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_63                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_64                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_65                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_66                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_67                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_68                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_69                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_70                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_71                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_72                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_73                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_74                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_75                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_76                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_77                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_78                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_79                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_00                  (256'h57B7955E557B7955E557800DEDEA280AADDA2AA22222A8DDDDDDDAEB5628A2AA),
                 .INITP_01                  (256'hA002AADEDDDE9795E5795E5795E5795EDE57955E557955E557955E557B7955E5),
                 .INITP_02                  (256'h540801754D502094D5354080DEDDE8200208D50016ED516ED516ED516E37B7A8),
                 .INITP_03                  (256'h955E557955E55780037B7A8A2002A8A5A36A202D5D4D42021852480235540D53),
                 .INITP_04                  (256'h557955E557B7955E557955E557955EDE57955E557955E557955EDE557955E557),
                 .INITP_05                  (256'h5B6976A0A552677776376D3554EAE202222DEDD820DE57955E557955E557955E),
                 .INITP_06                  (256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA98228888A2),
                 .INITP_07                  (256'hAAAAAAAAAAAAAAAAAAAAAAAA0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA),
                 .INITP_08                  (256'hA8888A2228A2DC0AC2A88AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA),
                 .INITP_09                  (256'h0000000000000000000B54808080A2A2A8A88B642028B62B2A2222AB2A222228),
                 .INITP_0A                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0B                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0C                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0D                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0E                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0F                  (256'h0000000000000000000000000000000000000000000000000000000000000000))
     kcpsm6_rom( .ADDRARDADDR               (address_a),
                 .ENARDEN                   (enable),
                 .CLKARDCLK                 (clk),
                 .DOADO                     (data_out_a[31:0]),
                 .DOPADOP                   (data_out_a[35:32]), 
                 .DIADI                     (data_in_a[31:0]),
                 .DIPADIP                   (data_in_a[35:32]), 
                 .WEA                       (4'b0000),
                 .REGCEAREGCE               (1'b0),
                 .RSTRAMARSTRAM             (1'b0),
                 .RSTREGARSTREG             (1'b0),
                 .ADDRBWRADDR               (address_b),
                 .ENBWREN                   (enable_b),
                 .CLKBWRCLK                 (clk_b),
                 .DOBDO                     (data_out_b[31:0]),
                 .DOPBDOP                   (data_out_b[35:32]), 
                 .DIBDI                     (data_in_b[31:0]),
                 .DIPBDIP                   (data_in_b[35:32]), 
                 .WEBWE                     (we_b),
                 .REGCEB                    (1'b0),
                 .RSTRAMB                   (1'b0),
                 .RSTREGB                   (1'b0),
                 .CASCADEINA                (1'b0),
                 .CASCADEINB                (1'b0),
                 .CASCADEOUTA               (),
                 .CASCADEOUTB               (),
                 .DBITERR                   (),
                 .ECCPARITY                 (),
                 .RDADDRECC                 (),
                 .SBITERR                   (),
                 .INJECTDBITERR             (1'b0),       
                 .INJECTSBITERR             (1'b0));   
    end // akv7;  
    // 
  end // ram_2k_generate;
endgenerate              
//
generate
  if (C_RAM_SIZE_KWORDS == 4) begin : ram_4k_generate 
    if (C_FAMILY == "S6") begin: s6 
      //
      assign address_a[13:0] = {address[10:0], 3'b000};
      assign data_in_a = 36'b000000000000000000000000000000000000;
      //
      FD s6_a11_flop ( .D      (address[11]),
                       .Q      (pipe_a11),
                       .C      (clk));
      //
      LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
       s6_4k_mux0_lut( .I0     (data_out_a_ll[0]),
                       .I1     (data_out_a_hl[0]),
                       .I2     (data_out_a_ll[1]),
                       .I3     (data_out_a_hl[1]),
                       .I4     (pipe_a11),
                       .I5     (1'b1),
                       .O5     (instruction[0]),
                       .O6     (instruction[1]));
      //
      LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
       s6_4k_mux2_lut( .I0     (data_out_a_ll[2]),
                       .I1     (data_out_a_hl[2]),
                       .I2     (data_out_a_ll[3]),
                       .I3     (data_out_a_hl[3]),
                       .I4     (pipe_a11),
                       .I5     (1'b1),
                       .O5     (instruction[2]),
                       .O6     (instruction[3]));
      //
      LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
       s6_4k_mux4_lut( .I0     (data_out_a_ll[4]),
                       .I1     (data_out_a_hl[4]),
                       .I2     (data_out_a_ll[5]),
                       .I3     (data_out_a_hl[5]),
                       .I4     (pipe_a11),
                       .I5     (1'b1),
                       .O5     (instruction[4]),
                       .O6     (instruction[5]));
      //
      LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
       s6_4k_mux6_lut( .I0     (data_out_a_ll[6]),
                       .I1     (data_out_a_hl[6]),
                       .I2     (data_out_a_ll[7]),
                       .I3     (data_out_a_hl[7]),
                       .I4     (pipe_a11),
                       .I5     (1'b1),
                       .O5     (instruction[6]),
                       .O6     (instruction[7]));
      //
      LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
       s6_4k_mux8_lut( .I0     (data_out_a_ll[32]),
                       .I1     (data_out_a_hl[32]),
                       .I2     (data_out_a_lh[0]),
                       .I3     (data_out_a_hh[0]),
                       .I4     (pipe_a11),
                       .I5     (1'b1),
                       .O5     (instruction[8]),
                       .O6     (instruction[9]));
      //
      LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
      s6_4k_mux10_lut( .I0     (data_out_a_lh[1]),
                       .I1     (data_out_a_hh[1]),
                       .I2     (data_out_a_lh[2]),
                       .I3     (data_out_a_hh[2]),
                       .I4     (pipe_a11),
                       .I5     (1'b1),
                       .O5     (instruction[10]),
                       .O6     (instruction[11]));
      //
      LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
      s6_4k_mux12_lut( .I0     (data_out_a_lh[3]),
                       .I1     (data_out_a_hh[3]),
                       .I2     (data_out_a_lh[4]),
                       .I3     (data_out_a_hh[4]),
                       .I4     (pipe_a11),
                       .I5     (1'b1),
                       .O5     (instruction[12]),
                       .O6     (instruction[13]));
      //
      LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
      s6_4k_mux14_lut( .I0     (data_out_a_lh[5]),
                       .I1     (data_out_a_hh[5]),
                       .I2     (data_out_a_lh[6]),
                       .I3     (data_out_a_hh[6]),
                       .I4     (pipe_a11),
                       .I5     (1'b1),
                       .O5     (instruction[14]),
                       .O6     (instruction[15]));
      //
      LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
      s6_4k_mux16_lut( .I0     (data_out_a_lh[7]),
                       .I1     (data_out_a_hh[7]),
                       .I2     (data_out_a_lh[32]),
                       .I3     (data_out_a_hh[32]),
                       .I4     (pipe_a11),
                       .I5     (1'b1),
                       .O5     (instruction[16]),
                       .O6     (instruction[17]));
      //
      if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b_ll = {3'b000, data_out_b_ll[32], 24'b000000000000000000000000, data_out_b_ll[7:0]};
        assign data_in_b_lh = {3'b000, data_out_b_lh[32], 24'b000000000000000000000000, data_out_b_lh[7:0]};
        assign data_in_b_hl = {3'b000, data_out_b_hl[32], 24'b000000000000000000000000, data_out_b_hl[7:0]};
        assign data_in_b_hh = {3'b000, data_out_b_hh[32], 24'b000000000000000000000000, data_out_b_hh[7:0]};
        assign address_b[13:0] = 14'b00000000000000;
        assign we_b_l[3:0] = 4'b0000;
        assign we_b_h[3:0] = 4'b0000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
        assign jtag_dout = {data_out_b_h[32], data_out_b_h[7:0], data_out_b_l[32], data_out_b_l[7:0]};
      end // no_loader;
      //
      if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b_lh = {3'b000, jtag_din[17], 24'b000000000000000000000000, jtag_din[16:9]};
        assign data_in_b_ll = {3'b000, jtag_din[8],  24'b000000000000000000000000, jtag_din[7:0]};
        assign data_in_b_hh = {3'b000, jtag_din[17], 24'b000000000000000000000000, jtag_din[16:9]};
        assign data_in_b_hl = {3'b000, jtag_din[8],  24'b000000000000000000000000, jtag_din[7:0]};
        assign address_b[13:0] = {jtag_addr[10:0], 3'b000};
        //
        LUT6_2 # (         .INIT   (64'h8000000020000000))
        s6_4k_jtag_we_lut( .I0     (jtag_we),
                           .I1     (jtag_addr[11]),
                           .I2     (1'b1),
                           .I3     (1'b1),
                           .I4     (1'b1),
                           .I5     (1'b1),
                           .O5     (jtag_we_l),
                           .O6     (jtag_we_h));
        //
        assign we_b_l[3:0] = {jtag_we_l, jtag_we_l, jtag_we_l, jtag_we_l};
        assign we_b_h[3:0] = {jtag_we_h, jtag_we_h, jtag_we_h, jtag_we_h};
        //
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
        //
        LUT6_2 # (            .INIT   (64'hFF00F0F0CCCCAAAA))
         s6_4k_jtag_mux0_lut( .I0     (data_out_b_ll[0]),
                              .I1     (data_out_b_hl[0]),
                              .I2     (data_out_b_ll[1]),
                              .I3     (data_out_b_hl[1]),
                              .I4     (jtag_addr[11]),
                              .I5     (1'b1),
                              .O5     (jtag_dout[0]),
                              .O6     (jtag_dout[1]));
        //
        LUT6_2 # (            .INIT   (64'hFF00F0F0CCCCAAAA))
         s6_4k_jtag_mux2_lut( .I0     (data_out_b_ll[2]),
                              .I1     (data_out_b_hl[2]),
                              .I2     (data_out_b_ll[3]),
                              .I3     (data_out_b_hl[3]),
                              .I4     (jtag_addr[11]),
                              .I5     (1'b1),
                              .O5     (jtag_dout[2]),
                              .O6     (jtag_dout[3]));
        //
        LUT6_2 # (            .INIT   (64'hFF00F0F0CCCCAAAA))
         s6_4k_jtag_mux4_lut( .I0     (data_out_b_ll[4]),
                              .I1     (data_out_b_hl[4]),
                              .I2     (data_out_b_ll[5]),
                              .I3     (data_out_b_hl[5]),
                              .I4     (jtag_addr[11]),
                              .I5     (1'b1),
                              .O5     (jtag_dout[4]),
                              .O6     (jtag_dout[5]));
        //
        LUT6_2 # (            .INIT   (64'hFF00F0F0CCCCAAAA))
         s6_4k_jtag_mux6_lut( .I0     (data_out_b_ll[6]),
                              .I1     (data_out_b_hl[6]),
                              .I2     (data_out_b_ll[7]),
                              .I3     (data_out_b_hl[7]),
                              .I4     (jtag_addr[11]),
                              .I5     (1'b1),
                              .O5     (jtag_dout[6]),
                              .O6     (jtag_dout[7]));
        //
        LUT6_2 # (            .INIT   (64'hFF00F0F0CCCCAAAA))
         s6_4k_jtag_mux8_lut( .I0     (data_out_b_ll[32]),
                              .I1     (data_out_b_hl[32]),
                              .I2     (data_out_b_lh[0]),
                              .I3     (data_out_b_hh[0]),
                              .I4     (jtag_addr[11]),
                              .I5     (1'b1),
                              .O5     (jtag_dout[8]),
                              .O6     (jtag_dout[9]));
        //
        LUT6_2 # (            .INIT   (64'hFF00F0F0CCCCAAAA))
        s6_4k_jtag_mux10_lut( .I0     (data_out_b_lh[1]),
                              .I1     (data_out_b_hh[1]),
                              .I2     (data_out_b_lh[2]),
                              .I3     (data_out_b_hh[2]),
                              .I4     (jtag_addr[11]),
                              .I5     (1'b1),
                              .O5     (jtag_dout[10]),
                              .O6     (jtag_dout[11]));
        //
        LUT6_2 # (            .INIT   (64'hFF00F0F0CCCCAAAA))
        s6_4k_jtag_mux12_lut( .I0     (data_out_b_lh[3]),
                              .I1     (data_out_b_hh[3]),
                              .I2     (data_out_b_lh[4]),
                              .I3     (data_out_b_hh[4]),
                              .I4     (jtag_addr[11]),
                              .I5     (1'b1),
                              .O5     (jtag_dout[12]),
                              .O6     (jtag_dout[13]));
        //
        LUT6_2 # (            .INIT   (64'hFF00F0F0CCCCAAAA))
        s6_4k_jtag_mux14_lut( .I0     (data_out_b_lh[5]),
                              .I1     (data_out_b_hh[5]),
                              .I2     (data_out_b_lh[6]),
                              .I3     (data_out_b_hh[6]),
                              .I4     (jtag_addr[11]),
                              .I5     (1'b1),
                              .O5     (jtag_dout[14]),
                              .O6     (jtag_dout[15]));
        //
        LUT6_2 # (            .INIT   (64'hFF00F0F0CCCCAAAA))
        s6_4k_jtag_mux16_lut( .I0     (data_out_b_lh[7]),
                              .I1     (data_out_b_hh[7]),
                              .I2     (data_out_b_lh[32]),
                              .I3     (data_out_b_hh[32]),
                              .I4     (jtag_addr[11]),
                              .I5     (1'b1),
                              .O5     (jtag_dout[16]),
                              .O6     (jtag_dout[17]));
        //
      end // loader;
      // 
      RAMB16BWER #(.DATA_WIDTH_A        (9),
                   .DOA_REG             (0),
                   .EN_RSTRAM_A         ("FALSE"),
                   .INIT_A              (9'b000000000),
                   .RST_PRIORITY_A      ("CE"),
                   .SRVAL_A             (9'b000000000),
                   .WRITE_MODE_A        ("WRITE_FIRST"),
                   .DATA_WIDTH_B        (9),
                   .DOB_REG             (0),
                   .EN_RSTRAM_B         ("FALSE"),
                   .INIT_B              (9'b000000000),
                   .RST_PRIORITY_B      ("CE"),
                   .SRVAL_B             (9'b000000000),
                   .WRITE_MODE_B        ("WRITE_FIRST"),
                   .RSTTYPE             ("SYNC"),
                   .INIT_FILE           ("NONE"),
                   .SIM_COLLISION_CHECK ("ALL"),
                   .SIM_DEVICE          ("SPARTAN6"),
                   .INIT_00             (256'hF844F5454157285211485DD71262CE1118BA20E9700DE9800DE9906B0F035AD0),
                   .INIT_01             (256'h012B36013F010DE920750D0D0DE970E980E99001100100BF125D5D3FC84CB34F),
                   .INIT_02             (256'h5E62000600503054620000A340684E524E624A904A62585D5256930000A30111),
                   .INIT_03             (256'h0050307B62772077620006005030706200060050306962652065620006005030),
                   .INIT_04             (256'h0050309B620006005030946200060050308D6289208962000600503082620006),
                   .INIT_05             (256'hBC20BC62005030B7620006005030B0620006005030A9620006005030A2620006),
                   .INIT_06             (256'hDE62065030D962065030D462065030CF62065030CA62065030C562065030C062),
                   .INIT_07             (256'h569300000000A2011193BF11F09CF06253015401E820E862805030E362065030),
                   .INIT_08             (256'h1C010006040050DD166212010006040050DD0C62030772076203900362585D72),
                   .INIT_09             (256'hA0B02075A12075A03401080E02203020300050DD2A6226010006040050DD2062),
                   .INIT_0A             (256'h5C010006025701080E020020750000A54C9C4C620C014620466280E0A580F0A4),
                   .INIT_0B             (256'h01080E020020757080A50100016F010006026A01080E02002075A520750001A4),
                   .INIT_0C             (256'hE08080F000B02075802075C000A22075A38A010000060607D01082010006027D),
                   .INIT_0D             (256'h01E920C3FF75585D57560000A21176010001AB010E04A70106042075A4305080),
                   .INIT_0E             (256'h004E40D972D962D590D562585D725693A19300000000A00111585D7756BA0001),
                   .INIT_0F             (256'h620006005030F8620006005030F1620006005030EA620006005030DF62000000),
                   .INIT_10             (256'h62000600503018621420146200060050300D62000600503006620006005030FF),
                   .INIT_11             (256'h0050303B620006005030346200060050302D620006005030266200060050301F),
                   .INIT_12             (256'h000600503059620006005030526200060050304B620006005030446240204062),
                   .INIT_13             (256'h000600503079620006005030726200060050306B626720676200060050306062),
                   .INIT_14             (256'h50309C620006005030956200060050308E620006005030876200060050308062),
                   .INIT_15             (256'h0600A0C50211B69CB662DE01DF0180E0A180F0A0A820A862005030A362000600),
                   .INIT_16             (256'hE900B900DF007B006100C60150CD01000000060400DDD75DC6620000A0B0C0C5),
                   .INIT_17             (256'h00015D0000A0003A07F80A005DF50F405DF50E0E0E0E40000A00F60007E71100),
                   .INIT_18             (256'h5F5F5F5F5F20205F202000015D80FA16035D20005D5B5D1B5D4A5D32085D0DFA),
                   .INIT_19             (256'h2F202F7C207C200D5F5F20205F5F20205F5F20205F5F5F5F20205F5F5F5F205F),
                   .INIT_1A             (256'h207C200D5F2F202F7C20202F5C20207C7C5F5F5F202F5C205F20207C5F5F5F20),
                   .INIT_1B             (256'h205F27207C207C2F5C7C207C5C205F5F5F5C20295F7C207C2020207C202F2027),
                   .INIT_1C             (256'h207C20207C207C20295F5F5F202F5F5F20207C5F5F5F7C205C202E207C200D5C),
                   .INIT_1D             (256'h7C2F5F5F5F5F7C2020207C5F7C5F5F5F5F5C5F5C7C5F7C200D2920295F28207C),
                   .INIT_1E             (256'h6944202D2048200D756E654D0D0D00FAD203000D2F5F5F5F5C7C5F7C20207C5F),
                   .INIT_1F             (256'h2945545942282064616552202D2052200D756E656D20736968742079616C7073),
                   .INIT_20             (256'h5328206573617245202D2045200D29454C494628206574697257202D2057200D),
                   .INIT_21             (256'h754F202D204F200D295455504E49282061746144202D2044200D29726F746365),
                   .INIT_22             (256'h5D04000001315D9C5D90000D50554B4F4F4C202D204C200D474F4C2074757074),
                   .INIT_23             (256'hA8ABAB70AB80AB90AB03A8A820AB20AB20ABAB9FA80001630001690800A70001),
                   .INIT_24             (256'h01BBA8AB70AB80AB90ABD8C0A800C48E01BBA8ABD0AB70AB80AB90AB02C0A820),
                   .INIT_25             (256'hA8ABAB05A80004FE040100AC01B60080030480200800040200A401B608A8009E),
                   .INIT_26             (256'h00000000000000D400000100D4809698D4400D03D4102700A8AB04A8A8AB06A8),
                   .INIT_27             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_28             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_29             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_30             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_31             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_32             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_33             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_34             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_35             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_36             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_37             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_38             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_39             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_00            (256'h2B04042108421084462C58B162C588B1622C588B165110968638161F5542A48C),
                   .INITP_01            (256'h2E5CB9755DC4AB1590AA6AAC4696CE6D49CDA933B525EB898DA34BB2ECBB2771),
                   .INITP_02            (256'h8DA33EAAAA81400A012C94A54A952A54A952A254A952A54462C58B162C458B17),
                   .INITP_03            (256'hFFFFFFFFFFFC7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD4A55A),
                   .INITP_04            (256'h0000000000422200000988280000000100088245017FFFFFFFFFFFFFFFFFFFFF),
                   .INITP_05            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_06            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_07            (256'h0000000000000000000000000000000000000000000000000000000000000000))
    kcpsm6_rom_ll( .ADDRA               (address_a[13:0]),
                   .ENA                 (enable),
                   .CLKA                (clk),
                   .DOA                 (data_out_a_ll[31:0]),
                   .DOPA                (data_out_a_ll[35:32]), 
                   .DIA                 (data_in_a[31:0]),
                   .DIPA                (data_in_a[35:32]), 
                   .WEA                 (4'b0000),
                   .REGCEA              (1'b0),
                   .RSTA                (1'b0),
                   .ADDRB               (address_b[13:0]),
                   .ENB                 (enable_b),
                   .CLKB                (clk_b),
                   .DOB                 (data_out_b_ll[31:0]),
                   .DOPB                (data_out_b_ll[35:32]), 
                   .DIB                 (data_in_b_ll[31:0]),
                   .DIPB                (data_in_b_ll[35:32]), 
                   .WEB                 (we_b_l[3:0]),
                   .REGCEB              (1'b0),
                   .RSTB                (1'b0));
      // 
      RAMB16BWER #(.DATA_WIDTH_A        (9),
                   .DOA_REG             (0),
                   .EN_RSTRAM_A         ("FALSE"),
                   .INIT_A              (9'b000000000),
                   .RST_PRIORITY_A      ("CE"),
                   .SRVAL_A             (9'b000000000),
                   .WRITE_MODE_A        ("WRITE_FIRST"),
                   .DATA_WIDTH_B        (9),
                   .DOB_REG             (0),
                   .EN_RSTRAM_B         ("FALSE"),
                   .INIT_B              (9'b000000000),
                   .RST_PRIORITY_B      ("CE"),
                   .SRVAL_B             (9'b000000000),
                   .WRITE_MODE_B        ("WRITE_FIRST"),
                   .RSTTYPE             ("SYNC"),
                   .INIT_FILE           ("NONE"),
                   .SIM_COLLISION_CHECK ("ALL"),
                   .SIM_DEVICE          ("SPARTAN6"),
                   .INIT_00             (256'h90EA90EA90EA90EA90EA020190020190FBFCEC01020101020101020201010202),
                   .INIT_01             (256'h0110B0CBD08B01010202010101010201020102010B010B011002020A90EA90EA),
                   .INIT_02             (256'h9002A4A39C83CA90020B0C0C0D0BB0EA9002B0EA900202020A02020B0C0C0110),
                   .INIT_03             (256'h9C83CA9002B0EA9002A4A39C83CA9002A4A39C83CA9002B0EA9002A4A39C83CA),
                   .INIT_04             (256'h9C83CA9002A4A39C83CA9002A4A39C83CA9002B0EA9002A4A39C83CA9002A4A3),
                   .INIT_05             (256'hB0EA90029C83CA9002A4A39C83CA9002A4A39C83CA9002A4A39C83CA9002A4A3),
                   .INIT_06             (256'h9002A181CA9002A181CA9002A181CA9002A181CA9002A181CA9002A181CA9002),
                   .INIT_07             (256'h02020F0F0B0C0C0110020110B0EA9002B0CBB0CDB0EA90020281CA9002A181CA),
                   .INIT_08             (256'hB0CDA1A10D9981019002B0CDA1A10D99810190020BB0EA9002B0EA900202020A),
                   .INIT_09             (256'h030405020C05020CB0CDA3A40D070703049981019002B0CDA1A10D9981019002),
                   .INIT_0A             (256'hB0CDA0A40DB0CDA4A60D0C06020B0C0CB0EA9002B0CBB0EA900202010C02010C),
                   .INIT_0B             (256'hCDA4A60D0C060201020C0B9C8BB0CDA0A40DB0CDA4A60D0C06020C06029C8B0C),
                   .INIT_0C             (256'h01CB02019F8707028B0702030C0C05020CB0CDA4A3A6A60D0603B0CDA0A40DB0),
                   .INIT_0D             (256'h01010290E90202020A020B0C0C10B0CB9C8BB0CDA00DB0CDA00D06020C030402),
                   .INIT_0E             (256'h0C090AB0EA9002B0EA900202020A02020C020F0F0B0C0C011002020A02109C8B),
                   .INIT_0F             (256'h02A4A39C83CA9002A4A39C83CA9002A4A39C83CA9002A4A39C83CA90020F0F0B),
                   .INIT_10             (256'h02A4A39C83CA9102B1EA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA90),
                   .INIT_11             (256'h9C83CA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA91),
                   .INIT_12             (256'hA7A79F87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102B1EA9102),
                   .INIT_13             (256'hA7A79F87CA9102A7A79F87CA9102A7A79F87CA9102B1EA9102A7A79F87CA9102),
                   .INIT_14             (256'h87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102),
                   .INIT_15             (256'h0F2801010F10B1EA9102B0CAB0C902010C02010CB1EA91029F87CA9102A7A79F),
                   .INIT_16             (256'hCAC88A281AE8EAC8EA28B1CF25B1C8A6A6A5A508C801010291020D2803040401),
                   .INIT_17             (256'h9D8D0288EA25288A8AD1CA2802011A020201A2A2A2A202288A28CAC88AF1CAC8),
                   .INIT_18             (256'h0A0A0A0A0A0A0A0A0A0A280102A2010D0D120A28020A020A020A020A01120A11),
                   .INIT_19             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1A             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1B             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1C             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1D             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1E             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A28010D0D0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_1F             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_20             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_21             (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_22             (256'hB26848285858120A120A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                   .INIT_23             (256'h120202010201020102090212030204020402020902284A1288C8B2684808286A),
                   .INIT_24             (256'h690202020102010201020902022802B269020202010201020102010209020206),
                   .INIT_25             (256'h1202020902286818682828B2C802A169496818000828680828B2C802080228B2),
                   .INIT_26             (256'h00000000000028B2D9D8C8001208080912080809120808091202090212020902),
                   .INIT_27             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_28             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_29             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_30             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_31             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_32             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_33             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_34             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_35             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_36             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_37             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_38             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_39             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_00            (256'hC1FBAB98C6318C63B183060C1830760C1D830760C182EF63EB7D55EAAABF16DF),
                   .INITP_01            (256'h83060C18177B41ECD746221121214021020420488408BAE412801E0781E075DE),
                   .INITP_02            (256'h365CC15555640FD156EA4B183060C183060C1D83060C183B183060C183B060C1),
                   .INITP_03            (256'hFFFFFFFFFFFF3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5AAD),
                   .INITP_04            (256'h00000000030888DDEEB446D7755F7556EAB56DA39EBFFFFFFFFFFFFFFFFFFFFF),
                   .INITP_05            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_06            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_07            (256'h0000000000000000000000000000000000000000000000000000000000000000))
    kcpsm6_rom_lh( .ADDRA               (address_a[13:0]),
                   .ENA                 (enable),
                   .CLKA                (clk),
                   .DOA                 (data_out_a_lh[31:0]),
                   .DOPA                (data_out_a_lh[35:32]), 
                   .DIA                 (data_in_a[31:0]),
                   .DIPA                (data_in_a[35:32]), 
                   .WEA                 (4'b0000),
                   .REGCEA              (1'b0),
                   .RSTA                (1'b0),
                   .ADDRB               (address_b[13:0]),
                   .ENB                 (enable_b),
                   .CLKB                (clk_b),
                   .DOB                 (data_out_b_lh[31:0]),
                   .DOPB                (data_out_b_lh[35:32]), 
                   .DIB                 (data_in_b_lh[31:0]),
                   .DIPB                (data_in_b_lh[35:32]), 
                   .WEB                 (we_b_l[3:0]),
                   .REGCEB              (1'b0),
                   .RSTB                (1'b0));
      // 
      RAMB16BWER #(.DATA_WIDTH_A        (9),
                   .DOA_REG             (0),
                   .EN_RSTRAM_A         ("FALSE"),
                   .INIT_A              (9'b000000000),
                   .RST_PRIORITY_A      ("CE"),
                   .SRVAL_A             (9'b000000000),
                   .WRITE_MODE_A        ("WRITE_FIRST"),
                   .DATA_WIDTH_B        (9),
                   .DOB_REG             (0),
                   .EN_RSTRAM_B         ("FALSE"),
                   .INIT_B              (9'b000000000),
                   .RST_PRIORITY_B      ("CE"),
                   .SRVAL_B             (9'b000000000),
                   .WRITE_MODE_B        ("WRITE_FIRST"),
                   .RSTTYPE             ("SYNC"),
                   .INIT_FILE           ("NONE"),
                   .SIM_COLLISION_CHECK ("ALL"),
                   .SIM_DEVICE          ("SPARTAN6"),
                   .INIT_00             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_01             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_02             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_03             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_04             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_05             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_06             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_07             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_08             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_09             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_10             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_11             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_12             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_13             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_14             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_15             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_16             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_17             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_18             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_19             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_20             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_21             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_22             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_23             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_24             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_25             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_26             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_27             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_28             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_29             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_30             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_31             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_32             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_33             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_34             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_35             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_36             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_37             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_38             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_39             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_00            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_01            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_02            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_03            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_04            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_05            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_06            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_07            (256'h0000000000000000000000000000000000000000000000000000000000000000))
    kcpsm6_rom_hl( .ADDRA               (address_a[13:0]),
                   .ENA                 (enable),
                   .CLKA                (clk),
                   .DOA                 (data_out_a_hl[31:0]),
                   .DOPA                (data_out_a_hl[35:32]), 
                   .DIA                 (data_in_a[31:0]),
                   .DIPA                (data_in_a[35:32]), 
                   .WEA                 (4'b0000),
                   .REGCEA              (1'b0),
                   .RSTA                (1'b0),
                   .ADDRB               (address_b[13:0]),
                   .ENB                 (enable_b),
                   .CLKB                (clk_b),
                   .DOB                 (data_out_b_hl[31:0]),
                   .DOPB                (data_out_b_hl[35:32]), 
                   .DIB                 (data_in_b_hl[31:0]),
                   .DIPB                (data_in_b_hl[35:32]), 
                   .WEB                 (we_b_h[3:0]),
                   .REGCEB              (1'b0),
                   .RSTB                (1'b0));
      // 
      RAMB16BWER #(.DATA_WIDTH_A        (9),
                   .DOA_REG             (0),
                   .EN_RSTRAM_A         ("FALSE"),
                   .INIT_A              (9'b000000000),
                   .RST_PRIORITY_A      ("CE"),
                   .SRVAL_A             (9'b000000000),
                   .WRITE_MODE_A        ("WRITE_FIRST"),
                   .DATA_WIDTH_B        (9),
                   .DOB_REG             (0),
                   .EN_RSTRAM_B         ("FALSE"),
                   .INIT_B              (9'b000000000),
                   .RST_PRIORITY_B      ("CE"),
                   .SRVAL_B             (9'b000000000),
                   .WRITE_MODE_B        ("WRITE_FIRST"),
                   .RSTTYPE             ("SYNC"),
                   .INIT_FILE           ("NONE"),
                   .SIM_COLLISION_CHECK ("ALL"),
                   .SIM_DEVICE          ("SPARTAN6"),
                   .INIT_00             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_01             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_02             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_03             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_04             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_05             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_06             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_07             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_08             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_09             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_0F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_10             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_11             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_12             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_13             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_14             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_15             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_16             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_17             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_18             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_19             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_1F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_20             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_21             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_22             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_23             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_24             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_25             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_26             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_27             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_28             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_29             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_2F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_30             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_31             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_32             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_33             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_34             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_35             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_36             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_37             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_38             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_39             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3A             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3B             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3C             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3D             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3E             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INIT_3F             (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_00            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_01            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_02            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_03            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_04            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_05            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_06            (256'h0000000000000000000000000000000000000000000000000000000000000000),
                   .INITP_07            (256'h0000000000000000000000000000000000000000000000000000000000000000))
    kcpsm6_rom_hh( .ADDRA               (address_a[13:0]),
                   .ENA                 (enable),
                   .CLKA                (clk),
                   .DOA                 (data_out_a_hh[31:0]),
                   .DOPA                (data_out_a_hh[35:32]), 
                   .DIA                 (data_in_a[31:0]),
                   .DIPA                (data_in_a[35:32]), 
                   .WEA                 (4'b0000),
                   .REGCEA              (1'b0),
                   .RSTA                (1'b0),
                   .ADDRB               (address_b[13:0]),
                   .ENB                 (enable_b),
                   .CLKB                (clk_b),
                   .DOB                 (data_out_b_hh[31:0]),
                   .DOPB                (data_out_b_hh[35:32]), 
                   .DIB                 (data_in_b_hh[31:0]),
                   .DIPB                (data_in_b_hh[35:32]), 
                   .WEB                 (we_b_h[3:0]),
                   .REGCEB              (1'b0),
                   .RSTB                (1'b0));
      //
    end // s6;
    //
    //
    if (C_FAMILY == "V6") begin: v6 
      //
      assign address_a = {1'b1, address[11:0], 3'b111};
      assign instruction = {data_out_a_h[32], data_out_a_h[7:0], data_out_a_l[32], data_out_a_l[7:0]};
      assign data_in_a = 36'b00000000000000000000000000000000000;
      assign jtag_dout = {data_out_b_h[32], data_out_b_h[7:0], data_out_b_l[32], data_out_b_l[7:0]};
      //
      if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b_l = {3'b000, data_out_b_l[32], 24'b000000000000000000000000, data_out_b_l[7:0]};
        assign data_in_b_h = {3'b000, data_out_b_h[32], 24'b000000000000000000000000, data_out_b_h[7:0]};
        assign address_b = 16'b1111111111111111;
        assign we_b = 8'b00000000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
      if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b_h = {3'b000, jtag_din[17], 24'b000000000000000000000000, jtag_din[16:9]};
        assign data_in_b_l = {3'b000, jtag_din[8],  24'b000000000000000000000000, jtag_din[7:0]};
        assign address_b = {1'b1, jtag_addr[11:0], 3'b111};
        assign we_b = {jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
      // 
      RAMB36E1 #(.READ_WIDTH_A              (9),
                 .WRITE_WIDTH_A             (9),
                 .DOA_REG                   (0),
                 .INIT_A                    (36'h000000000),
                 .RSTREG_PRIORITY_A         ("REGCE"),
                 .SRVAL_A                   (36'h000000000),
                 .WRITE_MODE_A              ("WRITE_FIRST"),
                 .READ_WIDTH_B              (9),
                 .WRITE_WIDTH_B             (9),
                 .DOB_REG                   (0),
                 .INIT_B                    (36'h000000000),
                 .RSTREG_PRIORITY_B         ("REGCE"),
                 .SRVAL_B                   (36'h000000000),
                 .WRITE_MODE_B              ("WRITE_FIRST"),
                 .INIT_FILE                 ("NONE"),
                 .SIM_COLLISION_CHECK       ("ALL"),
                 .RAM_MODE                  ("TDP"),
                 .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
                 .EN_ECC_READ               ("FALSE"),
                 .EN_ECC_WRITE              ("FALSE"),
                 .RAM_EXTENSION_A           ("NONE"),
                 .RAM_EXTENSION_B           ("NONE"),
                 .SIM_DEVICE                ("VIRTEX6"),
                 .INIT_00                   (256'hF844F5454157285211485DD71262CE1118BA20E9700DE9800DE9906B0F035AD0),
                 .INIT_01                   (256'h012B36013F010DE920750D0D0DE970E980E99001100100BF125D5D3FC84CB34F),
                 .INIT_02                   (256'h5E62000600503054620000A340684E524E624A904A62585D5256930000A30111),
                 .INIT_03                   (256'h0050307B62772077620006005030706200060050306962652065620006005030),
                 .INIT_04                   (256'h0050309B620006005030946200060050308D6289208962000600503082620006),
                 .INIT_05                   (256'hBC20BC62005030B7620006005030B0620006005030A9620006005030A2620006),
                 .INIT_06                   (256'hDE62065030D962065030D462065030CF62065030CA62065030C562065030C062),
                 .INIT_07                   (256'h569300000000A2011193BF11F09CF06253015401E820E862805030E362065030),
                 .INIT_08                   (256'h1C010006040050DD166212010006040050DD0C62030772076203900362585D72),
                 .INIT_09                   (256'hA0B02075A12075A03401080E02203020300050DD2A6226010006040050DD2062),
                 .INIT_0A                   (256'h5C010006025701080E020020750000A54C9C4C620C014620466280E0A580F0A4),
                 .INIT_0B                   (256'h01080E020020757080A50100016F010006026A01080E02002075A520750001A4),
                 .INIT_0C                   (256'hE08080F000B02075802075C000A22075A38A010000060607D01082010006027D),
                 .INIT_0D                   (256'h01E920C3FF75585D57560000A21176010001AB010E04A70106042075A4305080),
                 .INIT_0E                   (256'h004E40D972D962D590D562585D725693A19300000000A00111585D7756BA0001),
                 .INIT_0F                   (256'h620006005030F8620006005030F1620006005030EA620006005030DF62000000),
                 .INIT_10                   (256'h62000600503018621420146200060050300D62000600503006620006005030FF),
                 .INIT_11                   (256'h0050303B620006005030346200060050302D620006005030266200060050301F),
                 .INIT_12                   (256'h000600503059620006005030526200060050304B620006005030446240204062),
                 .INIT_13                   (256'h000600503079620006005030726200060050306B626720676200060050306062),
                 .INIT_14                   (256'h50309C620006005030956200060050308E620006005030876200060050308062),
                 .INIT_15                   (256'h0600A0C50211B69CB662DE01DF0180E0A180F0A0A820A862005030A362000600),
                 .INIT_16                   (256'hE900B900DF007B006100C60150CD01000000060400DDD75DC6620000A0B0C0C5),
                 .INIT_17                   (256'h00015D0000A0003A07F80A005DF50F405DF50E0E0E0E40000A00F60007E71100),
                 .INIT_18                   (256'h5F5F5F5F5F20205F202000015D80FA16035D20005D5B5D1B5D4A5D32085D0DFA),
                 .INIT_19                   (256'h2F202F7C207C200D5F5F20205F5F20205F5F20205F5F5F5F20205F5F5F5F205F),
                 .INIT_1A                   (256'h207C200D5F2F202F7C20202F5C20207C7C5F5F5F202F5C205F20207C5F5F5F20),
                 .INIT_1B                   (256'h205F27207C207C2F5C7C207C5C205F5F5F5C20295F7C207C2020207C202F2027),
                 .INIT_1C                   (256'h207C20207C207C20295F5F5F202F5F5F20207C5F5F5F7C205C202E207C200D5C),
                 .INIT_1D                   (256'h7C2F5F5F5F5F7C2020207C5F7C5F5F5F5F5C5F5C7C5F7C200D2920295F28207C),
                 .INIT_1E                   (256'h6944202D2048200D756E654D0D0D00FAD203000D2F5F5F5F5C7C5F7C20207C5F),
                 .INIT_1F                   (256'h2945545942282064616552202D2052200D756E656D20736968742079616C7073),
                 .INIT_20                   (256'h5328206573617245202D2045200D29454C494628206574697257202D2057200D),
                 .INIT_21                   (256'h754F202D204F200D295455504E49282061746144202D2044200D29726F746365),
                 .INIT_22                   (256'h5D04000001315D9C5D90000D50554B4F4F4C202D204C200D474F4C2074757074),
                 .INIT_23                   (256'hA8ABAB70AB80AB90AB03A8A820AB20AB20ABAB9FA80001630001690800A70001),
                 .INIT_24                   (256'h01BBA8AB70AB80AB90ABD8C0A800C48E01BBA8ABD0AB70AB80AB90AB02C0A820),
                 .INIT_25                   (256'hA8ABAB05A80004FE040100AC01B60080030480200800040200A401B608A8009E),
                 .INIT_26                   (256'h00000000000000D400000100D4809698D4400D03D4102700A8AB04A8A8AB06A8),
                 .INIT_27                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_28                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_29                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_30                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_31                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_32                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_33                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_34                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_35                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_36                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_37                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_38                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_39                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_40                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_41                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_42                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_43                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_44                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_45                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_46                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_47                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_48                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_49                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_50                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_51                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_52                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_53                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_54                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_55                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_56                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_57                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_58                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_59                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_60                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_61                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_62                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_63                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_64                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_65                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_66                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_67                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_68                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_69                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_70                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_71                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_72                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_73                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_74                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_75                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_76                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_77                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_78                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_79                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_00                  (256'h2B04042108421084462C58B162C588B1622C588B165110968638161F5542A48C),
                 .INITP_01                  (256'h2E5CB9755DC4AB1590AA6AAC4696CE6D49CDA933B525EB898DA34BB2ECBB2771),
                 .INITP_02                  (256'h8DA33EAAAA81400A012C94A54A952A54A952A254A952A54462C58B162C458B17),
                 .INITP_03                  (256'hFFFFFFFFFFFC7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD4A55A),
                 .INITP_04                  (256'h0000000000422200000988280000000100088245017FFFFFFFFFFFFFFFFFFFFF),
                 .INITP_05                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_06                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_07                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_08                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_09                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0A                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0B                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0C                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0D                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0E                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0F                  (256'h0000000000000000000000000000000000000000000000000000000000000000))
   kcpsm6_rom_l( .ADDRARDADDR               (address_a),
                 .ENARDEN                   (enable),
                 .CLKARDCLK                 (clk),
                 .DOADO                     (data_out_a_l[31:0]),
                 .DOPADOP                   (data_out_a_l[35:32]), 
                 .DIADI                     (data_in_a[31:0]),
                 .DIPADIP                   (data_in_a[35:32]), 
                 .WEA                       (4'b0000),
                 .REGCEAREGCE               (1'b0),
                 .RSTRAMARSTRAM             (1'b0),
                 .RSTREGARSTREG             (1'b0),
                 .ADDRBWRADDR               (address_b),
                 .ENBWREN                   (enable_b),
                 .CLKBWRCLK                 (clk_b),
                 .DOBDO                     (data_out_b_l[31:0]),
                 .DOPBDOP                   (data_out_b_l[35:32]), 
                 .DIBDI                     (data_in_b_l[31:0]),
                 .DIPBDIP                   (data_in_b_l[35:32]), 
                 .WEBWE                     (we_b),
                 .REGCEB                    (1'b0),
                 .RSTRAMB                   (1'b0),
                 .RSTREGB                   (1'b0),
                 .CASCADEINA                (1'b0),
                 .CASCADEINB                (1'b0),
                 .CASCADEOUTA               (),
                 .CASCADEOUTB               (),
                 .DBITERR                   (),
                 .ECCPARITY                 (),
                 .RDADDRECC                 (),
                 .SBITERR                   (),
                 .INJECTDBITERR             (1'b0),      
                 .INJECTSBITERR             (1'b0));   
      //
      RAMB36E1 #(.READ_WIDTH_A              (9),
                 .WRITE_WIDTH_A             (9),
                 .DOA_REG                   (0),
                 .INIT_A                    (36'h000000000),
                 .RSTREG_PRIORITY_A         ("REGCE"),
                 .SRVAL_A                   (36'h000000000),
                 .WRITE_MODE_A              ("WRITE_FIRST"),
                 .READ_WIDTH_B              (9),
                 .WRITE_WIDTH_B             (9),
                 .DOB_REG                   (0),
                 .INIT_B                    (36'h000000000),
                 .RSTREG_PRIORITY_B         ("REGCE"),
                 .SRVAL_B                   (36'h000000000),
                 .WRITE_MODE_B              ("WRITE_FIRST"),
                 .INIT_FILE                 ("NONE"),
                 .SIM_COLLISION_CHECK       ("ALL"),
                 .RAM_MODE                  ("TDP"),
                 .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
                 .EN_ECC_READ               ("FALSE"),
                 .EN_ECC_WRITE              ("FALSE"),
                 .RAM_EXTENSION_A           ("NONE"),
                 .RAM_EXTENSION_B           ("NONE"),
                 .SIM_DEVICE                ("VIRTEX6"),
                 .INIT_00                   (256'h90EA90EA90EA90EA90EA020190020190FBFCEC01020101020101020201010202),
                 .INIT_01                   (256'h0110B0CBD08B01010202010101010201020102010B010B011002020A90EA90EA),
                 .INIT_02                   (256'h9002A4A39C83CA90020B0C0C0D0BB0EA9002B0EA900202020A02020B0C0C0110),
                 .INIT_03                   (256'h9C83CA9002B0EA9002A4A39C83CA9002A4A39C83CA9002B0EA9002A4A39C83CA),
                 .INIT_04                   (256'h9C83CA9002A4A39C83CA9002A4A39C83CA9002B0EA9002A4A39C83CA9002A4A3),
                 .INIT_05                   (256'hB0EA90029C83CA9002A4A39C83CA9002A4A39C83CA9002A4A39C83CA9002A4A3),
                 .INIT_06                   (256'h9002A181CA9002A181CA9002A181CA9002A181CA9002A181CA9002A181CA9002),
                 .INIT_07                   (256'h02020F0F0B0C0C0110020110B0EA9002B0CBB0CDB0EA90020281CA9002A181CA),
                 .INIT_08                   (256'hB0CDA1A10D9981019002B0CDA1A10D99810190020BB0EA9002B0EA900202020A),
                 .INIT_09                   (256'h030405020C05020CB0CDA3A40D070703049981019002B0CDA1A10D9981019002),
                 .INIT_0A                   (256'hB0CDA0A40DB0CDA4A60D0C06020B0C0CB0EA9002B0CBB0EA900202010C02010C),
                 .INIT_0B                   (256'hCDA4A60D0C060201020C0B9C8BB0CDA0A40DB0CDA4A60D0C06020C06029C8B0C),
                 .INIT_0C                   (256'h01CB02019F8707028B0702030C0C05020CB0CDA4A3A6A60D0603B0CDA0A40DB0),
                 .INIT_0D                   (256'h01010290E90202020A020B0C0C10B0CB9C8BB0CDA00DB0CDA00D06020C030402),
                 .INIT_0E                   (256'h0C090AB0EA9002B0EA900202020A02020C020F0F0B0C0C011002020A02109C8B),
                 .INIT_0F                   (256'h02A4A39C83CA9002A4A39C83CA9002A4A39C83CA9002A4A39C83CA90020F0F0B),
                 .INIT_10                   (256'h02A4A39C83CA9102B1EA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA90),
                 .INIT_11                   (256'h9C83CA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA91),
                 .INIT_12                   (256'hA7A79F87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102B1EA9102),
                 .INIT_13                   (256'hA7A79F87CA9102A7A79F87CA9102A7A79F87CA9102B1EA9102A7A79F87CA9102),
                 .INIT_14                   (256'h87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102),
                 .INIT_15                   (256'h0F2801010F10B1EA9102B0CAB0C902010C02010CB1EA91029F87CA9102A7A79F),
                 .INIT_16                   (256'hCAC88A281AE8EAC8EA28B1CF25B1C8A6A6A5A508C801010291020D2803040401),
                 .INIT_17                   (256'h9D8D0288EA25288A8AD1CA2802011A020201A2A2A2A202288A28CAC88AF1CAC8),
                 .INIT_18                   (256'h0A0A0A0A0A0A0A0A0A0A280102A2010D0D120A28020A020A020A020A01120A11),
                 .INIT_19                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1A                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1B                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1C                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1D                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1E                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A28010D0D0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1F                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_20                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_21                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_22                   (256'hB26848285858120A120A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_23                   (256'h120202010201020102090212030204020402020902284A1288C8B2684808286A),
                 .INIT_24                   (256'h690202020102010201020902022802B269020202010201020102010209020206),
                 .INIT_25                   (256'h1202020902286818682828B2C802A169496818000828680828B2C802080228B2),
                 .INIT_26                   (256'h00000000000028B2D9D8C8001208080912080809120808091202090212020902),
                 .INIT_27                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_28                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_29                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_30                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_31                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_32                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_33                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_34                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_35                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_36                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_37                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_38                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_39                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_40                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_41                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_42                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_43                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_44                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_45                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_46                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_47                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_48                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_49                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_50                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_51                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_52                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_53                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_54                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_55                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_56                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_57                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_58                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_59                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_60                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_61                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_62                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_63                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_64                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_65                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_66                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_67                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_68                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_69                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_70                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_71                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_72                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_73                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_74                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_75                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_76                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_77                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_78                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_79                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_00                  (256'hC1FBAB98C6318C63B183060C1830760C1D830760C182EF63EB7D55EAAABF16DF),
                 .INITP_01                  (256'h83060C18177B41ECD746221121214021020420488408BAE412801E0781E075DE),
                 .INITP_02                  (256'h365CC15555640FD156EA4B183060C183060C1D83060C183B183060C183B060C1),
                 .INITP_03                  (256'hFFFFFFFFFFFF3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5AAD),
                 .INITP_04                  (256'h00000000030888DDEEB446D7755F7556EAB56DA39EBFFFFFFFFFFFFFFFFFFFFF),
                 .INITP_05                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_06                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_07                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_08                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_09                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0A                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0B                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0C                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0D                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0E                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0F                  (256'h0000000000000000000000000000000000000000000000000000000000000000))
   kcpsm6_rom_h( .ADDRARDADDR               (address_a),
                 .ENARDEN                   (enable),
                 .CLKARDCLK                 (clk),
                 .DOADO                     (data_out_a_h[31:0]),
                 .DOPADOP                   (data_out_a_h[35:32]), 
                 .DIADI                     (data_in_a[31:0]),
                 .DIPADIP                   (data_in_a[35:32]), 
                 .WEA                       (4'b0000),
                 .REGCEAREGCE               (1'b0),
                 .RSTRAMARSTRAM             (1'b0),
                 .RSTREGARSTREG             (1'b0),
                 .ADDRBWRADDR               (address_b),
                 .ENBWREN                   (enable_b),
                 .CLKBWRCLK                 (clk_b),
                 .DOBDO                     (data_out_b_h[31:0]),
                 .DOPBDOP                   (data_out_b_h[35:32]), 
                 .DIBDI                     (data_in_b_h[31:0]),
                 .DIPBDIP                   (data_in_b_h[35:32]), 
                 .WEBWE                     (we_b),
                 .REGCEB                    (1'b0),
                 .RSTRAMB                   (1'b0),
                 .RSTREGB                   (1'b0),
                 .CASCADEINA                (1'b0),
                 .CASCADEINB                (1'b0),
                 .CASCADEOUTA               (),
                 .CASCADEOUTB               (),
                 .DBITERR                   (),
                 .ECCPARITY                 (),
                 .RDADDRECC                 (),
                 .SBITERR                   (),
                 .INJECTDBITERR             (1'b0),      
                 .INJECTSBITERR             (1'b0));  
    end // v6;  
    //
    //
    if (C_FAMILY == "7S") begin: akv7 
      //
      assign address_a = {1'b1, address[11:0], 3'b111};
      assign instruction = {data_out_a_h[32], data_out_a_h[7:0], data_out_a_l[32], data_out_a_l[7:0]};
      assign data_in_a = 36'b00000000000000000000000000000000000;
      assign jtag_dout = {data_out_b_h[32], data_out_b_h[7:0], data_out_b_l[32], data_out_b_l[7:0]};
      //
      if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b_l = {3'b000, data_out_b_l[32], 24'b000000000000000000000000, data_out_b_l[7:0]};
        assign data_in_b_h = {3'b000, data_out_b_h[32], 24'b000000000000000000000000, data_out_b_h[7:0]};
        assign address_b = 16'b1111111111111111;
        assign we_b = 8'b00000000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
      if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b_h = {3'b000, jtag_din[17], 24'b000000000000000000000000, jtag_din[16:9]};
        assign data_in_b_l = {3'b000, jtag_din[8],  24'b000000000000000000000000, jtag_din[7:0]};
        assign address_b = {1'b1, jtag_addr[11:0], 3'b111};
        assign we_b = {jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
      // 
      RAMB36E1 #(.READ_WIDTH_A              (9),
                 .WRITE_WIDTH_A             (9),
                 .DOA_REG                   (0),
                 .INIT_A                    (36'h000000000),
                 .RSTREG_PRIORITY_A         ("REGCE"),
                 .SRVAL_A                   (36'h000000000),
                 .WRITE_MODE_A              ("WRITE_FIRST"),
                 .READ_WIDTH_B              (9),
                 .WRITE_WIDTH_B             (9),
                 .DOB_REG                   (0),
                 .INIT_B                    (36'h000000000),
                 .RSTREG_PRIORITY_B         ("REGCE"),
                 .SRVAL_B                   (36'h000000000),
                 .WRITE_MODE_B              ("WRITE_FIRST"),
                 .INIT_FILE                 ("NONE"),
                 .SIM_COLLISION_CHECK       ("ALL"),
                 .RAM_MODE                  ("TDP"),
                 .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
                 .EN_ECC_READ               ("FALSE"),
                 .EN_ECC_WRITE              ("FALSE"),
                 .RAM_EXTENSION_A           ("NONE"),
                 .RAM_EXTENSION_B           ("NONE"),
                 .SIM_DEVICE                ("7SERIES"),
                 .INIT_00                   (256'hF844F5454157285211485DD71262CE1118BA20E9700DE9800DE9906B0F035AD0),
                 .INIT_01                   (256'h012B36013F010DE920750D0D0DE970E980E99001100100BF125D5D3FC84CB34F),
                 .INIT_02                   (256'h5E62000600503054620000A340684E524E624A904A62585D5256930000A30111),
                 .INIT_03                   (256'h0050307B62772077620006005030706200060050306962652065620006005030),
                 .INIT_04                   (256'h0050309B620006005030946200060050308D6289208962000600503082620006),
                 .INIT_05                   (256'hBC20BC62005030B7620006005030B0620006005030A9620006005030A2620006),
                 .INIT_06                   (256'hDE62065030D962065030D462065030CF62065030CA62065030C562065030C062),
                 .INIT_07                   (256'h569300000000A2011193BF11F09CF06253015401E820E862805030E362065030),
                 .INIT_08                   (256'h1C010006040050DD166212010006040050DD0C62030772076203900362585D72),
                 .INIT_09                   (256'hA0B02075A12075A03401080E02203020300050DD2A6226010006040050DD2062),
                 .INIT_0A                   (256'h5C010006025701080E020020750000A54C9C4C620C014620466280E0A580F0A4),
                 .INIT_0B                   (256'h01080E020020757080A50100016F010006026A01080E02002075A520750001A4),
                 .INIT_0C                   (256'hE08080F000B02075802075C000A22075A38A010000060607D01082010006027D),
                 .INIT_0D                   (256'h01E920C3FF75585D57560000A21176010001AB010E04A70106042075A4305080),
                 .INIT_0E                   (256'h004E40D972D962D590D562585D725693A19300000000A00111585D7756BA0001),
                 .INIT_0F                   (256'h620006005030F8620006005030F1620006005030EA620006005030DF62000000),
                 .INIT_10                   (256'h62000600503018621420146200060050300D62000600503006620006005030FF),
                 .INIT_11                   (256'h0050303B620006005030346200060050302D620006005030266200060050301F),
                 .INIT_12                   (256'h000600503059620006005030526200060050304B620006005030446240204062),
                 .INIT_13                   (256'h000600503079620006005030726200060050306B626720676200060050306062),
                 .INIT_14                   (256'h50309C620006005030956200060050308E620006005030876200060050308062),
                 .INIT_15                   (256'h0600A0C50211B69CB662DE01DF0180E0A180F0A0A820A862005030A362000600),
                 .INIT_16                   (256'hE900B900DF007B006100C60150CD01000000060400DDD75DC6620000A0B0C0C5),
                 .INIT_17                   (256'h00015D0000A0003A07F80A005DF50F405DF50E0E0E0E40000A00F60007E71100),
                 .INIT_18                   (256'h5F5F5F5F5F20205F202000015D80FA16035D20005D5B5D1B5D4A5D32085D0DFA),
                 .INIT_19                   (256'h2F202F7C207C200D5F5F20205F5F20205F5F20205F5F5F5F20205F5F5F5F205F),
                 .INIT_1A                   (256'h207C200D5F2F202F7C20202F5C20207C7C5F5F5F202F5C205F20207C5F5F5F20),
                 .INIT_1B                   (256'h205F27207C207C2F5C7C207C5C205F5F5F5C20295F7C207C2020207C202F2027),
                 .INIT_1C                   (256'h207C20207C207C20295F5F5F202F5F5F20207C5F5F5F7C205C202E207C200D5C),
                 .INIT_1D                   (256'h7C2F5F5F5F5F7C2020207C5F7C5F5F5F5F5C5F5C7C5F7C200D2920295F28207C),
                 .INIT_1E                   (256'h6944202D2048200D756E654D0D0D00FAD203000D2F5F5F5F5C7C5F7C20207C5F),
                 .INIT_1F                   (256'h2945545942282064616552202D2052200D756E656D20736968742079616C7073),
                 .INIT_20                   (256'h5328206573617245202D2045200D29454C494628206574697257202D2057200D),
                 .INIT_21                   (256'h754F202D204F200D295455504E49282061746144202D2044200D29726F746365),
                 .INIT_22                   (256'h5D04000001315D9C5D90000D50554B4F4F4C202D204C200D474F4C2074757074),
                 .INIT_23                   (256'hA8ABAB70AB80AB90AB03A8A820AB20AB20ABAB9FA80001630001690800A70001),
                 .INIT_24                   (256'h01BBA8AB70AB80AB90ABD8C0A800C48E01BBA8ABD0AB70AB80AB90AB02C0A820),
                 .INIT_25                   (256'hA8ABAB05A80004FE040100AC01B60080030480200800040200A401B608A8009E),
                 .INIT_26                   (256'h00000000000000D400000100D4809698D4400D03D4102700A8AB04A8A8AB06A8),
                 .INIT_27                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_28                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_29                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_30                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_31                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_32                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_33                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_34                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_35                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_36                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_37                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_38                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_39                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_40                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_41                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_42                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_43                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_44                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_45                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_46                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_47                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_48                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_49                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_50                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_51                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_52                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_53                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_54                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_55                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_56                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_57                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_58                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_59                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_60                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_61                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_62                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_63                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_64                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_65                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_66                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_67                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_68                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_69                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_70                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_71                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_72                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_73                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_74                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_75                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_76                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_77                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_78                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_79                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_00                  (256'h2B04042108421084462C58B162C588B1622C588B165110968638161F5542A48C),
                 .INITP_01                  (256'h2E5CB9755DC4AB1590AA6AAC4696CE6D49CDA933B525EB898DA34BB2ECBB2771),
                 .INITP_02                  (256'h8DA33EAAAA81400A012C94A54A952A54A952A254A952A54462C58B162C458B17),
                 .INITP_03                  (256'hFFFFFFFFFFFC7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD4A55A),
                 .INITP_04                  (256'h0000000000422200000988280000000100088245017FFFFFFFFFFFFFFFFFFFFF),
                 .INITP_05                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_06                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_07                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_08                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_09                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0A                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0B                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0C                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0D                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0E                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0F                  (256'h0000000000000000000000000000000000000000000000000000000000000000))
   kcpsm6_rom_l( .ADDRARDADDR               (address_a),
                 .ENARDEN                   (enable),
                 .CLKARDCLK                 (clk),
                 .DOADO                     (data_out_a_l[31:0]),
                 .DOPADOP                   (data_out_a_l[35:32]), 
                 .DIADI                     (data_in_a[31:0]),
                 .DIPADIP                   (data_in_a[35:32]), 
                 .WEA                       (4'b0000),
                 .REGCEAREGCE               (1'b0),
                 .RSTRAMARSTRAM             (1'b0),
                 .RSTREGARSTREG             (1'b0),
                 .ADDRBWRADDR               (address_b),
                 .ENBWREN                   (enable_b),
                 .CLKBWRCLK                 (clk_b),
                 .DOBDO                     (data_out_b_l[31:0]),
                 .DOPBDOP                   (data_out_b_l[35:32]), 
                 .DIBDI                     (data_in_b_l[31:0]),
                 .DIPBDIP                   (data_in_b_l[35:32]), 
                 .WEBWE                     (we_b),
                 .REGCEB                    (1'b0),
                 .RSTRAMB                   (1'b0),
                 .RSTREGB                   (1'b0),
                 .CASCADEINA                (1'b0),
                 .CASCADEINB                (1'b0),
                 .CASCADEOUTA               (),
                 .CASCADEOUTB               (),
                 .DBITERR                   (),
                 .ECCPARITY                 (),
                 .RDADDRECC                 (),
                 .SBITERR                   (),
                 .INJECTDBITERR             (1'b0),      
                 .INJECTSBITERR             (1'b0));   
      //
      RAMB36E1 #(.READ_WIDTH_A              (9),
                 .WRITE_WIDTH_A             (9),
                 .DOA_REG                   (0),
                 .INIT_A                    (36'h000000000),
                 .RSTREG_PRIORITY_A         ("REGCE"),
                 .SRVAL_A                   (36'h000000000),
                 .WRITE_MODE_A              ("WRITE_FIRST"),
                 .READ_WIDTH_B              (9),
                 .WRITE_WIDTH_B             (9),
                 .DOB_REG                   (0),
                 .INIT_B                    (36'h000000000),
                 .RSTREG_PRIORITY_B         ("REGCE"),
                 .SRVAL_B                   (36'h000000000),
                 .WRITE_MODE_B              ("WRITE_FIRST"),
                 .INIT_FILE                 ("NONE"),
                 .SIM_COLLISION_CHECK       ("ALL"),
                 .RAM_MODE                  ("TDP"),
                 .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
                 .EN_ECC_READ               ("FALSE"),
                 .EN_ECC_WRITE              ("FALSE"),
                 .RAM_EXTENSION_A           ("NONE"),
                 .RAM_EXTENSION_B           ("NONE"),
                 .SIM_DEVICE                ("7SERIES"),
                 .INIT_00                   (256'h90EA90EA90EA90EA90EA020190020190FBFCEC01020101020101020201010202),
                 .INIT_01                   (256'h0110B0CBD08B01010202010101010201020102010B010B011002020A90EA90EA),
                 .INIT_02                   (256'h9002A4A39C83CA90020B0C0C0D0BB0EA9002B0EA900202020A02020B0C0C0110),
                 .INIT_03                   (256'h9C83CA9002B0EA9002A4A39C83CA9002A4A39C83CA9002B0EA9002A4A39C83CA),
                 .INIT_04                   (256'h9C83CA9002A4A39C83CA9002A4A39C83CA9002B0EA9002A4A39C83CA9002A4A3),
                 .INIT_05                   (256'hB0EA90029C83CA9002A4A39C83CA9002A4A39C83CA9002A4A39C83CA9002A4A3),
                 .INIT_06                   (256'h9002A181CA9002A181CA9002A181CA9002A181CA9002A181CA9002A181CA9002),
                 .INIT_07                   (256'h02020F0F0B0C0C0110020110B0EA9002B0CBB0CDB0EA90020281CA9002A181CA),
                 .INIT_08                   (256'hB0CDA1A10D9981019002B0CDA1A10D99810190020BB0EA9002B0EA900202020A),
                 .INIT_09                   (256'h030405020C05020CB0CDA3A40D070703049981019002B0CDA1A10D9981019002),
                 .INIT_0A                   (256'hB0CDA0A40DB0CDA4A60D0C06020B0C0CB0EA9002B0CBB0EA900202010C02010C),
                 .INIT_0B                   (256'hCDA4A60D0C060201020C0B9C8BB0CDA0A40DB0CDA4A60D0C06020C06029C8B0C),
                 .INIT_0C                   (256'h01CB02019F8707028B0702030C0C05020CB0CDA4A3A6A60D0603B0CDA0A40DB0),
                 .INIT_0D                   (256'h01010290E90202020A020B0C0C10B0CB9C8BB0CDA00DB0CDA00D06020C030402),
                 .INIT_0E                   (256'h0C090AB0EA9002B0EA900202020A02020C020F0F0B0C0C011002020A02109C8B),
                 .INIT_0F                   (256'h02A4A39C83CA9002A4A39C83CA9002A4A39C83CA9002A4A39C83CA90020F0F0B),
                 .INIT_10                   (256'h02A4A39C83CA9102B1EA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA90),
                 .INIT_11                   (256'h9C83CA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA9102A4A39C83CA91),
                 .INIT_12                   (256'hA7A79F87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102B1EA9102),
                 .INIT_13                   (256'hA7A79F87CA9102A7A79F87CA9102A7A79F87CA9102B1EA9102A7A79F87CA9102),
                 .INIT_14                   (256'h87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102A7A79F87CA9102),
                 .INIT_15                   (256'h0F2801010F10B1EA9102B0CAB0C902010C02010CB1EA91029F87CA9102A7A79F),
                 .INIT_16                   (256'hCAC88A281AE8EAC8EA28B1CF25B1C8A6A6A5A508C801010291020D2803040401),
                 .INIT_17                   (256'h9D8D0288EA25288A8AD1CA2802011A020201A2A2A2A202288A28CAC88AF1CAC8),
                 .INIT_18                   (256'h0A0A0A0A0A0A0A0A0A0A280102A2010D0D120A28020A020A020A020A01120A11),
                 .INIT_19                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1A                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1B                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1C                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1D                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1E                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A28010D0D0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_1F                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_20                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_21                   (256'h0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_22                   (256'hB26848285858120A120A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A),
                 .INIT_23                   (256'h120202010201020102090212030204020402020902284A1288C8B2684808286A),
                 .INIT_24                   (256'h690202020102010201020902022802B269020202010201020102010209020206),
                 .INIT_25                   (256'h1202020902286818682828B2C802A169496818000828680828B2C802080228B2),
                 .INIT_26                   (256'h00000000000028B2D9D8C8001208080912080809120808091202090212020902),
                 .INIT_27                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_28                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_29                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_2F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_30                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_31                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_32                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_33                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_34                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_35                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_36                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_37                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_38                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_39                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_3F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_40                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_41                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_42                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_43                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_44                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_45                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_46                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_47                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_48                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_49                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_4F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_50                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_51                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_52                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_53                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_54                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_55                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_56                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_57                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_58                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_59                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_5F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_60                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_61                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_62                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_63                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_64                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_65                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_66                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_67                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_68                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_69                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_6F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_70                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_71                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_72                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_73                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_74                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_75                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_76                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_77                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_78                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_79                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7A                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7B                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7C                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7D                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7E                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INIT_7F                   (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_00                  (256'hC1FBAB98C6318C63B183060C1830760C1D830760C182EF63EB7D55EAAABF16DF),
                 .INITP_01                  (256'h83060C18177B41ECD746221121214021020420488408BAE412801E0781E075DE),
                 .INITP_02                  (256'h365CC15555640FD156EA4B183060C183060C1D83060C183B183060C183B060C1),
                 .INITP_03                  (256'hFFFFFFFFFFFF3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5AAD),
                 .INITP_04                  (256'h00000000030888DDEEB446D7755F7556EAB56DA39EBFFFFFFFFFFFFFFFFFFFFF),
                 .INITP_05                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_06                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_07                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_08                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_09                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0A                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0B                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0C                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0D                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0E                  (256'h0000000000000000000000000000000000000000000000000000000000000000),
                 .INITP_0F                  (256'h0000000000000000000000000000000000000000000000000000000000000000))
   kcpsm6_rom_h( .ADDRARDADDR               (address_a),
                 .ENARDEN                   (enable),
                 .CLKARDCLK                 (clk),
                 .DOADO                     (data_out_a_h[31:0]),
                 .DOPADOP                   (data_out_a_h[35:32]), 
                 .DIADI                     (data_in_a[31:0]),
                 .DIPADIP                   (data_in_a[35:32]), 
                 .WEA                       (4'b0000),
                 .REGCEAREGCE               (1'b0),
                 .RSTRAMARSTRAM             (1'b0),
                 .RSTREGARSTREG             (1'b0),
                 .ADDRBWRADDR               (address_b),
                 .ENBWREN                   (enable_b),
                 .CLKBWRCLK                 (clk_b),
                 .DOBDO                     (data_out_b_h[31:0]),
                 .DOPBDOP                   (data_out_b_h[35:32]), 
                 .DIBDI                     (data_in_b_h[31:0]),
                 .DIPBDIP                   (data_in_b_h[35:32]), 
                 .WEBWE                     (we_b),
                 .REGCEB                    (1'b0),
                 .RSTRAMB                   (1'b0),
                 .RSTREGB                   (1'b0),
                 .CASCADEINA                (1'b0),
                 .CASCADEINB                (1'b0),
                 .CASCADEOUTA               (),
                 .CASCADEOUTB               (),
                 .DBITERR                   (),
                 .ECCPARITY                 (),
                 .RDADDRECC                 (),
                 .SBITERR                   (),
                 .INJECTDBITERR             (1'b0),      
                 .INJECTSBITERR             (1'b0));  
    end // akv7;  
    //
  end // ram_4k_generate;
endgenerate      
//
// JTAG Loader 
//
generate
  if (C_JTAG_LOADER_ENABLE == 1) begin: instantiate_loader
    jtag_loader_6  #(  .C_FAMILY              (C_FAMILY),
                       .C_NUM_PICOBLAZE       (1),
                       .C_JTAG_LOADER_ENABLE  (C_JTAG_LOADER_ENABLE),        
                       .C_BRAM_MAX_ADDR_WIDTH (BRAM_ADDRESS_WIDTH),        
                       .C_ADDR_WIDTH_0        (BRAM_ADDRESS_WIDTH))
    jtag_loader_6_inst(.picoblaze_reset       (rdl_bus),
                       .jtag_en               (jtag_en),
                       .jtag_din              (jtag_din),
                       .jtag_addr             (jtag_addr[BRAM_ADDRESS_WIDTH-1 : 0]),
                       .jtag_clk              (jtag_clk),
                       .jtag_we               (jtag_we),
                       .jtag_dout_0           (jtag_dout),
                       .jtag_dout_1           (jtag_dout),  // ports 1-7 are not used
                       .jtag_dout_2           (jtag_dout),  // in a 1 device debug 
                       .jtag_dout_3           (jtag_dout),  // session.  However, Synplify
                       .jtag_dout_4           (jtag_dout),  // etc require all ports are
                       .jtag_dout_5           (jtag_dout),  // connected
                       .jtag_dout_6           (jtag_dout),
                       .jtag_dout_7           (jtag_dout));  
    
  end //instantiate_loader
endgenerate 
//
//
endmodule
//
//
//
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// JTAG Loader 
//
///////////////////////////////////////////////////////////////////////////////////////////
//
//
// JTAG Loader 6 - Version 6.00
//
// Kris Chaplin - 4th February 2010
// Nick Sawyer  - 3rd March 2011 - Initial conversion to Verilog
// Ken Chapman  - 16th August 2011 - Revised coding style
//
`timescale 1ps/1ps
module jtag_loader_6 (picoblaze_reset, jtag_en, jtag_din, jtag_addr, jtag_clk, jtag_we, jtag_dout_0, jtag_dout_1, jtag_dout_2, jtag_dout_3, jtag_dout_4, jtag_dout_5, jtag_dout_6, jtag_dout_7);
//
parameter integer C_JTAG_LOADER_ENABLE = 1;
parameter         C_FAMILY = "V6";
parameter integer C_NUM_PICOBLAZE = 1;
parameter integer C_BRAM_MAX_ADDR_WIDTH = 10;
parameter integer C_PICOBLAZE_INSTRUCTION_DATA_WIDTH = 18;
parameter integer C_JTAG_CHAIN = 2;
parameter [4:0]   C_ADDR_WIDTH_0 = 10;
parameter [4:0]   C_ADDR_WIDTH_1 = 10;
parameter [4:0]   C_ADDR_WIDTH_2 = 10;
parameter [4:0]   C_ADDR_WIDTH_3 = 10;
parameter [4:0]   C_ADDR_WIDTH_4 = 10;
parameter [4:0]   C_ADDR_WIDTH_5 = 10;
parameter [4:0]   C_ADDR_WIDTH_6 = 10;
parameter [4:0]   C_ADDR_WIDTH_7 = 10;
//
output [C_NUM_PICOBLAZE-1:0]                    picoblaze_reset;
output [C_NUM_PICOBLAZE-1:0]                    jtag_en;
output [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_din;
output [C_BRAM_MAX_ADDR_WIDTH-1:0]              jtag_addr;
output                                          jtag_clk ;
output                                          jtag_we;  
input  [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_0;
input  [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_1;
input  [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_2;
input  [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_3;
input  [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_4;
input  [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_5;
input  [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_6;
input  [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_7;
//
//
wire   [2:0]                                    num_picoblaze;        
wire   [4:0]                                    picoblaze_instruction_data_width; 
//
wire                                            drck;
wire                                            shift_clk;
wire                                            shift_din;
wire                                            shift_dout;
wire                                            shift;
wire                                            capture;
//
reg                                             control_reg_ce;
reg    [C_NUM_PICOBLAZE-1:0]                    bram_ce;
wire   [C_NUM_PICOBLAZE-1:0]                    bus_zero;
wire   [C_NUM_PICOBLAZE-1:0]                    jtag_en_int;
wire   [7:0]                                    jtag_en_expanded;
reg    [C_BRAM_MAX_ADDR_WIDTH-1:0]              jtag_addr_int;
reg    [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_din_int;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] control_din;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] control_dout;
reg    [7:0]                                    control_dout_int;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] bram_dout_int;
reg                                             jtag_we_int;
wire                                            jtag_clk_int;
wire                                            bram_ce_valid;
reg                                             din_load;
//                                                
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_0_masked;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_1_masked;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_2_masked;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_3_masked;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_4_masked;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_5_masked;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_6_masked;
wire   [C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0] jtag_dout_7_masked;
reg    [C_NUM_PICOBLAZE-1:0]                    picoblaze_reset_int;
//
initial picoblaze_reset_int = 0;
//
genvar i;
//
generate
  for (i = 0; i <= C_NUM_PICOBLAZE-1; i = i+1)
    begin : npzero_loop
      assign bus_zero[i] = 1'b0;
    end
endgenerate
//
generate
  //
  if (C_JTAG_LOADER_ENABLE == 1)
    begin : jtag_loader_gen
      //
      // Insert BSCAN primitive for target device architecture.
      //
      if (C_FAMILY == "S6")
        begin : BSCAN_SPARTAN6_gen
          BSCAN_SPARTAN6 # (.JTAG_CHAIN (C_JTAG_CHAIN))
          BSCAN_BLOCK_inst (.CAPTURE    (capture),
                            .DRCK       (drck),
                            .RESET      (),
                            .RUNTEST    (),
                            .SEL        (bram_ce_valid),
                            .SHIFT      (shift),
                            .TCK        (),
                            .TDI        (shift_din),
                            .TMS        (),
                            .UPDATE     (jtag_clk_int),
                            .TDO        (shift_dout)); 
            
        end 
      //
      if (C_FAMILY == "V6")
        begin : BSCAN_VIRTEX6_gen
          BSCAN_VIRTEX6 # ( .JTAG_CHAIN   (C_JTAG_CHAIN),
                            .DISABLE_JTAG ("FALSE"))
          BSCAN_BLOCK_inst (.CAPTURE      (capture),
                            .DRCK         (drck),
                            .RESET        (),
                            .RUNTEST      (),
                            .SEL          (bram_ce_valid),
                            .SHIFT        (shift),
                            .TCK          (),
                            .TDI          (shift_din),
                            .TMS          (),
                            .UPDATE       (jtag_clk_int),
                            .TDO          (shift_dout));
        end 
      //
      if (C_FAMILY == "7S")
        begin : BSCAN_7SERIES_gen
          BSCANE2 # (       .JTAG_CHAIN   (C_JTAG_CHAIN),
                            .DISABLE_JTAG ("FALSE"))
          BSCAN_BLOCK_inst (.CAPTURE      (capture),
                            .DRCK         (drck),
                            .RESET        (),
                            .RUNTEST      (),
                            .SEL          (bram_ce_valid),
                            .SHIFT        (shift),
                            .TCK          (),
                            .TDI          (shift_din),
                            .TMS          (),
                            .UPDATE       (jtag_clk_int),
                            .TDO          (shift_dout));
        end 
      //
      // Insert clock buffer to ensure reliable shift operations.
      //
      BUFG upload_clock (.I (drck), .O (shift_clk));
      //        
      //
      // Shift Register 
      //
      always @ (posedge shift_clk) begin
        if (shift == 1'b1) begin
          control_reg_ce <= shift_din;
        end
      end
      // 
      always @ (posedge shift_clk) begin
        if (shift == 1'b1) begin
          bram_ce[0] <= control_reg_ce;
        end
      end 
      //
      for (i = 0; i <= C_NUM_PICOBLAZE-2; i = i+1)
      begin : loop0 
        if (C_NUM_PICOBLAZE > 1) begin
          always @ (posedge shift_clk) begin
            if (shift == 1'b1) begin
              bram_ce[i+1] <= bram_ce[i];
            end
          end
        end 
      end
      // 
      always @ (posedge shift_clk) begin
        if (shift == 1'b1) begin
          jtag_we_int <= bram_ce[C_NUM_PICOBLAZE-1];
        end
      end
      // 
      always @ (posedge shift_clk) begin 
        if (shift == 1'b1) begin
          jtag_addr_int[0] <= jtag_we_int;
        end
      end
      //
      for (i = 0; i <= C_BRAM_MAX_ADDR_WIDTH-2; i = i+1)
      begin : loop1
        always @ (posedge shift_clk) begin
          if (shift == 1'b1) begin
            jtag_addr_int[i+1] <= jtag_addr_int[i];
          end
        end 
      end
      // 
      always @ (posedge shift_clk) begin 
        if (din_load == 1'b1) begin
          jtag_din_int[0] <= bram_dout_int[0];
        end
        else if (shift == 1'b1) begin
          jtag_din_int[0] <= jtag_addr_int[C_BRAM_MAX_ADDR_WIDTH-1];
        end
      end       
      //
      for (i = 0; i <= C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-2; i = i+1)
      begin : loop2
        always @ (posedge shift_clk) begin
          if (din_load == 1'b1) begin
            jtag_din_int[i+1] <= bram_dout_int[i+1];
          end
          if (shift == 1'b1) begin
            jtag_din_int[i+1] <= jtag_din_int[i];
          end
        end 
      end
      //
      assign shift_dout = jtag_din_int[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1];
      //
      //
      always @ (bram_ce or din_load or capture or bus_zero or control_reg_ce) begin
        if ( bram_ce == bus_zero ) begin
          din_load <= capture & control_reg_ce;
        end else begin
          din_load <= capture;
        end
      end
      //
      //
      // Control Registers 
      //
      assign num_picoblaze = C_NUM_PICOBLAZE-3'h1;
      assign picoblaze_instruction_data_width = C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-5'h01;
      //
      always @ (posedge jtag_clk_int) begin
        if (bram_ce_valid == 1'b1 && jtag_we_int == 1'b0 && control_reg_ce == 1'b1) begin
          case (jtag_addr_int[3:0]) 
            0 : // 0 = version - returns (7:4) illustrating number of PB
                // and [3:0] picoblaze instruction data width
                control_dout_int <= {num_picoblaze, picoblaze_instruction_data_width};
            1 : // 1 = PicoBlaze 0 reset / status
                if (C_NUM_PICOBLAZE >= 1) begin 
                  control_dout_int <= {picoblaze_reset_int[0], 2'b00, C_ADDR_WIDTH_0-5'h01};
                end else begin
                  control_dout_int <= 8'h00;
                end
            2 : // 2 = PicoBlaze 1 reset / status
                if (C_NUM_PICOBLAZE >= 2) begin 
                  control_dout_int <= {picoblaze_reset_int[1], 2'b00, C_ADDR_WIDTH_1-5'h01};
                end else begin
                  control_dout_int <= 8'h00;
                end
            3 : // 3 = PicoBlaze 2 reset / status
                if (C_NUM_PICOBLAZE >= 3) begin 
                  control_dout_int <= {picoblaze_reset_int[2], 2'b00, C_ADDR_WIDTH_2-5'h01};
                end else begin
                  control_dout_int <= 8'h00;
                end
            4 : // 4 = PicoBlaze 3 reset / status
                if (C_NUM_PICOBLAZE >= 4) begin 
                  control_dout_int <= {picoblaze_reset_int[3], 2'b00, C_ADDR_WIDTH_3-5'h01};
                end else begin
                  control_dout_int <= 8'h00;
                end
            5:  // 5 = PicoBlaze 4 reset / status
                if (C_NUM_PICOBLAZE >= 5) begin 
                  control_dout_int <= {picoblaze_reset_int[4], 2'b00, C_ADDR_WIDTH_4-5'h01};
                end else begin
                  control_dout_int <= 8'h00;
                end
            6 : // 6 = PicoBlaze 5 reset / status
                if (C_NUM_PICOBLAZE >= 6) begin 
                  control_dout_int <= {picoblaze_reset_int[5], 2'b00, C_ADDR_WIDTH_5-5'h01};
                end else begin
                  control_dout_int <= 8'h00;
                end
            7 : // 7 = PicoBlaze 6 reset / status
                if (C_NUM_PICOBLAZE >= 7) begin 
                  control_dout_int <= {picoblaze_reset_int[6], 2'b00, C_ADDR_WIDTH_6-5'h01};
                end else begin
                  control_dout_int <= 8'h00;
                end
            8 : // 8 = PicoBlaze 7 reset / status
                if (C_NUM_PICOBLAZE >= 8) begin 
                  control_dout_int <= {picoblaze_reset_int[7], 2'b00, C_ADDR_WIDTH_7-5'h01};
                end else begin
                  control_dout_int <= 8'h00;
                end
            15 : control_dout_int <= C_BRAM_MAX_ADDR_WIDTH -1;
            default : control_dout_int <= 8'h00;
            //
          endcase
        end else begin
          control_dout_int <= 8'h00;
        end
      end 
      //
      assign control_dout[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-8] = control_dout_int;
      //
      always @ (posedge jtag_clk_int) begin
        if (bram_ce_valid == 1'b1 && jtag_we_int == 1'b1 && control_reg_ce == 1'b1) begin
          picoblaze_reset_int[C_NUM_PICOBLAZE-1:0] <= control_din[C_NUM_PICOBLAZE-1:0];
        end
      end     
      //
      //
      // Assignments 
      //
      if (C_PICOBLAZE_INSTRUCTION_DATA_WIDTH > 8) begin
        assign control_dout[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-9:0] = 10'h000;
      end
      //
      // Qualify the blockram CS signal with bscan select output
      assign jtag_en_int = (bram_ce_valid) ? bram_ce : bus_zero;
      //
      assign jtag_en_expanded[C_NUM_PICOBLAZE-1:0] = jtag_en_int; 
      //
      for (i = 7; i >= C_NUM_PICOBLAZE; i = i-1)
        begin : loop4 
          if (C_NUM_PICOBLAZE < 8) begin : jtag_en_expanded_gen
            assign jtag_en_expanded[i] = 1'b0;
          end
        end
      //
      assign bram_dout_int = control_dout | jtag_dout_0_masked | jtag_dout_1_masked | jtag_dout_2_masked | jtag_dout_3_masked | jtag_dout_4_masked | jtag_dout_5_masked | jtag_dout_6_masked | jtag_dout_7_masked;
      //
      assign control_din = jtag_din_int;
      //
      assign jtag_dout_0_masked = (jtag_en_expanded[0]) ? jtag_dout_0 : 18'h00000;
      assign jtag_dout_1_masked = (jtag_en_expanded[1]) ? jtag_dout_1 : 18'h00000;
      assign jtag_dout_2_masked = (jtag_en_expanded[2]) ? jtag_dout_2 : 18'h00000;
      assign jtag_dout_3_masked = (jtag_en_expanded[3]) ? jtag_dout_3 : 18'h00000;
      assign jtag_dout_4_masked = (jtag_en_expanded[4]) ? jtag_dout_4 : 18'h00000;
      assign jtag_dout_5_masked = (jtag_en_expanded[5]) ? jtag_dout_5 : 18'h00000;
      assign jtag_dout_6_masked = (jtag_en_expanded[6]) ? jtag_dout_6 : 18'h00000;
      assign jtag_dout_7_masked = (jtag_en_expanded[7]) ? jtag_dout_7 : 18'h00000;
      //       
      assign jtag_en = jtag_en_int;
      assign jtag_din = jtag_din_int;
      assign jtag_addr = jtag_addr_int;
      assign jtag_clk = jtag_clk_int;
      assign jtag_we = jtag_we_int;
      assign picoblaze_reset = picoblaze_reset_int;
      //
    end
endgenerate
   //
endmodule
//
///////////////////////////////////////////////////////////////////////////////////////////
//
//  END OF FILE core.v
//
///////////////////////////////////////////////////////////////////////////////////////////
//
