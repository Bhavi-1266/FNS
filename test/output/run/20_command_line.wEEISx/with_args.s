# FNS -> MIPS32 (spim).  Generated assembly.
# source: test/20_command_line.c
# run with:  spim -file <this file> [program arguments]

.data
str0: .asciiz "argc = %d\n"
str1: .byte 97, 114, 103, 118, 91, 37, 100, 93, 32, 61, 32, 34, 37, 115, 34, 32, 40, 108, 101, 110, 103, 116, 104, 32, 37, 100, 41, 10, 0    # "argv[%d] = \"%s\" (length %d)\n"
str2: .asciiz "usage: prog <op> <a> <b> [words...]\n"
str3: .asciiz "%c(%d, %d) = %d\n"
str4: .asciiz "longest word: %s\n"
str5: .asciiz "total as double = %.1f\n"
str6: .asciiz "argv[argc] is %s\n"
str7: .asciiz "NULL"
str8: .asciiz "not NULL"

.text
.globl __fns_test_main

__fns_test_main:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -200
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    sw $a0, -12($fp)
    sw $a1, -16($fp)
    addiu $sp, $sp, -8
    la $t0, str0
    sw $t0, 0($sp)
    lw $t0, -12($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -60($fp)
    li $t2, 1
    sw $t2, -20($fp)
.L0_L1:
    lw $t0, -20($fp)
    lw $t1, -12($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .L0_L3
    lw $t0, -20($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -16($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -64($fp)
    lw $t0, -20($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -16($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -68($fp)
    addiu $sp, $sp, -4
    lw $t0, -68($fp)
    sw $t0, 0($sp)
    jal R_strlen
    addiu $sp, $sp, 4
    sw $v0, -72($fp)
    lw $t2, -72($fp)
    sw $t2, -76($fp)
    addiu $sp, $sp, -16
    la $t0, str1
    sw $t0, 0($sp)
    lw $t0, -20($fp)
    sw $t0, 4($sp)
    lw $t0, -64($fp)
    sw $t0, 8($sp)
    lw $t0, -76($fp)
    sw $t0, 12($sp)
    jal R_printf
    addiu $sp, $sp, 16
    sw $v0, -80($fp)
.L0_L2:
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .L0_L1
.L0_L3:
    lw $t0, -12($fp)
    slti $t2, $t0, 4
    beq $t2, $zero, .L0_L4
    addiu $sp, $sp, -4
    la $t0, str2
    sw $t0, 0($sp)
    jal R_printf
    addiu $sp, $sp, 4
    sw $v0, -84($fp)
    li $v0, 1
    j .Lret0
.L0_L4:
    lw $t0, -16($fp)
    addiu $t2, $t0, 8
    lw $t2, 0($t2)
    sw $t2, -88($fp)
    addiu $sp, $sp, -4
    lw $t0, -88($fp)
    sw $t0, 0($sp)
    jal R_atoi
    addiu $sp, $sp, 4
    sw $v0, -92($fp)
    lw $t2, -92($fp)
    sw $t2, -24($fp)
    lw $t0, -16($fp)
    addiu $t2, $t0, 12
    lw $t2, 0($t2)
    sw $t2, -96($fp)
    addiu $sp, $sp, -4
    lw $t0, -96($fp)
    sw $t0, 0($sp)
    jal R_atoi
    addiu $sp, $sp, 4
    sw $v0, -100($fp)
    lw $t2, -100($fp)
    sw $t2, -28($fp)
    lw $t0, -16($fp)
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    lb $t2, 0($t2)
    sw $t2, -32($fp)
    lw $t2, -32($fp)
    sw $t2, -104($fp)
    li $t2, 97
    lw $t0, -104($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .L0_L11
    lw $t0, -24($fp)
    lw $t1, -28($fp)
    addu $t2, $t0, $t1
    sw $t2, -108($fp)
    j .L0_L12
.L0_L11:
    lw $t2, -32($fp)
    sw $t2, -112($fp)
    li $t2, 115
    lw $t0, -112($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .L0_L15
    lw $t0, -24($fp)
    lw $t1, -28($fp)
    subu $t2, $t0, $t1
    sw $t2, -116($fp)
    j .L0_L16
.L0_L15:
    lw $t2, -32($fp)
    sw $t2, -120($fp)
    li $t2, 109
    lw $t0, -120($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .L0_L17
    lw $t0, -24($fp)
    lw $t1, -28($fp)
    mult $t0, $t1
    mflo $t2
    sw $t2, -124($fp)
    j .L0_L18
.L0_L17:
    li $t2, 0
    sw $t2, -124($fp)
.L0_L18:
    lw $t2, -124($fp)
    sw $t2, -116($fp)
.L0_L16:
    lw $t2, -116($fp)
    sw $t2, -108($fp)
.L0_L12:
    lw $t2, -108($fp)
    sw $t2, -36($fp)
    lw $t2, -32($fp)
    sw $t2, -128($fp)
    addiu $sp, $sp, -20
    la $t0, str3
    sw $t0, 0($sp)
    lw $t0, -128($fp)
    sw $t0, 4($sp)
    lw $t0, -24($fp)
    sw $t0, 8($sp)
    lw $t0, -28($fp)
    sw $t0, 12($sp)
    lw $t0, -36($fp)
    sw $t0, 16($sp)
    jal R_printf
    addiu $sp, $sp, 20
    sw $v0, -132($fp)
    li $t2, 4
    sw $t2, -40($fp)
    li $t2, 4
    sw $t2, -44($fp)
.L0_L19:
    lw $t0, -44($fp)
    lw $t1, -12($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .L0_L21
    lw $t0, -44($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -16($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -136($fp)
    addiu $sp, $sp, -4
    lw $t0, -136($fp)
    sw $t0, 0($sp)
    jal R_strlen
    addiu $sp, $sp, 4
    sw $v0, -140($fp)
    lw $t0, -40($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -16($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -144($fp)
    addiu $sp, $sp, -4
    lw $t0, -144($fp)
    sw $t0, 0($sp)
    jal R_strlen
    addiu $sp, $sp, 4
    sw $v0, -148($fp)
    lw $t0, -140($fp)
    lw $t1, -148($fp)
    sltu $t2, $t1, $t0
    beq $t2, $zero, .L0_L22
    lw $t2, -44($fp)
    sw $t2, -40($fp)
.L0_L22:
.L0_L20:
    lw $t0, -44($fp)
    addiu $t2, $t0, 1
    sw $t2, -44($fp)
    j .L0_L19
.L0_L21:
    lw $t0, -12($fp)
    li $t1, 4
    slt $t2, $t1, $t0
    beq $t2, $zero, .L0_L23
    lw $t0, -40($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -16($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -152($fp)
    addiu $sp, $sp, -8
    la $t0, str4
    sw $t0, 0($sp)
    lw $t0, -152($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -156($fp)
.L0_L23:
    li $t0, 0
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -164($fp)
    l.d $f0, -164($fp)
    s.d $f0, -52($fp)
    li $t2, 2
    sw $t2, -56($fp)
.L0_L24:
    lw $t0, -56($fp)
    slti $t2, $t0, 4
    beq $t2, $zero, .L0_L26
    lw $t0, -56($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -16($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -168($fp)
    addiu $sp, $sp, -4
    lw $t0, -168($fp)
    sw $t0, 0($sp)
    jal R_atof
    addiu $sp, $sp, 4
    s.d $f0, -176($fp)
    l.d $f4, -52($fp)
    l.d $f6, -176($fp)
    add.d $f0, $f4, $f6
    s.d $f0, -184($fp)
    l.d $f0, -184($fp)
    s.d $f0, -52($fp)
.L0_L25:
    lw $t0, -56($fp)
    addiu $t2, $t0, 1
    sw $t2, -56($fp)
    j .L0_L24
.L0_L26:
    addiu $sp, $sp, -12
    la $t0, str5
    sw $t0, 0($sp)
    l.d $f0, -52($fp)
    s.d $f0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 12
    sw $v0, -188($fp)
    lw $t0, -12($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -16($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -192($fp)
    li $t2, 0
    lw $t0, -192($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .L0_L27
    la $t2, str7
    sw $t2, -196($fp)
    j .L0_L28
.L0_L27:
    la $t2, str8
    sw $t2, -196($fp)
.L0_L28:
    addiu $sp, $sp, -8
    la $t0, str6
    sw $t0, 0($sp)
    lw $t0, -196($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -200($fp)
    li $v0, 0
.Lret0:
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
Rstr1: .asciiz "0123456789ABCDEF"
Rstr2: .asciiz "0123456789abcdef"
Rstr3: .asciiz "NAN"
Rstr4: .asciiz "nan"
Rstr5: .asciiz "INF"
Rstr6: .asciiz "inf"
Rstr7: .asciiz ""
Rstr8: .asciiz "(nil)"
Rstr9: .asciiz "(null)"
.align 2
R___fns_free_list: .word 0
.align 2
R___fns_rtab: .space 136
.align 2
R___fns_ridx: .word 0
.align 2
R___fns_rseeded: .word 0
.align 2
R___fns_tok_next: .word 0
.align 2
R___fns_std: .space 80

.text
















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
    beq $t2, $zero, .R15_L61
    li $t2, 57
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R15_L61
    li $t2, 1
    sw $t2, -12($fp)
    j .R15_L62
.R15_L61:
    li $t2, 0
    sw $t2, -12($fp)
.R15_L62:
    lw $v0, -12($fp)
.Rret15:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra





R_isspace:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 32
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R20_L79
    li $t2, 9
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R20_L79
    li $t2, 0
    sw $t2, -12($fp)
    j .R20_L80
.R20_L79:
    li $t2, 1
    sw $t2, -12($fp)
.R20_L80:
    lw $t0, -12($fp)
    bne $t0, $zero, .R20_L77
    li $t2, 10
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R20_L77
    li $t2, 0
    sw $t2, -16($fp)
    j .R20_L78
.R20_L77:
    li $t2, 1
    sw $t2, -16($fp)
.R20_L78:
    lw $t0, -16($fp)
    bne $t0, $zero, .R20_L75
    li $t2, 13
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R20_L75
    li $t2, 0
    sw $t2, -20($fp)
    j .R20_L76
.R20_L75:
    li $t2, 1
    sw $t2, -20($fp)
.R20_L76:
    lw $t0, -20($fp)
    bne $t0, $zero, .R20_L73
    lw $t0, 0($fp)
    li $t1, 11
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R20_L73
    li $t2, 0
    sw $t2, -24($fp)
    j .R20_L74
.R20_L73:
    li $t2, 1
    sw $t2, -24($fp)
.R20_L74:
    lw $t0, -24($fp)
    bne $t0, $zero, .R20_L71
    lw $t0, 0($fp)
    li $t1, 12
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R20_L71
    li $t2, 0
    sw $t2, -28($fp)
    j .R20_L72
.R20_L71:
    li $t2, 1
    sw $t2, -28($fp)
.R20_L72:
    lw $v0, -28($fp)
.Rret20:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_isxdigit:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_isdigit
    addiu $sp, $sp, 4
    sw $v0, -12($fp)
    lw $t0, -12($fp)
    bne $t0, $zero, .R21_L83
    li $t2, 97
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R21_L85
    li $t2, 102
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R21_L85
    li $t2, 1
    sw $t2, -16($fp)
    j .R21_L86
.R21_L85:
    li $t2, 0
    sw $t2, -16($fp)
.R21_L86:
    lw $t0, -16($fp)
    bne $t0, $zero, .R21_L83
    li $t2, 0
    sw $t2, -20($fp)
    j .R21_L84
.R21_L83:
    li $t2, 1
    sw $t2, -20($fp)
.R21_L84:
    lw $t0, -20($fp)
    bne $t0, $zero, .R21_L81
    li $t2, 65
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R21_L87
    li $t2, 70
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R21_L87
    li $t2, 1
    sw $t2, -24($fp)
    j .R21_L88
.R21_L87:
    li $t2, 0
    sw $t2, -24($fp)
.R21_L88:
    lw $t0, -24($fp)
    bne $t0, $zero, .R21_L81
    li $t2, 0
    sw $t2, -28($fp)
    j .R21_L82
.R21_L81:
    li $t2, 1
    sw $t2, -28($fp)
.R21_L82:
    lw $v0, -28($fp)
.Rret21:
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
.R26_L99:
    lw $t0, 0($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    beq $t2, $zero, .R26_L100
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R26_L99
.R26_L100:
    lw $v0, -12($fp)
.Rret26:
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
    beq $t2, $zero, .R42_L162
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
    j .Rret42
.R42_L162:
    lw $t0, -20($fp)
    li $t1, 52
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R42_L163
    l.d $f0, 0($fp)
    j .Rret42
.R42_L163:
    lw $t0, -20($fp)
    slti $t2, $t0, 20
    beq $t2, $zero, .R42_L164
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
    j .R42_L165
.R42_L164:
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
.R42_L165:
    addiu $t2, $fp, -16
    sw $t2, -72($fp)
    lw $t1, -72($fp)
    l.d $f0, 0($t1)
    s.d $f0, -80($fp)
    l.d $f0, -80($fp)
.Rret42:
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
    beq $t2, $zero, .R43_L166
    l.d $f4, -16($fp)
    li.d $f6, 1.0
    sub.d $f0, $f4, $f6
    s.d $f0, -32($fp)
    l.d $f0, -32($fp)
    s.d $f0, -16($fp)
.R43_L166:
    l.d $f0, -16($fp)
.Rret43:
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
    beq $t2, $zero, .R46_L169
    li.d $f4, 0.0
    li.d $f6, 0.0
    div.d $f0, $f4, $f6
    s.d $f0, -24($fp)
    l.d $f0, -24($fp)
    j .Rret46
.R46_L169:
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
.Rret46:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra












R_strtol:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -152
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t2, 0($fp)
    sw $t2, -12($fp)
    li $t2, 0
    sw $t2, -16($fp)
    li $t2, 0
    sw $t2, -20($fp)
    li $t2, 0
    sw $t2, -24($fp)
.R58_L210:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -32($fp)
    addiu $sp, $sp, -4
    lw $t0, -32($fp)
    sw $t0, 0($sp)
    jal R_isspace
    addiu $sp, $sp, 4
    sw $v0, -36($fp)
    lw $t0, -36($fp)
    beq $t0, $zero, .R58_L211
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R58_L210
.R58_L211:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -40($fp)
    li $t2, 45
    lw $t0, -40($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R58_L212
    li $t2, 1
    sw $t2, -20($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R58_L213
.R58_L212:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -44($fp)
    li $t2, 43
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R58_L214
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
.R58_L214:
.R58_L213:
    lw $t0, 8($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R58_L222
    lw $t0, 8($fp)
    li $t1, 16
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R58_L222
    li $t2, 0
    sw $t2, -48($fp)
    j .R58_L223
.R58_L222:
    li $t2, 1
    sw $t2, -48($fp)
.R58_L223:
    lw $t0, -48($fp)
    beq $t0, $zero, .R58_L220
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -52($fp)
    li $t2, 48
    lw $t0, -52($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R58_L220
    li $t2, 1
    sw $t2, -56($fp)
    j .R58_L221
.R58_L220:
    li $t2, 0
    sw $t2, -56($fp)
.R58_L221:
    lw $t0, -56($fp)
    beq $t0, $zero, .R58_L218
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    lb $t2, 0($t2)
    sw $t2, -60($fp)
    li $t2, 120
    lw $t0, -60($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R58_L224
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    lb $t2, 0($t2)
    sw $t2, -64($fp)
    li $t2, 88
    lw $t0, -64($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R58_L224
    li $t2, 0
    sw $t2, -68($fp)
    j .R58_L225
.R58_L224:
    li $t2, 1
    sw $t2, -68($fp)
.R58_L225:
    lw $t0, -68($fp)
    beq $t0, $zero, .R58_L218
    li $t2, 1
    sw $t2, -72($fp)
    j .R58_L219
.R58_L218:
    li $t2, 0
    sw $t2, -72($fp)
.R58_L219:
    lw $t0, -72($fp)
    beq $t0, $zero, .R58_L216
    lw $t0, -12($fp)
    addiu $t2, $t0, 2
    lb $t2, 0($t2)
    sw $t2, -76($fp)
    addiu $sp, $sp, -4
    lw $t0, -76($fp)
    sw $t0, 0($sp)
    jal R_isxdigit
    addiu $sp, $sp, 4
    sw $v0, -80($fp)
    lw $t0, -80($fp)
    beq $t0, $zero, .R58_L216
    li $t2, 1
    sw $t2, -84($fp)
    j .R58_L217
.R58_L216:
    li $t2, 0
    sw $t2, -84($fp)
.R58_L217:
    lw $t0, -84($fp)
    beq $t0, $zero, .R58_L215
    lw $t0, -12($fp)
    addiu $t2, $t0, 2
    sw $t2, -12($fp)
    li $t2, 16
    sw $t2, 8($fp)
    j .R58_L226
.R58_L215:
    lw $t0, 8($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R58_L228
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -88($fp)
    li $t2, 48
    lw $t0, -88($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R58_L228
    li $t2, 1
    sw $t2, -92($fp)
    j .R58_L229
.R58_L228:
    li $t2, 0
    sw $t2, -92($fp)
.R58_L229:
    lw $t0, -92($fp)
    beq $t0, $zero, .R58_L227
    li $t2, 8
    sw $t2, 8($fp)
    j .R58_L230
.R58_L227:
    lw $t0, 8($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R58_L231
    li $t2, 10
    sw $t2, 8($fp)
.R58_L231:
.R58_L230:
.R58_L226:
.R58_L232:
    li $t0, 1
    beq $t0, $zero, .R58_L233
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -96($fp)
    addiu $sp, $sp, -4
    lw $t0, -96($fp)
    sw $t0, 0($sp)
    jal R_isdigit
    addiu $sp, $sp, 4
    sw $v0, -100($fp)
    lw $t0, -100($fp)
    beq $t0, $zero, .R58_L234
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -104($fp)
    li $t2, 48
    lw $t0, -104($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sw $t2, -28($fp)
    j .R58_L235
.R58_L234:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -108($fp)
    li $t2, 97
    lw $t0, -108($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R58_L237
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -112($fp)
    li $t2, 122
    lw $t0, -112($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R58_L237
    li $t2, 1
    sw $t2, -116($fp)
    j .R58_L238
.R58_L237:
    li $t2, 0
    sw $t2, -116($fp)
.R58_L238:
    lw $t0, -116($fp)
    beq $t0, $zero, .R58_L236
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -120($fp)
    li $t2, 97
    lw $t0, -120($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    move $t0, $t2
    addiu $t2, $t0, 10
    sw $t2, -28($fp)
    j .R58_L239
.R58_L236:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -124($fp)
    li $t2, 65
    lw $t0, -124($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R58_L241
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -128($fp)
    li $t2, 90
    lw $t0, -128($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R58_L241
    li $t2, 1
    sw $t2, -132($fp)
    j .R58_L242
.R58_L241:
    li $t2, 0
    sw $t2, -132($fp)
.R58_L242:
    lw $t0, -132($fp)
    beq $t0, $zero, .R58_L240
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -136($fp)
    li $t2, 65
    lw $t0, -136($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    move $t0, $t2
    addiu $t2, $t0, 10
    sw $t2, -28($fp)
    j .R58_L243
.R58_L240:
    j .R58_L233
.R58_L243:
.R58_L239:
.R58_L235:
    lw $t0, -28($fp)
    lw $t1, 8($fp)
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R58_L244
    j .R58_L233
.R58_L244:
    lw $t2, 8($fp)
    lw $t0, -16($fp)
    move $t1, $t2
    mult $t0, $t1
    mflo $t2
    sw $t2, -140($fp)
    lw $t2, -28($fp)
    lw $t0, -140($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -16($fp)
    li $t2, 1
    sw $t2, -24($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R58_L232
.R58_L233:
    lw $t0, 4($fp)
    beq $t0, $zero, .R58_L245
    lw $t0, -24($fp)
    beq $t0, $zero, .R58_L246
    lw $t2, -12($fp)
    sw $t2, -144($fp)
    j .R58_L247
.R58_L246:
    lw $t2, 0($fp)
    sw $t2, -144($fp)
.R58_L247:
    lw $t2, -144($fp)
    lw $t1, 4($fp)
    sw $t2, 0($t1)
.R58_L245:
    lw $t0, -20($fp)
    beq $t0, $zero, .R58_L248
    lw $t0, -16($fp)
    subu $t2, $zero, $t0
    sw $t2, -148($fp)
    j .R58_L249
.R58_L248:
    lw $t2, -16($fp)
    sw $t2, -148($fp)
.R58_L249:
    lw $v0, -148($fp)
.Rret58:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_atoi:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
    addiu $sp, $sp, -12
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -12($fp)
    sw $t0, 4($sp)
    li $t0, 10
    sw $t0, 8($sp)
    jal R_strtol
    addiu $sp, $sp, 12
    sw $v0, -16($fp)
    lw $t2, -16($fp)
    move $v0, $t2
.Rret59:
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
    beq $t0, $zero, .R61_L250
    lw $t0, 0($fp)
    subu $t2, $zero, $t0
    sw $t2, 0($fp)
.R61_L250:
.R61_L251:
    lw $t0, 0($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R61_L252
    lw $t0, 0($fp)
    andi $t2, $t0, 1
    beq $t2, $zero, .R61_L253
    l.d $f4, -16($fp)
    l.d $f6, -24($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -36($fp)
    l.d $f0, -36($fp)
    s.d $f0, -16($fp)
.R61_L253:
    l.d $f4, -24($fp)
    l.d $f6, -24($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -44($fp)
    l.d $f0, -44($fp)
    s.d $f0, -24($fp)
    lw $t0, 0($fp)
    sra $t2, $t0, 1
    sw $t2, 0($fp)
    j .R61_L251
.R61_L252:
    lw $t0, -28($fp)
    beq $t0, $zero, .R61_L254
    li.d $f4, 1.0
    l.d $f6, -16($fp)
    div.d $f0, $f4, $f6
    s.d $f0, -52($fp)
    l.d $f0, -52($fp)
    s.d $f0, -60($fp)
    j .R61_L255
.R61_L254:
    l.d $f0, -16($fp)
    s.d $f0, -60($fp)
.R61_L255:
    l.d $f0, -60($fp)
.Rret61:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strtod:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -296
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t2, 0($fp)
    sw $t2, -12($fp)
    li.d $f0, 0.0
    s.d $f0, -20($fp)
    li $t2, 0
    sw $t2, -24($fp)
    li $t2, 0
    sw $t2, -28($fp)
    li $t2, 0
    sw $t2, -32($fp)
    li $t2, 0
    sw $t2, -36($fp)
.R62_L256:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -56($fp)
    addiu $sp, $sp, -4
    lw $t0, -56($fp)
    sw $t0, 0($sp)
    jal R_isspace
    addiu $sp, $sp, 4
    sw $v0, -60($fp)
    lw $t0, -60($fp)
    beq $t0, $zero, .R62_L257
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R62_L256
.R62_L257:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -64($fp)
    li $t2, 45
    lw $t0, -64($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R62_L258
    li $t2, 1
    sw $t2, -24($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R62_L259
.R62_L258:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -68($fp)
    li $t2, 43
    lw $t0, -68($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R62_L260
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
.R62_L260:
.R62_L259:
.R62_L261:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -72($fp)
    addiu $sp, $sp, -4
    lw $t0, -72($fp)
    sw $t0, 0($sp)
    jal R_isdigit
    addiu $sp, $sp, 4
    sw $v0, -76($fp)
    lw $t0, -76($fp)
    beq $t0, $zero, .R62_L262
    lw $t0, -36($fp)
    slti $t2, $t0, 18
    beq $t2, $zero, .R62_L263
    l.d $f4, -20($fp)
    li.d $f6, 10.0
    mul.d $f0, $f4, $f6
    s.d $f0, -84($fp)
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -88($fp)
    li $t2, 48
    lw $t0, -88($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sw $t2, -92($fp)
    lw $t0, -92($fp)
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -100($fp)
    l.d $f4, -84($fp)
    l.d $f6, -100($fp)
    add.d $f0, $f4, $f6
    s.d $f0, -108($fp)
    l.d $f0, -108($fp)
    s.d $f0, -20($fp)
    lw $t0, -36($fp)
    addiu $t2, $t0, 1
    sw $t2, -36($fp)
    j .R62_L264
.R62_L263:
    lw $t0, -32($fp)
    addiu $t2, $t0, 1
    sw $t2, -32($fp)
.R62_L264:
    li $t2, 1
    sw $t2, -28($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R62_L261
.R62_L262:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -112($fp)
    li $t2, 46
    lw $t0, -112($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R62_L265
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
.R62_L266:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -116($fp)
    addiu $sp, $sp, -4
    lw $t0, -116($fp)
    sw $t0, 0($sp)
    jal R_isdigit
    addiu $sp, $sp, 4
    sw $v0, -120($fp)
    lw $t0, -120($fp)
    beq $t0, $zero, .R62_L267
    lw $t0, -36($fp)
    slti $t2, $t0, 18
    beq $t2, $zero, .R62_L268
    l.d $f4, -20($fp)
    li.d $f6, 10.0
    mul.d $f0, $f4, $f6
    s.d $f0, -128($fp)
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -132($fp)
    li $t2, 48
    lw $t0, -132($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sw $t2, -136($fp)
    lw $t0, -136($fp)
    mtc1 $t0, $f4
    cvt.d.w $f0, $f4
    s.d $f0, -144($fp)
    l.d $f4, -128($fp)
    l.d $f6, -144($fp)
    add.d $f0, $f4, $f6
    s.d $f0, -152($fp)
    l.d $f0, -152($fp)
    s.d $f0, -20($fp)
    lw $t0, -36($fp)
    addiu $t2, $t0, 1
    sw $t2, -36($fp)
    lw $t0, -32($fp)
    addiu $t2, $t0, -1
    sw $t2, -32($fp)
.R62_L268:
    li $t2, 1
    sw $t2, -28($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R62_L266
.R62_L267:
.R62_L265:
    lw $t0, -28($fp)
    beq $t0, $zero, .R62_L270
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -156($fp)
    li $t2, 101
    lw $t0, -156($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R62_L272
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -160($fp)
    li $t2, 69
    lw $t0, -160($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R62_L272
    li $t2, 0
    sw $t2, -164($fp)
    j .R62_L273
.R62_L272:
    li $t2, 1
    sw $t2, -164($fp)
.R62_L273:
    lw $t0, -164($fp)
    beq $t0, $zero, .R62_L270
    li $t2, 1
    sw $t2, -168($fp)
    j .R62_L271
.R62_L270:
    li $t2, 0
    sw $t2, -168($fp)
.R62_L271:
    lw $t0, -168($fp)
    beq $t0, $zero, .R62_L269
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -40($fp)
    li $t2, 0
    sw $t2, -44($fp)
    li $t2, 0
    sw $t2, -48($fp)
    li $t2, 0
    sw $t2, -52($fp)
    lw $t1, -40($fp)
    lb $t2, 0($t1)
    sw $t2, -172($fp)
    li $t2, 45
    lw $t0, -172($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R62_L274
    li $t2, 1
    sw $t2, -44($fp)
    lw $t0, -40($fp)
    addiu $t2, $t0, 1
    sw $t2, -40($fp)
    j .R62_L275
.R62_L274:
    lw $t1, -40($fp)
    lb $t2, 0($t1)
    sw $t2, -176($fp)
    li $t2, 43
    lw $t0, -176($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R62_L276
    lw $t0, -40($fp)
    addiu $t2, $t0, 1
    sw $t2, -40($fp)
.R62_L276:
.R62_L275:
.R62_L277:
    lw $t1, -40($fp)
    lb $t2, 0($t1)
    sw $t2, -180($fp)
    addiu $sp, $sp, -4
    lw $t0, -180($fp)
    sw $t0, 0($sp)
    jal R_isdigit
    addiu $sp, $sp, 4
    sw $v0, -184($fp)
    lw $t0, -184($fp)
    beq $t0, $zero, .R62_L278
    lw $t0, -48($fp)
    li $t1, 10
    mult $t0, $t1
    mflo $t2
    sw $t2, -188($fp)
    lw $t1, -40($fp)
    lb $t2, 0($t1)
    sw $t2, -192($fp)
    li $t2, 48
    lw $t0, -192($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    lw $t0, -188($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -48($fp)
    li $t2, 1
    sw $t2, -52($fp)
    lw $t0, -40($fp)
    addiu $t2, $t0, 1
    sw $t2, -40($fp)
    j .R62_L277
.R62_L278:
    lw $t0, -52($fp)
    beq $t0, $zero, .R62_L279
    lw $t2, -40($fp)
    sw $t2, -12($fp)
    lw $t0, -44($fp)
    beq $t0, $zero, .R62_L280
    lw $t0, -48($fp)
    subu $t2, $zero, $t0
    sw $t2, -196($fp)
    j .R62_L281
.R62_L280:
    lw $t2, -48($fp)
    sw $t2, -196($fp)
.R62_L281:
    lw $t0, -32($fp)
    lw $t1, -196($fp)
    addu $t2, $t0, $t1
    sw $t2, -32($fp)
.R62_L279:
.R62_L269:
    lw $t0, 4($fp)
    beq $t0, $zero, .R62_L282
    lw $t0, -28($fp)
    beq $t0, $zero, .R62_L283
    lw $t2, -12($fp)
    sw $t2, -200($fp)
    j .R62_L284
.R62_L283:
    lw $t2, 0($fp)
    sw $t2, -200($fp)
.R62_L284:
    lw $t2, -200($fp)
    lw $t1, 4($fp)
    sw $t2, 0($t1)
.R62_L282:
    lw $t0, -28($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R62_L285
    li.d $f0, 0.0
    j .Rret62
.R62_L285:
    lw $t0, -32($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R62_L287
    lw $t0, -32($fp)
    li $t1, -22
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R62_L287
    li $t2, 1
    sw $t2, -204($fp)
    j .R62_L288
.R62_L287:
    li $t2, 0
    sw $t2, -204($fp)
.R62_L288:
    lw $t0, -204($fp)
    beq $t0, $zero, .R62_L286
    lw $t0, -32($fp)
    subu $t2, $zero, $t0
    sw $t2, -208($fp)
    addiu $sp, $sp, -4
    lw $t0, -208($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -216($fp)
    l.d $f4, -20($fp)
    l.d $f6, -216($fp)
    div.d $f0, $f4, $f6
    s.d $f0, -224($fp)
    l.d $f0, -224($fp)
    s.d $f0, -20($fp)
    j .R62_L289
.R62_L286:
    lw $t0, -32($fp)
    slti $t2, $t0, -22
    beq $t2, $zero, .R62_L290
    addiu $sp, $sp, -4
    li $t0, 22
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -232($fp)
    l.d $f4, -20($fp)
    l.d $f6, -232($fp)
    div.d $f0, $f4, $f6
    s.d $f0, -240($fp)
    l.d $f0, -240($fp)
    s.d $f0, -20($fp)
    lw $t0, -32($fp)
    subu $t2, $zero, $t0
    move $t0, $t2
    addiu $t2, $t0, -22
    sw $t2, -244($fp)
    addiu $sp, $sp, -4
    lw $t0, -244($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -252($fp)
    l.d $f4, -20($fp)
    l.d $f6, -252($fp)
    div.d $f0, $f4, $f6
    s.d $f0, -260($fp)
    l.d $f0, -260($fp)
    s.d $f0, -20($fp)
    j .R62_L291
.R62_L290:
    lw $t0, -32($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R62_L292
    addiu $sp, $sp, -4
    lw $t0, -32($fp)
    sw $t0, 0($sp)
    jal R___fns_pow10
    addiu $sp, $sp, 4
    s.d $f0, -268($fp)
    l.d $f4, -20($fp)
    l.d $f6, -268($fp)
    mul.d $f0, $f4, $f6
    s.d $f0, -276($fp)
    l.d $f0, -276($fp)
    s.d $f0, -20($fp)
.R62_L292:
.R62_L291:
.R62_L289:
    lw $t0, -24($fp)
    beq $t0, $zero, .R62_L293
    l.d $f4, -20($fp)
    neg.d $f0, $f4
    s.d $f0, -284($fp)
    l.d $f0, -284($fp)
    s.d $f0, -292($fp)
    j .R62_L294
.R62_L293:
    l.d $f0, -20($fp)
    s.d $f0, -292($fp)
.R62_L294:
    l.d $f0, -292($fp)
.Rret62:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_atof:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -12($fp)
    sw $t0, 4($sp)
    jal R_strtod
    addiu $sp, $sp, 8
    s.d $f0, -20($fp)
    l.d $f0, -20($fp)
.Rret63:
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
    beq $t2, $zero, .R66_L309
    li $t2, 3
    lw $t0, -12($fp)
    move $t1, $t2
    sltu $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R66_L309
    li $t2, 1
    sw $t2, -20($fp)
    j .R66_L310
.R66_L309:
    li $t2, 0
    sw $t2, -20($fp)
.R66_L310:
    lw $t0, -20($fp)
    beq $t0, $zero, .R66_L308
    la $t2, R___fns_std
    sw $t2, -24($fp)
    lw $t0, -12($fp)
    li $t1, 20
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
    beq $t2, $zero, .R66_L311
    li $t2, 1
    sw $t2, -32($fp)
    j .R66_L312
.R66_L311:
    li $t2, 2
    sw $t2, -32($fp)
.R66_L312:
    lw $t0, -32($fp)
    lw $t1, -28($fp)
    sw $t0, 0($t1)
    lw $v0, -16($fp)
    j .Rret66
.R66_L308:
    lw $v0, 0($fp)
.Rret66:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra





R_fputc:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -40
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
    beq $t2, $zero, .R71_L336
    li $v0, -1
    j .Rret71
.R71_L336:
    lw $t1, -12($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    li $t1, 1
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R71_L338
    lw $t1, -12($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    li $t1, 2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R71_L338
    li $t2, 0
    sw $t2, -24($fp)
    j .R71_L339
.R71_L338:
    li $t2, 1
    sw $t2, -24($fp)
.R71_L339:
    lw $t0, -24($fp)
    beq $t0, $zero, .R71_L337
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
    j .Rret71
.R71_L337:
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
    beq $t2, $zero, .R71_L340
    lw $t0, -12($fp)
    addiu $t2, $t0, 16
    li $t0, 1
    sw $t0, 0($t2)
    li $v0, -1
    j .Rret71
.R71_L340:
    lw $t0, 0($fp)
    andi $t2, $t0, 255
    move $v0, $t2
.Rret71:
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
    beq $t2, $zero, .R85_L374
    lw $t0, 0($fp)
    addiu $t2, $t0, 12
    lw $t2, 0($t2)
    move $t0, $t2
    slti $t2, $t0, 0
    bne $t2, $zero, .R85_L376
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
    bne $t2, $zero, .R85_L376
    li $t2, 0
    sw $t2, -16($fp)
    j .R85_L377
.R85_L376:
    li $t2, 1
    sw $t2, -16($fp)
.R85_L377:
    lw $t0, -16($fp)
    beq $t0, $zero, .R85_L375
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
.R85_L375:
    j .R85_L378
.R85_L374:
    lw $t1, 0($fp)
    lw $t2, 0($t1)
    beq $t2, $zero, .R85_L379
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
.R85_L379:
.R85_L378:
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    sw $t2, -36($fp)
    lw $t1, -36($fp)
    lw $t2, 0($t1)
    move $t0, $t2
    addiu $t2, $t0, 1
    lw $t1, -36($fp)
    sw $t2, 0($t1)
.Rret85:
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
.R86_L380:
    lw $t2, 8($fp)
    sw $t2, -12($fp)
    lw $t0, 8($fp)
    addiu $t2, $t0, -1
    sw $t2, 8($fp)
    lw $t0, -12($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R86_L381
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, 4($fp)
    sw $t0, 4($sp)
    jal R___fns_put
    addiu $sp, $sp, 8
    j .R86_L380
.R86_L381:
.Rret86:
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
    beq $t2, $zero, .R87_L383
    lw $t0, 24($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R87_L383
    li $t2, 1
    sw $t2, -28($fp)
    j .R87_L384
.R87_L383:
    li $t2, 0
    sw $t2, -28($fp)
.R87_L384:
    lw $t0, -28($fp)
    beq $t0, $zero, .R87_L382
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
.R87_L382:
    li $t2, 0
    sw $t2, -20($fp)
.R87_L385:
    lw $t0, -20($fp)
    lw $t1, -12($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R87_L387
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
.R87_L386:
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .R87_L385
.R87_L387:
    lw $t0, 20($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R87_L389
    lw $t0, 24($fp)
    beq $t0, $zero, .R87_L389
    li $t2, 1
    sw $t2, -40($fp)
    j .R87_L390
.R87_L389:
    li $t2, 0
    sw $t2, -40($fp)
.R87_L390:
    lw $t0, -40($fp)
    beq $t0, $zero, .R87_L388
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
.R87_L388:
    li $t2, 0
    sw $t2, -20($fp)
.R87_L391:
    lw $t0, -20($fp)
    lw $t1, 12($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R87_L393
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
.R87_L392:
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .R87_L391
.R87_L393:
    lw $t0, 20($fp)
    beq $t0, $zero, .R87_L394
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
.R87_L394:
.Rret87:
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
    beq $t0, $zero, .R88_L395
    la $t2, Rstr1
    sw $t2, -120($fp)
    j .R88_L396
.R88_L395:
    la $t2, Rstr2
    sw $t2, -120($fp)
.R88_L396:
    lw $t2, -120($fp)
    sw $t2, -104($fp)
    li $t2, 0
    sw $t2, -108($fp)
    li $t2, 0
    sw $t2, -112($fp)
    li $t2, 0
    sw $t2, -116($fp)
.R88_L397:
    lw $t0, 4($fp)
    beq $t0, $zero, .R88_L398
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
    j .R88_L397
.R88_L398:
    lw $t0, 36($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R88_L399
    li $t2, 1
    sw $t2, 36($fp)
    j .R88_L400
.R88_L399:
    li $t2, 0
    sw $t2, 44($fp)
.R88_L400:
.R88_L401:
    lw $t0, -108($fp)
    lw $t1, 36($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R88_L402
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
    j .R88_L401
.R88_L402:
    lw $t0, 28($fp)
    beq $t0, $zero, .R88_L406
    lw $t0, 12($fp)
    li $t1, 8
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R88_L406
    li $t2, 1
    sw $t2, -144($fp)
    j .R88_L407
.R88_L406:
    li $t2, 0
    sw $t2, -144($fp)
.R88_L407:
    lw $t0, -144($fp)
    beq $t0, $zero, .R88_L404
    lw $t0, -108($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R88_L408
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
    bne $t2, $zero, .R88_L408
    li $t2, 0
    sw $t2, -156($fp)
    j .R88_L409
.R88_L408:
    li $t2, 1
    sw $t2, -156($fp)
.R88_L409:
    lw $t0, -156($fp)
    beq $t0, $zero, .R88_L404
    li $t2, 1
    sw $t2, -160($fp)
    j .R88_L405
.R88_L404:
    li $t2, 0
    sw $t2, -160($fp)
.R88_L405:
    lw $t0, -160($fp)
    beq $t0, $zero, .R88_L403
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
.R88_L403:
.R88_L410:
    lw $t0, -108($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R88_L411
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
    j .R88_L410
.R88_L411:
    lw $t0, 8($fp)
    beq $t0, $zero, .R88_L412
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
    j .R88_L413
.R88_L412:
    lw $t0, 20($fp)
    beq $t0, $zero, .R88_L414
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
    j .R88_L415
.R88_L414:
    lw $t0, 24($fp)
    beq $t0, $zero, .R88_L416
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
.R88_L416:
.R88_L415:
.R88_L413:
    lw $t0, 28($fp)
    beq $t0, $zero, .R88_L422
    lw $t0, 12($fp)
    li $t1, 16
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R88_L422
    li $t2, 1
    sw $t2, -216($fp)
    j .R88_L423
.R88_L422:
    li $t2, 0
    sw $t2, -216($fp)
.R88_L423:
    lw $t0, -216($fp)
    beq $t0, $zero, .R88_L420
    lw $t0, -112($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R88_L420
    li $t2, 1
    sw $t2, -220($fp)
    j .R88_L421
.R88_L420:
    li $t2, 0
    sw $t2, -220($fp)
.R88_L421:
    lw $t0, -220($fp)
    beq $t0, $zero, .R88_L418
    lw $t0, -112($fp)
    li $t1, 1
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R88_L424
    addiu $t2, $fp, -96
    lb $t2, 0($t2)
    sw $t2, -224($fp)
    li $t2, 48
    lw $t0, -224($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R88_L424
    li $t2, 1
    sw $t2, -228($fp)
    j .R88_L425
.R88_L424:
    li $t2, 0
    sw $t2, -228($fp)
.R88_L425:
    lw $t0, -228($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R88_L418
    li $t2, 1
    sw $t2, -232($fp)
    j .R88_L419
.R88_L418:
    li $t2, 0
    sw $t2, -232($fp)
.R88_L419:
    lw $t0, -232($fp)
    beq $t0, $zero, .R88_L417
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
    beq $t0, $zero, .R88_L426
    li $t2, 88
    sw $t2, -256($fp)
    j .R88_L427
.R88_L426:
    li $t2, 120
    sw $t2, -256($fp)
.R88_L427:
    lw $t2, -256($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -252($fp)
    sb $t2, 0($t1)
.R88_L417:
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
.Rret88:
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
.Rret89:
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
    beq $t2, $zero, .R90_L428
    li $t0, 48
    lw $t1, 8($fp)
    sb $t0, 0($t1)
    li $v0, 1
    j .Rret90
.R90_L428:
.R90_L429:
    l.d $f4, 0($fp)
    li.d $f6, 1.0
    li $t2, 0
    c.le.d $f6, $f4
    bc1f .Rfc20
    li $t2, 1
.Rfc20:
    beq $t2, $zero, .R90_L431
    lw $t0, -12($fp)
    slti $t2, $t0, 330
    beq $t2, $zero, .R90_L431
    li $t2, 1
    sw $t2, -28($fp)
    j .R90_L432
.R90_L431:
    li $t2, 0
    sw $t2, -28($fp)
.R90_L432:
    lw $t0, -28($fp)
    beq $t0, $zero, .R90_L430
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
    j .R90_L429
.R90_L430:
.R90_L433:
    lw $t0, -12($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R90_L434
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
    j .R90_L433
.R90_L434:
    lw $v0, -16($fp)
.Rret90:
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
    beq $t2, $zero, .R91_L435
    l.d $f4, -32($fp)
    li.d $f6, 1.0
    add.d $f0, $f4, $f6
    s.d $f0, -88($fp)
    l.d $f0, -88($fp)
    j .Rret91
.R91_L435:
    l.d $f4, -40($fp)
    li.d $f6, 0.5
    li $t2, 0
    c.lt.d $f4, $f6
    bc1f .Rfc22
    li $t2, 1
.Rfc22:
    beq $t2, $zero, .R91_L436
    l.d $f0, -32($fp)
    j .Rret91
.R91_L436:
    lw $t0, 8($fp)
    li $t1, 22
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R91_L437
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
    j .R91_L438
.R91_L437:
    li.d $f0, 0.0
    s.d $f0, -104($fp)
.R91_L438:
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
    beq $t2, $zero, .R91_L439
    l.d $f4, -32($fp)
    li.d $f6, 1.0
    add.d $f0, $f4, $f6
    s.d $f0, -120($fp)
    l.d $f0, -120($fp)
    j .Rret91
.R91_L439:
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
    beq $t2, $zero, .R91_L440
    l.d $f0, -32($fp)
    j .Rret91
.R91_L440:
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
    beq $t2, $zero, .R91_L441
    l.d $f4, -32($fp)
    li.d $f6, 1.0
    add.d $f0, $f4, $f6
    s.d $f0, -152($fp)
    l.d $f0, -152($fp)
    j .Rret91
.R91_L441:
    l.d $f0, -32($fp)
.Rret91:
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
    beq $t2, $zero, .R92_L442
    li $t2, 0
    sw $t2, -20($fp)
.R92_L442:
.R92_L443:
    lw $t0, 8($fp)
    addiu $t2, $t0, 1
    lw $t0, -20($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    beq $t2, $zero, .R92_L444
    lw $t2, -20($fp)
    sw $t2, -24($fp)
.R92_L445:
    lw $t0, -24($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R92_L447
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
.R92_L446:
    lw $t0, -24($fp)
    addiu $t2, $t0, -1
    sw $t2, -24($fp)
    j .R92_L445
.R92_L447:
    addiu $t2, $fp, -440
    li $t0, 48
    sb $t0, 0($t2)
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .R92_L443
.R92_L444:
    lw $t0, -20($fp)
    lw $t1, 8($fp)
    subu $t2, $t0, $t1
    sw $t2, -32($fp)
    li $t2, 0
    sw $t2, -24($fp)
.R92_L448:
    lw $t0, -24($fp)
    lw $t1, -32($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R92_L450
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
.R92_L449:
    lw $t0, -24($fp)
    addiu $t2, $t0, 1
    sw $t2, -24($fp)
    j .R92_L448
.R92_L450:
    lw $t0, 8($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    bne $t2, $zero, .R92_L452
    lw $t0, 12($fp)
    bne $t0, $zero, .R92_L452
    li $t2, 0
    sw $t2, -68($fp)
    j .R92_L453
.R92_L452:
    li $t2, 1
    sw $t2, -68($fp)
.R92_L453:
    lw $t0, -68($fp)
    beq $t0, $zero, .R92_L451
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
.R92_L451:
    lw $t2, -32($fp)
    sw $t2, -24($fp)
.R92_L454:
    lw $t0, -24($fp)
    lw $t1, -20($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R92_L456
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
.R92_L455:
    lw $t0, -24($fp)
    addiu $t2, $t0, 1
    sw $t2, -24($fp)
    j .R92_L454
.R92_L456:
    lw $v0, -28($fp)
.Rret92:
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
    beq $t2, $zero, .R93_L457
    li $v0, 0
    j .Rret93
.R93_L457:
.R93_L458:
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
    beq $t2, $zero, .R93_L460
    lw $t0, -12($fp)
    slti $t2, $t0, 308
    beq $t2, $zero, .R93_L460
    li $t2, 1
    sw $t2, -44($fp)
    j .R93_L461
.R93_L460:
    li $t2, 0
    sw $t2, -44($fp)
.R93_L461:
    lw $t0, -44($fp)
    beq $t0, $zero, .R93_L459
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R93_L458
.R93_L459:
.R93_L462:
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
    beq $t2, $zero, .R93_L464
    lw $t0, -12($fp)
    li $t1, -320
    slt $t2, $t1, $t0
    beq $t2, $zero, .R93_L464
    li $t2, 1
    sw $t2, -56($fp)
    j .R93_L465
.R93_L464:
    li $t2, 0
    sw $t2, -56($fp)
.R93_L465:
    lw $t0, -56($fp)
    beq $t0, $zero, .R93_L463
    lw $t0, -12($fp)
    addiu $t2, $t0, -1
    sw $t2, -12($fp)
    j .R93_L462
.R93_L463:
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
    beq $t2, $zero, .R93_L466
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
.R93_L466:
    lw $v0, -12($fp)
.Rret93:
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
    beq $t2, $zero, .R94_L467
    li.d $f0, 0.0
    s.d $f0, -48($fp)
    j .R94_L468
.R94_L467:
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
.R94_L468:
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
    beq $t2, $zero, .R94_L469
    lw $t0, -12($fp)
    subu $t2, $zero, $t0
    sw $t2, -72($fp)
    j .R94_L470
.R94_L469:
    lw $t2, -12($fp)
    sw $t2, -72($fp)
.R94_L470:
    lw $t2, -72($fp)
    sw $t2, -28($fp)
    lw $t0, -24($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R94_L474
    lw $t1, 20($fp)
    lb $t2, 0($t1)
    sw $t2, -76($fp)
    li $t2, 48
    lw $t0, -76($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    beq $t2, $zero, .R94_L474
    li $t2, 1
    sw $t2, -80($fp)
    j .R94_L475
.R94_L474:
    li $t2, 0
    sw $t2, -80($fp)
.R94_L475:
    lw $t0, -80($fp)
    beq $t0, $zero, .R94_L472
    lw $t0, 8($fp)
    addiu $t2, $t0, 2
    sw $t2, -84($fp)
    lw $t0, 8($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    bne $t2, $zero, .R94_L478
    lw $t0, 12($fp)
    bne $t0, $zero, .R94_L478
    li $t2, 0
    sw $t2, -88($fp)
    j .R94_L479
.R94_L478:
    li $t2, 1
    sw $t2, -88($fp)
.R94_L479:
    lw $t0, -88($fp)
    beq $t0, $zero, .R94_L476
    li $t2, 0
    sw $t2, -92($fp)
    j .R94_L477
.R94_L476:
    li $t2, -1
    sw $t2, -92($fp)
.R94_L477:
    lw $t0, -84($fp)
    lw $t1, -92($fp)
    addu $t2, $t0, $t1
    lw $t0, -24($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    beq $t2, $zero, .R94_L472
    li $t2, 1
    sw $t2, -96($fp)
    j .R94_L473
.R94_L472:
    li $t2, 0
    sw $t2, -96($fp)
.R94_L473:
    lw $t0, -96($fp)
    beq $t0, $zero, .R94_L471
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    lw $t0, -12($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R94_L480
    lw $t0, -12($fp)
    subu $t2, $zero, $t0
    sw $t2, -100($fp)
    j .R94_L481
.R94_L480:
    lw $t2, -12($fp)
    sw $t2, -100($fp)
.R94_L481:
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
.R94_L471:
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
    beq $t0, $zero, .R94_L482
    li $t2, 69
    sw $t2, -132($fp)
    j .R94_L483
.R94_L482:
    li $t2, 101
    sw $t2, -132($fp)
.R94_L483:
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
    beq $t2, $zero, .R94_L484
    li $t2, 45
    sw $t2, -144($fp)
    j .R94_L485
.R94_L484:
    li $t2, 43
    sw $t2, -144($fp)
.R94_L485:
    lw $t2, -144($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -140($fp)
    sb $t2, 0($t1)
    lw $t0, -28($fp)
    li $t1, 100
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R94_L486
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
.R94_L486:
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
.Rret94:
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
    bne $t2, $zero, .R95_L489
    li $t2, 69
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R95_L489
    li $t2, 0
    sw $t2, -60($fp)
    j .R95_L490
.R95_L489:
    li $t2, 1
    sw $t2, -60($fp)
.R95_L490:
    lw $t0, -60($fp)
    bne $t0, $zero, .R95_L487
    li $t2, 71
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R95_L487
    li $t2, 0
    sw $t2, -64($fp)
    j .R95_L488
.R95_L487:
    li $t2, 1
    sw $t2, -64($fp)
.R95_L488:
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
    beq $t0, $zero, .R95_L491
    l.d $f4, 4($fp)
    neg.d $f0, $f4
    s.d $f0, -80($fp)
    l.d $f0, -80($fp)
    s.d $f0, 4($fp)
.R95_L491:
    addiu $t2, $fp, -12
    sw $t2, -84($fp)
    lw $t0, -28($fp)
    beq $t0, $zero, .R95_L498
    li $t2, 45
    sw $t2, -88($fp)
    j .R95_L499
.R95_L498:
    lw $t0, 16($fp)
    beq $t0, $zero, .R95_L502
    li $t2, 43
    sw $t2, -92($fp)
    j .R95_L503
.R95_L502:
    lw $t0, 20($fp)
    beq $t0, $zero, .R95_L504
    li $t2, 32
    sw $t2, -96($fp)
    j .R95_L505
.R95_L504:
    li $t2, 0
    sw $t2, -96($fp)
.R95_L505:
    lw $t2, -96($fp)
    sw $t2, -92($fp)
.R95_L503:
    lw $t2, -92($fp)
    sw $t2, -88($fp)
.R95_L499:
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
    beq $t2, $zero, .R95_L506
    li $t2, 6
    sw $t2, 32($fp)
.R95_L506:
    l.d $f4, 4($fp)
    l.d $f6, 4($fp)
    li $t2, 1
    c.eq.d $f4, $f6
    bc1f .Rfc32
    li $t2, 0
.Rfc32:
    bne $t2, $zero, .R95_L508
    l.d $f4, 4($fp)
    li.d $f6, 1.7976931348623157e+308
    li $t2, 0
    c.lt.d $f6, $f4
    bc1f .Rfc33
    li $t2, 1
.Rfc33:
    bne $t2, $zero, .R95_L508
    li $t2, 0
    sw $t2, -104($fp)
    j .R95_L509
.R95_L508:
    li $t2, 1
    sw $t2, -104($fp)
.R95_L509:
    lw $t0, -104($fp)
    beq $t0, $zero, .R95_L507
    l.d $f4, 4($fp)
    l.d $f6, 4($fp)
    li $t2, 1
    c.eq.d $f4, $f6
    bc1f .Rfc34
    li $t2, 0
.Rfc34:
    beq $t2, $zero, .R95_L514
    lw $t0, -32($fp)
    beq $t0, $zero, .R95_L516
    la $t2, Rstr3
    sw $t2, -108($fp)
    j .R95_L517
.R95_L516:
    la $t2, Rstr4
    sw $t2, -108($fp)
.R95_L517:
    lw $t2, -108($fp)
    sw $t2, -112($fp)
    j .R95_L515
.R95_L514:
    lw $t0, -32($fp)
    beq $t0, $zero, .R95_L518
    la $t2, Rstr5
    sw $t2, -116($fp)
    j .R95_L519
.R95_L518:
    la $t2, Rstr6
    sw $t2, -116($fp)
.R95_L519:
    lw $t2, -116($fp)
    sw $t2, -112($fp)
.R95_L515:
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
    j .Rret95
.R95_L507:
    li $t2, 102
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R95_L521
    li $t2, 70
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R95_L521
    li $t2, 0
    sw $t2, -124($fp)
    j .R95_L522
.R95_L521:
    li $t2, 1
    sw $t2, -124($fp)
.R95_L522:
    lw $t0, -124($fp)
    beq $t0, $zero, .R95_L520
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
    j .R95_L523
.R95_L520:
    li $t2, 101
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R95_L525
    li $t2, 69
    lw $t0, 12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R95_L525
    li $t2, 0
    sw $t2, -136($fp)
    j .R95_L526
.R95_L525:
    li $t2, 1
    sw $t2, -136($fp)
.R95_L526:
    lw $t0, -136($fp)
    beq $t0, $zero, .R95_L524
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
    j .R95_L527
.R95_L524:
    lw $t0, 32($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R95_L528
    li $t2, 1
    sw $t2, -148($fp)
    j .R95_L529
.R95_L528:
    lw $t2, 32($fp)
    sw $t2, -148($fp)
.R95_L529:
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
    beq $t2, $zero, .R95_L531
    lw $t0, -44($fp)
    li $t1, -4
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R95_L531
    li $t2, 1
    sw $t2, -160($fp)
    j .R95_L532
.R95_L531:
    li $t2, 0
    sw $t2, -160($fp)
.R95_L532:
    lw $t0, -160($fp)
    beq $t0, $zero, .R95_L530
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
    j .R95_L533
.R95_L530:
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
.R95_L533:
    lw $t0, 24($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R95_L534
    lw $t2, -24($fp)
    sw $t2, -48($fp)
    li $t2, 0
    sw $t2, -52($fp)
.R95_L535:
    lw $t0, -52($fp)
    lw $t1, -24($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R95_L537
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
    bne $t2, $zero, .R95_L539
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
    bne $t2, $zero, .R95_L539
    li $t2, 0
    sw $t2, -196($fp)
    j .R95_L540
.R95_L539:
    li $t2, 1
    sw $t2, -196($fp)
.R95_L540:
    lw $t0, -196($fp)
    beq $t0, $zero, .R95_L538
    lw $t2, -52($fp)
    sw $t2, -48($fp)
    j .R95_L537
.R95_L538:
.R95_L536:
    lw $t0, -52($fp)
    addiu $t2, $t0, 1
    sw $t2, -52($fp)
    j .R95_L535
.R95_L537:
    lw $t2, -48($fp)
    sw $t2, -56($fp)
    li $t2, 0
    sw $t2, -52($fp)
.R95_L541:
    lw $t0, -52($fp)
    lw $t1, -48($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R95_L543
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
    beq $t2, $zero, .R95_L544
    j .R95_L543
.R95_L544:
.R95_L542:
    lw $t0, -52($fp)
    addiu $t2, $t0, 1
    sw $t2, -52($fp)
    j .R95_L541
.R95_L543:
    lw $t0, -52($fp)
    lw $t1, -48($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R95_L545
.R95_L546:
    lw $t0, -56($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R95_L548
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
    beq $t2, $zero, .R95_L548
    li $t2, 1
    sw $t2, -212($fp)
    j .R95_L549
.R95_L548:
    li $t2, 0
    sw $t2, -212($fp)
.R95_L549:
    lw $t0, -212($fp)
    beq $t0, $zero, .R95_L547
    lw $t0, -56($fp)
    addiu $t2, $t0, -1
    sw $t2, -56($fp)
    j .R95_L546
.R95_L547:
    lw $t0, -56($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R95_L551
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
    beq $t2, $zero, .R95_L551
    li $t2, 1
    sw $t2, -224($fp)
    j .R95_L552
.R95_L551:
    li $t2, 0
    sw $t2, -224($fp)
.R95_L552:
    lw $t0, -224($fp)
    beq $t0, $zero, .R95_L550
    lw $t0, -56($fp)
    addiu $t2, $t0, -1
    sw $t2, -56($fp)
.R95_L550:
    li $t2, 0
    sw $t2, -52($fp)
.R95_L553:
    lw $t0, -48($fp)
    lw $t1, -52($fp)
    addu $t2, $t0, $t1
    move $t0, $t2
    lw $t1, -24($fp)
    slt $t2, $t0, $t1
    beq $t2, $zero, .R95_L555
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
.R95_L554:
    lw $t0, -52($fp)
    addiu $t2, $t0, 1
    sw $t2, -52($fp)
    j .R95_L553
.R95_L555:
    lw $t0, -24($fp)
    lw $t1, -48($fp)
    subu $t2, $t0, $t1
    lw $t0, -56($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -24($fp)
.R95_L545:
.R95_L534:
.R95_L527:
.R95_L523:
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
.Rret95:
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
.R96_L556:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R96_L557
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
    beq $t2, $zero, .R96_L558
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
    j .R96_L556
.R96_L558:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
.R96_L559:
    li $t0, 1
    beq $t0, $zero, .R96_L560
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -100($fp)
    li $t2, 45
    lw $t0, -100($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L561
    li $t2, 1
    sw $t2, -12($fp)
    j .R96_L562
.R96_L561:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -104($fp)
    li $t2, 43
    lw $t0, -104($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L563
    li $t2, 1
    sw $t2, -16($fp)
    j .R96_L564
.R96_L563:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -108($fp)
    li $t2, 32
    lw $t0, -108($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L565
    li $t2, 1
    sw $t2, -20($fp)
    j .R96_L566
.R96_L565:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -112($fp)
    li $t2, 35
    lw $t0, -112($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L567
    li $t2, 1
    sw $t2, -24($fp)
    j .R96_L568
.R96_L567:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -116($fp)
    li $t2, 48
    lw $t0, -116($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L569
    li $t2, 1
    sw $t2, -28($fp)
    j .R96_L570
.R96_L569:
    j .R96_L560
.R96_L570:
.R96_L568:
.R96_L566:
.R96_L564:
.R96_L562:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    j .R96_L559
.R96_L560:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -120($fp)
    li $t2, 42
    lw $t0, -120($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L571
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
    beq $t2, $zero, .R96_L572
    li $t2, 1
    sw $t2, -12($fp)
    lw $t0, -32($fp)
    subu $t2, $zero, $t0
    sw $t2, -32($fp)
.R96_L572:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    j .R96_L573
.R96_L571:
.R96_L574:
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
    beq $t0, $zero, .R96_L575
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
    j .R96_L574
.R96_L575:
.R96_L573:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -148($fp)
    li $t2, 46
    lw $t0, -148($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L576
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
    beq $t2, $zero, .R96_L577
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
    j .R96_L578
.R96_L577:
.R96_L579:
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
    beq $t0, $zero, .R96_L580
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
    j .R96_L579
.R96_L580:
.R96_L578:
.R96_L576:
.R96_L581:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -180($fp)
    li $t2, 104
    lw $t0, -180($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L591
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -184($fp)
    li $t2, 108
    lw $t0, -184($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L591
    li $t2, 0
    sw $t2, -188($fp)
    j .R96_L592
.R96_L591:
    li $t2, 1
    sw $t2, -188($fp)
.R96_L592:
    lw $t0, -188($fp)
    bne $t0, $zero, .R96_L589
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -192($fp)
    li $t2, 76
    lw $t0, -192($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L589
    li $t2, 0
    sw $t2, -196($fp)
    j .R96_L590
.R96_L589:
    li $t2, 1
    sw $t2, -196($fp)
.R96_L590:
    lw $t0, -196($fp)
    bne $t0, $zero, .R96_L587
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -200($fp)
    li $t2, 122
    lw $t0, -200($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L587
    li $t2, 0
    sw $t2, -204($fp)
    j .R96_L588
.R96_L587:
    li $t2, 1
    sw $t2, -204($fp)
.R96_L588:
    lw $t0, -204($fp)
    bne $t0, $zero, .R96_L585
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -208($fp)
    li $t2, 106
    lw $t0, -208($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L585
    li $t2, 0
    sw $t2, -212($fp)
    j .R96_L586
.R96_L585:
    li $t2, 1
    sw $t2, -212($fp)
.R96_L586:
    lw $t0, -212($fp)
    bne $t0, $zero, .R96_L583
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -216($fp)
    li $t2, 116
    lw $t0, -216($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L583
    li $t2, 0
    sw $t2, -220($fp)
    j .R96_L584
.R96_L583:
    li $t2, 1
    sw $t2, -220($fp)
.R96_L584:
    lw $t0, -220($fp)
    beq $t0, $zero, .R96_L582
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -224($fp)
    li $t2, 104
    lw $t0, -224($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L593
    lw $t0, -40($fp)
    addiu $t2, $t0, -1
    sw $t2, -40($fp)
.R96_L593:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    j .R96_L581
.R96_L582:
    lw $t0, -12($fp)
    beq $t0, $zero, .R96_L594
    li $t2, 0
    sw $t2, -28($fp)
.R96_L594:
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -44($fp)
    lw $t0, -44($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R96_L595
    j .R96_L557
.R96_L595:
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    li $t2, 100
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L597
    li $t2, 105
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L597
    li $t2, 0
    sw $t2, -228($fp)
    j .R96_L598
.R96_L597:
    li $t2, 1
    sw $t2, -228($fp)
.R96_L598:
    lw $t0, -228($fp)
    beq $t0, $zero, .R96_L596
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
    beq $t2, $zero, .R96_L599
    lw $t2, -48($fp)
    sll $t2, $t2, 16
    sra $t2, $t2, 16
    sw $t2, -48($fp)
.R96_L599:
    lw $t0, -40($fp)
    li $t1, -2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R96_L600
    lw $t2, -48($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    sw $t2, -48($fp)
.R96_L600:
    lw $t0, -48($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R96_L601
    lw $t0, -48($fp)
    addiu $t2, $t0, 1
    move $t0, $t2
    subu $t2, $zero, $t0
    move $t0, $t2
    addiu $t2, $t0, 1
    sw $t2, -236($fp)
    j .R96_L602
.R96_L601:
    lw $t2, -48($fp)
    sw $t2, -236($fp)
.R96_L602:
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
    j .R96_L603
.R96_L596:
    li $t2, 117
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L609
    li $t2, 120
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L609
    li $t2, 0
    sw $t2, -244($fp)
    j .R96_L610
.R96_L609:
    li $t2, 1
    sw $t2, -244($fp)
.R96_L610:
    lw $t0, -244($fp)
    bne $t0, $zero, .R96_L607
    li $t2, 88
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L607
    li $t2, 0
    sw $t2, -248($fp)
    j .R96_L608
.R96_L607:
    li $t2, 1
    sw $t2, -248($fp)
.R96_L608:
    lw $t0, -248($fp)
    bne $t0, $zero, .R96_L605
    li $t2, 111
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L605
    li $t2, 0
    sw $t2, -252($fp)
    j .R96_L606
.R96_L605:
    li $t2, 1
    sw $t2, -252($fp)
.R96_L606:
    lw $t0, -252($fp)
    beq $t0, $zero, .R96_L604
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
    beq $t2, $zero, .R96_L611
    lw $t0, -56($fp)
    andi $t2, $t0, 65535
    sw $t2, -56($fp)
.R96_L611:
    lw $t0, -40($fp)
    li $t1, -2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R96_L612
    lw $t0, -56($fp)
    andi $t2, $t0, 255
    sw $t2, -56($fp)
.R96_L612:
    li $t2, 117
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L615
    li $t2, 10
    sw $t2, -260($fp)
    j .R96_L616
.R96_L615:
    li $t2, 111
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L617
    li $t2, 8
    sw $t2, -264($fp)
    j .R96_L618
.R96_L617:
    li $t2, 16
    sw $t2, -264($fp)
.R96_L618:
    lw $t2, -264($fp)
    sw $t2, -260($fp)
.R96_L616:
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
    j .R96_L619
.R96_L604:
    li $t2, 112
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L620
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
    beq $t2, $zero, .R96_L621
    addiu $sp, $sp, -28
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    la $t0, Rstr7
    sw $t0, 4($sp)
    la $t0, Rstr8
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
    j .R96_L622
.R96_L621:
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
.R96_L622:
    j .R96_L623
.R96_L620:
    li $t2, 99
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L624
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
    la $t0, Rstr7
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
    j .R96_L625
.R96_L624:
    li $t2, 115
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L626
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
    beq $t2, $zero, .R96_L627
    la $t2, Rstr9
    sw $t2, -68($fp)
.R96_L627:
.R96_L628:
    lw $t0, -68($fp)
    lw $t1, -72($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    beq $t2, $zero, .R96_L630
    lw $t0, -36($fp)
    slti $t2, $t0, 0
    bne $t2, $zero, .R96_L632
    lw $t0, -72($fp)
    lw $t1, -36($fp)
    slt $t2, $t0, $t1
    bne $t2, $zero, .R96_L632
    li $t2, 0
    sw $t2, -288($fp)
    j .R96_L633
.R96_L632:
    li $t2, 1
    sw $t2, -288($fp)
.R96_L633:
    lw $t0, -288($fp)
    beq $t0, $zero, .R96_L630
    li $t2, 1
    sw $t2, -292($fp)
    j .R96_L631
.R96_L630:
    li $t2, 0
    sw $t2, -292($fp)
.R96_L631:
    lw $t0, -292($fp)
    beq $t0, $zero, .R96_L629
    lw $t0, -72($fp)
    addiu $t2, $t0, 1
    sw $t2, -72($fp)
    j .R96_L628
.R96_L629:
    addiu $sp, $sp, -28
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    la $t0, Rstr7
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
    j .R96_L634
.R96_L626:
    li $t2, 102
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L644
    li $t2, 70
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L644
    li $t2, 0
    sw $t2, -296($fp)
    j .R96_L645
.R96_L644:
    li $t2, 1
    sw $t2, -296($fp)
.R96_L645:
    lw $t0, -296($fp)
    bne $t0, $zero, .R96_L642
    li $t2, 101
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L642
    li $t2, 0
    sw $t2, -300($fp)
    j .R96_L643
.R96_L642:
    li $t2, 1
    sw $t2, -300($fp)
.R96_L643:
    lw $t0, -300($fp)
    bne $t0, $zero, .R96_L640
    li $t2, 69
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L640
    li $t2, 0
    sw $t2, -304($fp)
    j .R96_L641
.R96_L640:
    li $t2, 1
    sw $t2, -304($fp)
.R96_L641:
    lw $t0, -304($fp)
    bne $t0, $zero, .R96_L638
    li $t2, 103
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L638
    li $t2, 0
    sw $t2, -308($fp)
    j .R96_L639
.R96_L638:
    li $t2, 1
    sw $t2, -308($fp)
.R96_L639:
    lw $t0, -308($fp)
    bne $t0, $zero, .R96_L636
    li $t2, 71
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R96_L636
    li $t2, 0
    sw $t2, -312($fp)
    j .R96_L637
.R96_L636:
    li $t2, 1
    sw $t2, -312($fp)
.R96_L637:
    lw $t0, -312($fp)
    beq $t0, $zero, .R96_L635
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
    j .R96_L646
.R96_L635:
    li $t2, 110
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L647
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
    j .R96_L648
.R96_L647:
    li $t2, 37
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R96_L649
    li $t2, 37
    sw $t2, -336($fp)
    addiu $sp, $sp, -8
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, -336($fp)
    sw $t0, 4($sp)
    jal R___fns_put
    addiu $sp, $sp, 8
    j .R96_L650
.R96_L649:
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
.R96_L650:
.R96_L648:
.R96_L646:
.R96_L634:
.R96_L625:
.R96_L623:
.R96_L619:
.R96_L603:
    j .R96_L556
.R96_L557:
    lw $t0, 0($fp)
    addiu $t2, $t0, 8
    lw $t2, 0($t2)
    move $v0, $t2
.Rret96:
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
.Rret97:
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
.Rret101:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra
















.data
__fns_test_argv0: .asciiz "program"
__fns_test_arg0: .asciiz "mul"
__fns_test_arg1: .asciiz "6"
__fns_test_arg2: .asciiz "-7"
__fns_test_arg3: .asciiz "alpha"
__fns_test_arg4: .asciiz "betagamma"
__fns_test_arg5: .asciiz "delta"
.align 2
__fns_test_argv:
    .word __fns_test_argv0
    .word __fns_test_arg0
    .word __fns_test_arg1
    .word __fns_test_arg2
    .word __fns_test_arg3
    .word __fns_test_arg4
    .word __fns_test_arg5
    .word 0
.text
.globl main
main:
    li $a0, 7
    la $a1, __fns_test_argv
    move $a2, $zero
    jal __fns_test_main
    nop
    li $v0, 10
    syscall
