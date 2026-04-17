
/* WARNING: Function: __x86.get_pc_thunk.ax replaced with injection: get_pc_thunk_ax */
/* WARNING: Removing unreachable block (ram,0x00010054) */

void g(undefined4 *param_1)

{
  uRam00010022 = *param_1;
                    /* WARNING: Read-only address (ram,0x00010022) is written */
  uRam00010026 = *(undefined2 *)(param_1 + 1);
                    /* WARNING: Read-only address (ram,0x00010026) is written */
  uRam00010028 = *(undefined1 *)((int)param_1 + 6);
                    /* WARNING: Read-only address (ram,0x00010028) is written */
  puts("");
                    /* WARNING: Read-only address (ram,0x00010022) is written */
                    /* WARNING: Read-only address (ram,0x00010026) is written */
                    /* WARNING: Read-only address (ram,0x00010028) is written */
  return;
}

           //
           // .text
           // SHT_PROGBITS  [0x0 -
           // ram:00010000-ram:000
           //
           ************************
           *       FUNCTION       *
           ************************
           undefined4 __cdecl f(v
     undef  EAX:4 <RETURN>
           f                  XREF Entry Point(
                                   000100dc(*), 
                                   _elfSectionH
                                   _elfSectionH
  0000 55    PUS EBP
  0001 89    MOV EBP,ESP
       e5
  0003 e8    CAL __x86.get_pc_thunk undefined4 _
       b0 
       00 
           LAB_00010008+1     XREF 0001000d(*)  
  0008 05    ADD EAX,0x1
       01 
       00 
  000d 8d    LEA EAX,[EAX]=>LAB_000
       80 
       00 
  0013 5d    POP EBP
  0014 c3    RET
           ************************
           *       FUNCTION       *
           ************************
           undefined __cdecl g(un
     undef  <UNAS <RETURN>
     undef  Stack param_1         XREF 000100
     undef  Stack local_8         XREF 000100
           g                  XREF Entry Point(
                                   000100fc(*)  
  0015 55    PUS EBP
  0016 89    MOV EBP,ESP
       e5
  0018 53    PUS EBX
  0019 83    SUB ESP,0x4
       ec 
       04
  001c e8    CAL __x86.get_pc_thunk undefined4 _
       97 
       00 
           LAB_00010021+1     XREF 0001002b(W), 
                                   00010046(R)  
  0021 05    ADD EAX,0x1
       01 
       00 
           LAB_00010026+2     XREF 00010035(W), 
           LAB_00010026            00010040(W)  
  0026 8b    MOV EDX,dword ptr [EBP
       55 
       08
  0029 8b    MOV ECX,dword ptr [EDX
       0a
  002b 89    MOV dword ptr [EAX]=>L
       88 
       00 
  0031 0f    MOV ECX,word ptr [EDX 
       b7 
       4a 
           LAB_00010035+4     XREF 00010057(*)  
  0035 66    MOV word ptr [EAX + 0x
       89 
       88 
  003c 0f    MOV EDX,byte ptr [EDX 
       b6 
       52 
           LAB_00010040+4     XREF 0001006d(*)  
  0040 88    MOV byte ptr [EAX + 0x
       90 
       06 
  0046 8b    MOV EDX,dword ptr [EAX
       90 
       00 
  004c 81    CMP EDX,0x57696e73
       fa 
       73 
  0052 75    JNZ LAB_0001006a
       16
  0054 83    SUB ESP,0xc
       ec 
       0c
  0057 8d    LEA EDX,[EAX + 0x17]=>
       90 
       17 
  005d 52    PUS EDX
  005e 89    MOV EBX,EAX
       c3
  0060 e8    CAL <EXTERNAL>::puts   int puts(cha
       9b 
       0f 
  0065 83    ADD ESP,0x10
       c4 
       10
  0068 eb    JMP LAB_0001007e
       14
           LAB_0001006a       XREF 00010052(j)  
  006a 83    SUB ESP,0xc
       ec 
       0c
  006d 8d    LEA EDX,[EAX + 0x22]=>
       90 
       22 
  0073 52    PUS EDX
  0074 89    MOV EBX,EAX
       c3
  0076 e8    CAL <EXTERNAL>::puts   int puts(cha
       85 
       0f 
  007b 83    ADD ESP,0x10
       c4 
       10
           LAB_0001007e       XREF 00010068(j)  
  007e 90    NOP
  007f 8b    MOV EBX,dword ptr [EBP
       5d 
       fc
  0082 c9    LEA
  0083 c3    RET
           //
           // .bss
           // SHT_NOBITS  [0x84 - 
           // ram:00010084-ram:000
           //
           student            XREF Entry Point(
                                   _elfSectionH
  0084       und ??
           //
           // .rodata
           // SHT_PROGBITS  [0x8b 
           // ram:0001008b-ram:000
           //
           s_You_gave_2_ints, XREF _elfSectionH
  008b 59    ds  "You gave 2 ints, 
       6f 
       75 
  00a2 59    ds  "You dog..."
       6f 
       75 
  00ad 54    ds  "Try again!"
       72 
       79 
           //
           // .text.__x86.get_pc_t
           // SHT_PROGBITS  [0xb8 
           // ram:000100b8-ram:000
           //
           ************************
           *       FUNCTION       *
           ************************
           undefined4 __cdecl __x
            Call-Fixup: get_
     undef  EAX:4 <RETURN>
     undef  Stack local_res0      XREF 000100
           __i686.get_pc_thun XREF Entry Point(
           __x86.get_pc_thunk      f:00010003(c
                                   g:0001001c(c
                                   00010120(*), 
                                   _elfSectionH
  00b8 8b    MOV EAX,dword ptr [ESP
       04 
       24
  00bb c3    RET
           //
           // .eh_frame
           // SHT_PROGBITS  [0xbc 
           // ram:000100bc-ram:000
           //
           ************************
           * Common Informatio... *
           ************************
           cie_000100bc       XREF 000100d8(*), 
                                   000100f8(*), 
                                   0001011c(*), 
                                   _elfSectionH
  00bc 14    ddw 14h                (CIE) Length
       00 
       00 
  00c0 00    ddw 0h                 (CIE) ID
       00 
       00 
  00c4 01    db  1h                 (CIE) Version
  00c5 7a    ds  "zR"               (CIE) Augmen
       52 
       00
  00c8 01    ule 1h                 (CIE) Code A
  00c9 7c    sle -4h                (CIE) Data A
  00ca 08    db  8h                 (CIE) Return
  00cb 01    ule 1h                 (CIE) Augmen
  00cc 1b    dwf DW_EH_PE_sdata4 |  (CIE Augment
  00cd 0c    db[                    (CIE) Initia
       04 
       04 
           ************************
           * Frame Descriptor ... *
           ************************
           fde_000100d4
  00d4 1c    ddw 1Ch                (FDE) Length
       00 
       00 
  00d8 1c    ddw cie_000100bc       (FDE) CIE Re
       00 
       00 
  00dc 24    ddw f                  (FDE) PcBegin
       ff 
       ff 
  00e0 15    ddw 15h                (FDE) PcRange
       00 
       00 
  00e4 00    ule 0h                 (FDE) Augmen
  00e5 41    db[                    (FDE) Call F
       0e 
       08 
           ************************
           * Frame Descriptor ... *
           ************************
           fde_000100f4
  00f4 20    ddw 20h                (FDE) Length
       00 
       00 
  00f8 3c    ddw cie_000100bc       (FDE) CIE Re
       00 
       00 
  00fc 19    ddw g                  (FDE) PcBegin
       ff 
       ff 
  0100 6f    ddw 6Fh                (FDE) PcRange
       00 
       00 
  0104 00    ule 0h                 (FDE) Augmen
  0105 41    db[                    (FDE) Call F
       0e 
       08 
           ************************
           * Frame Descriptor ... *
           ************************
           fde_00010118
  0118 10    ddw 10h                (FDE) Length
       00 
       00 
  011c 60    ddw cie_000100bc       (FDE) CIE Re
       00 
       00 
  0120 98    ddw __x86.get_pc_thunk (FDE) PcBegin
       ff 
       ff 
  0124 04    ddw 4h                 (FDE) PcRange
       00 
       00 
  0128 00    ule 0h                 (FDE) Augmen
  0129 00    db[                    (FDE) Call F
       00 
       00
           //
           // EXTERNAL
           // NOTE: This block is 
           // ram:00011000-ram:000
           //
           ************************
           *    THUNK FUNCTION    *
           ************************
           thunk int puts(char * 
            Thunked-Function
     int    EAX:4 <RETURN>
     char * Stack __s
           <EXTERNAL>::puts   XREF g:00010060(c
                                   g:00010076(c
  1000       ??  ??
  1001       ??  ??
  1002       ??  ??
  1003       ??  ??
           //
           // .comment
           // SHT_PROGBITS [not-lo
           // .comment::00000000-.
           //
     assume DF = <UNK
           ElfComment[0]      XREF _elfSectionH
  0000 00    utf u8""
           ElfComment[1]
  0001 47    utf u8"GCC: (Ubuntu 11
       43 
       43 
           //
           // .group
           // SHT_GROUP [not-loade
           // .group::00000000-.gr
           //
           DAT_.group__000000 XREF _elfSectionH
  0000 01    ??  01h                ?  ->  .grou
  0001 00    ??  00h
  0002 00    ??  00h
  0003 00    ??  00h
  0004 07    ??  07h                ?  ->  .grou
  0005 00    ??  00h
  0006 00    ??  00h
  0007 00    ??  00h
           //
           // .rel.eh_frame
           // SHT_REL [not-loaded]
           // .rel.eh_frame::00000
           //
           Elf32_Rel_ARRAY_.r XREF _elfSectionH
  0000 20    Elf                    location to 
       00 
       00 
           //
           // .rel.text
           // SHT_REL [not-loaded]
           // .rel.text::00000000-
           //
           Elf32_Rel_ARRAY_.r XREF _elfSectionH
  0000 04    Elf                    location to 
       00 
       00 
           //
           // .shstrtab
           // SHT_STRTAB [not-load
           // .shstrtab::00000000-
           //
           DAT_.shstrtab__000 XREF _elfSectionH
  0000 00    ??  00h
  0001 2e    utf u8".symtab"
       73 
       79 
  0009 2e    utf u8".strtab"
       73 
       74 
  0011 2e    utf u8".shstrtab"
       73 
       68 
  001b 2e    utf u8".rel.text"
       72 
       65 
  0025 2e    utf u8".data"
       64 
       61 
  002b 2e    utf u8".bss"
       62 
       73 
  0030 2e    utf u8".rodata"
       72 
       6f 
  0038 2e    utf u8".text.__x86.get
       74 
       65 
  0054 2e    utf u8".comment"
       63 
       6f 
  005d 2e    utf u8".note.GNU-stack
       6e 
       6f 
  006d 2e    utf u8".rel.eh_frame"
       72 
       65 
  007b 2e    utf u8".group"
       67 
       72 
           //
           // .strtab
           // SHT_STRTAB [not-load
           // .strtab::00000000-.s
           //
           DAT_.strtab__00000 XREF _elfSectionH
  0000 00    ??  00h
  0001 75    utf u8"utils.c"
       74 
       69 
  0009 73    utf u8"student"
       74 
       75 
  0011 66    utf u8"f"
       00
  0013 5f    utf u8"__x86.get_pc_th
       5f 
       78 
  0029 5f    utf u8"_GLOBAL_OFFSET_
       47 
       4c 
  003f 67    utf u8"g"
       00
  0041 70    utf u8"puts"
       75 
       74 
           //
           // .symtab
           // SHT_SYMTAB [not-load
           // .symtab::00000000-.s
           //
           Elf32_Sym_ARRAY_.s XREF _elfSectionH
  0000 00    Elf
       00 
       00 
           //
           // _elfHeader
           // Elf File Header
           // _elfHeader::00000000
           //
  0000 7f    Elf
       45 
       4c 
           //
           // _elfSectionHeaders
           // Elf Section Headers
           // _elfSectionHeaders::
           //
           Elf32_Shdr_ARRAY__ XREF _elfHeader::
  0000 00    Elf                    SECTION0 - S
       00 
       00 
