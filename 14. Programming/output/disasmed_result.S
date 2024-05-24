
output/result.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00005197          	auipc	gp,0x5
   4:	80018193          	add	gp,gp,-2048 # 4800 <_gbl_ptr>
   8:	00007117          	auipc	sp,0x7
   c:	5f810113          	add	sp,sp,1528 # 7600 <_stack_ptr>
  10:	00004297          	auipc	t0,0x4
  14:	ff028293          	add	t0,t0,-16 # 4000 <scan_code_is_unread>
  18:	00004317          	auipc	t1,0x4
  1c:	fe830313          	add	t1,t1,-24 # 4000 <scan_code_is_unread>

00000020 <_bss_init_loop>:
  20:	00534863          	blt	t1,t0,30 <_irq_config>
  24:	0002a023          	sw	zero,0(t0)
  28:	00428293          	add	t0,t0,4
  2c:	ff5ff06f          	j	20 <_bss_init_loop>

00000030 <_irq_config>:
  30:	05c00293          	li	t0,92
  34:	fff00313          	li	t1,-1
  38:	00008397          	auipc	t2,0x8
  3c:	fc838393          	add	t2,t2,-56 # 8000 <_data_end>
  40:	30529073          	csrw	mtvec,t0
  44:	30431073          	csrw	mie,t1
  48:	34039073          	csrw	mscratch,t2

0000004c <_main_call>:
  4c:	00000513          	li	a0,0
  50:	00000593          	li	a1,0
  54:	0d4000ef          	jal	128 <main>

00000058 <_endless_loop>:
  58:	0000006f          	j	58 <_endless_loop>

0000005c <_int_handler>:
  5c:	34011173          	csrrw	sp,mscratch,sp
  60:	fb010113          	add	sp,sp,-80
  64:	00112223          	sw	ra,4(sp)
  68:	00007097          	auipc	ra,0x7
  6c:	59808093          	add	ra,ra,1432 # 7600 <_stack_ptr>
  70:	fe1144e3          	blt	sp,ra,58 <_endless_loop>
  74:	00512623          	sw	t0,12(sp)
  78:	00612823          	sw	t1,16(sp)
  7c:	00712a23          	sw	t2,20(sp)
  80:	00a12c23          	sw	a0,24(sp)
  84:	00b12e23          	sw	a1,28(sp)
  88:	02c12023          	sw	a2,32(sp)
  8c:	02d12223          	sw	a3,36(sp)
  90:	02e12423          	sw	a4,40(sp)
  94:	02f12623          	sw	a5,44(sp)
  98:	03012823          	sw	a6,48(sp)
  9c:	03112a23          	sw	a7,52(sp)
  a0:	03c12c23          	sw	t3,56(sp)
  a4:	03d12e23          	sw	t4,60(sp)
  a8:	05e12023          	sw	t5,64(sp)
  ac:	05f12223          	sw	t6,68(sp)
  b0:	340022f3          	csrr	t0,mscratch
  b4:	34102373          	csrr	t1,mepc
  b8:	34202573          	csrr	a0,mcause
  bc:	00512423          	sw	t0,8(sp)
  c0:	04612423          	sw	t1,72(sp)
  c4:	04a12623          	sw	a0,76(sp)
  c8:	7dc000ef          	jal	8a4 <int_handler>
  cc:	00010513          	mv	a0,sp
  d0:	04852303          	lw	t1,72(a0)
  d4:	05010113          	add	sp,sp,80
  d8:	34011073          	csrw	mscratch,sp
  dc:	34131073          	csrw	mepc,t1
  e0:	00452083          	lw	ra,4(a0)
  e4:	00852103          	lw	sp,8(a0)
  e8:	00c52283          	lw	t0,12(a0)
  ec:	01052303          	lw	t1,16(a0)
  f0:	01452383          	lw	t2,20(a0)
  f4:	01c52583          	lw	a1,28(a0)
  f8:	02052603          	lw	a2,32(a0)
  fc:	02452683          	lw	a3,36(a0)
 100:	02852703          	lw	a4,40(a0)
 104:	02c52783          	lw	a5,44(a0)
 108:	03052803          	lw	a6,48(a0)
 10c:	03452883          	lw	a7,52(a0)
 110:	03852e03          	lw	t3,56(a0)
 114:	03c52e83          	lw	t4,60(a0)
 118:	04052f03          	lw	t5,64(a0)
 11c:	04452f83          	lw	t6,68(a0)
 120:	02852503          	lw	a0,40(a0)
 124:	30200073          	mret

00000128 <main>:
 128:	fc010113          	add	sp,sp,-64
 12c:	02112e23          	sw	ra,60(sp)
 130:	02812c23          	sw	s0,56(sp)
 134:	04010413          	add	s0,sp,64
 138:	fca42623          	sw	a0,-52(s0)
 13c:	fcb42423          	sw	a1,-56(s0)
 140:	fe042023          	sw	zero,-32(s0)
 144:	fc042e23          	sw	zero,-36(s0)
 148:	fe042623          	sw	zero,-20(s0)
 14c:	fe042423          	sw	zero,-24(s0)
 150:	fe042223          	sw	zero,-28(s0)
 154:	6ec000ef          	jal	840 <clear>
 158:	fdc40713          	add	a4,s0,-36
 15c:	fe040793          	add	a5,s0,-32
 160:	00070593          	mv	a1,a4
 164:	00078513          	mv	a0,a5
 168:	3d8000ef          	jal	540 <draw_hello>
 16c:	fe042783          	lw	a5,-32(s0)
 170:	00178793          	add	a5,a5,1
 174:	fef42023          	sw	a5,-32(s0)
 178:	fc042e23          	sw	zero,-36(s0)
 17c:	fdc40713          	add	a4,s0,-36
 180:	fe040793          	add	a5,s0,-32
 184:	00070593          	mv	a1,a4
 188:	00078513          	mv	a0,a5
 18c:	430000ef          	jal	5bc <draw_swi>
 190:	fdc40713          	add	a4,s0,-36
 194:	fe040793          	add	a5,s0,-32
 198:	00070593          	mv	a1,a4
 19c:	00078513          	mv	a0,a5
 1a0:	124000ef          	jal	2c4 <get_number>
 1a4:	fea42623          	sw	a0,-20(s0)
 1a8:	fe042783          	lw	a5,-32(s0)
 1ac:	00178793          	add	a5,a5,1
 1b0:	fef42023          	sw	a5,-32(s0)
 1b4:	fc042e23          	sw	zero,-36(s0)
 1b8:	fdc40713          	add	a4,s0,-36
 1bc:	fe040793          	add	a5,s0,-32
 1c0:	00070593          	mv	a1,a4
 1c4:	00078513          	mv	a0,a5
 1c8:	480000ef          	jal	648 <draw_a>
 1cc:	fdc40713          	add	a4,s0,-36
 1d0:	fe040793          	add	a5,s0,-32
 1d4:	00070593          	mv	a1,a4
 1d8:	00078513          	mv	a0,a5
 1dc:	0e8000ef          	jal	2c4 <get_number>
 1e0:	fea42423          	sw	a0,-24(s0)
 1e4:	fe042783          	lw	a5,-32(s0)
 1e8:	00178793          	add	a5,a5,1
 1ec:	fef42023          	sw	a5,-32(s0)
 1f0:	fc042e23          	sw	zero,-36(s0)
 1f4:	fdc40713          	add	a4,s0,-36
 1f8:	fe040793          	add	a5,s0,-32
 1fc:	00070593          	mv	a1,a4
 200:	00078513          	mv	a0,a5
 204:	4a0000ef          	jal	6a4 <draw_result>
 208:	fe842583          	lw	a1,-24(s0)
 20c:	fec42503          	lw	a0,-20(s0)
 210:	294000ef          	jal	4a4 <count_ocur>
 214:	fea42223          	sw	a0,-28(s0)
 218:	fe442783          	lw	a5,-28(s0)
 21c:	0ff7f793          	zext.b	a5,a5
 220:	03078793          	add	a5,a5,48
 224:	0ff7f693          	zext.b	a3,a5
 228:	fdc40713          	add	a4,s0,-36
 22c:	fe040793          	add	a5,s0,-32
 230:	00068613          	mv	a2,a3
 234:	00070593          	mv	a1,a4
 238:	00078513          	mv	a0,a5
 23c:	514000ef          	jal	750 <draw>
 240:	fe042783          	lw	a5,-32(s0)
 244:	00178793          	add	a5,a5,1
 248:	fef42023          	sw	a5,-32(s0)
 24c:	fc042e23          	sw	zero,-36(s0)
 250:	f2dff06f          	j	17c <main+0x54>

00000254 <get_scan_code>:
 254:	fe010113          	add	sp,sp,-32
 258:	00812e23          	sw	s0,28(sp)
 25c:	02010413          	add	s0,sp,32
 260:	fe042623          	sw	zero,-20(s0)
 264:	0100006f          	j	274 <get_scan_code+0x20>
 268:	fec42783          	lw	a5,-20(s0)
 26c:	00178793          	add	a5,a5,1
 270:	fef42623          	sw	a5,-20(s0)
 274:	000047b7          	lui	a5,0x4
 278:	0007a783          	lw	a5,0(a5) # 4000 <scan_code_is_unread>
 27c:	00079a63          	bnez	a5,290 <get_scan_code+0x3c>
 280:	fec42703          	lw	a4,-20(s0)
 284:	000027b7          	lui	a5,0x2
 288:	70f78793          	add	a5,a5,1807 # 270f <_text_size+0x170f>
 28c:	fce7fee3          	bgeu	a5,a4,268 <get_scan_code+0x14>
 290:	000047b7          	lui	a5,0x4
 294:	0007a783          	lw	a5,0(a5) # 4000 <scan_code_is_unread>
 298:	00078c63          	beqz	a5,2b0 <get_scan_code+0x5c>
 29c:	000047b7          	lui	a5,0x4
 2a0:	0007a023          	sw	zero,0(a5) # 4000 <scan_code_is_unread>
 2a4:	030007b7          	lui	a5,0x3000
 2a8:	0007a783          	lw	a5,0(a5) # 3000000 <_data_end+0x2ff8000>
 2ac:	0080006f          	j	2b4 <get_scan_code+0x60>
 2b0:	00000793          	li	a5,0
 2b4:	00078513          	mv	a0,a5
 2b8:	01c12403          	lw	s0,28(sp)
 2bc:	02010113          	add	sp,sp,32
 2c0:	00008067          	ret

000002c4 <get_number>:
 2c4:	fd010113          	add	sp,sp,-48
 2c8:	02112623          	sw	ra,44(sp)
 2cc:	02812423          	sw	s0,40(sp)
 2d0:	03010413          	add	s0,sp,48
 2d4:	fca42e23          	sw	a0,-36(s0)
 2d8:	fcb42c23          	sw	a1,-40(s0)
 2dc:	fe042623          	sw	zero,-20(s0)
 2e0:	fe042023          	sw	zero,-32(s0)
 2e4:	fe042423          	sw	zero,-24(s0)
 2e8:	f6dff0ef          	jal	254 <get_scan_code>
 2ec:	fea42223          	sw	a0,-28(s0)
 2f0:	0880006f          	j	378 <get_number+0xb4>
 2f4:	fe442503          	lw	a0,-28(s0)
 2f8:	0c0000ef          	jal	3b8 <ascii_code>
 2fc:	fea42023          	sw	a0,-32(s0)
 300:	fe042703          	lw	a4,-32(s0)
 304:	00a00793          	li	a5,10
 308:	06f70463          	beq	a4,a5,370 <get_number+0xac>
 30c:	fe842703          	lw	a4,-24(s0)
 310:	00100793          	li	a5,1
 314:	00f71663          	bne	a4,a5,320 <get_number+0x5c>
 318:	fe042423          	sw	zero,-24(s0)
 31c:	0540006f          	j	370 <get_number+0xac>
 320:	fe842783          	lw	a5,-24(s0)
 324:	00178793          	add	a5,a5,1
 328:	fef42423          	sw	a5,-24(s0)
 32c:	fe042783          	lw	a5,-32(s0)
 330:	0ff7f793          	zext.b	a5,a5
 334:	03078793          	add	a5,a5,48
 338:	0ff7f793          	zext.b	a5,a5
 33c:	00078613          	mv	a2,a5
 340:	fd842583          	lw	a1,-40(s0)
 344:	fdc42503          	lw	a0,-36(s0)
 348:	408000ef          	jal	750 <draw>
 34c:	fec42703          	lw	a4,-20(s0)
 350:	00070793          	mv	a5,a4
 354:	00279793          	sll	a5,a5,0x2
 358:	00e787b3          	add	a5,a5,a4
 35c:	00179793          	sll	a5,a5,0x1
 360:	00078713          	mv	a4,a5
 364:	fe042783          	lw	a5,-32(s0)
 368:	00e787b3          	add	a5,a5,a4
 36c:	fef42623          	sw	a5,-20(s0)
 370:	ee5ff0ef          	jal	254 <get_scan_code>
 374:	fea42223          	sw	a0,-28(s0)
 378:	fe442703          	lw	a4,-28(s0)
 37c:	05a00793          	li	a5,90
 380:	f6f71ae3          	bne	a4,a5,2f4 <get_number+0x30>
 384:	fe042223          	sw	zero,-28(s0)
 388:	00c0006f          	j	394 <get_number+0xd0>
 38c:	ec9ff0ef          	jal	254 <get_scan_code>
 390:	fea42223          	sw	a0,-28(s0)
 394:	fe442703          	lw	a4,-28(s0)
 398:	05a00793          	li	a5,90
 39c:	fef718e3          	bne	a4,a5,38c <get_number+0xc8>
 3a0:	fec42783          	lw	a5,-20(s0)
 3a4:	00078513          	mv	a0,a5
 3a8:	02c12083          	lw	ra,44(sp)
 3ac:	02812403          	lw	s0,40(sp)
 3b0:	03010113          	add	sp,sp,48
 3b4:	00008067          	ret

000003b8 <ascii_code>:
 3b8:	fe010113          	add	sp,sp,-32
 3bc:	00812e23          	sw	s0,28(sp)
 3c0:	02010413          	add	s0,sp,32
 3c4:	fea42623          	sw	a0,-20(s0)
 3c8:	fec42703          	lw	a4,-20(s0)
 3cc:	07000793          	li	a5,112
 3d0:	00f71663          	bne	a4,a5,3dc <ascii_code+0x24>
 3d4:	00000793          	li	a5,0
 3d8:	0bc0006f          	j	494 <ascii_code+0xdc>
 3dc:	fec42703          	lw	a4,-20(s0)
 3e0:	06900793          	li	a5,105
 3e4:	00f71663          	bne	a4,a5,3f0 <ascii_code+0x38>
 3e8:	00100793          	li	a5,1
 3ec:	0a80006f          	j	494 <ascii_code+0xdc>
 3f0:	fec42703          	lw	a4,-20(s0)
 3f4:	07200793          	li	a5,114
 3f8:	00f71663          	bne	a4,a5,404 <ascii_code+0x4c>
 3fc:	00200793          	li	a5,2
 400:	0940006f          	j	494 <ascii_code+0xdc>
 404:	fec42703          	lw	a4,-20(s0)
 408:	07a00793          	li	a5,122
 40c:	00f71663          	bne	a4,a5,418 <ascii_code+0x60>
 410:	00300793          	li	a5,3
 414:	0800006f          	j	494 <ascii_code+0xdc>
 418:	fec42703          	lw	a4,-20(s0)
 41c:	06b00793          	li	a5,107
 420:	00f71663          	bne	a4,a5,42c <ascii_code+0x74>
 424:	00400793          	li	a5,4
 428:	06c0006f          	j	494 <ascii_code+0xdc>
 42c:	fec42703          	lw	a4,-20(s0)
 430:	07300793          	li	a5,115
 434:	00f71663          	bne	a4,a5,440 <ascii_code+0x88>
 438:	00500793          	li	a5,5
 43c:	0580006f          	j	494 <ascii_code+0xdc>
 440:	fec42703          	lw	a4,-20(s0)
 444:	07400793          	li	a5,116
 448:	00f71663          	bne	a4,a5,454 <ascii_code+0x9c>
 44c:	00600793          	li	a5,6
 450:	0440006f          	j	494 <ascii_code+0xdc>
 454:	fec42703          	lw	a4,-20(s0)
 458:	06c00793          	li	a5,108
 45c:	00f71663          	bne	a4,a5,468 <ascii_code+0xb0>
 460:	00700793          	li	a5,7
 464:	0300006f          	j	494 <ascii_code+0xdc>
 468:	fec42703          	lw	a4,-20(s0)
 46c:	07500793          	li	a5,117
 470:	00f71663          	bne	a4,a5,47c <ascii_code+0xc4>
 474:	00800793          	li	a5,8
 478:	01c0006f          	j	494 <ascii_code+0xdc>
 47c:	fec42703          	lw	a4,-20(s0)
 480:	07d00793          	li	a5,125
 484:	00f71663          	bne	a4,a5,490 <ascii_code+0xd8>
 488:	00900793          	li	a5,9
 48c:	0080006f          	j	494 <ascii_code+0xdc>
 490:	00a00793          	li	a5,10
 494:	00078513          	mv	a0,a5
 498:	01c12403          	lw	s0,28(sp)
 49c:	02010113          	add	sp,sp,32
 4a0:	00008067          	ret

000004a4 <count_ocur>:
 4a4:	fd010113          	add	sp,sp,-48
 4a8:	02812623          	sw	s0,44(sp)
 4ac:	03010413          	add	s0,sp,48
 4b0:	fca42e23          	sw	a0,-36(s0)
 4b4:	fcb42c23          	sw	a1,-40(s0)
 4b8:	fd842783          	lw	a5,-40(s0)
 4bc:	0077f793          	and	a5,a5,7
 4c0:	fef42223          	sw	a5,-28(s0)
 4c4:	fe042623          	sw	zero,-20(s0)
 4c8:	fe042423          	sw	zero,-24(s0)
 4cc:	01d00793          	li	a5,29
 4d0:	fef42023          	sw	a5,-32(s0)
 4d4:	04c0006f          	j	520 <_stack_size+0x20>
 4d8:	fe042703          	lw	a4,-32(s0)
 4dc:	fe842783          	lw	a5,-24(s0)
 4e0:	40f707b3          	sub	a5,a4,a5
 4e4:	fdc42703          	lw	a4,-36(s0)
 4e8:	00f71733          	sll	a4,a4,a5
 4ec:	fe042783          	lw	a5,-32(s0)
 4f0:	00f757b3          	srl	a5,a4,a5
 4f4:	fe442703          	lw	a4,-28(s0)
 4f8:	00f71e63          	bne	a4,a5,514 <_stack_size+0x14>
 4fc:	fec42783          	lw	a5,-20(s0)
 500:	00178793          	add	a5,a5,1
 504:	fef42623          	sw	a5,-20(s0)
 508:	fe842783          	lw	a5,-24(s0)
 50c:	00278793          	add	a5,a5,2
 510:	fef42423          	sw	a5,-24(s0)
 514:	fe842783          	lw	a5,-24(s0)
 518:	00178793          	add	a5,a5,1
 51c:	fef42423          	sw	a5,-24(s0)
 520:	fe842703          	lw	a4,-24(s0)
 524:	fe042783          	lw	a5,-32(s0)
 528:	faf768e3          	bltu	a4,a5,4d8 <count_ocur+0x34>
 52c:	fec42783          	lw	a5,-20(s0)
 530:	00078513          	mv	a0,a5
 534:	02c12403          	lw	s0,44(sp)
 538:	03010113          	add	sp,sp,48
 53c:	00008067          	ret

00000540 <draw_hello>:
 540:	fe010113          	add	sp,sp,-32
 544:	00112e23          	sw	ra,28(sp)
 548:	00812c23          	sw	s0,24(sp)
 54c:	02010413          	add	s0,sp,32
 550:	fea42623          	sw	a0,-20(s0)
 554:	feb42423          	sw	a1,-24(s0)
 558:	04800613          	li	a2,72
 55c:	fe842583          	lw	a1,-24(s0)
 560:	fec42503          	lw	a0,-20(s0)
 564:	1ec000ef          	jal	750 <draw>
 568:	06500613          	li	a2,101
 56c:	fe842583          	lw	a1,-24(s0)
 570:	fec42503          	lw	a0,-20(s0)
 574:	1dc000ef          	jal	750 <draw>
 578:	06c00613          	li	a2,108
 57c:	fe842583          	lw	a1,-24(s0)
 580:	fec42503          	lw	a0,-20(s0)
 584:	1cc000ef          	jal	750 <draw>
 588:	06c00613          	li	a2,108
 58c:	fe842583          	lw	a1,-24(s0)
 590:	fec42503          	lw	a0,-20(s0)
 594:	1bc000ef          	jal	750 <draw>
 598:	06f00613          	li	a2,111
 59c:	fe842583          	lw	a1,-24(s0)
 5a0:	fec42503          	lw	a0,-20(s0)
 5a4:	1ac000ef          	jal	750 <draw>
 5a8:	00000013          	nop
 5ac:	01c12083          	lw	ra,28(sp)
 5b0:	01812403          	lw	s0,24(sp)
 5b4:	02010113          	add	sp,sp,32
 5b8:	00008067          	ret

000005bc <draw_swi>:
 5bc:	fe010113          	add	sp,sp,-32
 5c0:	00112e23          	sw	ra,28(sp)
 5c4:	00812c23          	sw	s0,24(sp)
 5c8:	02010413          	add	s0,sp,32
 5cc:	fea42623          	sw	a0,-20(s0)
 5d0:	feb42423          	sw	a1,-24(s0)
 5d4:	05300613          	li	a2,83
 5d8:	fe842583          	lw	a1,-24(s0)
 5dc:	fec42503          	lw	a0,-20(s0)
 5e0:	170000ef          	jal	750 <draw>
 5e4:	07700613          	li	a2,119
 5e8:	fe842583          	lw	a1,-24(s0)
 5ec:	fec42503          	lw	a0,-20(s0)
 5f0:	160000ef          	jal	750 <draw>
 5f4:	05f00613          	li	a2,95
 5f8:	fe842583          	lw	a1,-24(s0)
 5fc:	fec42503          	lw	a0,-20(s0)
 600:	150000ef          	jal	750 <draw>
 604:	06900613          	li	a2,105
 608:	fe842583          	lw	a1,-24(s0)
 60c:	fec42503          	lw	a0,-20(s0)
 610:	140000ef          	jal	750 <draw>
 614:	03a00613          	li	a2,58
 618:	fe842583          	lw	a1,-24(s0)
 61c:	fec42503          	lw	a0,-20(s0)
 620:	130000ef          	jal	750 <draw>
 624:	02000613          	li	a2,32
 628:	fe842583          	lw	a1,-24(s0)
 62c:	fec42503          	lw	a0,-20(s0)
 630:	120000ef          	jal	750 <draw>
 634:	00000013          	nop
 638:	01c12083          	lw	ra,28(sp)
 63c:	01812403          	lw	s0,24(sp)
 640:	02010113          	add	sp,sp,32
 644:	00008067          	ret

00000648 <draw_a>:
 648:	fe010113          	add	sp,sp,-32
 64c:	00112e23          	sw	ra,28(sp)
 650:	00812c23          	sw	s0,24(sp)
 654:	02010413          	add	s0,sp,32
 658:	fea42623          	sw	a0,-20(s0)
 65c:	feb42423          	sw	a1,-24(s0)
 660:	04100613          	li	a2,65
 664:	fe842583          	lw	a1,-24(s0)
 668:	fec42503          	lw	a0,-20(s0)
 66c:	0e4000ef          	jal	750 <draw>
 670:	03a00613          	li	a2,58
 674:	fe842583          	lw	a1,-24(s0)
 678:	fec42503          	lw	a0,-20(s0)
 67c:	0d4000ef          	jal	750 <draw>
 680:	02000613          	li	a2,32
 684:	fe842583          	lw	a1,-24(s0)
 688:	fec42503          	lw	a0,-20(s0)
 68c:	0c4000ef          	jal	750 <draw>
 690:	00000013          	nop
 694:	01c12083          	lw	ra,28(sp)
 698:	01812403          	lw	s0,24(sp)
 69c:	02010113          	add	sp,sp,32
 6a0:	00008067          	ret

000006a4 <draw_result>:
 6a4:	fe010113          	add	sp,sp,-32
 6a8:	00112e23          	sw	ra,28(sp)
 6ac:	00812c23          	sw	s0,24(sp)
 6b0:	02010413          	add	s0,sp,32
 6b4:	fea42623          	sw	a0,-20(s0)
 6b8:	feb42423          	sw	a1,-24(s0)
 6bc:	05200613          	li	a2,82
 6c0:	fe842583          	lw	a1,-24(s0)
 6c4:	fec42503          	lw	a0,-20(s0)
 6c8:	088000ef          	jal	750 <draw>
 6cc:	06500613          	li	a2,101
 6d0:	fe842583          	lw	a1,-24(s0)
 6d4:	fec42503          	lw	a0,-20(s0)
 6d8:	078000ef          	jal	750 <draw>
 6dc:	07300613          	li	a2,115
 6e0:	fe842583          	lw	a1,-24(s0)
 6e4:	fec42503          	lw	a0,-20(s0)
 6e8:	068000ef          	jal	750 <draw>
 6ec:	07500613          	li	a2,117
 6f0:	fe842583          	lw	a1,-24(s0)
 6f4:	fec42503          	lw	a0,-20(s0)
 6f8:	058000ef          	jal	750 <draw>
 6fc:	06c00613          	li	a2,108
 700:	fe842583          	lw	a1,-24(s0)
 704:	fec42503          	lw	a0,-20(s0)
 708:	048000ef          	jal	750 <draw>
 70c:	07400613          	li	a2,116
 710:	fe842583          	lw	a1,-24(s0)
 714:	fec42503          	lw	a0,-20(s0)
 718:	038000ef          	jal	750 <draw>
 71c:	03a00613          	li	a2,58
 720:	fe842583          	lw	a1,-24(s0)
 724:	fec42503          	lw	a0,-20(s0)
 728:	028000ef          	jal	750 <draw>
 72c:	02000613          	li	a2,32
 730:	fe842583          	lw	a1,-24(s0)
 734:	fec42503          	lw	a0,-20(s0)
 738:	018000ef          	jal	750 <draw>
 73c:	00000013          	nop
 740:	01c12083          	lw	ra,28(sp)
 744:	01812403          	lw	s0,24(sp)
 748:	02010113          	add	sp,sp,32
 74c:	00008067          	ret

00000750 <draw>:
 750:	fd010113          	add	sp,sp,-48
 754:	02812623          	sw	s0,44(sp)
 758:	03010413          	add	s0,sp,48
 75c:	fca42e23          	sw	a0,-36(s0)
 760:	fcb42c23          	sw	a1,-40(s0)
 764:	00060793          	mv	a5,a2
 768:	fcf40ba3          	sb	a5,-41(s0)
 76c:	fdc42783          	lw	a5,-36(s0)
 770:	0007a703          	lw	a4,0(a5)
 774:	00070793          	mv	a5,a4
 778:	00279793          	sll	a5,a5,0x2
 77c:	00e787b3          	add	a5,a5,a4
 780:	00479793          	sll	a5,a5,0x4
 784:	00078713          	mv	a4,a5
 788:	fd842783          	lw	a5,-40(s0)
 78c:	0007a783          	lw	a5,0(a5)
 790:	00f707b3          	add	a5,a4,a5
 794:	fef42623          	sw	a5,-20(s0)
 798:	07000737          	lui	a4,0x7000
 79c:	fec42783          	lw	a5,-20(s0)
 7a0:	00f707b3          	add	a5,a4,a5
 7a4:	fd744703          	lbu	a4,-41(s0)
 7a8:	00e78023          	sb	a4,0(a5)
 7ac:	0f000793          	li	a5,240
 7b0:	fef42423          	sw	a5,-24(s0)
 7b4:	07001737          	lui	a4,0x7001
 7b8:	fec42783          	lw	a5,-20(s0)
 7bc:	00f707b3          	add	a5,a4,a5
 7c0:	fe842703          	lw	a4,-24(s0)
 7c4:	0ff77713          	zext.b	a4,a4
 7c8:	00e78023          	sb	a4,0(a5)
 7cc:	fd842783          	lw	a5,-40(s0)
 7d0:	0007a703          	lw	a4,0(a5)
 7d4:	04f00793          	li	a5,79
 7d8:	02f71263          	bne	a4,a5,7fc <draw+0xac>
 7dc:	fd842783          	lw	a5,-40(s0)
 7e0:	0007a023          	sw	zero,0(a5)
 7e4:	fdc42783          	lw	a5,-36(s0)
 7e8:	0007a783          	lw	a5,0(a5)
 7ec:	00178713          	add	a4,a5,1
 7f0:	fdc42783          	lw	a5,-36(s0)
 7f4:	00e7a023          	sw	a4,0(a5)
 7f8:	0180006f          	j	810 <draw+0xc0>
 7fc:	fd842783          	lw	a5,-40(s0)
 800:	0007a783          	lw	a5,0(a5)
 804:	00178713          	add	a4,a5,1
 808:	fd842783          	lw	a5,-40(s0)
 80c:	00e7a023          	sw	a4,0(a5)
 810:	fdc42783          	lw	a5,-36(s0)
 814:	0007a703          	lw	a4,0(a5)
 818:	01d00793          	li	a5,29
 81c:	00f71a63          	bne	a4,a5,830 <draw+0xe0>
 820:	fdc42783          	lw	a5,-36(s0)
 824:	0007a023          	sw	zero,0(a5)
 828:	fd842783          	lw	a5,-40(s0)
 82c:	0007a023          	sw	zero,0(a5)
 830:	00000013          	nop
 834:	02c12403          	lw	s0,44(sp)
 838:	03010113          	add	sp,sp,48
 83c:	00008067          	ret

00000840 <clear>:
 840:	fe010113          	add	sp,sp,-32
 844:	00812e23          	sw	s0,28(sp)
 848:	02010413          	add	s0,sp,32
 84c:	fe042623          	sw	zero,-20(s0)
 850:	0300006f          	j	880 <clear+0x40>
 854:	07000737          	lui	a4,0x7000
 858:	fec42783          	lw	a5,-20(s0)
 85c:	00f707b3          	add	a5,a4,a5
 860:	00078023          	sb	zero,0(a5)
 864:	07001737          	lui	a4,0x7001
 868:	fec42783          	lw	a5,-20(s0)
 86c:	00f707b3          	add	a5,a4,a5
 870:	00078023          	sb	zero,0(a5)
 874:	fec42783          	lw	a5,-20(s0)
 878:	00178793          	add	a5,a5,1
 87c:	fef42623          	sw	a5,-20(s0)
 880:	fec42703          	lw	a4,-20(s0)
 884:	000017b7          	lui	a5,0x1
 888:	95f78793          	add	a5,a5,-1697 # 95f <int_handler+0xbb>
 88c:	fce7f4e3          	bgeu	a5,a4,854 <clear+0x14>
 890:	00000013          	nop
 894:	00000013          	nop
 898:	01c12403          	lw	s0,28(sp)
 89c:	02010113          	add	sp,sp,32
 8a0:	00008067          	ret

000008a4 <int_handler>:
 8a4:	ff010113          	add	sp,sp,-16
 8a8:	00812623          	sw	s0,12(sp)
 8ac:	01010413          	add	s0,sp,16
 8b0:	000047b7          	lui	a5,0x4
 8b4:	00100713          	li	a4,1
 8b8:	00e7a023          	sw	a4,0(a5) # 4000 <scan_code_is_unread>
 8bc:	00000013          	nop
 8c0:	00c12403          	lw	s0,12(sp)
 8c4:	01010113          	add	sp,sp,16
 8c8:	00008067          	ret
