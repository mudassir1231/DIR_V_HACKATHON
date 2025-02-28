load_gp:
 auipc	gp,0x2
 addi	gp,gp,1210 # 12808 <__global_pointer$>
 ret
 nop
flatten_row:
 addi	sp,sp,-48
 sw	ra,44(sp)
 sw	s0,40(sp)
 addi	s0,sp,48
 sw	a0,-36(s0)
 sw	a1,-40(s0)
 sw	zero,-20(s0)
 sw	zero,-24(s0)
 j	10424 <flatten_row+0x70>
 sw	zero,-28(s0)
 j	10410 <flatten_row+0x5c>
 lw	a5,-24(s0)
 slli	a5,a5,0x1
 lw	a4,-36(s0)
 add	a2,a4,a5
 lw	a5,-40(s0)
 addi	a3,a5,4
 lw	a5,-20(s0)
 addi	a4,a5,1
 sw	a4,-20(s0)
 lw	a4,-28(s0)
 add	a4,a4,a2
 lb	a4,0(a4)
 add	a5,a5,a3
 sb	a4,0(a5)
 lw	a5,-28(s0)
 addi	a5,a5,1
 sw	a5,-28(s0)
 lw	a4,-28(s0)
 li	a5,1
 bge	a5,a4,103d4 <flatten_row+0x20>
 lw	a5,-24(s0)
 addi	a5,a5,1
 sw	a5,-24(s0)
 lw	a4,-24(s0)
 li	a5,1
 bge	a5,a4,103ce <flatten_row+0x1a>
 nop
 mv	a0,a5
 lw	ra,44(sp)
 lw	s0,40(sp)
 addi	sp,sp,48
 ret
lowerTensor:
 addi	sp,sp,-48
 sw	ra,44(sp)
 sw	s0,40(sp)
 addi	s0,sp,48
 sw	a0,-36(s0)
 sw	a1,-40(s0)
 sw	a2,-44(s0)
 sw	a3,-48(s0)
 lw	a3,-40(s0)
 addi	a2,a3,-1
 sw	a2,-32(s0)
 mv	a2,a3
 mv	a6,a2
 li	a7,0
 srli	a2,a6,0x1d
 slli	a5,a7,0x3
 add	a5,a5,a2
 slli	a4,a6,0x3
 sw	zero,-20(s0)
 sw	zero,-24(s0)
 j	104d6 <lowerTensor+0x9c>
 sw	zero,-28(s0)
 j	104c0 <lowerTensor+0x86>
 mv	a4,a3
 lw	a5,-24(s0)
 mul	a5,a4,a5
 lw	a4,-44(s0)
 add	a2,a4,a5
 lw	a5,-20(s0)
 addi	a4,a5,1
 sw	a4,-20(s0)
 mv	a4,a5
 lw	a5,-48(s0)
 add	a5,a5,a4
 lw	a4,-28(s0)
 add	a4,a4,a2
 lb	a4,0(a4)
 sb	a4,1(a5)
 lw	a5,-28(s0)
 addi	a5,a5,1
 sw	a5,-28(s0)
 lw	a4,-40(s0)
 lw	a5,-28(s0)
 blt	a5,a4,10482 <lowerTensor+0x48>
 lw	a5,-24(s0)
 addi	a5,a5,1
 sw	a5,-24(s0)
 lw	a4,-36(s0)
 lw	a5,-24(s0)
 blt	a5,a4,1047c <lowerTensor+0x42>
 nop
 mv	a0,a5
 lw	ra,44(sp)
 lw	s0,40(sp)
 addi	sp,sp,48
 ret
pass_values:
 addi	sp,sp,-48
 sw	ra,44(sp)
 sw	s0,40(sp)
 addi	s0,sp,48
 sw	a0,-36(s0)
 sw	a1,-40(s0)
 sw	a2,-44(s0)
 sw	a3,-48(s0)
 lw	a5,-40(s0)
 sw	a5,-20(s0)
 j	10536 <pass_values+0x48>
 lw	a5,-20(s0)
 lw	a4,-36(s0)
 add	a4,a4,a5
 lw	a5,-20(s0)
 lw	a3,-48(s0)
 add	a5,a5,a3
 lb	a4,1(a4)
 sb	a4,1(a5)
 lw	a5,-20(s0)
 addi	a5,a5,1
 sw	a5,-20(s0)
 lw	a4,-20(s0)
 lw	a5,-44(s0)
 bge	a5,a4,10510 <pass_values+0x22>
 nop
 mv	a0,a5
 lw	ra,44(sp)
 lw	s0,40(sp)
 addi	sp,sp,48
 ret
main:
 addi	sp,sp,-160
 sw	ra,156(sp)
 sw	s0,152(sp)
 addi	s0,sp,160
 lui	a5,0x12
 lw	a5,8(a5) # 12008 <__TMC_END__>
 sw	a5,-20(s0)
 lui	a5,0x12
 lw	a5,8(a5) # 12008 <__TMC_END__>
 sw	a5,-24(s0)
 lui	a5,0x10
 addi	a4,a5,1744 # 106d0 <_IO_stdin_used+0x4>
 addi	a5,s0,-88
 mv	a3,a4
 li	a4,64
 mv	a2,a4
 mv	a1,a3
 mv	a0,a5
 jal	10320 <memcpy@plt>
 addi	a4,s0,-92
 addi	a5,s0,-24
 mv	a1,a4
 mv	a0,a5
 jal	103b4 <flatten_row>
 addi	a4,s0,-156
 addi	a5,s0,-88
 mv	a3,a4
 mv	a2,a5
 li	a1,8
 li	a0,8
 jal	1043a <lowerTensor>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,3
 li	a1,0
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,7
 li	a1,4
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,11
 li	a1,8
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,15
 li	a1,12
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,19
 li	a1,16
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,32
 li	a1,30
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,35
 li	a1,33
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,39
 li	a1,36
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,43
 li	a1,40
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,47
 li	a1,44
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,51
 li	a1,48
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,55
 li	a1,52
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,59
 li	a1,56
 mv	a0,a5
 jal	104ee <pass_values>
 addi	a4,s0,-160
 addi	a5,s0,-156
 mv	a3,a4
 li	a2,63
 li	a1,60
 mv	a0,a5
 jal	104ee <pass_values>
 li	a5,0
 mv	a0,a5
 lw	ra,156(sp)
 lw	s0,152(sp)
 addi	sp,sp,160
 ret
