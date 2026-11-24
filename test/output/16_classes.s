# FNS -> MIPS32 (spim).  Generated assembly.
# source: test/16_classes.cpp
# run with:  spim -file <this file> [program arguments]

.data
str0: .asciiz "  construct %d\n"
str1: .asciiz "  destruct %d\n"
str2: .asciiz "%+d "
str3: .asciiz "\n"
str4: .asciiz "  Box(%d, %d)\n"
str5: .asciiz "  square %d\n"
str6: .asciiz "  default box\n"
str7: .asciiz "stack kind %d\n"
str8: .asciiz "walk %d\n"
str9: .asciiz "box areas %d %d\n"
str10: .asciiz "%d %d %d %d instances=%d\n"
str11: .asciiz "r1 area=%.2f square=%d\n"
str12: .asciiz "r2 area=%.2f perimeter=%.2f\n"
str13: .asciiz "scaled area=%.2f\n"
str14: .asciiz "heap square=%d area=%.1f\n"
str15: .asciiz "array: %d %d %d\n"
str16: .asciiz "new[]: %d %d instances=%d\n"
str17: .asciiz "withdraw 500: %d, withdraw 30: %d\n"
str18: .asciiz "balance=%d history: "
str19: .asciiz "scopes:\n"
str20: .asciiz "  leaving inner block\n"
str21: .asciiz "  end of main\n"
.align 2
U_Counter_instances: .word 0

.text
.globl main

U_Counter_Counter:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t0, 0
    lw $t1, 0($fp)
    sw $t0, 0($t1)
    la $t0, U_Counter_instances
    lw $t0, 0($t0)
    addiu $t2, $t0, 1
    la $t8, U_Counter_instances
    sw $t2, 0($t8)
.Lret0:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Counter_Counter__1:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 4($fp)
    lw $t1, 0($fp)
    sw $t0, 0($t1)
    la $t0, U_Counter_instances
    lw $t0, 0($t0)
    addiu $t2, $t0, 1
    la $t8, U_Counter_instances
    sw $t2, 0($t8)
.Lret1:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Counter_increment:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    addiu $t2, $t0, 1
    lw $t1, 0($fp)
    sw $t2, 0($t1)
.Lret2:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Counter_add:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    lw $t1, 4($fp)
    addu $t2, $t0, $t1
    lw $t1, 0($fp)
    sw $t2, 0($t1)
.Lret3:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Counter_get:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    move $v0, $t2
.Lret4:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Counter_count:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    la $v0, U_Counter_instances
    lw $v0, 0($v0)
.Lret5:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Rectangle_perimeter:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -56
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    l.d $f0, 0($t1)
    s.d $f0, -16($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    sw $t2, -20($fp)
    lw $t1, -20($fp)
    l.d $f0, 0($t1)
    s.d $f0, -28($fp)
    l.d $f4, -16($fp)
    l.d $f6, -28($fp)
    add.d $f0, $f4, $f6
    s.d $f0, -36($fp)
    li $t0, 2
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -44($fp)
    l.d $f4, -44($fp)
    l.d $f6, -36($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -52($fp)
    l.d $f0, -52($fp)
.Lret6:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Rectangle_scale:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -48
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    l.d $f0, 0($t1)
    s.d $f0, -16($fp)
    l.d $f4, -16($fp)
    l.d $f6, 4($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -24($fp)
    l.d $f0, -24($fp)
    lw $t1, 0($fp)
    s.d $f0, 0($t1)
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    sw $t2, -28($fp)
    lw $t1, -28($fp)
    l.d $f0, 0($t1)
    s.d $f0, -36($fp)
    l.d $f4, -36($fp)
    l.d $f6, 4($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -44($fp)
    l.d $f0, -44($fp)
    lw $t1, -28($fp)
    s.d $f0, 0($t1)
.Lret7:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Rectangle_is_square:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    l.d $f0, 0($t1)
    s.d $f0, -16($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    sw $t2, -20($fp)
    lw $t1, -20($fp)
    l.d $f0, 0($t1)
    s.d $f0, -28($fp)
    l.d $f4, -16($fp)
    l.d $f6, -28($fp)
    li $t2, 0
    c.eq.d $f4, $f6
    bc1f .Lfc0
    li $t2, 1
.Lfc0:
    sltu $t2, $zero, $t2
    move $v0, $t2
.Lret8:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Rectangle_Rectangle:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t0, 1
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -16($fp)
    l.d $f0, -16($fp)
    lw $t1, 0($fp)
    s.d $f0, 0($t1)
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    sw $t2, -20($fp)
    li $t0, 1
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -28($fp)
    l.d $f0, -28($fp)
    lw $t1, -20($fp)
    s.d $f0, 0($t1)
.Lret9:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Rectangle_Rectangle__1:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    l.d $f0, 4($fp)
    lw $t1, 0($fp)
    s.d $f0, 0($t1)
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    sw $t2, -12($fp)
    l.d $f0, 12($fp)
    lw $t1, -12($fp)
    s.d $f0, 0($t1)
.Lret10:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Rectangle_area:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -40
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    l.d $f0, 0($t1)
    s.d $f0, -16($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    sw $t2, -20($fp)
    lw $t1, -20($fp)
    l.d $f0, 0($t1)
    s.d $f0, -28($fp)
    l.d $f4, -16($fp)
    l.d $f6, -28($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -36($fp)
    l.d $f0, -36($fp)
.Lret11:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Tracer_Tracer:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 4($fp)
    lw $t1, 0($fp)
    sw $t0, 0($t1)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    sw $t2, -12($fp)
    addiu $sp, $sp, -8
    la $t0, str0
    sw $t0, 0($sp)
    lw $t0, -12($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -16($fp)
.Lret12:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Tracer__dtor:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    sw $t2, -12($fp)
    addiu $sp, $sp, -8
    la $t0, str1
    sw $t0, 0($sp)
    lw $t0, -12($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -16($fp)
.Lret13:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_BankAccount_BankAccount:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 4
    sw $t2, -12($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 36
    sw $t2, -16($fp)
    lw $t0, 4($fp)
    lw $t1, 0($fp)
    sw $t0, 0($t1)
    lw $t0, 0($fp)
    addiu $t2, $t0, 36
    li $t0, 0
    sw $t0, 0($t2)
.Lret14:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_BankAccount_withdraw:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    lw $t0, 4($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    beq $t2, $zero, .L15_L1
    li $v0, 0
    j .Lret15
.L15_L1:
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    lw $t1, 4($fp)
    subu $t2, $t0, $t1
    lw $t1, 0($fp)
    sw $t2, 0($t1)
    lw $t0, 0($fp)
    addiu $t2, $t0, 4
    sw $t2, -12($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 36
    sw $t2, -16($fp)
    lw $t1, -16($fp)
    lw $t2, 0($t1)
    sw $t2, -20($fp)
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    lw $t1, -16($fp)
    sw $t2, 0($t1)
    lw $t0, -20($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -12($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -24($fp)
    lw $t0, 4($fp)
    subu $t2, $zero, $t0
    lw $t1, -24($fp)
    sw $t2, 0($t1)
    li $v0, 1
.Lret15:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_BankAccount_deposit:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    lw $t1, 4($fp)
    addu $t2, $t0, $t1
    lw $t1, 0($fp)
    sw $t2, 0($t1)
    lw $t0, 0($fp)
    addiu $t2, $t0, 4
    sw $t2, -12($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 36
    sw $t2, -16($fp)
    lw $t1, -16($fp)
    lw $t2, 0($t1)
    sw $t2, -20($fp)
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    lw $t1, -16($fp)
    sw $t2, 0($t1)
    lw $t0, -20($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -12($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t0, 4($fp)
    sw $t0, 0($t2)
.Lret16:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_BankAccount_get_balance:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    move $v0, $t2
.Lret17:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_BankAccount_print_history:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
.L18_L2:
    lw $t0, 0($fp)
    addiu $t2, $t0, 36
    lw $t2, 0($t2)
    lw $t0, -12($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    beq $t2, $zero, .L18_L4
    lw $t0, 0($fp)
    addiu $t2, $t0, 4
    sw $t2, -16($fp)
    lw $t0, -12($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -16($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -20($fp)
    addiu $sp, $sp, -8
    la $t0, str2
    sw $t0, 0($sp)
    lw $t0, -20($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -24($fp)
.L18_L3:
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .L18_L2
.L18_L4:
    addiu $sp, $sp, -4
    la $t0, str3
    sw $t0, 0($sp)
    jal R_printf
    addiu $sp, $sp, 4
    sw $v0, -28($fp)
.Lret18:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Box_Box:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 4($fp)
    lw $t1, 0($fp)
    sw $t0, 0($t1)
    lw $t0, 0($fp)
    addiu $t2, $t0, 4
    lw $t0, 8($fp)
    sw $t0, 0($t2)
    addiu $sp, $sp, -12
    la $t0, str4
    sw $t0, 0($sp)
    lw $t0, 4($fp)
    sw $t0, 4($sp)
    lw $t0, 8($fp)
    sw $t0, 8($sp)
    jal R_printf
    addiu $sp, $sp, 12
    sw $v0, -12($fp)
.Lret19:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Box_Box__1:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -12
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, 4($fp)
    sw $t0, 4($sp)
    lw $t0, 4($fp)
    sw $t0, 8($sp)
    jal U_Box_Box
    addiu $sp, $sp, 12
    addiu $sp, $sp, -8
    la $t0, str5
    sw $t0, 0($sp)
    lw $t0, 4($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -12($fp)
.Lret20:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Box_Box__2:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    li $t0, 1
    sw $t0, 4($sp)
    jal U_Box_Box__1
    addiu $sp, $sp, 8
    addiu $sp, $sp, -4
    la $t0, str6
    sw $t0, 0($sp)
    jal R_printf
    addiu $sp, $sp, 4
    sw $v0, -12($fp)
.Lret21:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Box_area:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    sw $t2, -12($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    lw $t0, -12($fp)
    move $t1, $t2
    mult $t0, $t1
    mflo $t2
    move $v0, $t2
.Lret22:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Node_Node:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 4($fp)
    lw $t1, 0($fp)
    sw $t0, 0($t1)
    lw $t0, 0($fp)
    addiu $t2, $t0, 4
    lw $t0, 8($fp)
    sw $t0, 0($t2)
.Lret23:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Walker_Walker:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 4($fp)
    lw $t1, 0($fp)
    sw $t0, 0($t1)
.Lret24:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Walker_more:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    sw $t2, -12($fp)
    li $t2, 0
    lw $t0, -12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    sltu $t2, $zero, $t2
    move $v0, $t2
.Lret25:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Walker_next:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    lw $t2, 0($t2)
    sw $t2, -12($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    lw $t1, 0($fp)
    sw $t2, 0($t1)
    lw $v0, -12($fp)
.Lret26:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Stack_Stack:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    lw $t1, 0($fp)
    sw $t2, 0($t1)
.Lret27:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Stack__dtor:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
.L28_L5:
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    beq $t2, $zero, .L28_L6
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    sw $t2, -12($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    sw $t2, -16($fp)
    addiu $sp, $sp, -4
    lw $t0, -16($fp)
    sw $t0, 0($sp)
    jal R_free
    addiu $sp, $sp, 4
    lw $t0, -12($fp)
    lw $t1, 0($fp)
    sw $t0, 0($t1)
    j .L28_L5
.L28_L6:
.Lret28:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Stack_push:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -12
    li $t0, 1
    sw $t0, 0($sp)
    li $t0, 8
    sw $t0, 4($sp)
    li $t0, 0
    sw $t0, 8($sp)
    jal R___fns_new
    addiu $sp, $sp, 12
    sw $v0, -12($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    sw $t2, -16($fp)
    addiu $sp, $sp, -12
    lw $t0, -12($fp)
    sw $t0, 0($sp)
    lw $t0, 4($fp)
    sw $t0, 4($sp)
    lw $t0, -16($fp)
    sw $t0, 8($sp)
    jal U_Node_Node
    addiu $sp, $sp, 12
    lw $t0, -12($fp)
    lw $t1, 0($fp)
    sw $t0, 0($t1)
.Lret29:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Stack_walk:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $t2, $fp, -12
    sw $t2, -16($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    sw $t2, -20($fp)
    addiu $sp, $sp, -8
    lw $t0, -16($fp)
    sw $t0, 0($sp)
    lw $t0, -20($fp)
    sw $t0, 4($sp)
    jal U_Walker_Walker
    addiu $sp, $sp, 8
    lw $v0, -16($fp)
.Lret30:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

U_Stack_kind:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    beq $t2, $zero, .L31_L7
    li $t2, 1
    sw $t2, -12($fp)
    j .L31_L8
.L31_L7:
    li $t2, 0
    sw $t2, -12($fp)
.L31_L8:
    lw $t2, -12($fp)
    move $v0, $t2
.Lret31:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

main:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -648
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $t2, $fp, -12
    sw $t2, -172($fp)
    addiu $sp, $sp, -4
    lw $t0, -172($fp)
    sw $t0, 0($sp)
    jal U_Stack_Stack
    addiu $sp, $sp, 4
    addiu $t2, $fp, -12
    sw $t2, -176($fp)
    addiu $sp, $sp, -4
    lw $t0, -176($fp)
    sw $t0, 0($sp)
    jal U_Stack_kind
    addiu $sp, $sp, 4
    sw $v0, -180($fp)
    lw $t2, -180($fp)
    sw $t2, -184($fp)
    li $t2, 0
    lw $t0, -184($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    sw $t2, -188($fp)
    addiu $sp, $sp, -8
    la $t0, str7
    sw $t0, 0($sp)
    lw $t0, -188($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -192($fp)
    li $t2, 1
    sw $t2, -16($fp)
.L32_L9:
    lw $t0, -16($fp)
    li $t1, 3
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .L32_L11
    addiu $t2, $fp, -12
    sw $t2, -196($fp)
    lw $t0, -16($fp)
    li $t1, 10
    mult $t0, $t1
    mflo $t2
    sw $t2, -200($fp)
    addiu $sp, $sp, -8
    lw $t0, -196($fp)
    sw $t0, 0($sp)
    lw $t0, -200($fp)
    sw $t0, 4($sp)
    jal U_Stack_push
    addiu $sp, $sp, 8
.L32_L10:
    lw $t0, -16($fp)
    addiu $t2, $t0, 1
    sw $t2, -16($fp)
    j .L32_L9
.L32_L11:
    addiu $t2, $fp, -12
    sw $t2, -204($fp)
    addiu $sp, $sp, -4
    lw $t0, -204($fp)
    sw $t0, 0($sp)
    jal U_Stack_walk
    addiu $sp, $sp, 4
    sw $v0, -208($fp)
    addiu $t2, $fp, -20
    move $t8, $t2
    lw $t9, -208($fp)
    li $t0, 4
.Lcpy1:
    beq $t0, $zero, .Lcpy1_end
    lb $t1, 0($t9)
    sb $t1, 0($t8)
    addiu $t8, $t8, 1
    addiu $t9, $t9, 1
    addiu $t0, $t0, -1
    j .Lcpy1
.Lcpy1_end:
.L32_L12:
    addiu $t2, $fp, -20
    sw $t2, -212($fp)
    addiu $sp, $sp, -4
    lw $t0, -212($fp)
    sw $t0, 0($sp)
    jal U_Walker_more
    addiu $sp, $sp, 4
    sw $v0, -216($fp)
    lw $t0, -216($fp)
    beq $t0, $zero, .L32_L14
    addiu $t2, $fp, -20
    sw $t2, -220($fp)
    addiu $sp, $sp, -4
    lw $t0, -220($fp)
    sw $t0, 0($sp)
    jal U_Walker_next
    addiu $sp, $sp, 4
    sw $v0, -224($fp)
    addiu $sp, $sp, -8
    la $t0, str8
    sw $t0, 0($sp)
    lw $t0, -224($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -228($fp)
.L32_L13:
    j .L32_L12
.L32_L14:
    addiu $t2, $fp, -28
    sw $t2, -232($fp)
    addiu $sp, $sp, -4
    lw $t0, -232($fp)
    sw $t0, 0($sp)
    jal U_Box_Box__2
    addiu $sp, $sp, 4
    addiu $t2, $fp, -36
    sw $t2, -236($fp)
    addiu $sp, $sp, -8
    lw $t0, -236($fp)
    sw $t0, 0($sp)
    li $t0, 3
    sw $t0, 4($sp)
    jal U_Box_Box__1
    addiu $sp, $sp, 8
    addiu $t2, $fp, -28
    sw $t2, -240($fp)
    addiu $sp, $sp, -4
    lw $t0, -240($fp)
    sw $t0, 0($sp)
    jal U_Box_area
    addiu $sp, $sp, 4
    sw $v0, -244($fp)
    addiu $t2, $fp, -36
    sw $t2, -248($fp)
    addiu $sp, $sp, -4
    lw $t0, -248($fp)
    sw $t0, 0($sp)
    jal U_Box_area
    addiu $sp, $sp, 4
    sw $v0, -252($fp)
    addiu $sp, $sp, -12
    la $t0, str9
    sw $t0, 0($sp)
    lw $t0, -244($fp)
    sw $t0, 4($sp)
    lw $t0, -252($fp)
    sw $t0, 8($sp)
    jal R_printf
    addiu $sp, $sp, 12
    sw $v0, -256($fp)
    addiu $t2, $fp, -40
    sw $t2, -260($fp)
    addiu $sp, $sp, -4
    lw $t0, -260($fp)
    sw $t0, 0($sp)
    jal U_Counter_Counter
    addiu $sp, $sp, 4
    addiu $t2, $fp, -44
    sw $t2, -264($fp)
    addiu $sp, $sp, -8
    lw $t0, -264($fp)
    sw $t0, 0($sp)
    li $t0, 10
    sw $t0, 4($sp)
    jal U_Counter_Counter__1
    addiu $sp, $sp, 8
    addiu $t2, $fp, -48
    sw $t2, -268($fp)
    addiu $sp, $sp, -8
    lw $t0, -268($fp)
    sw $t0, 0($sp)
    li $t0, 100
    sw $t0, 4($sp)
    jal U_Counter_Counter__1
    addiu $sp, $sp, 8
    addiu $t2, $fp, -52
    sw $t2, -272($fp)
    addiu $sp, $sp, -8
    lw $t0, -272($fp)
    sw $t0, 0($sp)
    li $t0, 7
    sw $t0, 4($sp)
    jal U_Counter_Counter__1
    addiu $sp, $sp, 8
    addiu $t2, $fp, -40
    sw $t2, -276($fp)
    addiu $sp, $sp, -4
    lw $t0, -276($fp)
    sw $t0, 0($sp)
    jal U_Counter_increment
    addiu $sp, $sp, 4
    addiu $t2, $fp, -40
    sw $t2, -280($fp)
    addiu $sp, $sp, -4
    lw $t0, -280($fp)
    sw $t0, 0($sp)
    jal U_Counter_increment
    addiu $sp, $sp, 4
    addiu $t2, $fp, -44
    sw $t2, -284($fp)
    addiu $sp, $sp, -8
    lw $t0, -284($fp)
    sw $t0, 0($sp)
    li $t0, 5
    sw $t0, 4($sp)
    jal U_Counter_add
    addiu $sp, $sp, 8
    addiu $t2, $fp, -40
    sw $t2, -288($fp)
    addiu $sp, $sp, -4
    lw $t0, -288($fp)
    sw $t0, 0($sp)
    jal U_Counter_get
    addiu $sp, $sp, 4
    sw $v0, -292($fp)
    addiu $t2, $fp, -44
    sw $t2, -296($fp)
    addiu $sp, $sp, -4
    lw $t0, -296($fp)
    sw $t0, 0($sp)
    jal U_Counter_get
    addiu $sp, $sp, 4
    sw $v0, -300($fp)
    addiu $t2, $fp, -48
    sw $t2, -304($fp)
    addiu $sp, $sp, -4
    lw $t0, -304($fp)
    sw $t0, 0($sp)
    jal U_Counter_get
    addiu $sp, $sp, 4
    sw $v0, -308($fp)
    addiu $t2, $fp, -52
    sw $t2, -312($fp)
    addiu $sp, $sp, -4
    lw $t0, -312($fp)
    sw $t0, 0($sp)
    jal U_Counter_get
    addiu $sp, $sp, 4
    sw $v0, -316($fp)
    jal U_Counter_count
    sw $v0, -320($fp)
    addiu $sp, $sp, -24
    la $t0, str10
    sw $t0, 0($sp)
    lw $t0, -292($fp)
    sw $t0, 4($sp)
    lw $t0, -300($fp)
    sw $t0, 8($sp)
    lw $t0, -308($fp)
    sw $t0, 12($sp)
    lw $t0, -316($fp)
    sw $t0, 16($sp)
    lw $t0, -320($fp)
    sw $t0, 20($sp)
    jal R_printf
    addiu $sp, $sp, 24
    sw $v0, -324($fp)
    addiu $t2, $fp, -68
    sw $t2, -328($fp)
    addiu $sp, $sp, -4
    lw $t0, -328($fp)
    sw $t0, 0($sp)
    jal U_Rectangle_Rectangle
    addiu $sp, $sp, 4
    addiu $t2, $fp, -84
    sw $t2, -332($fp)
    addiu $sp, $sp, -20
    lw $t0, -332($fp)
    sw $t0, 0($sp)
    li.d $f0, 3.0
    s.d $f0, 4($sp)
    li.d $f0, 4.5
    s.d $f0, 12($sp)
    jal U_Rectangle_Rectangle__1
    addiu $sp, $sp, 20
    addiu $t2, $fp, -68
    sw $t2, -336($fp)
    addiu $sp, $sp, -4
    lw $t0, -336($fp)
    sw $t0, 0($sp)
    jal U_Rectangle_area
    addiu $sp, $sp, 4
    s.d $f0, -344($fp)
    addiu $t2, $fp, -68
    sw $t2, -348($fp)
    addiu $sp, $sp, -4
    lw $t0, -348($fp)
    sw $t0, 0($sp)
    jal U_Rectangle_is_square
    addiu $sp, $sp, 4
    sw $v0, -352($fp)
    lw $t2, -352($fp)
    sw $t2, -356($fp)
    addiu $sp, $sp, -16
    la $t0, str11
    sw $t0, 0($sp)
    l.d $f0, -344($fp)
    s.d $f0, 4($sp)
    lw $t0, -356($fp)
    sw $t0, 12($sp)
    jal R_printf
    addiu $sp, $sp, 16
    sw $v0, -360($fp)
    addiu $t2, $fp, -84
    sw $t2, -364($fp)
    addiu $sp, $sp, -4
    lw $t0, -364($fp)
    sw $t0, 0($sp)
    jal U_Rectangle_area
    addiu $sp, $sp, 4
    s.d $f0, -372($fp)
    addiu $t2, $fp, -84
    sw $t2, -376($fp)
    addiu $sp, $sp, -4
    lw $t0, -376($fp)
    sw $t0, 0($sp)
    jal U_Rectangle_perimeter
    addiu $sp, $sp, 4
    s.d $f0, -384($fp)
    addiu $sp, $sp, -20
    la $t0, str12
    sw $t0, 0($sp)
    l.d $f0, -372($fp)
    s.d $f0, 4($sp)
    l.d $f0, -384($fp)
    s.d $f0, 12($sp)
    jal R_printf
    addiu $sp, $sp, 20
    sw $v0, -388($fp)
    addiu $t2, $fp, -84
    sw $t2, -392($fp)
    li $t0, 2
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -400($fp)
    addiu $sp, $sp, -12
    lw $t0, -392($fp)
    sw $t0, 0($sp)
    l.d $f0, -400($fp)
    s.d $f0, 4($sp)
    jal U_Rectangle_scale
    addiu $sp, $sp, 12
    addiu $t2, $fp, -84
    sw $t2, -404($fp)
    addiu $sp, $sp, -4
    lw $t0, -404($fp)
    sw $t0, 0($sp)
    jal U_Rectangle_area
    addiu $sp, $sp, 4
    s.d $f0, -412($fp)
    addiu $sp, $sp, -12
    la $t0, str13
    sw $t0, 0($sp)
    l.d $f0, -412($fp)
    s.d $f0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 12
    sw $v0, -416($fp)
    addiu $sp, $sp, -12
    li $t0, 1
    sw $t0, 0($sp)
    li $t0, 16
    sw $t0, 4($sp)
    li $t0, 0
    sw $t0, 8($sp)
    jal R___fns_new
    addiu $sp, $sp, 12
    sw $v0, -420($fp)
    addiu $sp, $sp, -20
    lw $t0, -420($fp)
    sw $t0, 0($sp)
    li.d $f0, 2.0
    s.d $f0, 4($sp)
    li.d $f0, 2.0
    s.d $f0, 12($sp)
    jal U_Rectangle_Rectangle__1
    addiu $sp, $sp, 20
    lw $t2, -420($fp)
    sw $t2, -88($fp)
    addiu $sp, $sp, -4
    lw $t0, -88($fp)
    sw $t0, 0($sp)
    jal U_Rectangle_is_square
    addiu $sp, $sp, 4
    sw $v0, -424($fp)
    lw $t2, -424($fp)
    sw $t2, -428($fp)
    addiu $sp, $sp, -4
    lw $t0, -88($fp)
    sw $t0, 0($sp)
    jal U_Rectangle_area
    addiu $sp, $sp, 4
    s.d $f0, -436($fp)
    addiu $sp, $sp, -16
    la $t0, str14
    sw $t0, 0($sp)
    lw $t0, -428($fp)
    sw $t0, 4($sp)
    l.d $f0, -436($fp)
    s.d $f0, 8($sp)
    jal R_printf
    addiu $sp, $sp, 16
    sw $v0, -440($fp)
    addiu $sp, $sp, -4
    lw $t0, -88($fp)
    sw $t0, 0($sp)
    jal R_free
    addiu $sp, $sp, 4
    addiu $t2, $fp, -100
    sw $t2, -444($fp)
    li $t2, 0
    sw $t2, -448($fp)
.L32_L15:
    lw $t0, -448($fp)
    li $t1, 3
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    bne $t2, $zero, .L32_L16
    lw $t0, -448($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -444($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -452($fp)
    addiu $sp, $sp, -4
    lw $t0, -452($fp)
    sw $t0, 0($sp)
    jal U_Counter_Counter
    addiu $sp, $sp, 4
    lw $t0, -448($fp)
    addiu $t2, $t0, 1
    sw $t2, -448($fp)
    j .L32_L15
.L32_L16:
    li $t2, 0
    sw $t2, -104($fp)
.L32_L17:
    lw $t0, -104($fp)
    slti $t2, $t0, 3
    beq $t2, $zero, .L32_L19
    addiu $t2, $fp, -100
    sw $t2, -456($fp)
    lw $t0, -104($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -456($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -460($fp)
    lw $t0, -104($fp)
    li $t1, 2
    mult $t0, $t1
    mflo $t2
    sw $t2, -464($fp)
    addiu $sp, $sp, -8
    lw $t0, -460($fp)
    sw $t0, 0($sp)
    lw $t0, -464($fp)
    sw $t0, 4($sp)
    jal U_Counter_add
    addiu $sp, $sp, 8
.L32_L18:
    lw $t0, -104($fp)
    addiu $t2, $t0, 1
    sw $t2, -104($fp)
    j .L32_L17
.L32_L19:
    addiu $t2, $fp, -100
    sw $t2, -468($fp)
    addiu $sp, $sp, -4
    lw $t0, -468($fp)
    sw $t0, 0($sp)
    jal U_Counter_get
    addiu $sp, $sp, 4
    sw $v0, -472($fp)
    addiu $t2, $fp, -100
    move $t0, $t2
    addiu $t2, $t0, 4
    sw $t2, -476($fp)
    addiu $sp, $sp, -4
    lw $t0, -476($fp)
    sw $t0, 0($sp)
    jal U_Counter_get
    addiu $sp, $sp, 4
    sw $v0, -480($fp)
    addiu $t2, $fp, -100
    move $t0, $t2
    addiu $t2, $t0, 8
    sw $t2, -484($fp)
    addiu $sp, $sp, -4
    lw $t0, -484($fp)
    sw $t0, 0($sp)
    jal U_Counter_get
    addiu $sp, $sp, 4
    sw $v0, -488($fp)
    addiu $sp, $sp, -16
    la $t0, str15
    sw $t0, 0($sp)
    lw $t0, -472($fp)
    sw $t0, 4($sp)
    lw $t0, -480($fp)
    sw $t0, 8($sp)
    lw $t0, -488($fp)
    sw $t0, 12($sp)
    jal R_printf
    addiu $sp, $sp, 16
    sw $v0, -492($fp)
    addiu $sp, $sp, -12
    li $t0, 2
    sw $t0, 0($sp)
    li $t0, 4
    sw $t0, 4($sp)
    li $t0, 4
    sw $t0, 8($sp)
    jal R___fns_new
    addiu $sp, $sp, 12
    sw $v0, -496($fp)
    li $t0, 2
    lw $t1, -496($fp)
    sw $t0, 0($t1)
    lw $t0, -496($fp)
    addiu $t2, $t0, 4
    sw $t2, -500($fp)
    li $t2, 0
    sw $t2, -504($fp)
.L32_L20:
    lw $t0, -504($fp)
    li $t1, 2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    bne $t2, $zero, .L32_L21
    lw $t0, -504($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -500($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -508($fp)
    addiu $sp, $sp, -4
    lw $t0, -508($fp)
    sw $t0, 0($sp)
    jal U_Counter_Counter
    addiu $sp, $sp, 4
    lw $t0, -504($fp)
    addiu $t2, $t0, 1
    sw $t2, -504($fp)
    j .L32_L20
.L32_L21:
    lw $t2, -500($fp)
    sw $t2, -108($fp)
    lw $t0, -108($fp)
    addiu $t2, $t0, 4
    sw $t2, -512($fp)
    addiu $sp, $sp, -4
    lw $t0, -512($fp)
    sw $t0, 0($sp)
    jal U_Counter_increment
    addiu $sp, $sp, 4
    addiu $sp, $sp, -4
    lw $t0, -108($fp)
    sw $t0, 0($sp)
    jal U_Counter_get
    addiu $sp, $sp, 4
    sw $v0, -516($fp)
    lw $t0, -108($fp)
    addiu $t2, $t0, 4
    sw $t2, -520($fp)
    addiu $sp, $sp, -4
    lw $t0, -520($fp)
    sw $t0, 0($sp)
    jal U_Counter_get
    addiu $sp, $sp, 4
    sw $v0, -524($fp)
    jal U_Counter_count
    sw $v0, -528($fp)
    addiu $sp, $sp, -16
    la $t0, str16
    sw $t0, 0($sp)
    lw $t0, -516($fp)
    sw $t0, 4($sp)
    lw $t0, -524($fp)
    sw $t0, 8($sp)
    lw $t0, -528($fp)
    sw $t0, 12($sp)
    jal R_printf
    addiu $sp, $sp, 16
    sw $v0, -532($fp)
    lw $t0, -108($fp)
    beq $t0, $zero, .L32_L22
    lw $t0, -108($fp)
    addiu $t2, $t0, -4
    sw $t2, -536($fp)
    addiu $sp, $sp, -4
    lw $t0, -536($fp)
    sw $t0, 0($sp)
    jal R_free
    addiu $sp, $sp, 4
.L32_L22:
    addiu $t2, $fp, -148
    sw $t2, -540($fp)
    addiu $sp, $sp, -8
    lw $t0, -540($fp)
    sw $t0, 0($sp)
    li $t0, 100
    sw $t0, 4($sp)
    jal U_BankAccount_BankAccount
    addiu $sp, $sp, 8
    addiu $t2, $fp, -148
    sw $t2, -544($fp)
    addiu $sp, $sp, -8
    lw $t0, -544($fp)
    sw $t0, 0($sp)
    li $t0, 50
    sw $t0, 4($sp)
    jal U_BankAccount_deposit
    addiu $sp, $sp, 8
    addiu $t2, $fp, -148
    sw $t2, -548($fp)
    addiu $sp, $sp, -8
    lw $t0, -548($fp)
    sw $t0, 0($sp)
    li $t0, 500
    sw $t0, 4($sp)
    jal U_BankAccount_withdraw
    addiu $sp, $sp, 8
    sw $v0, -552($fp)
    lw $t2, -552($fp)
    sw $t2, -556($fp)
    addiu $t2, $fp, -148
    sw $t2, -560($fp)
    addiu $sp, $sp, -8
    lw $t0, -560($fp)
    sw $t0, 0($sp)
    li $t0, 30
    sw $t0, 4($sp)
    jal U_BankAccount_withdraw
    addiu $sp, $sp, 8
    sw $v0, -564($fp)
    lw $t2, -564($fp)
    sw $t2, -568($fp)
    addiu $sp, $sp, -12
    la $t0, str17
    sw $t0, 0($sp)
    lw $t0, -556($fp)
    sw $t0, 4($sp)
    lw $t0, -568($fp)
    sw $t0, 8($sp)
    jal R_printf
    addiu $sp, $sp, 12
    sw $v0, -572($fp)
    addiu $t2, $fp, -148
    sw $t2, -576($fp)
    addiu $sp, $sp, -4
    lw $t0, -576($fp)
    sw $t0, 0($sp)
    jal U_BankAccount_get_balance
    addiu $sp, $sp, 4
    sw $v0, -580($fp)
    addiu $sp, $sp, -8
    la $t0, str18
    sw $t0, 0($sp)
    lw $t0, -580($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -584($fp)
    addiu $t2, $fp, -148
    sw $t2, -588($fp)
    addiu $sp, $sp, -4
    lw $t0, -588($fp)
    sw $t0, 0($sp)
    jal U_BankAccount_print_history
    addiu $sp, $sp, 4
    addiu $sp, $sp, -4
    la $t0, str19
    sw $t0, 0($sp)
    jal R_printf
    addiu $sp, $sp, 4
    sw $v0, -592($fp)
    addiu $t2, $fp, -152
    sw $t2, -596($fp)
    addiu $sp, $sp, -8
    lw $t0, -596($fp)
    sw $t0, 0($sp)
    li $t0, 1
    sw $t0, 4($sp)
    jal U_Tracer_Tracer
    addiu $sp, $sp, 8
    addiu $t2, $fp, -156
    sw $t2, -600($fp)
    addiu $sp, $sp, -8
    lw $t0, -600($fp)
    sw $t0, 0($sp)
    li $t0, 2
    sw $t0, 4($sp)
    jal U_Tracer_Tracer
    addiu $sp, $sp, 8
    addiu $t2, $fp, -160
    sw $t2, -604($fp)
    addiu $sp, $sp, -8
    lw $t0, -604($fp)
    sw $t0, 0($sp)
    li $t0, 3
    sw $t0, 4($sp)
    jal U_Tracer_Tracer
    addiu $sp, $sp, 8
    addiu $sp, $sp, -4
    la $t0, str20
    sw $t0, 0($sp)
    jal R_printf
    addiu $sp, $sp, 4
    sw $v0, -608($fp)
    addiu $t2, $fp, -160
    sw $t2, -612($fp)
    addiu $sp, $sp, -4
    lw $t0, -612($fp)
    sw $t0, 0($sp)
    jal U_Tracer__dtor
    addiu $sp, $sp, 4
    addiu $t2, $fp, -156
    sw $t2, -616($fp)
    addiu $sp, $sp, -4
    lw $t0, -616($fp)
    sw $t0, 0($sp)
    jal U_Tracer__dtor
    addiu $sp, $sp, 4
    li $t2, 0
    sw $t2, -164($fp)
.L32_L23:
    lw $t0, -164($fp)
    slti $t2, $t0, 2
    beq $t2, $zero, .L32_L25
    addiu $t2, $fp, -168
    sw $t2, -620($fp)
    li $t0, 10
    lw $t1, -164($fp)
    addu $t2, $t0, $t1
    sw $t2, -624($fp)
    addiu $sp, $sp, -8
    lw $t0, -620($fp)
    sw $t0, 0($sp)
    lw $t0, -624($fp)
    sw $t0, 4($sp)
    jal U_Tracer_Tracer
    addiu $sp, $sp, 8
    lw $t0, -164($fp)
    li $t1, 1
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .L32_L26
    addiu $t2, $fp, -168
    sw $t2, -628($fp)
    addiu $sp, $sp, -4
    lw $t0, -628($fp)
    sw $t0, 0($sp)
    jal U_Tracer__dtor
    addiu $sp, $sp, 4
    j .L32_L25
.L32_L26:
    addiu $t2, $fp, -168
    sw $t2, -632($fp)
    addiu $sp, $sp, -4
    lw $t0, -632($fp)
    sw $t0, 0($sp)
    jal U_Tracer__dtor
    addiu $sp, $sp, 4
.L32_L24:
    lw $t0, -164($fp)
    addiu $t2, $t0, 1
    sw $t2, -164($fp)
    j .L32_L23
.L32_L25:
    addiu $sp, $sp, -4
    la $t0, str21
    sw $t0, 0($sp)
    jal R_printf
    addiu $sp, $sp, 4
    sw $v0, -636($fp)
    addiu $t2, $fp, -152
    sw $t2, -640($fp)
    addiu $sp, $sp, -4
    lw $t0, -640($fp)
    sw $t0, 0($sp)
    jal U_Tracer__dtor
    addiu $sp, $sp, 4
    addiu $t2, $fp, -12
    sw $t2, -644($fp)
    addiu $sp, $sp, -4
    lw $t0, -644($fp)
    sw $t0, 0($sp)
    jal U_Stack__dtor
    addiu $sp, $sp, 4
    li $v0, 0
.Lret32:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

# ==== FNS runtime: syscall stubs (src/runtime.s) ====

# ===========================================================================
# FNS runtime: system-call stubs for the spim simulator.
#
# These are the only hand-written parts of the runtime.  Everything else
# (printf, scanf, files, strings, malloc, math, ...) is written in C in
# src/lib/libfns.c and compiled to MIPS by fnsc itself (`fnsc --runtime`).
#
# Calling convention (same as compiled code): arguments are on the stack,
# arg0 at 0($sp), a double takes two words; integer results in $v0, double
# results in $f0.  The stubs use only $a0-$a2, $v0, $f0, $f12.
# ===========================================================================
.text

__sys_putc:                 # void __sys_putc(int c)          print_char
    lw   $a0, 0($sp)
    li   $v0, 11
    syscall
    jr   $ra

__sys_open:                 # int __sys_open(char *name, int flags, int mode)
    lw   $a0, 0($sp)
    lw   $a1, 4($sp)
    lw   $a2, 8($sp)
    li   $v0, 13
    syscall
    jr   $ra

__sys_read:                 # int __sys_read(int fd, char *buf, int n)   0 at EOF
    lw   $a0, 0($sp)
    lw   $a1, 4($sp)
    lw   $a2, 8($sp)
    li   $v0, 14
    syscall
    jr   $ra

__sys_write:                # int __sys_write(int fd, char *buf, int n)
    lw   $a0, 0($sp)
    lw   $a1, 4($sp)
    lw   $a2, 8($sp)
    li   $v0, 15
    syscall
    jr   $ra

__sys_close:                # int __sys_close(int fd)
    lw   $a0, 0($sp)
    li   $v0, 16
    syscall
    jr   $ra

__sys_sbrk:                 # void *__sys_sbrk(int nbytes)
    lw   $a0, 0($sp)
    li   $v0, 9
    syscall
    jr   $ra

__sys_exit:                 # void __sys_exit(int code)       exit2
    lw   $a0, 0($sp)
    li   $v0, 17
    syscall
    jr   $ra

__sys_sqrt:                 # double __sys_sqrt(double x)
    l.d  $f12, 0($sp)
    sqrt.d $f0, $f12
    jr   $ra

__pure_virtual:             # vtable slot of a pure virtual method
    la   $a0, __pure_msg
    li   $v0, 4
    syscall
    li   $a0, 134
    li   $v0, 17
    syscall

.data
__pure_msg: .asciiz "pure virtual method called\n"
.text



# ==== FNS runtime: C library (src/lib/libfns.c), functions used by this program ====

# FNS runtime library (compiled from src/lib/libfns.c by fnsc --runtime)

.data
Rstr0: .asciiz "Aborted\n"
Rstr1: .asciiz "std::bad_array_new_length"
Rstr2: .asciiz "std::bad_alloc"
Rstr3: .asciiz "terminate called after throwing an instance of '"
Rstr4: .asciiz "'\n  what():  "
Rstr5: .asciiz "0123456789ABCDEF"
Rstr6: .asciiz "0123456789abcdef"
Rstr7: .asciiz "NAN"
Rstr8: .asciiz "nan"
Rstr9: .asciiz "INF"
Rstr10: .asciiz "inf"
Rstr11: .asciiz ""
Rstr12: .asciiz "(nil)"
Rstr13: .asciiz "(null)"
.align 2
R___fns_free_list: .word 0
.align 2
R___fns_exit_list: .space 4
.align 2
R___fns_rtab: .space 136
.align 2
R___fns_ridx: .word 0
.align 2
R___fns_rseeded: .word 0
.align 2
R___fns_tok_next: .word 0
.align 2
R___fns_std: .space 128

.text





R_malloc:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -64
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
    la $t2, R___fns_free_list
    lw $t2, 0($t2)
    sw $t2, -16($fp)
    lw $t0, 0($fp)
    li $t1, 2147483632
    sltu $t2, $t1, $t0
    beq $t2, $zero, .R4_L23
    li $v0, 0
    j .Rret4
.R4_L23:
    li $t2, 0
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R4_L24
    li $t2, 1
    sw $t2, 0($fp)
.R4_L24:
    li $t2, 7
    lw $t0, 0($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -24($fp)
    li $t2, 7
    move $t0, $t2
    nor $t2, $t0, $zero
    lw $t0, -24($fp)
    move $t1, $t2
    and $t2, $t0, $t1
    sw $t2, 0($fp)
.R4_L25:
    lw $t0, -16($fp)
    beq $t0, $zero, .R4_L26
    lw $t1, -16($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    lw $t1, 0($fp)
    sltu $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R4_L27
    lw $t1, -16($fp)
    lw $t2, 0($t1)
    sw $t2, -28($fp)
    li $t2, 24
    lw $t0, 0($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t0, -28($fp)
    move $t1, $t2
    sltu $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R4_L28
    lw $t2, -16($fp)
    move $t0, $t2
    addiu $t2, $t0, 8
    sw $t2, -32($fp)
    lw $t2, 0($fp)
    lw $t0, -32($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -20($fp)
    lw $t1, -16($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    lw $t1, 0($fp)
    subu $t2, $t0, $t1
    sw $t2, -36($fp)
    li $t2, 8
    lw $t0, -36($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t1, -20($fp)
    sw $t2, 0($t1)
    lw $t0, -20($fp)
    addiu $t2, $t0, 4
    sw $t2, -40($fp)
    lw $t0, -16($fp)
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    lw $t1, -40($fp)
    sw $t2, 0($t1)
    lw $t0, 0($fp)
    lw $t1, -16($fp)
    sw $t0, 0($t1)
    lw $t0, -12($fp)
    beq $t0, $zero, .R4_L29
    lw $t0, -12($fp)
    addiu $t2, $t0, 4
    lw $t0, -20($fp)
    sw $t0, 0($t2)
    j .R4_L30
.R4_L29:
    lw $t2, -20($fp)
    la $t8, R___fns_free_list
    sw $t2, 0($t8)
.R4_L30:
    j .R4_L31
.R4_L28:
    lw $t0, -12($fp)
    beq $t0, $zero, .R4_L32
    lw $t0, -12($fp)
    addiu $t2, $t0, 4
    sw $t2, -44($fp)
    lw $t0, -16($fp)
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    lw $t1, -44($fp)
    sw $t2, 0($t1)
    j .R4_L33
.R4_L32:
    lw $t0, -16($fp)
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    la $t8, R___fns_free_list
    sw $t2, 0($t8)
.R4_L33:
.R4_L31:
    lw $t0, -16($fp)
    addiu $t2, $t0, 4
    sw $t2, -48($fp)
    li $t2, 0
    lw $t1, -48($fp)
    sw $t2, 0($t1)
    lw $t2, -16($fp)
    move $t0, $t2
    addiu $t2, $t0, 8
    move $v0, $t2
    j .Rret4
.R4_L27:
    lw $t2, -16($fp)
    sw $t2, -12($fp)
    lw $t0, -16($fp)
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    sw $t2, -16($fp)
    j .R4_L25
.R4_L26:
    lw $t2, 0($fp)
    move $t0, $t2
    addiu $t2, $t0, 8
    sw $t2, -52($fp)
    addiu $sp, $sp, -4
    lw $t0, -52($fp)
    sw $t0, 0($sp)
    jal __sys_sbrk
    addiu $sp, $sp, 4
    sw $v0, -56($fp)
    lw $t2, -56($fp)
    sw $t2, -16($fp)
    li $t2, 0
    lw $t0, -16($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R4_L35
    lw $t2, -16($fp)
    move $t0, $t2
    li $t1, -1
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R4_L35
    li $t2, 0
    sw $t2, -60($fp)
    j .R4_L36
.R4_L35:
    li $t2, 1
    sw $t2, -60($fp)
.R4_L36:
    lw $t0, -60($fp)
    beq $t0, $zero, .R4_L34
    li $v0, 0
    j .Rret4
.R4_L34:
    lw $t0, 0($fp)
    lw $t1, -16($fp)
    sw $t0, 0($t1)
    lw $t0, -16($fp)
    addiu $t2, $t0, 4
    sw $t2, -64($fp)
    li $t2, 0
    lw $t1, -64($fp)
    sw $t2, 0($t1)
    lw $t2, -16($fp)
    move $t0, $t2
    addiu $t2, $t0, 8
    move $v0, $t2
.Rret4:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_free:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 0($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R5_L37
    j .Rret5
.R5_L37:
    lw $t2, 0($fp)
    move $t0, $t2
    addiu $t2, $t0, -8
    sw $t2, -12($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 4
    la $t0, R___fns_free_list
    lw $t0, 0($t0)
    sw $t0, 0($t2)
    lw $t2, -12($fp)
    la $t8, R___fns_free_list
    sw $t2, 0($t8)
.Rret5:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra






R_abort:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    la $t2, Rstr0
    sw $t2, -12($fp)
.R11_L49:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R11_L50
    lw $t2, -12($fp)
    sw $t2, -16($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    lw $t1, -16($fp)
    lb $t2, 0($t1)
    sw $t2, -20($fp)
    addiu $sp, $sp, -4
    lw $t0, -20($fp)
    sw $t0, 0($sp)
    jal __sys_putc
    addiu $sp, $sp, 4
    j .R11_L49
.R11_L50:
    addiu $sp, $sp, -4
    li $t0, 134
    sw $t0, 0($sp)
    jal __sys_exit
    addiu $sp, $sp, 4
.Rret11:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_new:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -64
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
    li $t2, 0
    sw $t2, -20($fp)
    lw $t0, 0($fp)
    slti $t2, $t0, 0
    bne $t2, $zero, .R12_L52
    lw $t0, 4($fp)
    beq $t0, $zero, .R12_L54
    lw $t2, 0($fp)
    sw $t2, -24($fp)
    li $t0, 2147483632
    lw $t1, 8($fp)
    subu $t2, $t0, $t1
    move $t0, $t2
    lw $t1, 4($fp)
    divu $t0, $t1
    mflo $t2
    lw $t0, -24($fp)
    move $t1, $t2
    sltu $t2, $t1, $t0
    beq $t2, $zero, .R12_L54
    li $t2, 1
    sw $t2, -28($fp)
    j .R12_L55
.R12_L54:
    li $t2, 0
    sw $t2, -28($fp)
.R12_L55:
    lw $t0, -28($fp)
    bne $t0, $zero, .R12_L52
    li $t2, 0
    sw $t2, -32($fp)
    j .R12_L53
.R12_L52:
    li $t2, 1
    sw $t2, -32($fp)
.R12_L53:
    lw $t0, -32($fp)
    beq $t0, $zero, .R12_L51
    la $t2, Rstr1
    sw $t2, -12($fp)
    j .R12_L56
.R12_L51:
    lw $t2, 0($fp)
    move $t0, $t2
    lw $t1, 4($fp)
    mult $t0, $t1
    mflo $t2
    move $t0, $t2
    lw $t1, 8($fp)
    addu $t2, $t0, $t1
    sw $t2, -36($fp)
    addiu $sp, $sp, -4
    lw $t0, -36($fp)
    sw $t0, 0($sp)
    jal R_malloc
    addiu $sp, $sp, 4
    sw $v0, -40($fp)
    lw $t2, -40($fp)
    sw $t2, -20($fp)
    lw $t0, -40($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R12_L57
    la $t2, Rstr2
    sw $t2, -12($fp)
.R12_L57:
.R12_L56:
    lw $t0, -12($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R12_L58
    lw $v0, -20($fp)
    j .Rret12
.R12_L58:
    la $t2, Rstr3
    sw $t2, -16($fp)
.R12_L59:
    lw $t1, -16($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R12_L61
    lw $t1, -16($fp)
    lb $t2, 0($t1)
    sw $t2, -44($fp)
    addiu $sp, $sp, -4
    lw $t0, -44($fp)
    sw $t0, 0($sp)
    jal __sys_putc
    addiu $sp, $sp, 4
.R12_L60:
    lw $t0, -16($fp)
    addiu $t2, $t0, 1
    sw $t2, -16($fp)
    j .R12_L59
.R12_L61:
    lw $t2, -12($fp)
    sw $t2, -16($fp)
.R12_L62:
    lw $t1, -16($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R12_L64
    lw $t1, -16($fp)
    lb $t2, 0($t1)
    sw $t2, -48($fp)
    addiu $sp, $sp, -4
    lw $t0, -48($fp)
    sw $t0, 0($sp)
    jal __sys_putc
    addiu $sp, $sp, 4
.R12_L63:
    lw $t0, -16($fp)
    addiu $t2, $t0, 1
    sw $t2, -16($fp)
    j .R12_L62
.R12_L64:
    la $t2, Rstr4
    sw $t2, -16($fp)
.R12_L65:
    lw $t1, -16($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R12_L67
    lw $t1, -16($fp)
    lb $t2, 0($t1)
    sw $t2, -52($fp)
    addiu $sp, $sp, -4
    lw $t0, -52($fp)
    sw $t0, 0($sp)
    jal __sys_putc
    addiu $sp, $sp, 4
.R12_L66:
    lw $t0, -16($fp)
    addiu $t2, $t0, 1
    sw $t2, -16($fp)
    j .R12_L65
.R12_L67:
    lw $t2, -12($fp)
    sw $t2, -16($fp)
.R12_L68:
    lw $t1, -16($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R12_L70
    lw $t1, -16($fp)
    lb $t2, 0($t1)
    sw $t2, -56($fp)
    addiu $sp, $sp, -4
    lw $t0, -56($fp)
    sw $t0, 0($sp)
    jal __sys_putc
    addiu $sp, $sp, 4
.R12_L69:
    lw $t0, -16($fp)
    addiu $t2, $t0, 1
    sw $t2, -16($fp)
    j .R12_L68
.R12_L70:
    li $t2, 10
    sw $t2, -60($fp)
    addiu $sp, $sp, -4
    lw $t0, -60($fp)
    sw $t0, 0($sp)
    jal __sys_putc
    addiu $sp, $sp, 4
    jal R_abort
    li $v0, 0
.Rret12:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra






R_isdigit:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 48
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R18_L88
    li $t2, 57
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R18_L88
    li $t2, 1
    sw $t2, -12($fp)
    j .R18_L89
.R18_L88:
    li $t2, 0
    sw $t2, -12($fp)
.R18_L89:
    lw $v0, -12($fp)
.Rret18:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra











R_strlen:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
.R29_L126:
    lw $t0, 0($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    beq $t2, $zero, .R29_L127
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R29_L126
.R29_L127:
    lw $v0, -12($fp)
.Rret29:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra
















R___fns_trunc:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -80
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $t2, $fp, -16
    sw $t2, -24($fp)
    l.d $f0, 0($fp)
    lw $t1, -24($fp)
    s.d $f0, 0($t1)
    addiu $t2, $fp, -16
    move $t0, $t2
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    move $t0, $t2
    srl $t2, $t0, 20
    sw $t2, -28($fp)
    li $t2, 2047
    lw $t0, -28($fp)
    move $t1, $t2
    and $t2, $t0, $t1
    move $t0, $t2
    addiu $t2, $t0, -1023
    sw $t2, -20($fp)
    lw $t0, -20($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R45_L189
    addiu $t2, $fp, -16
    sw $t2, -32($fp)
    li $t2, 0
    lw $t1, -32($fp)
    sw $t2, 0($t1)
    addiu $t2, $fp, -16
    move $t0, $t2
    addiu $t2, $t0, 4
    sw $t2, -36($fp)
    addiu $t2, $fp, -16
    move $t0, $t2
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    move $t0, $t2
    li $t1, -2147483648
    and $t2, $t0, $t1
    lw $t1, -36($fp)
    sw $t2, 0($t1)
    addiu $t2, $fp, -16
    sw $t2, -40($fp)
    lw $t1, -40($fp)
    l.d $f0, 0($t1)
    s.d $f0, -48($fp)
    l.d $f0, -48($fp)
    j .Rret45
.R45_L189:
    lw $t0, -20($fp)
    li $t1, 52
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R45_L190
    l.d $f0, 0($fp)
    j .Rret45
.R45_L190:
    lw $t0, -20($fp)
    slti $t2, $t0, 20
    beq $t2, $zero, .R45_L191
    addiu $t2, $fp, -16
    move $t0, $t2
    addiu $t2, $t0, 4
    sw $t2, -52($fp)
    addiu $t2, $fp, -16
    move $t0, $t2
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    sw $t2, -56($fp)
    li $t0, 1048575
    lw $t1, -20($fp)
    srlv $t2, $t0, $t1
    move $t0, $t2
    nor $t2, $t0, $zero
    lw $t0, -56($fp)
    move $t1, $t2
    and $t2, $t0, $t1
    lw $t1, -52($fp)
    sw $t2, 0($t1)
    addiu $t2, $fp, -16
    sw $t2, -60($fp)
    li $t2, 0
    lw $t1, -60($fp)
    sw $t2, 0($t1)
    j .R45_L192
.R45_L191:
    addiu $t2, $fp, -16
    sw $t2, -64($fp)
    addiu $t2, $fp, -16
    lw $t2, 0($t2)
    sw $t2, -68($fp)
    lw $t0, -20($fp)
    addiu $t2, $t0, -20
    li $t0, -1
    move $t1, $t2
    srlv $t2, $t0, $t1
    move $t0, $t2
    nor $t2, $t0, $zero
    lw $t0, -68($fp)
    move $t1, $t2
    and $t2, $t0, $t1
    lw $t1, -64($fp)
    sw $t2, 0($t1)
.R45_L192:
    addiu $t2, $fp, -16
    sw $t2, -72($fp)
    lw $t1, -72($fp)
    l.d $f0, 0($t1)
    s.d $f0, -80($fp)
    l.d $f0, -80($fp)
.Rret45:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_floor:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -8
    l.d $f0, 0($fp)
    s.d $f0, 0($sp)
    jal R___fns_trunc
    addiu $sp, $sp, 8
    s.d $f0, -24($fp)
    l.d $f0, -24($fp)
    s.d $f0, -16($fp)
    l.d $f4, -16($fp)
    l.d $f6, 0($fp)
    li $t2, 0
    c.lt.d $f6, $f4
    bc1f .Rfc1
    li $t2, 1
.Rfc1:
    beq $t2, $zero, .R46_L193
    l.d $f4, -16($fp)
    li.d $f6, 1.0
    sub.d $f0, $f4, $f6
    s.d $f0, -32($fp)
    l.d $f0, -32($fp)
    s.d $f0, -16($fp)
.R46_L193:
    l.d $f0, -16($fp)
.Rret46:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra



R_fmod:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -56
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t0, 0
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -16($fp)
    l.d $f4, 8($fp)
    l.d $f6, -16($fp)
    li $t2, 0
    c.eq.d $f4, $f6
    bc1f .Rfc4
    li $t2, 1
.Rfc4:
    beq $t2, $zero, .R49_L196
    li.d $f4, 0.0
    li.d $f6, 0.0
    div.d $f0, $f4, $f6
    s.d $f0, -24($fp)
    l.d $f0, -24($fp)
    j .Rret49
.R49_L196:
    l.d $f4, 0($fp)
    l.d $f6, 8($fp)
    div.d $f0, $f4, $f6
    s.d $f0, -32($fp)
    addiu $sp, $sp, -8
    l.d $f0, -32($fp)
    s.d $f0, 0($sp)
    jal R___fns_trunc
    addiu $sp, $sp, 8
    s.d $f0, -40($fp)
    l.d $f4, -40($fp)
    l.d $f6, 8($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -48($fp)
    l.d $f4, 0($fp)
    l.d $f6, -48($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -56($fp)
    l.d $f0, -56($fp)
.Rret49:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra















R___fns_pow10:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -64
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li.d $f0, 1.0
    s.d $f0, -16($fp)
    li.d $f0, 10.0
    s.d $f0, -24($fp)
    lw $t0, 0($fp)
    slti $t2, $t0, 0
    sw $t2, -28($fp)
    lw $t0, -28($fp)
    beq $t0, $zero, .R64_L277
    lw $t0, 0($fp)
    subu $t2, $zero, $t0
    sw $t2, 0($fp)
.R64_L277:
.R64_L278:
    lw $t0, 0($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R64_L279
    lw $t0, 0($fp)
    andi $t2, $t0, 1
    beq $t2, $zero, .R64_L280
    l.d $f4, -16($fp)
    l.d $f6, -24($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -36($fp)
    l.d $f0, -36($fp)
    s.d $f0, -16($fp)
.R64_L280:
    l.d $f4, -24($fp)
    l.d $f6, -24($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -44($fp)
    l.d $f0, -44($fp)
    s.d $f0, -24($fp)
    lw $t0, 0($fp)
    sra $t2, $t0, 1
    sw $t2, 0($fp)
    j .R64_L278
.R64_L279:
    lw $t0, -28($fp)
    beq $t0, $zero, .R64_L281
    li.d $f4, 1.0
    l.d $f6, -16($fp)
    div.d $f0, $f4, $f6
    s.d $f0, -52($fp)
    l.d $f0, -52($fp)
    s.d $f0, -60($fp)
    j .R64_L282
.R64_L281:
    l.d $f0, -16($fp)
    s.d $f0, -60($fp)
.R64_L282:
    l.d $f0, -60($fp)
.Rret64:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra





R___fns_file:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t2, 0($fp)
    sw $t2, -12($fp)
    li $t2, 1
    lw $t0, -12($fp)
    move $t1, $t2
    sltu $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R69_L336
    li $t2, 3
    lw $t0, -12($fp)
    move $t1, $t2
    sltu $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R69_L336
    li $t2, 1
    sw $t2, -20($fp)
    j .R69_L337
.R69_L336:
    li $t2, 0
    sw $t2, -20($fp)
.R69_L337:
    lw $t0, -20($fp)
    beq $t0, $zero, .R69_L335
    la $t2, R___fns_std
    sw $t2, -24($fp)
    lw $t0, -12($fp)
    li $t1, 32
    mult $t0, $t1
    mflo $t2
    lw $t0, -24($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -16($fp)
    lw $t2, -12($fp)
    move $t0, $t2
    addiu $t2, $t0, -1
    lw $t1, -16($fp)
    sw $t2, 0($t1)
    lw $t0, -16($fp)
    addiu $t2, $t0, 4
    sw $t2, -28($fp)
    li $t2, 1
    lw $t0, -12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R69_L338
    li $t2, 1
    sw $t2, -32($fp)
    j .R69_L339
.R69_L338:
    li $t2, 2
    sw $t2, -32($fp)
.R69_L339:
    lw $t0, -32($fp)
    lw $t1, -28($fp)
    sw $t0, 0($t1)
    lw $v0, -16($fp)
    j .Rret69
.R69_L335:
    lw $v0, 0($fp)
.Rret69:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra









R_fputc:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -48
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 4($fp)
    sw $t0, 0($sp)
    jal R___fns_file
    addiu $sp, $sp, 4
    sw $v0, -20($fp)
    lw $t2, -20($fp)
    sw $t2, -12($fp)
    lw $t2, 0($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    sw $t2, -16($fp)
    lw $t0, -12($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R78_L394
    li $v0, -1
    j .Rret78
.R78_L394:
    lw $t1, -12($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    li $t1, 1
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R78_L396
    lw $t1, -12($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    li $t1, 2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R78_L396
    li $t2, 0
    sw $t2, -24($fp)
    j .R78_L397
.R78_L396:
    li $t2, 1
    sw $t2, -24($fp)
.R78_L397:
    lw $t0, -24($fp)
    beq $t0, $zero, .R78_L395
    lw $t0, 0($fp)
    andi $t2, $t0, 255
    sw $t2, -28($fp)
    addiu $sp, $sp, -4
    lw $t0, -28($fp)
    sw $t0, 0($sp)
    jal __sys_putc
    addiu $sp, $sp, 4
    lw $t0, 0($fp)
    andi $t2, $t0, 255
    move $v0, $t2
    j .Rret78
.R78_L395:
    lw $t1, -12($fp)
    lw $t2, 0($t1)
    sw $t2, -32($fp)
    addiu $t2, $fp, -16
    sw $t2, -36($fp)
    addiu $sp, $sp, -12
    lw $t0, -32($fp)
    sw $t0, 0($sp)
    lw $t0, -36($fp)
    sw $t0, 4($sp)
    li $t0, 1
    sw $t0, 8($sp)
    jal __sys_write
    addiu $sp, $sp, 12
    sw $v0, -40($fp)
    lw $t0, -40($fp)
    li $t1, 1
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    beq $t2, $zero, .R78_L398
    lw $t0, -12($fp)
    addiu $t2, $t0, 16
    li $t0, 1
    sw $t0, 0($t2)
    li $v0, -1
    j .Rret78
.R78_L398:
    lw $t0, -12($fp)
    addiu $t2, $t0, 20
    lw $t2, 0($t2)
    move $t0, $t2
    li $t1, 0
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R78_L399
    lw $t0, -12($fp)
    addiu $t2, $t0, 20
    sw $t2, -44($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 24
    lw $t2, 0($t2)
    move $t0, $t2
    andi $t2, $t0, 1024
    beq $t2, $zero, .R78_L400
    li $t2, -1
    sw $t2, -48($fp)
    j .R78_L401
.R78_L400:
    lw $t0, -12($fp)
    addiu $t2, $t0, 20
    lw $t2, 0($t2)
    move $t0, $t2
    addiu $t2, $t0, 1
    sw $t2, -48($fp)
.R78_L401:
    lw $t0, -48($fp)
    lw $t1, -44($fp)
    sw $t0, 0($t1)
.R78_L399:
    lw $t0, 0($fp)
    andi $t2, $t0, 255
    move $v0, $t2
.Rret78:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra














R___fns_put:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -40
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    beq $t2, $zero, .R92_L436
    lw $t0, 0($fp)
    addiu $t2, $t0, 12
    lw $t2, 0($t2)
    move $t0, $t2
    slti $t2, $t0, 0
    bne $t2, $zero, .R92_L438
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    lw $t2, 0($t2)
    sw $t2, -12($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 12
    lw $t2, 0($t2)
    move $t0, $t2
    addiu $t2, $t0, -1
    lw $t0, -12($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    bne $t2, $zero, .R92_L438
    li $t2, 0
    sw $t2, -16($fp)
    j .R92_L439
.R92_L438:
    li $t2, 1
    sw $t2, -16($fp)
.R92_L439:
    lw $t0, -16($fp)
    beq $t0, $zero, .R92_L437
    lw $t0, 0($fp)
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    sw $t2, -20($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    lw $t2, 0($t2)
    lw $t0, -20($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -24($fp)
    lw $t2, 4($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -24($fp)
    sb $t2, 0($t1)
.R92_L437:
    j .R92_L440
.R92_L436:
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    beq $t2, $zero, .R92_L441
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    sw $t2, -28($fp)
    addiu $sp, $sp, -8
    lw $t0, 4($fp)
    sw $t0, 0($sp)
    lw $t0, -28($fp)
    sw $t0, 4($sp)
    jal R_fputc
    addiu $sp, $sp, 8
    sw $v0, -32($fp)
.R92_L441:
.R92_L440:
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    sw $t2, -36($fp)
    lw $t1, -36($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    addiu $t2, $t0, 1
    lw $t1, -36($fp)
    sw $t2, 0($t1)
.Rret92:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_pad:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
.R93_L442:
    lw $t2, 8($fp)
    sw $t2, -12($fp)
    lw $t0, 8($fp)
    addiu $t2, $t0, -1
    sw $t2, 8($fp)
    lw $t0, -12($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R93_L443
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, 4($fp)
    sw $t0, 4($sp)
    jal R___fns_put
    addiu $sp, $sp, 8
    j .R93_L442
.R93_L443:
.Rret93:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_emit:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -56
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 4($fp)
    sw $t0, 0($sp)
    jal R_strlen
    addiu $sp, $sp, 4
    sw $v0, -24($fp)
    lw $t2, -24($fp)
    sw $t2, -12($fp)
    lw $t0, 16($fp)
    lw $t1, -12($fp)
    subu $t2, $t0, $t1
    move $t0, $t2
    lw $t1, 12($fp)
    subu $t2, $t0, $t1
    sw $t2, -16($fp)
    lw $t0, 20($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R94_L445
    lw $t0, 24($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R94_L445
    li $t2, 1
    sw $t2, -28($fp)
    j .R94_L446
.R94_L445:
    li $t2, 0
    sw $t2, -28($fp)
.R94_L446:
    lw $t0, -28($fp)
    beq $t0, $zero, .R94_L444
    li $t2, 32
    sw $t2, -32($fp)
    addiu $sp, $sp, -12
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -32($fp)
    sw $t0, 4($sp)
    lw $t0, -16($fp)
    sw $t0, 8($sp)
    jal R___fns_pad
    addiu $sp, $sp, 12
.R94_L444:
    li $t2, 0
    sw $t2, -20($fp)
.R94_L447:
    lw $t0, -20($fp)
    lw $t1, -12($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R94_L449
    lw $t0, 4($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -36($fp)
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -36($fp)
    sw $t0, 4($sp)
    jal R___fns_put
    addiu $sp, $sp, 8
.R94_L448:
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .R94_L447
.R94_L449:
    lw $t0, 20($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R94_L451
    lw $t0, 24($fp)
    beq $t0, $zero, .R94_L451
    li $t2, 1
    sw $t2, -40($fp)
    j .R94_L452
.R94_L451:
    li $t2, 0
    sw $t2, -40($fp)
.R94_L452:
    lw $t0, -40($fp)
    beq $t0, $zero, .R94_L450
    li $t2, 48
    sw $t2, -44($fp)
    addiu $sp, $sp, -12
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -44($fp)
    sw $t0, 4($sp)
    lw $t0, -16($fp)
    sw $t0, 8($sp)
    jal R___fns_pad
    addiu $sp, $sp, 12
.R94_L450:
    li $t2, 0
    sw $t2, -20($fp)
.R94_L453:
    lw $t0, -20($fp)
    lw $t1, 12($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R94_L455
    lw $t0, 8($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -48($fp)
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -48($fp)
    sw $t0, 4($sp)
    jal R___fns_put
    addiu $sp, $sp, 8
.R94_L454:
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .R94_L453
.R94_L455:
    lw $t0, 20($fp)
    beq $t0, $zero, .R94_L456
    li $t2, 32
    sw $t2, -52($fp)
    addiu $sp, $sp, -12
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -52($fp)
    sw $t0, 4($sp)
    lw $t0, -16($fp)
    sw $t0, 8($sp)
    jal R___fns_pad
    addiu $sp, $sp, 12
.R94_L456:
.Rret94:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_fmt_int:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -272
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 16($fp)
    beq $t0, $zero, .R95_L457
    la $t2, Rstr5
    sw $t2, -120($fp)
    j .R95_L458
.R95_L457:
    la $t2, Rstr6
    sw $t2, -120($fp)
.R95_L458:
    lw $t2, -120($fp)
    sw $t2, -104($fp)
    li $t2, 0
    sw $t2, -108($fp)
    li $t2, 0
    sw $t2, -112($fp)
    li $t2, 0
    sw $t2, -116($fp)
.R95_L459:
    lw $t0, 4($fp)
    beq $t0, $zero, .R95_L460
    addiu $t2, $fp, -48
    sw $t2, -124($fp)
    lw $t2, -108($fp)
    sw $t2, -128($fp)
    lw $t0, -108($fp)
    addiu $t2, $t0, 1
    sw $t2, -108($fp)
    lw $t0, -124($fp)
    lw $t1, -128($fp)
    addu $t2, $t0, $t1
    sw $t2, -132($fp)
    lw $t2, 12($fp)
    lw $t0, 4($fp)
    move $t1, $t2
    divu $t0, $t1
    mfhi $t2
    lw $t0, -104($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -132($fp)
    sb $t2, 0($t1)
    lw $t2, 12($fp)
    lw $t0, 4($fp)
    move $t1, $t2
    divu $t0, $t1
    mflo $t2
    sw $t2, 4($fp)
    j .R95_L459
.R95_L460:
    lw $t0, 36($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R95_L461
    li $t2, 1
    sw $t2, 36($fp)
    j .R95_L462
.R95_L461:
    li $t2, 0
    sw $t2, 44($fp)
.R95_L462:
.R95_L463:
    lw $t0, -108($fp)
    lw $t1, 36($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R95_L464
    addiu $t2, $fp, -48
    sw $t2, -136($fp)
    lw $t2, -108($fp)
    sw $t2, -140($fp)
    lw $t0, -108($fp)
    addiu $t2, $t0, 1
    sw $t2, -108($fp)
    lw $t0, -136($fp)
    lw $t1, -140($fp)
    addu $t2, $t0, $t1
    li $t0, 48
    sb $t0, 0($t2)
    j .R95_L463
.R95_L464:
    lw $t0, 28($fp)
    beq $t0, $zero, .R95_L468
    lw $t0, 12($fp)
    li $t1, 8
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R95_L468
    li $t2, 1
    sw $t2, -144($fp)
    j .R95_L469
.R95_L468:
    li $t2, 0
    sw $t2, -144($fp)
.R95_L469:
    lw $t0, -144($fp)
    beq $t0, $zero, .R95_L466
    lw $t0, -108($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R95_L470
    addiu $t2, $fp, -48
    sw $t2, -148($fp)
    lw $t0, -108($fp)
    addiu $t2, $t0, -1
    lw $t0, -148($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -152($fp)
    li $t2, 48
    lw $t0, -152($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    bne $t2, $zero, .R95_L470
    li $t2, 0
    sw $t2, -156($fp)
    j .R95_L471
.R95_L470:
    li $t2, 1
    sw $t2, -156($fp)
.R95_L471:
    lw $t0, -156($fp)
    beq $t0, $zero, .R95_L466
    li $t2, 1
    sw $t2, -160($fp)
    j .R95_L467
.R95_L466:
    li $t2, 0
    sw $t2, -160($fp)
.R95_L467:
    lw $t0, -160($fp)
    beq $t0, $zero, .R95_L465
    addiu $t2, $fp, -48
    sw $t2, -164($fp)
    lw $t2, -108($fp)
    sw $t2, -168($fp)
    lw $t0, -108($fp)
    addiu $t2, $t0, 1
    sw $t2, -108($fp)
    lw $t0, -164($fp)
    lw $t1, -168($fp)
    addu $t2, $t0, $t1
    li $t0, 48
    sb $t0, 0($t2)
.R95_L465:
.R95_L472:
    lw $t0, -108($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R95_L473
    addiu $t2, $fp, -96
    sw $t2, -172($fp)
    lw $t2, -112($fp)
    sw $t2, -176($fp)
    lw $t0, -112($fp)
    addiu $t2, $t0, 1
    sw $t2, -112($fp)
    lw $t0, -172($fp)
    lw $t1, -176($fp)
    addu $t2, $t0, $t1
    sw $t2, -180($fp)
    addiu $t2, $fp, -48
    sw $t2, -184($fp)
    lw $t0, -108($fp)
    addiu $t2, $t0, -1
    sw $t2, -188($fp)
    lw $t2, -188($fp)
    sw $t2, -108($fp)
    lw $t0, -184($fp)
    lw $t1, -188($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -180($fp)
    sb $t2, 0($t1)
    j .R95_L472
.R95_L473:
    lw $t0, 8($fp)
    beq $t0, $zero, .R95_L474
    addiu $t2, $fp, -100
    sw $t2, -192($fp)
    lw $t2, -116($fp)
    sw $t2, -196($fp)
    lw $t0, -116($fp)
    addiu $t2, $t0, 1
    sw $t2, -116($fp)
    lw $t0, -192($fp)
    lw $t1, -196($fp)
    addu $t2, $t0, $t1
    li $t0, 45
    sb $t0, 0($t2)
    j .R95_L475
.R95_L474:
    lw $t0, 20($fp)
    beq $t0, $zero, .R95_L476
    addiu $t2, $fp, -100
    sw $t2, -200($fp)
    lw $t2, -116($fp)
    sw $t2, -204($fp)
    lw $t0, -116($fp)
    addiu $t2, $t0, 1
    sw $t2, -116($fp)
    lw $t0, -200($fp)
    lw $t1, -204($fp)
    addu $t2, $t0, $t1
    li $t0, 43
    sb $t0, 0($t2)
    j .R95_L477
.R95_L476:
    lw $t0, 24($fp)
    beq $t0, $zero, .R95_L478
    addiu $t2, $fp, -100
    sw $t2, -208($fp)
    lw $t2, -116($fp)
    sw $t2, -212($fp)
    lw $t0, -116($fp)
    addiu $t2, $t0, 1
    sw $t2, -116($fp)
    lw $t0, -208($fp)
    lw $t1, -212($fp)
    addu $t2, $t0, $t1
    li $t0, 32
    sb $t0, 0($t2)
.R95_L478:
.R95_L477:
.R95_L475:
    lw $t0, 28($fp)
    beq $t0, $zero, .R95_L484
    lw $t0, 12($fp)
    li $t1, 16
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R95_L484
    li $t2, 1
    sw $t2, -216($fp)
    j .R95_L485
.R95_L484:
    li $t2, 0
    sw $t2, -216($fp)
.R95_L485:
    lw $t0, -216($fp)
    beq $t0, $zero, .R95_L482
    lw $t0, -112($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R95_L482
    li $t2, 1
    sw $t2, -220($fp)
    j .R95_L483
.R95_L482:
    li $t2, 0
    sw $t2, -220($fp)
.R95_L483:
    lw $t0, -220($fp)
    beq $t0, $zero, .R95_L480
    lw $t0, -112($fp)
    li $t1, 1
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R95_L486
    addiu $t2, $fp, -96
    lb $t2, 0($t2)
    sw $t2, -224($fp)
    li $t2, 48
    lw $t0, -224($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R95_L486
    li $t2, 1
    sw $t2, -228($fp)
    j .R95_L487
.R95_L486:
    li $t2, 0
    sw $t2, -228($fp)
.R95_L487:
    lw $t0, -228($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R95_L480
    li $t2, 1
    sw $t2, -232($fp)
    j .R95_L481
.R95_L480:
    li $t2, 0
    sw $t2, -232($fp)
.R95_L481:
    lw $t0, -232($fp)
    beq $t0, $zero, .R95_L479
    addiu $t2, $fp, -100
    sw $t2, -236($fp)
    lw $t2, -116($fp)
    sw $t2, -240($fp)
    lw $t0, -116($fp)
    addiu $t2, $t0, 1
    sw $t2, -116($fp)
    lw $t0, -236($fp)
    lw $t1, -240($fp)
    addu $t2, $t0, $t1
    li $t0, 48
    sb $t0, 0($t2)
    addiu $t2, $fp, -100
    sw $t2, -244($fp)
    lw $t2, -116($fp)
    sw $t2, -248($fp)
    lw $t0, -116($fp)
    addiu $t2, $t0, 1
    sw $t2, -116($fp)
    lw $t0, -244($fp)
    lw $t1, -248($fp)
    addu $t2, $t0, $t1
    sw $t2, -252($fp)
    lw $t0, 16($fp)
    beq $t0, $zero, .R95_L488
    li $t2, 88
    sw $t2, -256($fp)
    j .R95_L489
.R95_L488:
    li $t2, 120
    sw $t2, -256($fp)
.R95_L489:
    lw $t2, -256($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -252($fp)
    sb $t2, 0($t1)
.R95_L479:
    addiu $t2, $fp, -100
    move $t0, $t2
    lw $t1, -116($fp)
    addu $t2, $t0, $t1
    sw $t2, -260($fp)
    li $t2, 0
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -260($fp)
    sb $t2, 0($t1)
    addiu $t2, $fp, -100
    sw $t2, -264($fp)
    addiu $t2, $fp, -96
    sw $t2, -268($fp)
    addiu $sp, $sp, -28
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -264($fp)
    sw $t0, 4($sp)
    lw $t0, -268($fp)
    sw $t0, 8($sp)
    lw $t0, -112($fp)
    sw $t0, 12($sp)
    lw $t0, 32($fp)
    sw $t0, 16($sp)
    lw $t0, 40($fp)
    sw $t0, 20($sp)
    lw $t0, 44($fp)
    sw $t0, 24($sp)
    jal R___fns_emit
    addiu $sp, $sp, 28
.Rret95:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_mul_err:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -192
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li.d $f0, 134217729.0
    s.d $f0, -16($fp)
    l.d $f4, -16($fp)
    l.d $f6, 0($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -72($fp)
    l.d $f0, -72($fp)
    s.d $f0, -24($fp)
    l.d $f4, -16($fp)
    l.d $f6, 8($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -80($fp)
    l.d $f0, -80($fp)
    s.d $f0, -32($fp)
    l.d $f4, -24($fp)
    l.d $f6, 0($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -88($fp)
    l.d $f4, -24($fp)
    l.d $f6, -88($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -96($fp)
    l.d $f0, -96($fp)
    s.d $f0, -40($fp)
    l.d $f4, 0($fp)
    l.d $f6, -40($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -104($fp)
    l.d $f0, -104($fp)
    s.d $f0, -48($fp)
    l.d $f4, -32($fp)
    l.d $f6, 8($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -112($fp)
    l.d $f4, -32($fp)
    l.d $f6, -112($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -120($fp)
    l.d $f0, -120($fp)
    s.d $f0, -56($fp)
    l.d $f4, 8($fp)
    l.d $f6, -56($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -128($fp)
    l.d $f0, -128($fp)
    s.d $f0, -64($fp)
    l.d $f4, -40($fp)
    l.d $f6, -56($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -136($fp)
    l.d $f4, -136($fp)
    l.d $f6, 16($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -144($fp)
    l.d $f4, -40($fp)
    l.d $f6, -64($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -152($fp)
    l.d $f4, -144($fp)
    l.d $f6, -152($fp)
    add.d $f0, $f4, $f6
    s.d $f0, -160($fp)
    l.d $f4, -48($fp)
    l.d $f6, -56($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -168($fp)
    l.d $f4, -160($fp)
    l.d $f6, -168($fp)
    add.d $f0, $f4, $f6
    s.d $f0, -176($fp)
    l.d $f4, -48($fp)
    l.d $f6, -64($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -184($fp)
    l.d $f4, -176($fp)
    l.d $f6, -184($fp)
    add.d $f0, $f4, $f6
    s.d $f0, -192($fp)
    l.d $f0, -192($fp)
.Rret96:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_int_digits:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -432
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
    li $t2, 0
    sw $t2, -16($fp)
    l.d $f4, 0($fp)
    li.d $f6, 1.0
    li $t2, 0
    c.lt.d $f4, $f6
    bc1f .Rfc19
    li $t2, 1
.Rfc19:
    beq $t2, $zero, .R97_L490
    li $t0, 48
    lw $t1, 8($fp)
    sb $t0, 0($t1)
    li $v0, 1
    j .Rret97
.R97_L490:
.R97_L491:
    l.d $f4, 0($fp)
    li.d $f6, 1.0
    li $t2, 0
    c.le.d $f6, $f4
    bc1f .Rfc20
    li $t2, 1
.Rfc20:
    beq $t2, $zero, .R97_L493
    lw $t0, -12($fp)
    slti $t2, $t0, 330
    beq $t2, $zero, .R97_L493
    li $t2, 1
    sw $t2, -28($fp)
    j .R97_L494
.R97_L493:
    li $t2, 0
    sw $t2, -28($fp)
.R97_L494:
    lw $t0, -28($fp)
    beq $t0, $zero, .R97_L492
    l.d $f4, 0($fp)
    li.d $f6, 10.0
    div.d $f0, $f4, $f6
    s.d $f0, -36($fp)
    addiu $sp, $sp, -8
    l.d $f0, -36($fp)
    s.d $f0, 0($sp)
    jal R___fns_trunc
    addiu $sp, $sp, 8
    s.d $f0, -44($fp)
    l.d $f0, -44($fp)
    s.d $f0, -24($fp)
    addiu $t2, $fp, -432
    sw $t2, -48($fp)
    lw $t2, -12($fp)
    sw $t2, -52($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    lw $t0, -48($fp)
    lw $t1, -52($fp)
    addu $t2, $t0, $t1
    sw $t2, -56($fp)
    l.d $f4, -24($fp)
    li.d $f6, 10.0
    mul.d $f0, $f4, $f6
    s.d $f0, -64($fp)
    l.d $f4, 0($fp)
    l.d $f6, -64($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -72($fp)
    l.d $f4, -72($fp)
    trunc.w.d $f0, $f4
    mfc1 $t0, $f0
    sw $t0, -76($fp)
    li $t2, 48
    move $t0, $t2
    lw $t1, -76($fp)
    addu $t2, $t0, $t1
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -56($fp)
    sb $t2, 0($t1)
    l.d $f0, -24($fp)
    s.d $f0, 0($fp)
    j .R97_L491
.R97_L492:
.R97_L495:
    lw $t0, -12($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R97_L496
    lw $t2, -16($fp)
    sw $t2, -80($fp)
    lw $t0, -16($fp)
    addiu $t2, $t0, 1
    sw $t2, -16($fp)
    lw $t0, 8($fp)
    lw $t1, -80($fp)
    addu $t2, $t0, $t1
    sw $t2, -84($fp)
    addiu $t2, $fp, -432
    sw $t2, -88($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, -1
    sw $t2, -92($fp)
    lw $t2, -92($fp)
    sw $t2, -12($fp)
    lw $t0, -88($fp)
    lw $t1, -92($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -84($fp)
    sb $t2, 0($t1)
    j .R97_L495
.R97_L496:
    lw $v0, -16($fp)
.Rret97:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_scaled_round:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -152
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 8($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -56($fp)
    l.d $f0, -56($fp)
    s.d $f0, -16($fp)
    l.d $f4, 0($fp)
    l.d $f6, -16($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -64($fp)
    l.d $f0, -64($fp)
    s.d $f0, -24($fp)
    addiu $sp, $sp, -8
    l.d $f0, -24($fp)
    s.d $f0, 0($sp)
    jal R_floor
    addiu $sp, $sp, 8
    s.d $f0, -72($fp)
    l.d $f0, -72($fp)
    s.d $f0, -32($fp)
    l.d $f4, -24($fp)
    l.d $f6, -32($fp)
    sub.d $f0, $f4, $f6
    s.d $f0, -80($fp)
    l.d $f0, -80($fp)
    s.d $f0, -40($fp)
    l.d $f4, -40($fp)
    li.d $f6, 0.5
    li $t2, 0
    c.lt.d $f6, $f4
    bc1f .Rfc21
    li $t2, 1
.Rfc21:
    beq $t2, $zero, .R98_L497
    l.d $f4, -32($fp)
    li.d $f6, 1.0
    add.d $f0, $f4, $f6
    s.d $f0, -88($fp)
    l.d $f0, -88($fp)
    j .Rret98
.R98_L497:
    l.d $f4, -40($fp)
    li.d $f6, 0.5
    li $t2, 0
    c.lt.d $f4, $f6
    bc1f .Rfc22
    li $t2, 1
.Rfc22:
    beq $t2, $zero, .R98_L498
    l.d $f0, -32($fp)
    j .Rret98
.R98_L498:
    lw $t0, 8($fp)
    li $t1, 22
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R98_L499
    addiu $sp, $sp, -24
    l.d $f0, 0($fp)
    s.d $f0, 0($sp)
    l.d $f0, -16($fp)
    s.d $f0, 8($sp)
    l.d $f0, -24($fp)
    s.d $f0, 16($sp)
    jal R___fns_mul_err
    addiu $sp, $sp, 24
    s.d $f0, -96($fp)
    l.d $f0, -96($fp)
    s.d $f0, -104($fp)
    j .R98_L500
.R98_L499:
    li.d $f0, 0.0
    s.d $f0, -104($fp)
.R98_L500:
    l.d $f0, -104($fp)
    s.d $f0, -48($fp)
    li $t0, 0
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -112($fp)
    l.d $f4, -48($fp)
    l.d $f6, -112($fp)
    li $t2, 0
    c.lt.d $f6, $f4
    bc1f .Rfc23
    li $t2, 1
.Rfc23:
    beq $t2, $zero, .R98_L501
    l.d $f4, -32($fp)
    li.d $f6, 1.0
    add.d $f0, $f4, $f6
    s.d $f0, -120($fp)
    l.d $f0, -120($fp)
    j .Rret98
.R98_L501:
    li $t0, 0
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -128($fp)
    l.d $f4, -48($fp)
    l.d $f6, -128($fp)
    li $t2, 0
    c.lt.d $f4, $f6
    bc1f .Rfc24
    li $t2, 1
.Rfc24:
    beq $t2, $zero, .R98_L502
    l.d $f0, -32($fp)
    j .Rret98
.R98_L502:
    addiu $sp, $sp, -16
    l.d $f0, -32($fp)
    s.d $f0, 0($sp)
    li.d $f0, 2.0
    s.d $f0, 8($sp)
    jal R_fmod
    addiu $sp, $sp, 16
    s.d $f0, -136($fp)
    li $t0, 0
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -144($fp)
    l.d $f4, -136($fp)
    l.d $f6, -144($fp)
    li $t2, 1
    c.eq.d $f4, $f6
    bc1f .Rfc25
    li $t2, 0
.Rfc25:
    beq $t2, $zero, .R98_L503
    l.d $f4, -32($fp)
    li.d $f6, 1.0
    add.d $f0, $f4, $f6
    s.d $f0, -152($fp)
    l.d $f0, -152($fp)
    j .Rret98
.R98_L503:
    l.d $f0, -32($fp)
.Rret98:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_fixed:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -440
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -12
    l.d $f0, 0($fp)
    s.d $f0, 0($sp)
    lw $t0, 8($fp)
    sw $t0, 8($sp)
    jal R___fns_scaled_round
    addiu $sp, $sp, 12
    s.d $f0, -40($fp)
    l.d $f0, -40($fp)
    s.d $f0, -16($fp)
    addiu $t2, $fp, -440
    sw $t2, -44($fp)
    addiu $sp, $sp, -12
    l.d $f0, -16($fp)
    s.d $f0, 0($sp)
    lw $t0, -44($fp)
    sw $t0, 8($sp)
    jal R___fns_int_digits
    addiu $sp, $sp, 12
    sw $v0, -48($fp)
    lw $t2, -48($fp)
    sw $t2, -20($fp)
    li $t2, 0
    sw $t2, -28($fp)
    l.d $f4, -16($fp)
    li.d $f6, 1.0
    li $t2, 0
    c.lt.d $f4, $f6
    bc1f .Rfc26
    li $t2, 1
.Rfc26:
    beq $t2, $zero, .R99_L504
    li $t2, 0
    sw $t2, -20($fp)
.R99_L504:
.R99_L505:
    lw $t0, 8($fp)
    addiu $t2, $t0, 1
    lw $t0, -20($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    beq $t2, $zero, .R99_L506
    lw $t2, -20($fp)
    sw $t2, -24($fp)
.R99_L507:
    lw $t0, -24($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R99_L509
    addiu $t2, $fp, -440
    move $t0, $t2
    lw $t1, -24($fp)
    addu $t2, $t0, $t1
    sw $t2, -52($fp)
    addiu $t2, $fp, -440
    sw $t2, -56($fp)
    lw $t0, -24($fp)
    addiu $t2, $t0, -1
    lw $t0, -56($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -52($fp)
    sb $t2, 0($t1)
.R99_L508:
    lw $t0, -24($fp)
    addiu $t2, $t0, -1
    sw $t2, -24($fp)
    j .R99_L507
.R99_L509:
    addiu $t2, $fp, -440
    li $t0, 48
    sb $t0, 0($t2)
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .R99_L505
.R99_L506:
    lw $t0, -20($fp)
    lw $t1, 8($fp)
    subu $t2, $t0, $t1
    sw $t2, -32($fp)
    li $t2, 0
    sw $t2, -24($fp)
.R99_L510:
    lw $t0, -24($fp)
    lw $t1, -32($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R99_L512
    lw $t2, -28($fp)
    sw $t2, -60($fp)
    lw $t0, -28($fp)
    addiu $t2, $t0, 1
    sw $t2, -28($fp)
    lw $t0, 16($fp)
    lw $t1, -60($fp)
    addu $t2, $t0, $t1
    sw $t2, -64($fp)
    addiu $t2, $fp, -440
    move $t0, $t2
    lw $t1, -24($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -64($fp)
    sb $t2, 0($t1)
.R99_L511:
    lw $t0, -24($fp)
    addiu $t2, $t0, 1
    sw $t2, -24($fp)
    j .R99_L510
.R99_L512:
    lw $t0, 8($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    bne $t2, $zero, .R99_L514
    lw $t0, 12($fp)
    bne $t0, $zero, .R99_L514
    li $t2, 0
    sw $t2, -68($fp)
    j .R99_L515
.R99_L514:
    li $t2, 1
    sw $t2, -68($fp)
.R99_L515:
    lw $t0, -68($fp)
    beq $t0, $zero, .R99_L513
    lw $t2, -28($fp)
    sw $t2, -72($fp)
    lw $t0, -28($fp)
    addiu $t2, $t0, 1
    sw $t2, -28($fp)
    lw $t0, 16($fp)
    lw $t1, -72($fp)
    addu $t2, $t0, $t1
    li $t0, 46
    sb $t0, 0($t2)
.R99_L513:
    lw $t2, -32($fp)
    sw $t2, -24($fp)
.R99_L516:
    lw $t0, -24($fp)
    lw $t1, -20($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R99_L518
    lw $t2, -28($fp)
    sw $t2, -76($fp)
    lw $t0, -28($fp)
    addiu $t2, $t0, 1
    sw $t2, -28($fp)
    lw $t0, 16($fp)
    lw $t1, -76($fp)
    addu $t2, $t0, $t1
    sw $t2, -80($fp)
    addiu $t2, $fp, -440
    move $t0, $t2
    lw $t1, -24($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -80($fp)
    sb $t2, 0($t1)
.R99_L517:
    lw $t0, -24($fp)
    addiu $t2, $t0, 1
    sw $t2, -24($fp)
    j .R99_L516
.R99_L518:
    lw $v0, -28($fp)
.Rret99:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_exp10:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -96
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
    li $t0, 0
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -28($fp)
    l.d $f4, 0($fp)
    l.d $f6, -28($fp)
    li $t2, 0
    c.eq.d $f4, $f6
    bc1f .Rfc27
    li $t2, 1
.Rfc27:
    beq $t2, $zero, .R100_L519
    li $v0, 0
    j .Rret100
.R100_L519:
.R100_L520:
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -32($fp)
    addiu $sp, $sp, -4
    lw $t0, -32($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -40($fp)
    l.d $f4, 0($fp)
    l.d $f6, -40($fp)
    li $t2, 0
    c.le.d $f6, $f4
    bc1f .Rfc28
    li $t2, 1
.Rfc28:
    beq $t2, $zero, .R100_L522
    lw $t0, -12($fp)
    slti $t2, $t0, 308
    beq $t2, $zero, .R100_L522
    li $t2, 1
    sw $t2, -44($fp)
    j .R100_L523
.R100_L522:
    li $t2, 0
    sw $t2, -44($fp)
.R100_L523:
    lw $t0, -44($fp)
    beq $t0, $zero, .R100_L521
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R100_L520
.R100_L521:
.R100_L524:
    addiu $sp, $sp, -4
    lw $t0, -12($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -52($fp)
    l.d $f4, 0($fp)
    l.d $f6, -52($fp)
    li $t2, 0
    c.lt.d $f4, $f6
    bc1f .Rfc29
    li $t2, 1
.Rfc29:
    beq $t2, $zero, .R100_L526
    lw $t0, -12($fp)
    li $t1, -320
    slt $t2, $t1, $t0
    beq $t2, $zero, .R100_L526
    li $t2, 1
    sw $t2, -56($fp)
    j .R100_L527
.R100_L526:
    li $t2, 0
    sw $t2, -56($fp)
.R100_L527:
    lw $t0, -56($fp)
    beq $t0, $zero, .R100_L525
    lw $t0, -12($fp)
    addiu $t2, $t0, -1
    sw $t2, -12($fp)
    j .R100_L524
.R100_L525:
    addiu $sp, $sp, -4
    lw $t0, -12($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -64($fp)
    l.d $f4, 0($fp)
    l.d $f6, -64($fp)
    div.d $f0, $f4, $f6
    s.d $f0, -72($fp)
    addiu $sp, $sp, -12
    l.d $f0, -72($fp)
    s.d $f0, 0($sp)
    lw $t0, 8($fp)
    sw $t0, 8($sp)
    jal R___fns_scaled_round
    addiu $sp, $sp, 12
    s.d $f0, -80($fp)
    l.d $f0, -80($fp)
    s.d $f0, -20($fp)
    lw $t0, 8($fp)
    addiu $t2, $t0, 1
    sw $t2, -84($fp)
    addiu $sp, $sp, -4
    lw $t0, -84($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -92($fp)
    l.d $f4, -20($fp)
    l.d $f6, -92($fp)
    li $t2, 0
    c.le.d $f6, $f4
    bc1f .Rfc30
    li $t2, 1
.Rfc30:
    beq $t2, $zero, .R100_L528
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
.R100_L528:
    lw $v0, -12($fp)
.Rret100:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_expo:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -184
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -12
    l.d $f0, 0($fp)
    s.d $f0, 0($sp)
    lw $t0, 8($fp)
    sw $t0, 8($sp)
    jal R___fns_exp10
    addiu $sp, $sp, 12
    sw $v0, -32($fp)
    lw $t2, -32($fp)
    sw $t2, -12($fp)
    li $t0, 0
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -40($fp)
    l.d $f4, 0($fp)
    l.d $f6, -40($fp)
    li $t2, 0
    c.eq.d $f4, $f6
    bc1f .Rfc31
    li $t2, 1
.Rfc31:
    beq $t2, $zero, .R101_L529
    li.d $f0, 0.0
    s.d $f0, -48($fp)
    j .R101_L530
.R101_L529:
    addiu $sp, $sp, -4
    lw $t0, -12($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -56($fp)
    l.d $f4, 0($fp)
    l.d $f6, -56($fp)
    div.d $f0, $f4, $f6
    s.d $f0, -64($fp)
    l.d $f0, -64($fp)
    s.d $f0, -48($fp)
.R101_L530:
    l.d $f0, -48($fp)
    s.d $f0, -20($fp)
    addiu $sp, $sp, -20
    l.d $f0, -20($fp)
    s.d $f0, 0($sp)
    lw $t0, 8($fp)
    sw $t0, 8($sp)
    lw $t0, 12($fp)
    sw $t0, 12($sp)
    lw $t0, 20($fp)
    sw $t0, 16($sp)
    jal R___fns_fixed
    addiu $sp, $sp, 20
    sw $v0, -68($fp)
    lw $t2, -68($fp)
    sw $t2, -24($fp)
    lw $t0, -12($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R101_L531
    lw $t0, -12($fp)
    subu $t2, $zero, $t0
    sw $t2, -72($fp)
    j .R101_L532
.R101_L531:
    lw $t2, -12($fp)
    sw $t2, -72($fp)
.R101_L532:
    lw $t2, -72($fp)
    sw $t2, -28($fp)
    lw $t0, -24($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R101_L536
    lw $t1, 20($fp)
    lb $t2, 0($t1)
    sw $t2, -76($fp)
    li $t2, 48
    lw $t0, -76($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    beq $t2, $zero, .R101_L536
    li $t2, 1
    sw $t2, -80($fp)
    j .R101_L537
.R101_L536:
    li $t2, 0
    sw $t2, -80($fp)
.R101_L537:
    lw $t0, -80($fp)
    beq $t0, $zero, .R101_L534
    lw $t0, 8($fp)
    addiu $t2, $t0, 2
    sw $t2, -84($fp)
    lw $t0, 8($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    bne $t2, $zero, .R101_L540
    lw $t0, 12($fp)
    bne $t0, $zero, .R101_L540
    li $t2, 0
    sw $t2, -88($fp)
    j .R101_L541
.R101_L540:
    li $t2, 1
    sw $t2, -88($fp)
.R101_L541:
    lw $t0, -88($fp)
    beq $t0, $zero, .R101_L538
    li $t2, 0
    sw $t2, -92($fp)
    j .R101_L539
.R101_L538:
    li $t2, -1
    sw $t2, -92($fp)
.R101_L539:
    lw $t0, -84($fp)
    lw $t1, -92($fp)
    addu $t2, $t0, $t1
    lw $t0, -24($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    beq $t2, $zero, .R101_L534
    li $t2, 1
    sw $t2, -96($fp)
    j .R101_L535
.R101_L534:
    li $t2, 0
    sw $t2, -96($fp)
.R101_L535:
    lw $t0, -96($fp)
    beq $t0, $zero, .R101_L533
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    lw $t0, -12($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R101_L542
    lw $t0, -12($fp)
    subu $t2, $zero, $t0
    sw $t2, -100($fp)
    j .R101_L543
.R101_L542:
    lw $t2, -12($fp)
    sw $t2, -100($fp)
.R101_L543:
    lw $t2, -100($fp)
    sw $t2, -28($fp)
    addiu $sp, $sp, -4
    lw $t0, -12($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -108($fp)
    l.d $f4, 0($fp)
    l.d $f6, -108($fp)
    div.d $f0, $f4, $f6
    s.d $f0, -116($fp)
    addiu $sp, $sp, -20
    l.d $f0, -116($fp)
    s.d $f0, 0($sp)
    lw $t0, 8($fp)
    sw $t0, 8($sp)
    lw $t0, 12($fp)
    sw $t0, 12($sp)
    lw $t0, 20($fp)
    sw $t0, 16($sp)
    jal R___fns_fixed
    addiu $sp, $sp, 20
    sw $v0, -120($fp)
    lw $t2, -120($fp)
    sw $t2, -24($fp)
.R101_L533:
    lw $t2, -24($fp)
    sw $t2, -124($fp)
    lw $t0, -24($fp)
    addiu $t2, $t0, 1
    sw $t2, -24($fp)
    lw $t0, 20($fp)
    lw $t1, -124($fp)
    addu $t2, $t0, $t1
    sw $t2, -128($fp)
    lw $t0, 16($fp)
    beq $t0, $zero, .R101_L544
    li $t2, 69
    sw $t2, -132($fp)
    j .R101_L545
.R101_L544:
    li $t2, 101
    sw $t2, -132($fp)
.R101_L545:
    lw $t2, -132($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -128($fp)
    sb $t2, 0($t1)
    lw $t2, -24($fp)
    sw $t2, -136($fp)
    lw $t0, -24($fp)
    addiu $t2, $t0, 1
    sw $t2, -24($fp)
    lw $t0, 20($fp)
    lw $t1, -136($fp)
    addu $t2, $t0, $t1
    sw $t2, -140($fp)
    lw $t0, -12($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R101_L546
    li $t2, 45
    sw $t2, -144($fp)
    j .R101_L547
.R101_L546:
    li $t2, 43
    sw $t2, -144($fp)
.R101_L547:
    lw $t2, -144($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -140($fp)
    sb $t2, 0($t1)
    lw $t0, -28($fp)
    li $t1, 100
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R101_L548
    lw $t2, -24($fp)
    sw $t2, -148($fp)
    lw $t0, -24($fp)
    addiu $t2, $t0, 1
    sw $t2, -24($fp)
    lw $t0, 20($fp)
    lw $t1, -148($fp)
    addu $t2, $t0, $t1
    sw $t2, -152($fp)
    lw $t0, -28($fp)
    li $t1, 100
    div $t0, $t1
    mflo $t2
    sw $t2, -156($fp)
    li $t2, 48
    move $t0, $t2
    lw $t1, -156($fp)
    addu $t2, $t0, $t1
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -152($fp)
    sb $t2, 0($t1)
.R101_L548:
    lw $t2, -24($fp)
    sw $t2, -160($fp)
    lw $t0, -24($fp)
    addiu $t2, $t0, 1
    sw $t2, -24($fp)
    lw $t0, 20($fp)
    lw $t1, -160($fp)
    addu $t2, $t0, $t1
    sw $t2, -164($fp)
    lw $t0, -28($fp)
    li $t1, 10
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 10
    div $t0, $t1
    mfhi $t2
    sw $t2, -168($fp)
    li $t2, 48
    move $t0, $t2
    lw $t1, -168($fp)
    addu $t2, $t0, $t1
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -164($fp)
    sb $t2, 0($t1)
    lw $t2, -24($fp)
    sw $t2, -172($fp)
    lw $t0, -24($fp)
    addiu $t2, $t0, 1
    sw $t2, -24($fp)
    lw $t0, 20($fp)
    lw $t1, -172($fp)
    addu $t2, $t0, $t1
    sw $t2, -176($fp)
    lw $t0, -28($fp)
    li $t1, 10
    div $t0, $t1
    mfhi $t2
    sw $t2, -180($fp)
    li $t2, 48
    move $t0, $t2
    lw $t1, -180($fp)
    addu $t2, $t0, $t1
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -176($fp)
    sb $t2, 0($t1)
    lw $v0, -24($fp)
.Rret101:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_fmt_float:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -648
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -24($fp)
    li $t2, 70
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R102_L551
    li $t2, 69
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R102_L551
    li $t2, 0
    sw $t2, -60($fp)
    j .R102_L552
.R102_L551:
    li $t2, 1
    sw $t2, -60($fp)
.R102_L552:
    lw $t0, -60($fp)
    bne $t0, $zero, .R102_L549
    li $t2, 71
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R102_L549
    li $t2, 0
    sw $t2, -64($fp)
    j .R102_L550
.R102_L549:
    li $t2, 1
    sw $t2, -64($fp)
.R102_L550:
    lw $t2, -64($fp)
    sw $t2, -32($fp)
    addiu $t2, $fp, -20
    sw $t2, -68($fp)
    l.d $f0, 4($fp)
    lw $t1, -68($fp)
    s.d $f0, 0($t1)
    addiu $t2, $fp, -20
    move $t0, $t2
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    move $t0, $t2
    li $t1, -2147483648
    and $t2, $t0, $t1
    sw $t2, -72($fp)
    li $t2, 0
    lw $t0, -72($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    sw $t2, -28($fp)
    lw $t0, -28($fp)
    beq $t0, $zero, .R102_L553
    l.d $f4, 4($fp)
    neg.d $f0, $f4
    s.d $f0, -80($fp)
    l.d $f0, -80($fp)
    s.d $f0, 4($fp)
.R102_L553:
    addiu $t2, $fp, -12
    sw $t2, -84($fp)
    lw $t0, -28($fp)
    beq $t0, $zero, .R102_L560
    li $t2, 45
    sw $t2, -88($fp)
    j .R102_L561
.R102_L560:
    lw $t0, 16($fp)
    beq $t0, $zero, .R102_L564
    li $t2, 43
    sw $t2, -92($fp)
    j .R102_L565
.R102_L564:
    lw $t0, 20($fp)
    beq $t0, $zero, .R102_L566
    li $t2, 32
    sw $t2, -96($fp)
    j .R102_L567
.R102_L566:
    li $t2, 0
    sw $t2, -96($fp)
.R102_L567:
    lw $t2, -96($fp)
    sw $t2, -92($fp)
.R102_L565:
    lw $t2, -92($fp)
    sw $t2, -88($fp)
.R102_L561:
    lw $t2, -88($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -84($fp)
    sb $t2, 0($t1)
    addiu $t2, $fp, -12
    move $t0, $t2
    addiu $t2, $t0, 1
    sw $t2, -100($fp)
    li $t2, 0
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -100($fp)
    sb $t2, 0($t1)
    lw $t0, 32($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R102_L568
    li $t2, 6
    sw $t2, 32($fp)
.R102_L568:
    l.d $f4, 4($fp)
    l.d $f6, 4($fp)
    li $t2, 1
    c.eq.d $f4, $f6
    bc1f .Rfc32
    li $t2, 0
.Rfc32:
    bne $t2, $zero, .R102_L570
    l.d $f4, 4($fp)
    li.d $f6, 1.7976931348623157e+308
    li $t2, 0
    c.lt.d $f6, $f4
    bc1f .Rfc33
    li $t2, 1
.Rfc33:
    bne $t2, $zero, .R102_L570
    li $t2, 0
    sw $t2, -104($fp)
    j .R102_L571
.R102_L570:
    li $t2, 1
    sw $t2, -104($fp)
.R102_L571:
    lw $t0, -104($fp)
    beq $t0, $zero, .R102_L569
    l.d $f4, 4($fp)
    l.d $f6, 4($fp)
    li $t2, 1
    c.eq.d $f4, $f6
    bc1f .Rfc34
    li $t2, 0
.Rfc34:
    beq $t2, $zero, .R102_L576
    lw $t0, -32($fp)
    beq $t0, $zero, .R102_L578
    la $t2, Rstr7
    sw $t2, -108($fp)
    j .R102_L579
.R102_L578:
    la $t2, Rstr8
    sw $t2, -108($fp)
.R102_L579:
    lw $t2, -108($fp)
    sw $t2, -112($fp)
    j .R102_L577
.R102_L576:
    lw $t0, -32($fp)
    beq $t0, $zero, .R102_L580
    la $t2, Rstr9
    sw $t2, -116($fp)
    j .R102_L581
.R102_L580:
    la $t2, Rstr10
    sw $t2, -116($fp)
.R102_L581:
    lw $t2, -116($fp)
    sw $t2, -112($fp)
.R102_L577:
    lw $t2, -112($fp)
    sw $t2, -36($fp)
    addiu $t2, $fp, -12
    sw $t2, -120($fp)
    addiu $sp, $sp, -28
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -120($fp)
    sw $t0, 4($sp)
    lw $t0, -36($fp)
    sw $t0, 8($sp)
    li $t0, 3
    sw $t0, 12($sp)
    lw $t0, 28($fp)
    sw $t0, 16($sp)
    lw $t0, 36($fp)
    sw $t0, 20($sp)
    li $t0, 0
    sw $t0, 24($sp)
    jal R___fns_emit
    addiu $sp, $sp, 28
    j .Rret102
.R102_L569:
    li $t2, 102
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R102_L583
    li $t2, 70
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R102_L583
    li $t2, 0
    sw $t2, -124($fp)
    j .R102_L584
.R102_L583:
    li $t2, 1
    sw $t2, -124($fp)
.R102_L584:
    lw $t0, -124($fp)
    beq $t0, $zero, .R102_L582
    addiu $t2, $fp, -644
    sw $t2, -128($fp)
    addiu $sp, $sp, -20
    l.d $f0, 4($fp)
    s.d $f0, 0($sp)
    lw $t0, 32($fp)
    sw $t0, 8($sp)
    lw $t0, 24($fp)
    sw $t0, 12($sp)
    lw $t0, -128($fp)
    sw $t0, 16($sp)
    jal R___fns_fixed
    addiu $sp, $sp, 20
    sw $v0, -132($fp)
    lw $t2, -132($fp)
    sw $t2, -24($fp)
    j .R102_L585
.R102_L582:
    li $t2, 101
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R102_L587
    li $t2, 69
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R102_L587
    li $t2, 0
    sw $t2, -136($fp)
    j .R102_L588
.R102_L587:
    li $t2, 1
    sw $t2, -136($fp)
.R102_L588:
    lw $t0, -136($fp)
    beq $t0, $zero, .R102_L586
    addiu $t2, $fp, -644
    sw $t2, -140($fp)
    addiu $sp, $sp, -24
    l.d $f0, 4($fp)
    s.d $f0, 0($sp)
    lw $t0, 32($fp)
    sw $t0, 8($sp)
    lw $t0, 24($fp)
    sw $t0, 12($sp)
    lw $t0, -32($fp)
    sw $t0, 16($sp)
    lw $t0, -140($fp)
    sw $t0, 20($sp)
    jal R___fns_expo
    addiu $sp, $sp, 24
    sw $v0, -144($fp)
    lw $t2, -144($fp)
    sw $t2, -24($fp)
    j .R102_L589
.R102_L586:
    lw $t0, 32($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R102_L590
    li $t2, 1
    sw $t2, -148($fp)
    j .R102_L591
.R102_L590:
    lw $t2, 32($fp)
    sw $t2, -148($fp)
.R102_L591:
    lw $t2, -148($fp)
    sw $t2, -40($fp)
    lw $t0, -40($fp)
    addiu $t2, $t0, -1
    sw $t2, -152($fp)
    addiu $sp, $sp, -12
    l.d $f0, 4($fp)
    s.d $f0, 0($sp)
    lw $t0, -152($fp)
    sw $t0, 8($sp)
    jal R___fns_exp10
    addiu $sp, $sp, 12
    sw $v0, -156($fp)
    lw $t2, -156($fp)
    sw $t2, -44($fp)
    lw $t0, -40($fp)
    lw $t1, -44($fp)
    slt $t2, $t1, $t0
    beq $t2, $zero, .R102_L593
    lw $t0, -44($fp)
    li $t1, -4
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R102_L593
    li $t2, 1
    sw $t2, -160($fp)
    j .R102_L594
.R102_L593:
    li $t2, 0
    sw $t2, -160($fp)
.R102_L594:
    lw $t0, -160($fp)
    beq $t0, $zero, .R102_L592
    lw $t0, -40($fp)
    addiu $t2, $t0, -1
    move $t0, $t2
    lw $t1, -44($fp)
    subu $t2, $t0, $t1
    sw $t2, -164($fp)
    addiu $t2, $fp, -644
    sw $t2, -168($fp)
    addiu $sp, $sp, -20
    l.d $f0, 4($fp)
    s.d $f0, 0($sp)
    lw $t0, -164($fp)
    sw $t0, 8($sp)
    lw $t0, 24($fp)
    sw $t0, 12($sp)
    lw $t0, -168($fp)
    sw $t0, 16($sp)
    jal R___fns_fixed
    addiu $sp, $sp, 20
    sw $v0, -172($fp)
    lw $t2, -172($fp)
    sw $t2, -24($fp)
    j .R102_L595
.R102_L592:
    lw $t0, -40($fp)
    addiu $t2, $t0, -1
    sw $t2, -176($fp)
    addiu $t2, $fp, -644
    sw $t2, -180($fp)
    addiu $sp, $sp, -24
    l.d $f0, 4($fp)
    s.d $f0, 0($sp)
    lw $t0, -176($fp)
    sw $t0, 8($sp)
    lw $t0, 24($fp)
    sw $t0, 12($sp)
    lw $t0, -32($fp)
    sw $t0, 16($sp)
    lw $t0, -180($fp)
    sw $t0, 20($sp)
    jal R___fns_expo
    addiu $sp, $sp, 24
    sw $v0, -184($fp)
    lw $t2, -184($fp)
    sw $t2, -24($fp)
.R102_L595:
    lw $t0, 24($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R102_L596
    lw $t2, -24($fp)
    sw $t2, -48($fp)
    li $t2, 0
    sw $t2, -52($fp)
.R102_L597:
    lw $t0, -52($fp)
    lw $t1, -24($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R102_L599
    addiu $t2, $fp, -644
    move $t0, $t2
    lw $t1, -52($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -188($fp)
    li $t2, 101
    lw $t0, -188($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R102_L601
    addiu $t2, $fp, -644
    move $t0, $t2
    lw $t1, -52($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -192($fp)
    li $t2, 69
    lw $t0, -192($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R102_L601
    li $t2, 0
    sw $t2, -196($fp)
    j .R102_L602
.R102_L601:
    li $t2, 1
    sw $t2, -196($fp)
.R102_L602:
    lw $t0, -196($fp)
    beq $t0, $zero, .R102_L600
    lw $t2, -52($fp)
    sw $t2, -48($fp)
    j .R102_L599
.R102_L600:
.R102_L598:
    lw $t0, -52($fp)
    addiu $t2, $t0, 1
    sw $t2, -52($fp)
    j .R102_L597
.R102_L599:
    lw $t2, -48($fp)
    sw $t2, -56($fp)
    li $t2, 0
    sw $t2, -52($fp)
.R102_L603:
    lw $t0, -52($fp)
    lw $t1, -48($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R102_L605
    addiu $t2, $fp, -644
    move $t0, $t2
    lw $t1, -52($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -200($fp)
    li $t2, 46
    lw $t0, -200($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R102_L606
    j .R102_L605
.R102_L606:
.R102_L604:
    lw $t0, -52($fp)
    addiu $t2, $t0, 1
    sw $t2, -52($fp)
    j .R102_L603
.R102_L605:
    lw $t0, -52($fp)
    lw $t1, -48($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R102_L607
.R102_L608:
    lw $t0, -56($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R102_L610
    addiu $t2, $fp, -644
    sw $t2, -204($fp)
    lw $t0, -56($fp)
    addiu $t2, $t0, -1
    lw $t0, -204($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -208($fp)
    li $t2, 48
    lw $t0, -208($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R102_L610
    li $t2, 1
    sw $t2, -212($fp)
    j .R102_L611
.R102_L610:
    li $t2, 0
    sw $t2, -212($fp)
.R102_L611:
    lw $t0, -212($fp)
    beq $t0, $zero, .R102_L609
    lw $t0, -56($fp)
    addiu $t2, $t0, -1
    sw $t2, -56($fp)
    j .R102_L608
.R102_L609:
    lw $t0, -56($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R102_L613
    addiu $t2, $fp, -644
    sw $t2, -216($fp)
    lw $t0, -56($fp)
    addiu $t2, $t0, -1
    lw $t0, -216($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -220($fp)
    li $t2, 46
    lw $t0, -220($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R102_L613
    li $t2, 1
    sw $t2, -224($fp)
    j .R102_L614
.R102_L613:
    li $t2, 0
    sw $t2, -224($fp)
.R102_L614:
    lw $t0, -224($fp)
    beq $t0, $zero, .R102_L612
    lw $t0, -56($fp)
    addiu $t2, $t0, -1
    sw $t2, -56($fp)
.R102_L612:
    li $t2, 0
    sw $t2, -52($fp)
.R102_L615:
    lw $t0, -48($fp)
    lw $t1, -52($fp)
    addu $t2, $t0, $t1
    move $t0, $t2
    lw $t1, -24($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R102_L617
    addiu $t2, $fp, -644
    sw $t2, -228($fp)
    lw $t0, -56($fp)
    lw $t1, -52($fp)
    addu $t2, $t0, $t1
    lw $t0, -228($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -232($fp)
    addiu $t2, $fp, -644
    sw $t2, -236($fp)
    lw $t0, -48($fp)
    lw $t1, -52($fp)
    addu $t2, $t0, $t1
    lw $t0, -236($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -232($fp)
    sb $t2, 0($t1)
.R102_L616:
    lw $t0, -52($fp)
    addiu $t2, $t0, 1
    sw $t2, -52($fp)
    j .R102_L615
.R102_L617:
    lw $t0, -24($fp)
    lw $t1, -48($fp)
    subu $t2, $t0, $t1
    lw $t0, -56($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -24($fp)
.R102_L607:
.R102_L596:
.R102_L589:
.R102_L585:
    addiu $t2, $fp, -12
    sw $t2, -240($fp)
    addiu $t2, $fp, -644
    sw $t2, -244($fp)
    addiu $sp, $sp, -28
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -240($fp)
    sw $t0, 4($sp)
    lw $t0, -244($fp)
    sw $t0, 8($sp)
    lw $t0, -24($fp)
    sw $t0, 12($sp)
    lw $t0, 28($fp)
    sw $t0, 16($sp)
    lw $t0, 36($fp)
    sw $t0, 20($sp)
    lw $t0, 40($fp)
    sw $t0, 24($sp)
    jal R___fns_emit
    addiu $sp, $sp, 28
.Rret102:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R___fns_vformat:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -344
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
.R103_L618:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R103_L619
    li $t2, 0
    sw $t2, -12($fp)
    li $t2, 0
    sw $t2, -16($fp)
    li $t2, 0
    sw $t2, -20($fp)
    li $t2, 0
    sw $t2, -24($fp)
    li $t2, 0
    sw $t2, -28($fp)
    li $t2, 0
    sw $t2, -32($fp)
    li $t2, -1
    sw $t2, -36($fp)
    li $t2, 0
    sw $t2, -40($fp)
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -88($fp)
    li $t2, 37
    lw $t0, -88($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    beq $t2, $zero, .R103_L620
    lw $t2, 4($fp)
    sw $t2, -92($fp)
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    lw $t1, -92($fp)
    lb $t2, 0($t1)
    sw $t2, -96($fp)
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -96($fp)
    sw $t0, 4($sp)
    jal R___fns_put
    addiu $sp, $sp, 8
    j .R103_L618
.R103_L620:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
.R103_L621:
    li $t0, 1
    beq $t0, $zero, .R103_L622
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -100($fp)
    li $t2, 45
    lw $t0, -100($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L623
    li $t2, 1
    sw $t2, -12($fp)
    j .R103_L624
.R103_L623:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -104($fp)
    li $t2, 43
    lw $t0, -104($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L625
    li $t2, 1
    sw $t2, -16($fp)
    j .R103_L626
.R103_L625:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -108($fp)
    li $t2, 32
    lw $t0, -108($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L627
    li $t2, 1
    sw $t2, -20($fp)
    j .R103_L628
.R103_L627:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -112($fp)
    li $t2, 35
    lw $t0, -112($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L629
    li $t2, 1
    sw $t2, -24($fp)
    j .R103_L630
.R103_L629:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -116($fp)
    li $t2, 48
    lw $t0, -116($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L631
    li $t2, 1
    sw $t2, -28($fp)
    j .R103_L632
.R103_L631:
    j .R103_L622
.R103_L632:
.R103_L630:
.R103_L628:
.R103_L626:
.R103_L624:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    j .R103_L621
.R103_L622:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -120($fp)
    li $t2, 42
    lw $t0, -120($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L633
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, 8($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -124($fp)
    lw $t2, -124($fp)
    sw $t2, 8($fp)
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -124($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -32($fp)
    lw $t0, -32($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R103_L634
    li $t2, 1
    sw $t2, -12($fp)
    lw $t0, -32($fp)
    subu $t2, $zero, $t0
    sw $t2, -32($fp)
.R103_L634:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    j .R103_L635
.R103_L633:
.R103_L636:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -128($fp)
    addiu $sp, $sp, -4
    lw $t0, -128($fp)
    sw $t0, 0($sp)
    jal R_isdigit
    addiu $sp, $sp, 4
    sw $v0, -132($fp)
    lw $t0, -132($fp)
    beq $t0, $zero, .R103_L637
    lw $t0, -32($fp)
    li $t1, 10
    mult $t0, $t1
    mflo $t2
    sw $t2, -136($fp)
    lw $t2, 4($fp)
    sw $t2, -140($fp)
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    lw $t1, -140($fp)
    lb $t2, 0($t1)
    sw $t2, -144($fp)
    li $t2, 48
    lw $t0, -144($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t0, -136($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -32($fp)
    j .R103_L636
.R103_L637:
.R103_L635:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -148($fp)
    li $t2, 46
    lw $t0, -148($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L638
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    li $t2, 0
    sw $t2, -36($fp)
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -152($fp)
    li $t2, 42
    lw $t0, -152($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L639
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, 8($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -156($fp)
    lw $t2, -156($fp)
    sw $t2, 8($fp)
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -156($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -36($fp)
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    j .R103_L640
.R103_L639:
.R103_L641:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -160($fp)
    addiu $sp, $sp, -4
    lw $t0, -160($fp)
    sw $t0, 0($sp)
    jal R_isdigit
    addiu $sp, $sp, 4
    sw $v0, -164($fp)
    lw $t0, -164($fp)
    beq $t0, $zero, .R103_L642
    lw $t0, -36($fp)
    li $t1, 10
    mult $t0, $t1
    mflo $t2
    sw $t2, -168($fp)
    lw $t2, 4($fp)
    sw $t2, -172($fp)
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    lw $t1, -172($fp)
    lb $t2, 0($t1)
    sw $t2, -176($fp)
    li $t2, 48
    lw $t0, -176($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t0, -168($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -36($fp)
    j .R103_L641
.R103_L642:
.R103_L640:
.R103_L638:
.R103_L643:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -180($fp)
    li $t2, 104
    lw $t0, -180($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L653
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -184($fp)
    li $t2, 108
    lw $t0, -184($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L653
    li $t2, 0
    sw $t2, -188($fp)
    j .R103_L654
.R103_L653:
    li $t2, 1
    sw $t2, -188($fp)
.R103_L654:
    lw $t0, -188($fp)
    bne $t0, $zero, .R103_L651
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -192($fp)
    li $t2, 76
    lw $t0, -192($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L651
    li $t2, 0
    sw $t2, -196($fp)
    j .R103_L652
.R103_L651:
    li $t2, 1
    sw $t2, -196($fp)
.R103_L652:
    lw $t0, -196($fp)
    bne $t0, $zero, .R103_L649
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -200($fp)
    li $t2, 122
    lw $t0, -200($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L649
    li $t2, 0
    sw $t2, -204($fp)
    j .R103_L650
.R103_L649:
    li $t2, 1
    sw $t2, -204($fp)
.R103_L650:
    lw $t0, -204($fp)
    bne $t0, $zero, .R103_L647
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -208($fp)
    li $t2, 106
    lw $t0, -208($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L647
    li $t2, 0
    sw $t2, -212($fp)
    j .R103_L648
.R103_L647:
    li $t2, 1
    sw $t2, -212($fp)
.R103_L648:
    lw $t0, -212($fp)
    bne $t0, $zero, .R103_L645
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -216($fp)
    li $t2, 116
    lw $t0, -216($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L645
    li $t2, 0
    sw $t2, -220($fp)
    j .R103_L646
.R103_L645:
    li $t2, 1
    sw $t2, -220($fp)
.R103_L646:
    lw $t0, -220($fp)
    beq $t0, $zero, .R103_L644
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -224($fp)
    li $t2, 104
    lw $t0, -224($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L655
    lw $t0, -40($fp)
    addiu $t2, $t0, -1
    sw $t2, -40($fp)
.R103_L655:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    j .R103_L643
.R103_L644:
    lw $t0, -12($fp)
    beq $t0, $zero, .R103_L656
    li $t2, 0
    sw $t2, -28($fp)
.R103_L656:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -44($fp)
    lw $t0, -44($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R103_L657
    j .R103_L619
.R103_L657:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    li $t2, 100
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L659
    li $t2, 105
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L659
    li $t2, 0
    sw $t2, -228($fp)
    j .R103_L660
.R103_L659:
    li $t2, 1
    sw $t2, -228($fp)
.R103_L660:
    lw $t0, -228($fp)
    beq $t0, $zero, .R103_L658
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, 8($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -232($fp)
    lw $t2, -232($fp)
    sw $t2, 8($fp)
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -232($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -48($fp)
    lw $t0, -40($fp)
    li $t1, -1
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L661
    lw $t2, -48($fp)
    sll $t2, $t2, 16
    sra $t2, $t2, 16
    sw $t2, -48($fp)
.R103_L661:
    lw $t0, -40($fp)
    li $t1, -2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R103_L662
    lw $t2, -48($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    sw $t2, -48($fp)
.R103_L662:
    lw $t0, -48($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R103_L663
    lw $t0, -48($fp)
    addiu $t2, $t0, 1
    move $t0, $t2
    subu $t2, $zero, $t0
    move $t0, $t2
    addiu $t2, $t0, 1
    sw $t2, -236($fp)
    j .R103_L664
.R103_L663:
    lw $t2, -48($fp)
    sw $t2, -236($fp)
.R103_L664:
    lw $t2, -236($fp)
    sw $t2, -52($fp)
    lw $t0, -48($fp)
    slti $t2, $t0, 0
    sw $t2, -240($fp)
    addiu $sp, $sp, -48
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -52($fp)
    sw $t0, 4($sp)
    lw $t0, -240($fp)
    sw $t0, 8($sp)
    li $t0, 10
    sw $t0, 12($sp)
    li $t0, 0
    sw $t0, 16($sp)
    lw $t0, -16($fp)
    sw $t0, 20($sp)
    lw $t0, -20($fp)
    sw $t0, 24($sp)
    lw $t0, -24($fp)
    sw $t0, 28($sp)
    lw $t0, -32($fp)
    sw $t0, 32($sp)
    lw $t0, -36($fp)
    sw $t0, 36($sp)
    lw $t0, -12($fp)
    sw $t0, 40($sp)
    lw $t0, -28($fp)
    sw $t0, 44($sp)
    jal R___fns_fmt_int
    addiu $sp, $sp, 48
    j .R103_L665
.R103_L658:
    li $t2, 117
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L671
    li $t2, 120
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L671
    li $t2, 0
    sw $t2, -244($fp)
    j .R103_L672
.R103_L671:
    li $t2, 1
    sw $t2, -244($fp)
.R103_L672:
    lw $t0, -244($fp)
    bne $t0, $zero, .R103_L669
    li $t2, 88
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L669
    li $t2, 0
    sw $t2, -248($fp)
    j .R103_L670
.R103_L669:
    li $t2, 1
    sw $t2, -248($fp)
.R103_L670:
    lw $t0, -248($fp)
    bne $t0, $zero, .R103_L667
    li $t2, 111
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L667
    li $t2, 0
    sw $t2, -252($fp)
    j .R103_L668
.R103_L667:
    li $t2, 1
    sw $t2, -252($fp)
.R103_L668:
    lw $t0, -252($fp)
    beq $t0, $zero, .R103_L666
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, 8($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -256($fp)
    lw $t2, -256($fp)
    sw $t2, 8($fp)
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -256($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -56($fp)
    lw $t0, -40($fp)
    li $t1, -1
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L673
    lw $t0, -56($fp)
    andi $t2, $t0, 65535
    sw $t2, -56($fp)
.R103_L673:
    lw $t0, -40($fp)
    li $t1, -2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R103_L674
    lw $t0, -56($fp)
    andi $t2, $t0, 255
    sw $t2, -56($fp)
.R103_L674:
    li $t2, 117
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L677
    li $t2, 10
    sw $t2, -260($fp)
    j .R103_L678
.R103_L677:
    li $t2, 111
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L679
    li $t2, 8
    sw $t2, -264($fp)
    j .R103_L680
.R103_L679:
    li $t2, 16
    sw $t2, -264($fp)
.R103_L680:
    lw $t2, -264($fp)
    sw $t2, -260($fp)
.R103_L678:
    li $t2, 88
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    sw $t2, -268($fp)
    addiu $sp, $sp, -48
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -56($fp)
    sw $t0, 4($sp)
    li $t0, 0
    sw $t0, 8($sp)
    lw $t0, -260($fp)
    sw $t0, 12($sp)
    lw $t0, -268($fp)
    sw $t0, 16($sp)
    li $t0, 0
    sw $t0, 20($sp)
    li $t0, 0
    sw $t0, 24($sp)
    lw $t0, -24($fp)
    sw $t0, 28($sp)
    lw $t0, -32($fp)
    sw $t0, 32($sp)
    lw $t0, -36($fp)
    sw $t0, 36($sp)
    lw $t0, -12($fp)
    sw $t0, 40($sp)
    lw $t0, -28($fp)
    sw $t0, 44($sp)
    jal R___fns_fmt_int
    addiu $sp, $sp, 48
    j .R103_L681
.R103_L666:
    li $t2, 112
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L682
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, 8($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -272($fp)
    lw $t2, -272($fp)
    sw $t2, 8($fp)
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -272($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -60($fp)
    li $t2, 0
    lw $t0, -60($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L683
    addiu $sp, $sp, -28
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    la $t0, Rstr11
    sw $t0, 4($sp)
    la $t0, Rstr12
    sw $t0, 8($sp)
    li $t0, 5
    sw $t0, 12($sp)
    lw $t0, -32($fp)
    sw $t0, 16($sp)
    lw $t0, -12($fp)
    sw $t0, 20($sp)
    li $t0, 0
    sw $t0, 24($sp)
    jal R___fns_emit
    addiu $sp, $sp, 28
    j .R103_L684
.R103_L683:
    addiu $sp, $sp, -48
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -60($fp)
    sw $t0, 4($sp)
    li $t0, 0
    sw $t0, 8($sp)
    li $t0, 16
    sw $t0, 12($sp)
    li $t0, 0
    sw $t0, 16($sp)
    lw $t0, -16($fp)
    sw $t0, 20($sp)
    lw $t0, -20($fp)
    sw $t0, 24($sp)
    li $t0, 1
    sw $t0, 28($sp)
    lw $t0, -32($fp)
    sw $t0, 32($sp)
    lw $t0, -36($fp)
    sw $t0, 36($sp)
    lw $t0, -12($fp)
    sw $t0, 40($sp)
    lw $t0, -28($fp)
    sw $t0, 44($sp)
    jal R___fns_fmt_int
    addiu $sp, $sp, 48
.R103_L684:
    j .R103_L685
.R103_L682:
    li $t2, 99
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L686
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, 8($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -276($fp)
    lw $t2, -276($fp)
    sw $t2, 8($fp)
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -276($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t2, 0($t2)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    sw $t2, -64($fp)
    addiu $t2, $fp, -64
    sw $t2, -280($fp)
    addiu $sp, $sp, -28
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    la $t0, Rstr11
    sw $t0, 4($sp)
    lw $t0, -280($fp)
    sw $t0, 8($sp)
    li $t0, 1
    sw $t0, 12($sp)
    lw $t0, -32($fp)
    sw $t0, 16($sp)
    lw $t0, -12($fp)
    sw $t0, 20($sp)
    li $t0, 0
    sw $t0, 24($sp)
    jal R___fns_emit
    addiu $sp, $sp, 28
    j .R103_L687
.R103_L686:
    li $t2, 115
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L688
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, 8($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -284($fp)
    lw $t2, -284($fp)
    sw $t2, 8($fp)
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -284($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -68($fp)
    li $t2, 0
    sw $t2, -72($fp)
    lw $t0, -68($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R103_L689
    la $t2, Rstr13
    sw $t2, -68($fp)
.R103_L689:
.R103_L690:
    lw $t0, -68($fp)
    lw $t1, -72($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    beq $t2, $zero, .R103_L692
    lw $t0, -36($fp)
    slti $t2, $t0, 0
    bne $t2, $zero, .R103_L694
    lw $t0, -72($fp)
    lw $t1, -36($fp)
    slt $t2, $t0, $t1
    bne $t2, $zero, .R103_L694
    li $t2, 0
    sw $t2, -288($fp)
    j .R103_L695
.R103_L694:
    li $t2, 1
    sw $t2, -288($fp)
.R103_L695:
    lw $t0, -288($fp)
    beq $t0, $zero, .R103_L692
    li $t2, 1
    sw $t2, -292($fp)
    j .R103_L693
.R103_L692:
    li $t2, 0
    sw $t2, -292($fp)
.R103_L693:
    lw $t0, -292($fp)
    beq $t0, $zero, .R103_L691
    lw $t0, -72($fp)
    addiu $t2, $t0, 1
    sw $t2, -72($fp)
    j .R103_L690
.R103_L691:
    addiu $sp, $sp, -28
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    la $t0, Rstr11
    sw $t0, 4($sp)
    lw $t0, -68($fp)
    sw $t0, 8($sp)
    lw $t0, -72($fp)
    sw $t0, 12($sp)
    lw $t0, -32($fp)
    sw $t0, 16($sp)
    lw $t0, -12($fp)
    sw $t0, 20($sp)
    li $t0, 0
    sw $t0, 24($sp)
    jal R___fns_emit
    addiu $sp, $sp, 28
    j .R103_L696
.R103_L688:
    li $t2, 102
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L706
    li $t2, 70
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L706
    li $t2, 0
    sw $t2, -296($fp)
    j .R103_L707
.R103_L706:
    li $t2, 1
    sw $t2, -296($fp)
.R103_L707:
    lw $t0, -296($fp)
    bne $t0, $zero, .R103_L704
    li $t2, 101
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L704
    li $t2, 0
    sw $t2, -300($fp)
    j .R103_L705
.R103_L704:
    li $t2, 1
    sw $t2, -300($fp)
.R103_L705:
    lw $t0, -300($fp)
    bne $t0, $zero, .R103_L702
    li $t2, 69
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L702
    li $t2, 0
    sw $t2, -304($fp)
    j .R103_L703
.R103_L702:
    li $t2, 1
    sw $t2, -304($fp)
.R103_L703:
    lw $t0, -304($fp)
    bne $t0, $zero, .R103_L700
    li $t2, 103
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L700
    li $t2, 0
    sw $t2, -308($fp)
    j .R103_L701
.R103_L700:
    li $t2, 1
    sw $t2, -308($fp)
.R103_L701:
    lw $t0, -308($fp)
    bne $t0, $zero, .R103_L698
    li $t2, 71
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R103_L698
    li $t2, 0
    sw $t2, -312($fp)
    j .R103_L699
.R103_L698:
    li $t2, 1
    sw $t2, -312($fp)
.R103_L699:
    lw $t0, -312($fp)
    beq $t0, $zero, .R103_L697
    li $t0, 8
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, 8($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -316($fp)
    lw $t2, -316($fp)
    sw $t2, 8($fp)
    li $t0, 8
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -316($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sw $t2, -320($fp)
    lw $t1, -320($fp)
    l.d $f0, 0($t1)
    s.d $f0, -328($fp)
    l.d $f0, -328($fp)
    s.d $f0, -80($fp)
    addiu $sp, $sp, -44
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    l.d $f0, -80($fp)
    s.d $f0, 4($sp)
    lw $t0, -44($fp)
    sw $t0, 12($sp)
    lw $t0, -16($fp)
    sw $t0, 16($sp)
    lw $t0, -20($fp)
    sw $t0, 20($sp)
    lw $t0, -24($fp)
    sw $t0, 24($sp)
    lw $t0, -32($fp)
    sw $t0, 28($sp)
    lw $t0, -36($fp)
    sw $t0, 32($sp)
    lw $t0, -12($fp)
    sw $t0, 36($sp)
    lw $t0, -28($fp)
    sw $t0, 40($sp)
    jal R___fns_fmt_float
    addiu $sp, $sp, 44
    j .R103_L708
.R103_L697:
    li $t2, 110
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L709
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, 8($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -332($fp)
    lw $t2, -332($fp)
    sw $t2, 8($fp)
    li $t0, 4
    addiu $t2, $t0, 3
    move $t0, $t2
    li $t1, 4
    div $t0, $t1
    mflo $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -332($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -84($fp)
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    lw $t2, 0($t2)
    lw $t1, -84($fp)
    sw $t2, 0($t1)
    j .R103_L710
.R103_L709:
    li $t2, 37
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R103_L711
    li $t2, 37
    sw $t2, -336($fp)
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -336($fp)
    sw $t0, 4($sp)
    jal R___fns_put
    addiu $sp, $sp, 8
    j .R103_L712
.R103_L711:
    li $t2, 37
    sw $t2, -340($fp)
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -340($fp)
    sw $t0, 4($sp)
    jal R___fns_put
    addiu $sp, $sp, 8
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -44($fp)
    sw $t0, 4($sp)
    jal R___fns_put
    addiu $sp, $sp, 8
.R103_L712:
.R103_L710:
.R103_L708:
.R103_L696:
.R103_L687:
.R103_L685:
.R103_L681:
.R103_L665:
    j .R103_L618
.R103_L619:
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    lw $t2, 0($t2)
    move $v0, $t2
.Rret103:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_vfprintf:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -40
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $t2, $fp, -24
    lw $t0, 0($fp)
    sw $t0, 0($t2)
    addiu $t2, $fp, -24
    move $t0, $t2
    addiu $t2, $t0, 4
    sw $t2, -28($fp)
    li $t2, 0
    lw $t1, -28($fp)
    sw $t2, 0($t1)
    addiu $t2, $fp, -24
    move $t0, $t2
    addiu $t2, $t0, 8
    li $t0, 0
    sw $t0, 0($t2)
    addiu $t2, $fp, -24
    move $t0, $t2
    addiu $t2, $t0, 12
    li $t0, -1
    sw $t0, 0($t2)
    addiu $t2, $fp, -24
    sw $t2, -32($fp)
    addiu $sp, $sp, -12
    lw $t0, -32($fp)
    sw $t0, 0($sp)
    lw $t0, 4($fp)
    sw $t0, 4($sp)
    lw $t0, 8($fp)
    sw $t0, 8($sp)
    jal R___fns_vformat
    addiu $sp, $sp, 12
    sw $v0, -36($fp)
    lw $v0, -36($fp)
.Rret104:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra




R_printf:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $t2, $fp, 4
    sw $t2, -12($fp)
    li $t2, 2
    sw $t2, -20($fp)
    addiu $sp, $sp, -12
    lw $t0, -20($fp)
    sw $t0, 0($sp)
    lw $t0, 0($fp)
    sw $t0, 4($sp)
    lw $t0, -12($fp)
    sw $t0, 8($sp)
    jal R_vfprintf
    addiu $sp, $sp, 12
    sw $v0, -24($fp)
    lw $t2, -24($fp)
    sw $t2, -16($fp)
    li $t2, 0
    sw $t2, -12($fp)
    lw $v0, -16($fp)
.Rret108:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra














