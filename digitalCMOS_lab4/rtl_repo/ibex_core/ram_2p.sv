// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * Dual-port RAM with 1 cycle read/write delay, 32 bit words.
 */


module ram_2p #(
    parameter int Depth       = 128

) (
    input               clk_i,
    input               rst_ni,

    input               a_req_i,
    input               a_we_i,
    input        [ 3:0] a_be_i,
    input        [31:0] a_addr_i,
    input        [31:0] a_wdata_i,
    output logic        a_rvalid_o,
    output logic [31:0] a_rdata_o,

    input               b_req_i,
    input               b_we_i,
    input        [ 3:0] b_be_i,
    input        [31:0] b_addr_i,
    input        [31:0] b_wdata_i,
    output logic        b_rvalid_o,
    output logic [31:0] b_rdata_o
);

  localparam int Aw = $clog2(Depth);

  logic [Aw-1:0] a_addr_idx;
  assign a_addr_idx = a_addr_i[Aw-1+2:2];
  logic [31-Aw:0] unused_a_addr_parts;
  assign unused_a_addr_parts = {a_addr_i[31:Aw+2], a_addr_i[1:0]};

  logic [Aw-1:0] b_addr_idx;
  assign b_addr_idx = b_addr_i[Aw-1+2:2];
  logic [31-Aw:0] unused_b_addr_parts;
  assign unused_b_addr_parts = {b_addr_i[31:Aw+2], b_addr_i[1:0]};

  // Convert byte mask to SRAM bit mask.
  logic [3:0] a_wmask;
  logic [3:0] b_wmask;
  
  assign a_wmask = (a_we_i==1'b1) ? a_be_i : 4'b0000;
  assign b_wmask = (b_we_i==1'b1) ? b_be_i : 4'b0000;
	

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      a_rvalid_o <= '0;
      b_rvalid_o <= '0;
    end else begin
      a_rvalid_o <= a_req_i;
      b_rvalid_o <= b_req_i;
    end
  end


SJ180_1024X8X4CM8 u_sram_memory (	

.A0(a_addr_idx[0]),
.A1(a_addr_idx[1]),
.A2(a_addr_idx[2]),
.A3(a_addr_idx[3]),
.A4(a_addr_idx[4]),
.A5(a_addr_idx[5]),
.A6(a_addr_idx[6]),
.A7(a_addr_idx[7]),
.A8(a_addr_idx[8]),
.A9(a_addr_idx[9]),

.B0(b_addr_idx[0]),
.B1(b_addr_idx[1]),
.B2(b_addr_idx[2]),
.B3(b_addr_idx[3]),
.B4(b_addr_idx[4]),
.B5(b_addr_idx[5]),
.B6(b_addr_idx[6]),
.B7(b_addr_idx[7]),
.B8(b_addr_idx[8]),
.B9(b_addr_idx[9]),

.DOA0(a_rdata_o[0]),
.DOA1(a_rdata_o[1]),
.DOA2(a_rdata_o[2]),
.DOA3(a_rdata_o[3]),
.DOA4(a_rdata_o[4]),
.DOA5(a_rdata_o[5]),
.DOA6(a_rdata_o[6]),
.DOA7(a_rdata_o[7]),
.DOA8(a_rdata_o[8]),
.DOA9(a_rdata_o[9]),
.DOA10(a_rdata_o[10]),
.DOA11(a_rdata_o[11]),
.DOA12(a_rdata_o[12]),
.DOA13(a_rdata_o[13]),
.DOA14(a_rdata_o[14]),
.DOA15(a_rdata_o[15]),
.DOA16(a_rdata_o[16]),
.DOA17(a_rdata_o[17]),
.DOA18(a_rdata_o[18]),
.DOA19(a_rdata_o[19]),
.DOA20(a_rdata_o[20]),
.DOA21(a_rdata_o[21]),
.DOA22(a_rdata_o[22]),
.DOA23(a_rdata_o[23]),
.DOA24(a_rdata_o[24]),
.DOA25(a_rdata_o[25]),
.DOA26(a_rdata_o[26]),
.DOA27(a_rdata_o[27]),
.DOA28(a_rdata_o[28]),
.DOA29(a_rdata_o[29]),
.DOA30(a_rdata_o[30]),
.DOA31(a_rdata_o[31]),

.DOB0(b_rdata_o[0]),
.DOB1(b_rdata_o[1]),
.DOB2(b_rdata_o[2]),
.DOB3(b_rdata_o[3]),
.DOB4(b_rdata_o[4]),
.DOB5(b_rdata_o[5]),
.DOB6(b_rdata_o[6]),
.DOB7(b_rdata_o[7]),
.DOB8(b_rdata_o[8]),
.DOB9(b_rdata_o[9]),
.DOB10(b_rdata_o[10]),
.DOB11(b_rdata_o[11]),
.DOB12(b_rdata_o[12]),
.DOB13(b_rdata_o[13]),
.DOB14(b_rdata_o[14]),
.DOB15(b_rdata_o[15]),
.DOB16(b_rdata_o[16]),
.DOB17(b_rdata_o[17]),
.DOB18(b_rdata_o[18]),
.DOB19(b_rdata_o[19]),
.DOB20(b_rdata_o[20]),
.DOB21(b_rdata_o[21]),
.DOB22(b_rdata_o[22]),
.DOB23(b_rdata_o[23]),
.DOB24(b_rdata_o[24]),
.DOB25(b_rdata_o[25]),
.DOB26(b_rdata_o[26]),
.DOB27(b_rdata_o[27]),
.DOB28(b_rdata_o[28]),
.DOB29(b_rdata_o[29]),
.DOB30(b_rdata_o[30]),
.DOB31(b_rdata_o[31]),

.DIA0(a_wdata_i[0]),
.DIA1(a_wdata_i[1]),
.DIA2(a_wdata_i[2]),
.DIA3(a_wdata_i[3]),
.DIA4(a_wdata_i[4]),
.DIA5(a_wdata_i[5]),
.DIA6(a_wdata_i[6]),
.DIA7(a_wdata_i[7]),
.DIA8(a_wdata_i[8]),
.DIA9(a_wdata_i[9]),
.DIA10(a_wdata_i[10]),
.DIA11(a_wdata_i[11]),
.DIA12(a_wdata_i[12]),
.DIA13(a_wdata_i[13]),
.DIA14(a_wdata_i[14]),
.DIA15(a_wdata_i[15]),
.DIA16(a_wdata_i[16]),
.DIA17(a_wdata_i[17]),
.DIA18(a_wdata_i[18]),
.DIA19(a_wdata_i[19]),
.DIA20(a_wdata_i[20]),
.DIA21(a_wdata_i[21]),
.DIA22(a_wdata_i[22]),
.DIA23(a_wdata_i[23]),
.DIA24(a_wdata_i[24]),
.DIA25(a_wdata_i[25]),
.DIA26(a_wdata_i[26]),
.DIA27(a_wdata_i[27]),
.DIA28(a_wdata_i[28]),
.DIA29(a_wdata_i[29]),
.DIA30(a_wdata_i[30]),
.DIA31(a_wdata_i[31]),

.DIB0(b_wdata_i[0]),
.DIB1(b_wdata_i[1]),
.DIB2(b_wdata_i[2]),
.DIB3(b_wdata_i[3]),
.DIB4(b_wdata_i[4]),
.DIB5(b_wdata_i[5]),
.DIB6(b_wdata_i[6]),
.DIB7(b_wdata_i[7]),
.DIB8(b_wdata_i[8]),
.DIB9(b_wdata_i[9]),
.DIB10(b_wdata_i[10]),
.DIB11(b_wdata_i[11]),
.DIB12(b_wdata_i[12]),
.DIB13(b_wdata_i[13]),
.DIB14(b_wdata_i[14]),
.DIB15(b_wdata_i[15]),
.DIB16(b_wdata_i[16]),
.DIB17(b_wdata_i[17]),
.DIB18(b_wdata_i[18]),
.DIB19(b_wdata_i[19]),
.DIB20(b_wdata_i[20]),
.DIB21(b_wdata_i[21]),
.DIB22(b_wdata_i[22]),
.DIB23(b_wdata_i[23]),
.DIB24(b_wdata_i[24]),
.DIB25(b_wdata_i[25]),
.DIB26(b_wdata_i[26]),
.DIB27(b_wdata_i[27]),
.DIB28(b_wdata_i[28]),
.DIB29(b_wdata_i[29]),
.DIB30(b_wdata_i[30]),
.DIB31(b_wdata_i[31]),

.WEAN0(~a_wmask[0]),
.WEAN1(~a_wmask[1]),
.WEAN2(~a_wmask[2]),
.WEAN3(~a_wmask[3]),

.WEBN0(~b_wmask[0]),
.WEBN1(~b_wmask[1]),
.WEBN2(~b_wmask[2]),
.WEBN3(~b_wmask[3]),
                         

.CKA(clk_i),
.CKB(clk_i),

.CSA(a_req_i),.CSB(b_req_i),

.OEA(1'b1),.OEB(1'b1)			

);



endmodule
