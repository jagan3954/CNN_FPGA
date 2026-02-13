/*------------------------------------------------------------------------
 *
 *  Copyright (c) 2021 by Bo Young Kang, All rights reserved.
 *
 *  File name  : fully_connected.v
 *  Written by : Kang, Bo Young
 *  Written on : Oct 13, 2021
 *  Version    : 21.2
 *  Design     : Fully Connected Layer for CNN
 *
 *------------------------------------------------------------------------*/

/*-------------------------------------------------------------------
 *  Module: fully_connected
 *------------------------------------------------------------------*/

 module fully_connected #(parameter INPUT_NUM = 48, OUTPUT_NUM = 10, DATA_BITS = 8) (
   input clk,
   input rst_n,
   input valid_in,
   input signed [11:0] data_in_1, data_in_2, data_in_3,
   output [11:0] data_out,
   output reg valid_out_fc
 );

 localparam INPUT_WIDTH = 16;
 localparam INPUT_NUM_DATA_BITS = 5;

 reg state;
 reg [INPUT_WIDTH - 1:0] buf_idx;
 reg [3:0] out_idx;
 reg signed [13:0] buffer [0:INPUT_NUM - 1];
 reg signed [DATA_BITS - 1:0] weight [0:INPUT_NUM * OUTPUT_NUM - 1];
 reg signed [DATA_BITS - 1:0] bias [0:OUTPUT_NUM - 1];
   
 wire signed [19:0] calc_out;
 wire signed [13:0] data1, data2, data3;

// initial begin
//   $readmemh("fc_weight.txt", weight);
//   $readmemh("fc_bias.txt", bias);
// end


initial begin
    weight[0] = 8'shfe;
    weight[1] = 8'sh 1;
    weight[2] = 8'sh8 ;
    weight[3] = 8'shfe;
    weight[4] = 8'sh f;
    weight[5] = 8'sh8 ;
    weight[6] = 8'sh13;
    weight[7] = 8'sh 1;
    weight[8] = 8'sh3 ;
    weight[9] = 8'shfc;
    weight[10] = 8'sh 1;
    weight[11] = 8'sh4 ;
    weight[12] = 8'sh11;
    weight[13] = 8'sh f;
    weight[14] = 8'shb ;
    weight[15] = 8'shf8;
    weight[16] = 8'sh 2;
    weight[17] = 8'sh2 ;
    weight[18] = 8'shfd;
    weight[19] = 8'sh e;
    weight[20] = 8'she ;
    weight[21] = 8'sh00;
    weight[22] = 8'sh 0;
    weight[23] = 8'sh1 ;
    weight[24] = 8'shfd;
    weight[25] = 8'sh 0;
    weight[26] = 8'sh2 ;
    weight[27] = 8'sh0f;
    weight[28] = 8'sh 0;
    weight[29] = 8'sh6 ;
    weight[30] = 8'shf2;
    weight[31] = 8'sh f;
    weight[32] = 8'sh5 ;
    weight[33] = 8'she7;
    weight[34] = 8'sh f;
    weight[35] = 8'shd ;
    weight[36] = 8'shdf;
    weight[37] = 8'sh e;
    weight[38] = 8'sh3 ;
    weight[39] = 8'shf2;
    weight[40] = 8'sh 0;
    weight[41] = 8'sh4 ;
    weight[42] = 8'shf1;
    weight[43] = 8'sh 1;
    weight[44] = 8'sh2 ;
    weight[45] = 8'sh1a;
    weight[46] = 8'sh f;
    weight[47] = 8'sha ;
    weight[48] = 8'shf5;
    weight[49] = 8'sh 0;
    weight[50] = 8'sh9 ;
    weight[51] = 8'sh03;
    weight[52] = 8'sh 0;
    weight[53] = 8'sh2 ;
    weight[54] = 8'shfd;
    weight[55] = 8'sh f;
    weight[56] = 8'sha ;
    weight[57] = 8'sh0d;
    weight[58] = 8'sh 2;
    weight[59] = 8'sh3 ;
    weight[60] = 8'sh14;
    weight[61] = 8'sh e;
    weight[62] = 8'shf ;
    weight[63] = 8'she0;
    weight[64] = 8'sh f;
    weight[65] = 8'shc ;
    weight[66] = 8'sh27;
    weight[67] = 8'sh e;
    weight[68] = 8'shb ;
    weight[69] = 8'shcc;
    weight[70] = 8'sh 0;
    weight[71] = 8'sha;
    weight[72] = 8'shfe;
    weight[73] = 8'sh e;
    weight[74] = 8'shf ;
    weight[75] = 8'sh30;
    weight[76] = 8'sh 0;
    weight[77] = 8'shd ;
    weight[78] = 8'sh09;
    weight[79] = 8'sh 0;
    weight[80] = 8'sh9 ;
    weight[81] = 8'sh0a;
    weight[82] = 8'sh f;
    weight[83] = 8'sh3 ;
    weight[84] = 8'sh18;
    weight[85] = 8'sh 0;
    weight[86] = 8'shf ;
    weight[87] = 8'shef;
    weight[88] = 8'sh e;
    weight[89] = 8'shc ;
    weight[90] = 8'sh14;
    weight[91] = 8'sh 2;
    weight[92] = 8'sh8 ;
    weight[93] = 8'she0;
    weight[94] = 8'sh f;
    weight[95] = 8'sh9 ;
    weight[96] = 8'sh01;
    weight[97] = 8'sh 1;
    weight[98] = 8'sh7 ;
    weight[99] = 8'shdd;
    weight[100] = 8'sh f;
    weight[101] = 8'sh1 ;
    weight[102] = 8'sh0b;
    weight[103] = 8'sh f;
    weight[104] = 8'sh4 ;
    weight[105] = 8'shed;
    weight[106] = 8'sh e;
    weight[107] = 8'sh8 ;
    weight[108] = 8'sh02;
    weight[109] = 8'sh f;
    weight[110] = 8'sh4 ;
    weight[111] = 8'shef;
    weight[112] = 8'sh f;
    weight[113] = 8'sh2 ;
    weight[114] = 8'sh11;
    weight[115] = 8'sh f;
    weight[116] = 8'sh4 ;
    weight[117] = 8'shf7;
    weight[118] = 8'sh 2;
    weight[119] = 8'sh0 ;
    weight[120] = 8'shd9;
    weight[121] = 8'sh 3;
    weight[122] = 8'sh1 ;
    weight[123] = 8'shd4;
    weight[124] = 8'sh d;
    weight[125] = 8'sh6 ;
    weight[126] = 8'shdd;
    weight[127] = 8'sh 4;
    weight[128] = 8'sh0 ;
    weight[129] = 8'shfe;
    weight[130] = 8'sh f;
    weight[131] = 8'she ;
    weight[132] = 8'shed;
    weight[133] = 8'sh 1;
    weight[134] = 8'sh0 ;
    weight[135] = 8'shf5;
    weight[136] = 8'sh 0;
    weight[137] = 8'sh5 ;
    weight[138] = 8'shc5;
    weight[139] = 8'sh 2;
    weight[140] = 8'sh1 ;
    weight[141] = 8'sh03;
    weight[142] = 8'sh f;
    weight[143] = 8'sha;
    weight[144] = 8'she3;
    weight[145] = 8'sh f;
    weight[146] = 8'sh5 ;
    weight[147] = 8'shed;
    weight[148] = 8'sh e;
    weight[149] = 8'sh4 ;
    weight[150] = 8'sh0f;
    weight[151] = 8'sh 1;
    weight[152] = 8'sh1 ;
    weight[153] = 8'sh16;
    weight[154] = 8'sh 1;
    weight[155] = 8'shb ;
    weight[156] = 8'sh38;
    weight[157] = 8'sh 2;
    weight[158] = 8'sh9 ;
    weight[159] = 8'sh09;
    weight[160] = 8'sh 0;
    weight[161] = 8'sh0 ;
    weight[162] = 8'shfd;
    weight[163] = 8'sh e;
    weight[164] = 8'shd ;
    weight[165] = 8'shde;
    weight[166] = 8'sh e;
    weight[167] = 8'sh3 ;
    weight[168] = 8'sh1e;
    weight[169] = 8'sh 0;
    weight[170] = 8'sh6 ;
    weight[171] = 8'sh0e;
    weight[172] = 8'sh f;
    weight[173] = 8'sh1 ;
    weight[174] = 8'sh3a;
    weight[175] = 8'sh 1;
    weight[176] = 8'sh4 ;
    weight[177] = 8'shfd;
    weight[178] = 8'sh f;
    weight[179] = 8'sh1 ;
    weight[180] = 8'sh12;
    weight[181] = 8'sh f;
    weight[182] = 8'sha ;
    weight[183] = 8'sh02;
    weight[184] = 8'sh 1;
    weight[185] = 8'sh4 ;
    weight[186] = 8'she7;
    weight[187] = 8'sh f;
    weight[188] = 8'sha ;
    weight[189] = 8'sh04;
    weight[190] = 8'sh 2;
    weight[191] = 8'sha ;
    weight[192] = 8'sh1c;
    weight[193] = 8'sh 2;
    weight[194] = 8'sh8 ;
    weight[195] = 8'sh3d;
    weight[196] = 8'sh 0;
    weight[197] = 8'sh6 ;
    weight[198] = 8'shfe;
    weight[199] = 8'sh e;
    weight[200] = 8'she ;
    weight[201] = 8'shf6;
    weight[202] = 8'sh f;
    weight[203] = 8'sh4 ;
    weight[204] = 8'shd0;
    weight[205] = 8'sh f;
    weight[206] = 8'sh1 ;
    weight[207] = 8'shdd;
    weight[208] = 8'sh 0;
    weight[209] = 8'sh2 ;
    weight[210] = 8'sh00;
    weight[211] = 8'sh f;
    weight[212] = 8'sha ;
    weight[213] = 8'sh0c;
    weight[214] = 8'sh 1;
    weight[215] = 8'sh0;
    weight[216] = 8'shcc;
    weight[217] = 8'sh f;
    weight[218] = 8'sh9 ;
    weight[219] = 8'sh0f;
    weight[220] = 8'sh 1;
    weight[221] = 8'she ;
    weight[222] = 8'shf2;
    weight[223] = 8'sh 1;
    weight[224] = 8'sh1 ;
    weight[225] = 8'sh01;
    weight[226] = 8'sh 1;
    weight[227] = 8'sh2 ;
    weight[228] = 8'she1;
    weight[229] = 8'sh d;
    weight[230] = 8'shb ;
    weight[231] = 8'shd0;
    weight[232] = 8'sh 0;
    weight[233] = 8'sh3 ;
    weight[234] = 8'sh01;
    weight[235] = 8'sh 1;
    weight[236] = 8'shc ;
    weight[237] = 8'sh18;
    weight[238] = 8'sh 1;
    weight[239] = 8'sh7 ;
    weight[240] = 8'sh1e;
    weight[241] = 8'sh 1;
    weight[242] = 8'sh4 ;
    weight[243] = 8'sh08;
    weight[244] = 8'sh 0;
    weight[245] = 8'sh4 ;
    weight[246] = 8'sh17;
    weight[247] = 8'sh 0;
    weight[248] = 8'sh3 ;
    weight[249] = 8'sh0b;
    weight[250] = 8'sh 0;
    weight[251] = 8'shb ;
    weight[252] = 8'sh00;
    weight[253] = 8'sh 0;
    weight[254] = 8'sh1 ;
    weight[255] = 8'sh11;
    weight[256] = 8'sh f;
    weight[257] = 8'shc ;
    weight[258] = 8'sh25;
    weight[259] = 8'sh f;
    weight[260] = 8'sha ;
    weight[261] = 8'sh14;
    weight[262] = 8'sh f;
    weight[263] = 8'sh0 ;
    weight[264] = 8'shfa;
    weight[265] = 8'sh 2;
    weight[266] = 8'sh6 ;
    weight[267] = 8'sh17;
    weight[268] = 8'sh f;
    weight[269] = 8'she ;
    weight[270] = 8'she8;
    weight[271] = 8'sh 0;
    weight[272] = 8'sh0 ;
    weight[273] = 8'shfb;
    weight[274] = 8'sh f;
    weight[275] = 8'sh7 ;
    weight[276] = 8'she6;
    weight[277] = 8'sh 1;
    weight[278] = 8'sh3 ;
    weight[279] = 8'sh12;
    weight[280] = 8'sh f;
    weight[281] = 8'shc ;
    weight[282] = 8'shed;
    weight[283] = 8'sh f;
    weight[284] = 8'sh8 ;
    weight[285] = 8'sh00;
    weight[286] = 8'sh 0;
    weight[287] = 8'sh8;
    weight[288] = 8'sh14;
    weight[289] = 8'sh 2;
    weight[290] = 8'sh0 ;
    weight[291] = 8'sh20;
    weight[292] = 8'sh 2;
    weight[293] = 8'shc ;
    weight[294] = 8'sh27;
    weight[295] = 8'sh e;
    weight[296] = 8'sh9 ;
    weight[297] = 8'shf3;
    weight[298] = 8'sh 1;
    weight[299] = 8'sha ;
    weight[300] = 8'shef;
    weight[301] = 8'sh d;
    weight[302] = 8'shb ;
    weight[303] = 8'sh06;
    weight[304] = 8'sh e;
    weight[305] = 8'shc ;
    weight[306] = 8'sh1b;
    weight[307] = 8'sh 1;
    weight[308] = 8'sh6 ;
    weight[309] = 8'shf5;
    weight[310] = 8'sh f;
    weight[311] = 8'sh5 ;
    weight[312] = 8'shf9;
    weight[313] = 8'sh d;
    weight[314] = 8'sh0 ;
    weight[315] = 8'shcc;
    weight[316] = 8'sh d;
    weight[317] = 8'sh7 ;
    weight[318] = 8'shfb;
    weight[319] = 8'sh 1;
    weight[320] = 8'sh7 ;
    weight[321] = 8'sh00;
    weight[322] = 8'sh e;
    weight[323] = 8'shf ;
    weight[324] = 8'sh19;
    weight[325] = 8'sh 1;
    weight[326] = 8'sh8 ;
    weight[327] = 8'sh1e;
    weight[328] = 8'sh 1;
    weight[329] = 8'shc ;
    weight[330] = 8'shf8;
    weight[331] = 8'sh f;
    weight[332] = 8'sh6 ;
    weight[333] = 8'she6;
    weight[334] = 8'sh f;
    weight[335] = 8'sh7 ;
    weight[336] = 8'sh35;
    weight[337] = 8'sh e;
    weight[338] = 8'she ;
    weight[339] = 8'shf0;
    weight[340] = 8'sh f;
    weight[341] = 8'sh7 ;
    weight[342] = 8'sh08;
    weight[343] = 8'sh e;
    weight[344] = 8'shf ;
    weight[345] = 8'sh2c;
    weight[346] = 8'sh e;
    weight[347] = 8'shf ;
    weight[348] = 8'sh12;
    weight[349] = 8'sh 0;
    weight[350] = 8'shf ;
    weight[351] = 8'shf2;
    weight[352] = 8'sh f;
    weight[353] = 8'sha ;
    weight[354] = 8'shf0;
    weight[355] = 8'sh 0;
    weight[356] = 8'sh1 ;
    weight[357] = 8'sh08;
    weight[358] = 8'sh f;
    weight[359] = 8'sh1;
    weight[360] = 8'sh01;
    weight[361] = 8'sh 1;
    weight[362] = 8'sh2 ;
    weight[363] = 8'shea;
    weight[364] = 8'sh e;
    weight[365] = 8'sh7 ;
    weight[366] = 8'she6;
    weight[367] = 8'sh f;
    weight[368] = 8'sh3 ;
    weight[369] = 8'she0;
    weight[370] = 8'sh b;
    weight[371] = 8'sh3 ;
    weight[372] = 8'sh00;
    weight[373] = 8'sh 0;
    weight[374] = 8'sh1 ;
    weight[375] = 8'sh12;
    weight[376] = 8'sh e;
    weight[377] = 8'sh9 ;
    weight[378] = 8'shed;
    weight[379] = 8'sh 1;
    weight[380] = 8'sh2 ;
    weight[381] = 8'sh1f;
    weight[382] = 8'sh 2;
    weight[383] = 8'sh9 ;
    weight[384] = 8'shf0;
    weight[385] = 8'sh 0;
    weight[386] = 8'sh2 ;
    weight[387] = 8'sh08;
    weight[388] = 8'sh 3;
    weight[389] = 8'sh9 ;
    weight[390] = 8'shfc;
    weight[391] = 8'sh 0;
    weight[392] = 8'sh8 ;
    weight[393] = 8'sh0e;
    weight[394] = 8'sh 2;
    weight[395] = 8'sh5 ;
    weight[396] = 8'sh18;
    weight[397] = 8'sh 0;
    weight[398] = 8'sh5 ;
    weight[399] = 8'shfe;
    weight[400] = 8'sh 0;
    weight[401] = 8'sh0 ;
    weight[402] = 8'sh2c;
    weight[403] = 8'sh 0;
    weight[404] = 8'sh4 ;
    weight[405] = 8'sh0c;
    weight[406] = 8'sh e;
    weight[407] = 8'she ;
    weight[408] = 8'sh0d;
    weight[409] = 8'sh e;
    weight[410] = 8'sh3 ;
    weight[411] = 8'shdb;
    weight[412] = 8'sh 2;
    weight[413] = 8'sh1 ;
    weight[414] = 8'sh1b;
    weight[415] = 8'sh f;
    weight[416] = 8'sh1 ;
    weight[417] = 8'shfb;
    weight[418] = 8'sh 0;
    weight[419] = 8'sh3 ;
    weight[420] = 8'sh15;
    weight[421] = 8'sh 0;
    weight[422] = 8'shc ;
    weight[423] = 8'sh23;
    weight[424] = 8'sh f;
    weight[425] = 8'sh8 ;
    weight[426] = 8'sh00;
    weight[427] = 8'sh f;
    weight[428] = 8'shb ;
    weight[429] = 8'sh0b;
    weight[430] = 8'sh 0;
    weight[431] = 8'sh5;
    weight[432] = 8'sh18;
    weight[433] = 8'sh 2;
    weight[434] = 8'shc ;
    weight[435] = 8'sh18;
    weight[436] = 8'sh e;
    weight[437] = 8'sh7 ;
    weight[438] = 8'sh06;
    weight[439] = 8'sh f;
    weight[440] = 8'shf ;
    weight[441] = 8'sh0b;
    weight[442] = 8'sh d;
    weight[443] = 8'shc ;
    weight[444] = 8'shf6;
    weight[445] = 8'sh 1;
    weight[446] = 8'sh7 ;
    weight[447] = 8'sh29;
    weight[448] = 8'sh 2;
    weight[449] = 8'sha ;
    weight[450] = 8'shed;
    weight[451] = 8'sh e;
    weight[452] = 8'sh6 ;
    weight[453] = 8'shf6;
    weight[454] = 8'sh f;
    weight[455] = 8'sh9 ;
    weight[456] = 8'shf1;
    weight[457] = 8'sh e;
    weight[458] = 8'sh2 ;
    weight[459] = 8'shf3;
    weight[460] = 8'sh f;
    weight[461] = 8'shf ;
    weight[462] = 8'she4;
    weight[463] = 8'sh e;
    weight[464] = 8'sh2 ;
    weight[465] = 8'sh0f;
    weight[466] = 8'sh 2;
    weight[467] = 8'sh3 ;
    weight[468] = 8'she1;
    weight[469] = 8'sh e;
    weight[470] = 8'sha ;
    weight[471] = 8'sh08;
    weight[472] = 8'sh 0;
    weight[473] = 8'sh9 ;
    weight[474] = 8'she5;
    weight[475] = 8'sh 0;
    weight[476] = 8'sh5 ;
    weight[477] = 8'sh0e;
    weight[478] = 8'sh 0;
    weight[479] = 8'shd ;
    weight[480] = 8'shf4;
    weight[481] = 8'sh d;
    weight[482] = 8'sh1 ;
    weight[483] = 8'shbc;
    weight[484] = 8'sh 1;
    weight[485] = 8'sha ;
    weight[486] = 8'shf4;
    weight[487] = 8'sh c;
    weight[488] = 8'sh1 ;
    weight[489] = 8'shc5;
    weight[490] = 8'sh 0;
    weight[491] = 8'sh9 ;
    weight[492] = 8'sh0d;
    weight[493] = 8'sh e;
    weight[494] = 8'shf ;
    weight[495] = 8'sh09;
    weight[496] = 8'sh 1;
    weight[497] = 8'sh1 ;
    weight[498] = 8'sh1c;
    weight[499] = 8'sh 1;
    weight[500] = 8'sh0 ;
    weight[501] = 8'sh0b;
    weight[502] = 8'sh 0;
    weight[503] = 8'shd;
    weight[504] = 8'shf0;
    weight[505] = 8'sh d;
    weight[506] = 8'sh3 ;
    weight[507] = 8'she1;
    weight[508] = 8'sh 1;
    weight[509] = 8'sh8 ;
    weight[510] = 8'sh17;
    weight[511] = 8'sh 2;
    weight[512] = 8'sh3 ;
    weight[513] = 8'sh0b;
    weight[514] = 8'sh 0;
    weight[515] = 8'shd ;
    weight[516] = 8'sh0f;
    weight[517] = 8'sh f;
    weight[518] = 8'sh1 ;
    weight[519] = 8'sh0f;
    weight[520] = 8'sh 0;
    weight[521] = 8'shc ;
    weight[522] = 8'sh13;
    weight[523] = 8'sh 0;
    weight[524] = 8'shb ;
    weight[525] = 8'sh00;
    weight[526] = 8'sh f;
    weight[527] = 8'shb ;
    weight[528] = 8'sh15;
    weight[529] = 8'sh 1;
    weight[530] = 8'shc ;
    weight[531] = 8'sh2b;
    weight[532] = 8'sh 0;
    weight[533] = 8'sh5 ;
    weight[534] = 8'sh1e;
    weight[535] = 8'sh 1;
    weight[536] = 8'sh7 ;
    weight[537] = 8'sh02;
    weight[538] = 8'sh 0;
    weight[539] = 8'sh0 ;
    weight[540] = 8'sh13;
    weight[541] = 8'sh e;
    weight[542] = 8'sh9 ;
    weight[543] = 8'shf3;
    weight[544] = 8'sh 2;
    weight[545] = 8'sh9 ;
    weight[546] = 8'shfd;
    weight[547] = 8'sh e;
    weight[548] = 8'sh2 ;
    weight[549] = 8'shde;
    weight[550] = 8'sh e;
    weight[551] = 8'sh8 ;
    weight[552] = 8'sh11;
    weight[553] = 8'sh f;
    weight[554] = 8'she ;
    weight[555] = 8'sh09;
    weight[556] = 8'sh d;
    weight[557] = 8'she ;
    weight[558] = 8'shfc;
    weight[559] = 8'sh 0;
    weight[560] = 8'shc ;
    weight[561] = 8'sh39;
    weight[562] = 8'sh 0;
    weight[563] = 8'sh4 ;
    weight[564] = 8'sh0e;
    weight[565] = 8'sh f;
    weight[566] = 8'sh6 ;
    weight[567] = 8'shd7;
    weight[568] = 8'sh e;
    weight[569] = 8'sha ;
    weight[570] = 8'shc7;
    weight[571] = 8'sh 0;
    weight[572] = 8'sh1 ;
    weight[573] = 8'sh00;
    weight[574] = 8'sh 0;
    weight[575] = 8'sh0;
    weight[576] = 8'sh0e;
    weight[577] = 8'sh f;
    weight[578] = 8'shf ;
    weight[579] = 8'shfa;
    weight[580] = 8'sh 0;
    weight[581] = 8'sh7 ;
    weight[582] = 8'shf6;
    weight[583] = 8'sh e;
    weight[584] = 8'she ;
    weight[585] = 8'sh0d;
    weight[586] = 8'sh 1;
    weight[587] = 8'sh7 ;
    weight[588] = 8'sh28;
    weight[589] = 8'sh 2;
    weight[590] = 8'sha ;
    weight[591] = 8'shf6;
    weight[592] = 8'sh e;
    weight[593] = 8'sh3 ;
    weight[594] = 8'shfa;
    weight[595] = 8'sh d;
    weight[596] = 8'sh0 ;
    weight[597] = 8'sh0b;
    weight[598] = 8'sh 1;
    weight[599] = 8'sh0 ;
    weight[600] = 8'she3;
    weight[601] = 8'sh 0;
    weight[602] = 8'shf ;
    weight[603] = 8'shff;
    weight[604] = 8'sh 1;
    weight[605] = 8'sh4 ;
    weight[606] = 8'shf9;
    weight[607] = 8'sh 0;
    weight[608] = 8'shc ;
    weight[609] = 8'sh03;
    weight[610] = 8'sh 1;
    weight[611] = 8'sh5 ;
    weight[612] = 8'shef;
    weight[613] = 8'sh f;
    weight[614] = 8'sh8 ;
    weight[615] = 8'shf4;
    weight[616] = 8'sh 1;
    weight[617] = 8'sh2 ;
    weight[618] = 8'shd4;
    weight[619] = 8'sh f;
    weight[620] = 8'shf ;
    weight[621] = 8'sh07;
    weight[622] = 8'sh 0;
    weight[623] = 8'sh5 ;
    weight[624] = 8'shf7;
    weight[625] = 8'sh 1;
    weight[626] = 8'sh4 ;
    weight[627] = 8'sh17;
    weight[628] = 8'sh 1;
    weight[629] = 8'sh9 ;
    weight[630] = 8'sh32;
    weight[631] = 8'sh 1;
    weight[632] = 8'sh2 ;
    weight[633] = 8'she9;
    weight[634] = 8'sh 0;
    weight[635] = 8'sh4 ;
    weight[636] = 8'sh00;
    weight[637] = 8'sh 1;
    weight[638] = 8'sh9 ;
    weight[639] = 8'shef;
    weight[640] = 8'sh 0;
    weight[641] = 8'sh4 ;
    weight[642] = 8'sh0b;
    weight[643] = 8'sh e;
    weight[644] = 8'shd ;
    weight[645] = 8'sh00;
    weight[646] = 8'sh e;
    weight[647] = 8'shc;
    weight[648] = 8'sh16;
    weight[649] = 8'sh 2;
    weight[650] = 8'sh8 ;
    weight[651] = 8'sh0e;
    weight[652] = 8'sh f;
    weight[653] = 8'shb ;
    weight[654] = 8'shf4;
    weight[655] = 8'sh e;
    weight[656] = 8'sh9 ;
    weight[657] = 8'sh0e;
    weight[658] = 8'sh 0;
    weight[659] = 8'shd ;
    weight[660] = 8'shd1;
    weight[661] = 8'sh c;
    weight[662] = 8'sh9 ;
    weight[663] = 8'shf8;
    weight[664] = 8'sh 0;
    weight[665] = 8'sh6 ;
    weight[666] = 8'sh15;
    weight[667] = 8'sh 2;
    weight[668] = 8'sh4 ;
    weight[669] = 8'shed;
    weight[670] = 8'sh 0;
    weight[671] = 8'sh2 ;
    weight[672] = 8'shf3;
    weight[673] = 8'sh 0;
    weight[674] = 8'sha ;
    weight[675] = 8'sh1c;
    weight[676] = 8'sh 0;
    weight[677] = 8'sh8 ;
    weight[678] = 8'shce;
    weight[679] = 8'sh 0;
    weight[680] = 8'sha ;
    weight[681] = 8'sh07;
    weight[682] = 8'sh 0;
    weight[683] = 8'shd ;
    weight[684] = 8'sh00;
    weight[685] = 8'sh 1;
    weight[686] = 8'shf ;
    weight[687] = 8'shfd;
    weight[688] = 8'sh c;
    weight[689] = 8'sha ;
    weight[690] = 8'shf2;
    weight[691] = 8'sh 1;
    weight[692] = 8'sh3 ;
    weight[693] = 8'she3;
    weight[694] = 8'sh b;
    weight[695] = 8'she ;
    weight[696] = 8'shc4;
    weight[697] = 8'sh e;
    weight[698] = 8'sh0 ;
    weight[699] = 8'sh09;
    weight[700] = 8'sh 0;
    weight[701] = 8'sh1 ;
    weight[702] = 8'sh01;
    weight[703] = 8'sh 1;
    weight[704] = 8'sh6 ;
    weight[705] = 8'sh1e;
    weight[706] = 8'sh f;
    weight[707] = 8'sha ;
    weight[708] = 8'sh0a;
    weight[709] = 8'sh 0;
    weight[710] = 8'shf ;
    weight[711] = 8'sh37;
    weight[712] = 8'sh f;
    weight[713] = 8'shc ;
    weight[714] = 8'sh03;
    weight[715] = 8'sh 0;
    weight[716] = 8'sh0 ;
    weight[717] = 8'shf1;
    weight[718] = 8'sh 0;
    weight[719] = 8'sh9;
end
initial begin
    bias[0] = 8'shf5;
    bias[1] = 8'sh1d;
    bias[2] = 8'sh09;
    bias[3] = 8'she0;
    bias[4] = 8'sh00;
    bias[5] = 8'shfb;
    bias[6] = 8'sh07;
    bias[7] = 8'sh05;
    bias[8] = 8'shf9;
    bias[9] = 8'shf4;
end

 assign data1 = (data_in_1[11] == 1) ? {2'b11, data_in_1} : {2'b00, data_in_1};
 assign data2 = (data_in_2[11] == 1) ? {2'b11, data_in_2} : {2'b00, data_in_2};
 assign data3 = (data_in_3[11] == 1) ? {2'b11, data_in_3} : {2'b00, data_in_3};
 
 always @(posedge clk) begin
   if(~rst_n) begin
     valid_out_fc <= 0;
     buf_idx <= 0;
     out_idx <= 0;
     state <= 0;
   end else begin  // IMPORTANT: Added else block

     if(valid_out_fc == 1) begin
       valid_out_fc <= 0;
     end

     if(valid_in == 1) begin
       // Wait until 48 input data filled in buffer
       if(!state) begin
         buffer[buf_idx] <= data1;
         buffer[INPUT_WIDTH + buf_idx] <= data2;
         buffer[INPUT_WIDTH * 2 + buf_idx] <= data3;
         buf_idx <= buf_idx + 1'b1;
         if(buf_idx == INPUT_WIDTH - 1) begin
           buf_idx <= 0;
           state <= 1;
           valid_out_fc <= 1;
         end
       end else begin // valid state
         out_idx <= out_idx + 1'b1;
         if(out_idx == OUTPUT_NUM - 1) begin
           out_idx <= 0;
         end
         valid_out_fc <= 1;
       end
     end
   end  // end of else block
 end

 assign calc_out = weight[out_idx * INPUT_NUM] * buffer[0] + weight[out_idx * INPUT_NUM + 1] * buffer[1] + 
		  		weight[out_idx * INPUT_NUM + 2] * buffer[2] + weight[out_idx * INPUT_NUM + 3] * buffer[3] + 
  				weight[out_idx * INPUT_NUM + 4] * buffer[4] + weight[out_idx * INPUT_NUM + 5] * buffer[5] + 
	  			weight[out_idx * INPUT_NUM + 6] * buffer[6] + weight[out_idx * INPUT_NUM + 7] * buffer[7] + 
		  		weight[out_idx * INPUT_NUM + 8] * buffer[8] + weight[out_idx * INPUT_NUM + 9] * buffer[9] + 
  				weight[out_idx * INPUT_NUM + 10] * buffer[10] + weight[out_idx * INPUT_NUM + 11] * buffer[11] + 
  				weight[out_idx * INPUT_NUM + 12] * buffer[12] + weight[out_idx * INPUT_NUM + 13] * buffer[13] + 
	  			weight[out_idx * INPUT_NUM + 14] * buffer[14] + weight[out_idx * INPUT_NUM + 15] * buffer[15] + 
  				weight[out_idx * INPUT_NUM + 16] * buffer[16] + weight[out_idx * INPUT_NUM + 17] * buffer[17] + 
  				weight[out_idx * INPUT_NUM + 18] * buffer[18] + weight[out_idx * INPUT_NUM + 19] * buffer[19] + 
  				weight[out_idx * INPUT_NUM + 20] * buffer[20] + weight[out_idx * INPUT_NUM + 21] * buffer[21] + 
  				weight[out_idx * INPUT_NUM + 22] * buffer[22] + weight[out_idx * INPUT_NUM + 23] * buffer[23] + 
  				weight[out_idx * INPUT_NUM + 24] * buffer[24] + weight[out_idx * INPUT_NUM + 25] * buffer[25] + 
  				weight[out_idx * INPUT_NUM + 26] * buffer[26] + weight[out_idx * INPUT_NUM + 27] * buffer[27] + 
  				weight[out_idx * INPUT_NUM + 28] * buffer[28] + weight[out_idx * INPUT_NUM + 29] * buffer[29] + 
  				weight[out_idx * INPUT_NUM + 30] * buffer[30] + weight[out_idx * INPUT_NUM + 31] * buffer[31] + 
  				weight[out_idx * INPUT_NUM + 32] * buffer[32] + weight[out_idx * INPUT_NUM + 33] * buffer[33] + 
  				weight[out_idx * INPUT_NUM + 34] * buffer[34] + weight[out_idx * INPUT_NUM + 35] * buffer[35] + 
  				weight[out_idx * INPUT_NUM + 36] * buffer[36] + weight[out_idx * INPUT_NUM + 37] * buffer[37] + 
  				weight[out_idx * INPUT_NUM + 38] * buffer[38] + weight[out_idx * INPUT_NUM + 39] * buffer[39] + 
	  			weight[out_idx * INPUT_NUM + 40] * buffer[40] + weight[out_idx * INPUT_NUM + 41] * buffer[41] + 
	  			weight[out_idx * INPUT_NUM + 42] * buffer[42] + weight[out_idx * INPUT_NUM + 43] * buffer[43] + 
	  			weight[out_idx * INPUT_NUM + 44] * buffer[44] + weight[out_idx * INPUT_NUM + 45] * buffer[45] + 
  				weight[out_idx * INPUT_NUM + 46] * buffer[46] + weight[out_idx * INPUT_NUM + 47] * buffer[47] + 
  				bias[out_idx];
 
 assign data_out = calc_out[18:7];

 endmodule