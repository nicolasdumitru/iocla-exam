
crackme:     file format elf32-i386


Disassembly of section .init:

00001000 <.init>:
    1000:	f3 0f 1e fb          	endbr32
    1004:	53                   	push   ebx
    1005:	83 ec 08             	sub    esp,0x8
    1008:	e8 c3 00 00 00       	call   10d0 <__cxa_finalize@plt+0x40>
    100d:	81 c3 bf 2f 00 00    	add    ebx,0x2fbf
    1013:	8b 83 28 00 00 00    	mov    eax,DWORD PTR [ebx+0x28]
    1019:	85 c0                	test   eax,eax
    101b:	74 02                	je     101f <strstr@plt-0x21>
    101d:	ff d0                	call   eax
    101f:	83 c4 08             	add    esp,0x8
    1022:	5b                   	pop    ebx
    1023:	c3                   	ret

Disassembly of section .plt:

00001030 <strstr@plt-0x10>:
    1030:	ff b3 04 00 00 00    	push   DWORD PTR [ebx+0x4]
    1036:	ff a3 08 00 00 00    	jmp    DWORD PTR [ebx+0x8]
    103c:	00 00                	add    BYTE PTR [eax],al
	...

00001040 <strstr@plt>:
    1040:	ff a3 0c 00 00 00    	jmp    DWORD PTR [ebx+0xc]
    1046:	68 00 00 00 00       	push   0x0
    104b:	e9 e0 ff ff ff       	jmp    1030 <strstr@plt-0x10>

00001050 <__libc_start_main@plt>:
    1050:	ff a3 10 00 00 00    	jmp    DWORD PTR [ebx+0x10]
    1056:	68 08 00 00 00       	push   0x8
    105b:	e9 d0 ff ff ff       	jmp    1030 <strstr@plt-0x10>

00001060 <time@plt>:
    1060:	ff a3 14 00 00 00    	jmp    DWORD PTR [ebx+0x14]
    1066:	68 10 00 00 00       	push   0x10
    106b:	e9 c0 ff ff ff       	jmp    1030 <strstr@plt-0x10>

00001070 <sleep@plt>:
    1070:	ff a3 18 00 00 00    	jmp    DWORD PTR [ebx+0x18]
    1076:	68 18 00 00 00       	push   0x18
    107b:	e9 b0 ff ff ff       	jmp    1030 <strstr@plt-0x10>

00001080 <puts@plt>:
    1080:	ff a3 1c 00 00 00    	jmp    DWORD PTR [ebx+0x1c]
    1086:	68 20 00 00 00       	push   0x20
    108b:	e9 a0 ff ff ff       	jmp    1030 <strstr@plt-0x10>

Disassembly of section .plt.got:

00001090 <__cxa_finalize@plt>:
    1090:	ff a3 24 00 00 00    	jmp    DWORD PTR [ebx+0x24]
    1096:	66 90                	xchg   ax,ax

Disassembly of section .text:

000010a0 <.text>:
    10a0:	f3 0f 1e fb          	endbr32
    10a4:	31 ed                	xor    ebp,ebp
    10a6:	5e                   	pop    esi
    10a7:	89 e1                	mov    ecx,esp
    10a9:	83 e4 f0             	and    esp,0xfffffff0
    10ac:	50                   	push   eax
    10ad:	54                   	push   esp
    10ae:	52                   	push   edx
    10af:	e8 18 00 00 00       	call   10cc <__cxa_finalize@plt+0x3c>
    10b4:	81 c3 18 2f 00 00    	add    ebx,0x2f18
    10ba:	6a 00                	push   0x0
    10bc:	6a 00                	push   0x0
    10be:	51                   	push   ecx
    10bf:	56                   	push   esi
    10c0:	ff b3 2c 00 00 00    	push   DWORD PTR [ebx+0x2c]
    10c6:	e8 85 ff ff ff       	call   1050 <__libc_start_main@plt>
    10cb:	f4                   	hlt
    10cc:	8b 1c 24             	mov    ebx,DWORD PTR [esp]
    10cf:	c3                   	ret
    10d0:	8b 1c 24             	mov    ebx,DWORD PTR [esp]
    10d3:	c3                   	ret
    10d4:	66 90                	xchg   ax,ax
    10d6:	66 90                	xchg   ax,ax
    10d8:	66 90                	xchg   ax,ax
    10da:	66 90                	xchg   ax,ax
    10dc:	66 90                	xchg   ax,ax
    10de:	66 90                	xchg   ax,ax
    10e0:	e8 e4 00 00 00       	call   11c9 <__cxa_finalize@plt+0x139>
    10e5:	81 c2 e7 2e 00 00    	add    edx,0x2ee7
    10eb:	8d 8a 3c 00 00 00    	lea    ecx,[edx+0x3c]
    10f1:	8d 82 3c 00 00 00    	lea    eax,[edx+0x3c]
    10f7:	39 c8                	cmp    eax,ecx
    10f9:	74 1d                	je     1118 <__cxa_finalize@plt+0x88>
    10fb:	8b 82 20 00 00 00    	mov    eax,DWORD PTR [edx+0x20]
    1101:	85 c0                	test   eax,eax
    1103:	74 13                	je     1118 <__cxa_finalize@plt+0x88>
    1105:	55                   	push   ebp
    1106:	89 e5                	mov    ebp,esp
    1108:	83 ec 14             	sub    esp,0x14
    110b:	51                   	push   ecx
    110c:	ff d0                	call   eax
    110e:	83 c4 10             	add    esp,0x10
    1111:	c9                   	leave
    1112:	c3                   	ret
    1113:	8d 74 26 00          	lea    esi,[esi+eiz*1+0x0]
    1117:	90                   	nop
    1118:	c3                   	ret
    1119:	8d b4 26 00 00 00 00 	lea    esi,[esi+eiz*1+0x0]
    1120:	e8 a4 00 00 00       	call   11c9 <__cxa_finalize@plt+0x139>
    1125:	81 c2 a7 2e 00 00    	add    edx,0x2ea7
    112b:	55                   	push   ebp
    112c:	89 e5                	mov    ebp,esp
    112e:	53                   	push   ebx
    112f:	8d 8a 3c 00 00 00    	lea    ecx,[edx+0x3c]
    1135:	8d 82 3c 00 00 00    	lea    eax,[edx+0x3c]
    113b:	83 ec 04             	sub    esp,0x4
    113e:	29 c8                	sub    eax,ecx
    1140:	89 c3                	mov    ebx,eax
    1142:	c1 e8 1f             	shr    eax,0x1f
    1145:	c1 fb 02             	sar    ebx,0x2
    1148:	01 d8                	add    eax,ebx
    114a:	d1 f8                	sar    eax,1
    114c:	74 14                	je     1162 <__cxa_finalize@plt+0xd2>
    114e:	8b 92 30 00 00 00    	mov    edx,DWORD PTR [edx+0x30]
    1154:	85 d2                	test   edx,edx
    1156:	74 0a                	je     1162 <__cxa_finalize@plt+0xd2>
    1158:	83 ec 08             	sub    esp,0x8
    115b:	50                   	push   eax
    115c:	51                   	push   ecx
    115d:	ff d2                	call   edx
    115f:	83 c4 10             	add    esp,0x10
    1162:	8b 5d fc             	mov    ebx,DWORD PTR [ebp-0x4]
    1165:	c9                   	leave
    1166:	c3                   	ret
    1167:	8d b4 26 00 00 00 00 	lea    esi,[esi+eiz*1+0x0]
    116e:	66 90                	xchg   ax,ax
    1170:	f3 0f 1e fb          	endbr32
    1174:	55                   	push   ebp
    1175:	89 e5                	mov    ebp,esp
    1177:	53                   	push   ebx
    1178:	e8 53 ff ff ff       	call   10d0 <__cxa_finalize@plt+0x40>
    117d:	81 c3 4f 2e 00 00    	add    ebx,0x2e4f
    1183:	83 ec 04             	sub    esp,0x4
    1186:	80 bb 3c 00 00 00 00 	cmp    BYTE PTR [ebx+0x3c],0x0
    118d:	75 27                	jne    11b6 <__cxa_finalize@plt+0x126>
    118f:	8b 83 24 00 00 00    	mov    eax,DWORD PTR [ebx+0x24]
    1195:	85 c0                	test   eax,eax
    1197:	74 11                	je     11aa <__cxa_finalize@plt+0x11a>
    1199:	83 ec 0c             	sub    esp,0xc
    119c:	ff b3 38 00 00 00    	push   DWORD PTR [ebx+0x38]
    11a2:	e8 e9 fe ff ff       	call   1090 <__cxa_finalize@plt>
    11a7:	83 c4 10             	add    esp,0x10
    11aa:	e8 31 ff ff ff       	call   10e0 <__cxa_finalize@plt+0x50>
    11af:	c6 83 3c 00 00 00 01 	mov    BYTE PTR [ebx+0x3c],0x1
    11b6:	8b 5d fc             	mov    ebx,DWORD PTR [ebp-0x4]
    11b9:	c9                   	leave
    11ba:	c3                   	ret
    11bb:	8d 74 26 00          	lea    esi,[esi+eiz*1+0x0]
    11bf:	90                   	nop
    11c0:	f3 0f 1e fb          	endbr32
    11c4:	e9 57 ff ff ff       	jmp    1120 <__cxa_finalize@plt+0x90>
    11c9:	8b 14 24             	mov    edx,DWORD PTR [esp]
    11cc:	c3                   	ret
    11cd:	8d 4c 24 04          	lea    ecx,[esp+0x4]
    11d1:	83 e4 f0             	and    esp,0xfffffff0
    11d4:	ff 71 fc             	push   DWORD PTR [ecx-0x4]
    11d7:	55                   	push   ebp
    11d8:	89 e5                	mov    ebp,esp
    11da:	56                   	push   esi
    11db:	53                   	push   ebx
    11dc:	51                   	push   ecx
    11dd:	83 ec 1c             	sub    esp,0x1c
    11e0:	e8 eb fe ff ff       	call   10d0 <__cxa_finalize@plt+0x40>
    11e5:	81 c3 e7 2d 00 00    	add    ebx,0x2de7
    11eb:	89 ce                	mov    esi,ecx
    11ed:	c7 45 d8 03 00 00 00 	mov    DWORD PTR [ebp-0x28],0x3
    11f4:	8b 46 04             	mov    eax,DWORD PTR [esi+0x4]
    11f7:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
    11fa:	89 45 dc             	mov    DWORD PTR [ebp-0x24],eax
    11fd:	eb 08                	jmp    1207 <__cxa_finalize@plt+0x177>
    11ff:	83 6d d8 01          	sub    DWORD PTR [ebp-0x28],0x1
    1203:	83 45 dc 02          	add    DWORD PTR [ebp-0x24],0x2
    1207:	83 3e 02             	cmp    DWORD PTR [esi],0x2
    120a:	75 1e                	jne    122a <__cxa_finalize@plt+0x19a>
    120c:	83 ec 08             	sub    esp,0x8
    120f:	8d 83 3c e0 ff ff    	lea    eax,[ebx-0x1fc4]
    1215:	50                   	push   eax
    1216:	ff 75 dc             	push   DWORD PTR [ebp-0x24]
    1219:	e8 22 fe ff ff       	call   1040 <strstr@plt>
    121e:	83 c4 10             	add    esp,0x10
    1221:	89 45 dc             	mov    DWORD PTR [ebp-0x24],eax
    1224:	83 7d dc 00          	cmp    DWORD PTR [ebp-0x24],0x0
    1228:	75 d5                	jne    11ff <__cxa_finalize@plt+0x16f>
    122a:	8b 45 d8             	mov    eax,DWORD PTR [ebp-0x28]
    122d:	89 c2                	mov    edx,eax
    122f:	f7 da                	neg    edx
    1231:	0f 49 c2             	cmovns eax,edx
    1234:	89 45 d8             	mov    DWORD PTR [ebp-0x28],eax
    1237:	83 ec 0c             	sub    esp,0xc
    123a:	8d 83 3f e0 ff ff    	lea    eax,[ebx-0x1fc1]
    1240:	50                   	push   eax
    1241:	e8 3a fe ff ff       	call   1080 <puts@plt>
    1246:	83 c4 10             	add    esp,0x10
    1249:	83 ec 0c             	sub    esp,0xc
    124c:	6a 00                	push   0x0
    124e:	e8 0d fe ff ff       	call   1060 <time@plt>
    1253:	83 c4 10             	add    esp,0x10
    1256:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax
    1259:	8b 45 d8             	mov    eax,DWORD PTR [ebp-0x28]
    125c:	83 ec 0c             	sub    esp,0xc
    125f:	50                   	push   eax
    1260:	e8 0b fe ff ff       	call   1070 <sleep@plt>
    1265:	83 c4 10             	add    esp,0x10
    1268:	83 ec 0c             	sub    esp,0xc
    126b:	6a 00                	push   0x0
    126d:	e8 ee fd ff ff       	call   1060 <time@plt>
    1272:	83 c4 10             	add    esp,0x10
    1275:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax
    1278:	8b 45 e0             	mov    eax,DWORD PTR [ebp-0x20]
    127b:	3b 45 e4             	cmp    eax,DWORD PTR [ebp-0x1c]
    127e:	74 19                	je     1299 <__cxa_finalize@plt+0x209>
    1280:	83 ec 0c             	sub    esp,0xc
    1283:	8d 83 58 e0 ff ff    	lea    eax,[ebx-0x1fa8]
    1289:	50                   	push   eax
    128a:	e8 f1 fd ff ff       	call   1080 <puts@plt>
    128f:	83 c4 10             	add    esp,0x10
    1292:	b8 01 00 00 00       	mov    eax,0x1
    1297:	eb 17                	jmp    12b0 <__cxa_finalize@plt+0x220>
    1299:	83 ec 0c             	sub    esp,0xc
    129c:	8d 83 7a e0 ff ff    	lea    eax,[ebx-0x1f86]
    12a2:	50                   	push   eax
    12a3:	e8 d8 fd ff ff       	call   1080 <puts@plt>
    12a8:	83 c4 10             	add    esp,0x10
    12ab:	b8 00 00 00 00       	mov    eax,0x0
    12b0:	8d 65 f4             	lea    esp,[ebp-0xc]
    12b3:	59                   	pop    ecx
    12b4:	5b                   	pop    ebx
    12b5:	5e                   	pop    esi
    12b6:	5d                   	pop    ebp
    12b7:	8d 61 fc             	lea    esp,[ecx-0x4]
    12ba:	c3                   	ret

Disassembly of section .fini:

000012bc <.fini>:
    12bc:	f3 0f 1e fb          	endbr32
    12c0:	53                   	push   ebx
    12c1:	83 ec 08             	sub    esp,0x8
    12c4:	e8 07 fe ff ff       	call   10d0 <__cxa_finalize@plt+0x40>
    12c9:	81 c3 03 2d 00 00    	add    ebx,0x2d03
    12cf:	83 c4 08             	add    esp,0x8
    12d2:	5b                   	pop    ebx
    12d3:	c3                   	ret
