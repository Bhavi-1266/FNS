# FNS -> MIPS32 (spim).  Generated assembly.
# source: test/26_string_library.c
# run with:  spim -file <this file> [program arguments]

.data
str0: .asciiz "Hello"
str1: .asciiz ", World"
str2: .asciiz "%s | %s | len=%d\n"
str3: .asciiz "cmp: %d %d %d\n"
str4: .asciiz "abc"
str5: .asciiz "abd"
str6: .asciiz "b"
str7: .asciiz "a"
str8: .asciiz "ncmp: %d\n"
str9: .asciiz "compiler"
str10: .asciiz "compute"
str11: .asciiz "truncate-me"
str12: .asciiz "strncpy: %s\n"
str13: .asciiz "XYZW"
str14: .asciiz "strncat: %s\n"
str15: .asciiz "strchr: %s, strrchr: %s\n"
str16: .asciiz "strstr: %s, missing: %s\n"
str17: .asciiz "World"
str18: .asciiz "xyz"
str19: .asciiz "found"
str20: .asciiz "null"
str21: .asciiz "duplicate"
str22: .asciiz "%s\n"
str23: .asciiz "one,two;;three four"
str24: .asciiz ",; "
str25: .asciiz "[%s]"
str26: .asciiz "\n"
str27: .asciiz "MiXeD 123 text!"
str28: .asciiz "a1 b2, c3!"
str29: .asciiz "alpha=%d digit=%d space=%d punct=%d\n"
str30: .asciiz "atoi=%d atol=%ld atof=%.3f\n"
str31: .asciiz "  -321xyz"
str32: .asciiz "123456"
str33: .asciiz "2.5e2"
str34: .asciiz "0x1F rest"
str35: .asciiz "strtol hex=%ld rest=%s\n"
str36: .asciiz "abs=%d %d\n"
str37: .asciiz "memcpy: %d %d, memset: %d, memcmp: %d\n"
str38: .asciiz "memmove: %d %d %d %d %d\n"
str39: .asciiz "rand repeatable after srand: %d\n"

.text
.globl main

main:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -744
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $t2, $fp, -72
    sw $t2, -264($fp)
    li $t0, 0
    lw $t1, -264($fp)
    sb $t0, 0($t1)
    lw $t0, -264($fp)
    addiu $t2, $t0, 1
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 2
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 3
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 4
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 5
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 6
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 7
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 8
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 9
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 10
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 11
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 12
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 13
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 14
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 15
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 16
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 17
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 18
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 19
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 20
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 21
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 22
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 23
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 24
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 25
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 26
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 27
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 28
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 29
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 30
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 31
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 32
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 33
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 34
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 35
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 36
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 37
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 38
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 39
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 40
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 41
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 42
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 43
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 44
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 45
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 46
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 47
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 48
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 49
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 50
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 51
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 52
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 53
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 54
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 55
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 56
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 57
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 58
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 59
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 60
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 61
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 62
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -264($fp)
    addiu $t2, $t0, 63
    li $t0, 0
    sb $t0, 0($t2)
    lw $t8, -264($fp)
    la $t9, str0
    li $t0, 6
.Lcpy0:
    beq $t0, $zero, .Lcpy0_end
    lb $t1, 0($t9)
    sb $t1, 0($t8)
    addiu $t8, $t8, 1
    addiu $t9, $t9, 1
    addiu $t0, $t0, -1
    j .Lcpy0
.Lcpy0_end:
    addiu $t2, $fp, -136
    sw $t2, -268($fp)
    addiu $t2, $fp, -72
    sw $t2, -272($fp)
    addiu $sp, $sp, -8
    lw $t0, -268($fp)
    sw $t0, 0($sp)
    lw $t0, -272($fp)
    sw $t0, 4($sp)
    jal R_strcpy
    addiu $sp, $sp, 8
    sw $v0, -276($fp)
    addiu $t2, $fp, -72
    sw $t2, -280($fp)
    addiu $sp, $sp, -8
    lw $t0, -280($fp)
    sw $t0, 0($sp)
    la $t0, str1
    sw $t0, 4($sp)
    jal R_strcat
    addiu $sp, $sp, 8
    sw $v0, -284($fp)
    addiu $t2, $fp, -72
    sw $t2, -288($fp)
    addiu $t2, $fp, -136
    sw $t2, -292($fp)
    addiu $t2, $fp, -72
    sw $t2, -296($fp)
    addiu $sp, $sp, -4
    lw $t0, -296($fp)
    sw $t0, 0($sp)
    jal R_strlen
    addiu $sp, $sp, 4
    sw $v0, -300($fp)
    lw $t2, -300($fp)
    sw $t2, -304($fp)
    addiu $sp, $sp, -16
    la $t0, str2
    sw $t0, 0($sp)
    lw $t0, -288($fp)
    sw $t0, 4($sp)
    lw $t0, -292($fp)
    sw $t0, 8($sp)
    lw $t0, -304($fp)
    sw $t0, 12($sp)
    jal R_printf
    addiu $sp, $sp, 16
    sw $v0, -308($fp)
    addiu $sp, $sp, -8
    la $t0, str4
    sw $t0, 0($sp)
    la $t0, str4
    sw $t0, 4($sp)
    jal R_strcmp
    addiu $sp, $sp, 8
    sw $v0, -312($fp)
    lw $t0, -312($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    sw $t2, -316($fp)
    addiu $sp, $sp, -8
    la $t0, str4
    sw $t0, 0($sp)
    la $t0, str5
    sw $t0, 4($sp)
    jal R_strcmp
    addiu $sp, $sp, 8
    sw $v0, -320($fp)
    lw $t0, -320($fp)
    slti $t2, $t0, 0
    sw $t2, -324($fp)
    addiu $sp, $sp, -8
    la $t0, str6
    sw $t0, 0($sp)
    la $t0, str7
    sw $t0, 4($sp)
    jal R_strcmp
    addiu $sp, $sp, 8
    sw $v0, -328($fp)
    lw $t0, -328($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    sw $t2, -332($fp)
    addiu $sp, $sp, -16
    la $t0, str3
    sw $t0, 0($sp)
    lw $t0, -316($fp)
    sw $t0, 4($sp)
    lw $t0, -324($fp)
    sw $t0, 8($sp)
    lw $t0, -332($fp)
    sw $t0, 12($sp)
    jal R_printf
    addiu $sp, $sp, 16
    sw $v0, -336($fp)
    li $t2, 4
    sw $t2, -340($fp)
    addiu $sp, $sp, -12
    la $t0, str9
    sw $t0, 0($sp)
    la $t0, str10
    sw $t0, 4($sp)
    lw $t0, -340($fp)
    sw $t0, 8($sp)
    jal R_strncmp
    addiu $sp, $sp, 12
    sw $v0, -344($fp)
    addiu $sp, $sp, -8
    la $t0, str8
    sw $t0, 0($sp)
    lw $t0, -344($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -348($fp)
    addiu $t2, $fp, -136
    sw $t2, -352($fp)
    li $t2, 8
    sw $t2, -356($fp)
    addiu $sp, $sp, -12
    lw $t0, -352($fp)
    sw $t0, 0($sp)
    la $t0, str11
    sw $t0, 4($sp)
    lw $t0, -356($fp)
    sw $t0, 8($sp)
    jal R_strncpy
    addiu $sp, $sp, 12
    sw $v0, -360($fp)
    addiu $t2, $fp, -136
    move $t0, $t2
    addiu $t2, $t0, 8
    li $t0, 0
    sb $t0, 0($t2)
    addiu $t2, $fp, -136
    sw $t2, -364($fp)
    addiu $sp, $sp, -8
    la $t0, str12
    sw $t0, 0($sp)
    lw $t0, -364($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -368($fp)
    addiu $t2, $fp, -136
    sw $t2, -372($fp)
    li $t2, 2
    sw $t2, -376($fp)
    addiu $sp, $sp, -12
    lw $t0, -372($fp)
    sw $t0, 0($sp)
    la $t0, str13
    sw $t0, 4($sp)
    lw $t0, -376($fp)
    sw $t0, 8($sp)
    jal R_strncat
    addiu $sp, $sp, 12
    sw $v0, -380($fp)
    addiu $t2, $fp, -136
    sw $t2, -384($fp)
    addiu $sp, $sp, -8
    la $t0, str14
    sw $t0, 0($sp)
    lw $t0, -384($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -388($fp)
    addiu $t2, $fp, -72
    sw $t2, -392($fp)
    li $t2, 111
    sw $t2, -396($fp)
    addiu $sp, $sp, -8
    lw $t0, -392($fp)
    sw $t0, 0($sp)
    lw $t0, -396($fp)
    sw $t0, 4($sp)
    jal R_strchr
    addiu $sp, $sp, 8
    sw $v0, -400($fp)
    addiu $t2, $fp, -72
    sw $t2, -404($fp)
    li $t2, 111
    sw $t2, -408($fp)
    addiu $sp, $sp, -8
    lw $t0, -404($fp)
    sw $t0, 0($sp)
    lw $t0, -408($fp)
    sw $t0, 4($sp)
    jal R_strrchr
    addiu $sp, $sp, 8
    sw $v0, -412($fp)
    addiu $sp, $sp, -12
    la $t0, str15
    sw $t0, 0($sp)
    lw $t0, -400($fp)
    sw $t0, 4($sp)
    lw $t0, -412($fp)
    sw $t0, 8($sp)
    jal R_printf
    addiu $sp, $sp, 12
    sw $v0, -416($fp)
    addiu $t2, $fp, -72
    sw $t2, -420($fp)
    addiu $sp, $sp, -8
    lw $t0, -420($fp)
    sw $t0, 0($sp)
    la $t0, str17
    sw $t0, 4($sp)
    jal R_strstr
    addiu $sp, $sp, 8
    sw $v0, -424($fp)
    addiu $t2, $fp, -72
    sw $t2, -428($fp)
    addiu $sp, $sp, -8
    lw $t0, -428($fp)
    sw $t0, 0($sp)
    la $t0, str18
    sw $t0, 4($sp)
    jal R_strstr
    addiu $sp, $sp, 8
    sw $v0, -432($fp)
    lw $t0, -432($fp)
    beq $t0, $zero, .L0_L1
    la $t2, str19
    sw $t2, -436($fp)
    j .L0_L2
.L0_L1:
    la $t2, str20
    sw $t2, -436($fp)
.L0_L2:
    addiu $sp, $sp, -12
    la $t0, str16
    sw $t0, 0($sp)
    lw $t0, -424($fp)
    sw $t0, 4($sp)
    lw $t0, -436($fp)
    sw $t0, 8($sp)
    jal R_printf
    addiu $sp, $sp, 12
    sw $v0, -440($fp)
    addiu $sp, $sp, -4
    la $t0, str21
    sw $t0, 0($sp)
    jal R_strdup
    addiu $sp, $sp, 4
    sw $v0, -444($fp)
    lw $t2, -444($fp)
    sw $t2, -140($fp)
    li $t0, 68
    lw $t1, -140($fp)
    sb $t0, 0($t1)
    addiu $sp, $sp, -8
    la $t0, str22
    sw $t0, 0($sp)
    lw $t0, -140($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -448($fp)
    addiu $sp, $sp, -4
    lw $t0, -140($fp)
    sw $t0, 0($sp)
    jal R_free
    addiu $sp, $sp, 4
    addiu $t2, $fp, -160
    sw $t2, -452($fp)
    li $t0, 0
    lw $t1, -452($fp)
    sb $t0, 0($t1)
    lw $t0, -452($fp)
    addiu $t2, $t0, 1
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 2
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 3
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 4
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 5
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 6
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 7
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 8
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 9
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 10
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 11
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 12
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 13
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 14
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 15
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 16
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 17
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 18
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -452($fp)
    addiu $t2, $t0, 19
    li $t0, 0
    sb $t0, 0($t2)
    lw $t8, -452($fp)
    la $t9, str23
    li $t0, 20
.Lcpy1:
    beq $t0, $zero, .Lcpy1_end
    lb $t1, 0($t9)
    sb $t1, 0($t8)
    addiu $t8, $t8, 1
    addiu $t9, $t9, 1
    addiu $t0, $t0, -1
    j .Lcpy1
.Lcpy1_end:
    addiu $t2, $fp, -160
    sw $t2, -456($fp)
    addiu $sp, $sp, -8
    lw $t0, -456($fp)
    sw $t0, 0($sp)
    la $t0, str24
    sw $t0, 4($sp)
    jal R_strtok
    addiu $sp, $sp, 8
    sw $v0, -460($fp)
    lw $t2, -460($fp)
    sw $t2, -164($fp)
.L0_L3:
    lw $t0, -164($fp)
    beq $t0, $zero, .L0_L4
    addiu $sp, $sp, -8
    la $t0, str25
    sw $t0, 0($sp)
    lw $t0, -164($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -464($fp)
    li $t2, 0
    sw $t2, -468($fp)
    addiu $sp, $sp, -8
    lw $t0, -468($fp)
    sw $t0, 0($sp)
    la $t0, str24
    sw $t0, 4($sp)
    jal R_strtok
    addiu $sp, $sp, 8
    sw $v0, -472($fp)
    lw $t2, -472($fp)
    sw $t2, -164($fp)
    j .L0_L3
.L0_L4:
    addiu $sp, $sp, -4
    la $t0, str26
    sw $t0, 0($sp)
    jal R_printf
    addiu $sp, $sp, 4
    sw $v0, -476($fp)
    addiu $t2, $fp, -180
    sw $t2, -480($fp)
    li $t0, 0
    lw $t1, -480($fp)
    sb $t0, 0($t1)
    lw $t0, -480($fp)
    addiu $t2, $t0, 1
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 2
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 3
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 4
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 5
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 6
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 7
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 8
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 9
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 10
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 11
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 12
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 13
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 14
    li $t0, 0
    sb $t0, 0($t2)
    lw $t0, -480($fp)
    addiu $t2, $t0, 15
    li $t0, 0
    sb $t0, 0($t2)
    lw $t8, -480($fp)
    la $t9, str27
    li $t0, 16
.Lcpy2:
    beq $t0, $zero, .Lcpy2_end
    lb $t1, 0($t9)
    sb $t1, 0($t8)
    addiu $t8, $t8, 1
    addiu $t9, $t9, 1
    addiu $t0, $t0, -1
    j .Lcpy2
.Lcpy2_end:
    li $t2, 0
    sw $t2, -184($fp)
.L0_L5:
    addiu $t2, $fp, -180
    move $t0, $t2
    lw $t1, -184($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    beq $t2, $zero, .L0_L7
    addiu $t2, $fp, -180
    move $t0, $t2
    lw $t1, -184($fp)
    addu $t2, $t0, $t1
    sw $t2, -484($fp)
    addiu $t2, $fp, -180
    move $t0, $t2
    lw $t1, -184($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -488($fp)
    addiu $sp, $sp, -4
    lw $t0, -488($fp)
    sw $t0, 0($sp)
    jal R_isupper
    addiu $sp, $sp, 4
    sw $v0, -492($fp)
    lw $t0, -492($fp)
    beq $t0, $zero, .L0_L8
    addiu $t2, $fp, -180
    move $t0, $t2
    lw $t1, -184($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -496($fp)
    addiu $sp, $sp, -4
    lw $t0, -496($fp)
    sw $t0, 0($sp)
    jal R_tolower
    addiu $sp, $sp, 4
    sw $v0, -500($fp)
    lw $t2, -500($fp)
    sw $t2, -504($fp)
    j .L0_L9
.L0_L8:
    addiu $t2, $fp, -180
    move $t0, $t2
    lw $t1, -184($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -508($fp)
    addiu $sp, $sp, -4
    lw $t0, -508($fp)
    sw $t0, 0($sp)
    jal R_toupper
    addiu $sp, $sp, 4
    sw $v0, -512($fp)
    lw $t2, -512($fp)
    sw $t2, -504($fp)
.L0_L9:
    lw $t2, -504($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -484($fp)
    sb $t2, 0($t1)
.L0_L6:
    lw $t0, -184($fp)
    addiu $t2, $t0, 1
    sw $t2, -184($fp)
    j .L0_L5
.L0_L7:
    addiu $t2, $fp, -180
    sw $t2, -516($fp)
    addiu $sp, $sp, -8
    la $t0, str22
    sw $t0, 0($sp)
    lw $t0, -516($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -520($fp)
    li $t2, 0
    sw $t2, -188($fp)
    li $t2, 0
    sw $t2, -192($fp)
    li $t2, 0
    sw $t2, -196($fp)
    li $t2, 0
    sw $t2, -200($fp)
    la $t2, str28
    sw $t2, -204($fp)
.L0_L10:
    lw $t1, -204($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .L0_L12
    lw $t1, -204($fp)
    lb $t2, 0($t1)
    sw $t2, -524($fp)
    addiu $sp, $sp, -4
    lw $t0, -524($fp)
    sw $t0, 0($sp)
    jal R_isalpha
    addiu $sp, $sp, 4
    sw $v0, -528($fp)
    lw $t0, -528($fp)
    beq $t0, $zero, .L0_L13
    lw $t0, -188($fp)
    addiu $t2, $t0, 1
    sw $t2, -188($fp)
.L0_L13:
    lw $t1, -204($fp)
    lb $t2, 0($t1)
    sw $t2, -532($fp)
    addiu $sp, $sp, -4
    lw $t0, -532($fp)
    sw $t0, 0($sp)
    jal R_isdigit
    addiu $sp, $sp, 4
    sw $v0, -536($fp)
    lw $t0, -536($fp)
    beq $t0, $zero, .L0_L14
    lw $t0, -192($fp)
    addiu $t2, $t0, 1
    sw $t2, -192($fp)
.L0_L14:
    lw $t1, -204($fp)
    lb $t2, 0($t1)
    sw $t2, -540($fp)
    addiu $sp, $sp, -4
    lw $t0, -540($fp)
    sw $t0, 0($sp)
    jal R_isspace
    addiu $sp, $sp, 4
    sw $v0, -544($fp)
    lw $t0, -544($fp)
    beq $t0, $zero, .L0_L15
    lw $t0, -196($fp)
    addiu $t2, $t0, 1
    sw $t2, -196($fp)
.L0_L15:
    lw $t1, -204($fp)
    lb $t2, 0($t1)
    sw $t2, -548($fp)
    addiu $sp, $sp, -4
    lw $t0, -548($fp)
    sw $t0, 0($sp)
    jal R_ispunct
    addiu $sp, $sp, 4
    sw $v0, -552($fp)
    lw $t0, -552($fp)
    beq $t0, $zero, .L0_L16
    lw $t0, -200($fp)
    addiu $t2, $t0, 1
    sw $t2, -200($fp)
.L0_L16:
.L0_L11:
    lw $t0, -204($fp)
    addiu $t2, $t0, 1
    sw $t2, -204($fp)
    j .L0_L10
.L0_L12:
    addiu $sp, $sp, -20
    la $t0, str29
    sw $t0, 0($sp)
    lw $t0, -188($fp)
    sw $t0, 4($sp)
    lw $t0, -192($fp)
    sw $t0, 8($sp)
    lw $t0, -196($fp)
    sw $t0, 12($sp)
    lw $t0, -200($fp)
    sw $t0, 16($sp)
    jal R_printf
    addiu $sp, $sp, 20
    sw $v0, -556($fp)
    addiu $sp, $sp, -4
    la $t0, str31
    sw $t0, 0($sp)
    jal R_atoi
    addiu $sp, $sp, 4
    sw $v0, -560($fp)
    addiu $sp, $sp, -4
    la $t0, str32
    sw $t0, 0($sp)
    jal R_atol
    addiu $sp, $sp, 4
    sw $v0, -564($fp)
    addiu $sp, $sp, -4
    la $t0, str33
    sw $t0, 0($sp)
    jal R_atof
    addiu $sp, $sp, 4
    s.d $f0, -572($fp)
    addiu $sp, $sp, -20
    la $t0, str30
    sw $t0, 0($sp)
    lw $t0, -560($fp)
    sw $t0, 4($sp)
    lw $t0, -564($fp)
    sw $t0, 8($sp)
    l.d $f0, -572($fp)
    s.d $f0, 12($sp)
    jal R_printf
    addiu $sp, $sp, 20
    sw $v0, -576($fp)
    addiu $t2, $fp, -208
    sw $t2, -580($fp)
    addiu $sp, $sp, -12
    la $t0, str34
    sw $t0, 0($sp)
    lw $t0, -580($fp)
    sw $t0, 4($sp)
    li $t0, 16
    sw $t0, 8($sp)
    jal R_strtol
    addiu $sp, $sp, 12
    sw $v0, -584($fp)
    lw $t2, -584($fp)
    sw $t2, -212($fp)
    addiu $sp, $sp, -12
    la $t0, str35
    sw $t0, 0($sp)
    lw $t0, -212($fp)
    sw $t0, 4($sp)
    lw $t0, -208($fp)
    sw $t0, 8($sp)
    jal R_printf
    addiu $sp, $sp, 12
    sw $v0, -588($fp)
    addiu $sp, $sp, -4
    li $t0, -17
    sw $t0, 0($sp)
    jal R_abs
    addiu $sp, $sp, 4
    sw $v0, -592($fp)
    addiu $sp, $sp, -4
    li $t0, 17
    sw $t0, 0($sp)
    jal R_abs
    addiu $sp, $sp, 4
    sw $v0, -596($fp)
    addiu $sp, $sp, -12
    la $t0, str36
    sw $t0, 0($sp)
    lw $t0, -592($fp)
    sw $t0, 4($sp)
    lw $t0, -596($fp)
    sw $t0, 8($sp)
    jal R_printf
    addiu $sp, $sp, 12
    sw $v0, -600($fp)
    addiu $t2, $fp, -232
    sw $t2, -604($fp)
    li $t0, 0
    lw $t1, -604($fp)
    sw $t0, 0($t1)
    lw $t0, -604($fp)
    addiu $t2, $t0, 4
    li $t0, 0
    sw $t0, 0($t2)
    lw $t0, -604($fp)
    addiu $t2, $t0, 8
    li $t0, 0
    sw $t0, 0($t2)
    lw $t0, -604($fp)
    addiu $t2, $t0, 12
    li $t0, 0
    sw $t0, 0($t2)
    lw $t0, -604($fp)
    addiu $t2, $t0, 16
    li $t0, 0
    sw $t0, 0($t2)
    li $t0, 1
    lw $t1, -604($fp)
    sw $t0, 0($t1)
    lw $t0, -604($fp)
    addiu $t2, $t0, 4
    li $t0, 2
    sw $t0, 0($t2)
    lw $t0, -604($fp)
    addiu $t2, $t0, 8
    li $t0, 3
    sw $t0, 0($t2)
    lw $t0, -604($fp)
    addiu $t2, $t0, 12
    li $t0, 4
    sw $t0, 0($t2)
    lw $t0, -604($fp)
    addiu $t2, $t0, 16
    li $t0, 5
    sw $t0, 0($t2)
    addiu $t2, $fp, -252
    sw $t2, -608($fp)
    addiu $t2, $fp, -232
    sw $t2, -612($fp)
    li $t2, 20
    sw $t2, -616($fp)
    addiu $sp, $sp, -12
    lw $t0, -608($fp)
    sw $t0, 0($sp)
    lw $t0, -612($fp)
    sw $t0, 4($sp)
    lw $t0, -616($fp)
    sw $t0, 8($sp)
    jal R_memcpy
    addiu $sp, $sp, 12
    sw $v0, -620($fp)
    addiu $t2, $fp, -232
    sw $t2, -624($fp)
    li $t2, 20
    sw $t2, -628($fp)
    addiu $sp, $sp, -12
    lw $t0, -624($fp)
    sw $t0, 0($sp)
    li $t0, 0
    sw $t0, 4($sp)
    lw $t0, -628($fp)
    sw $t0, 8($sp)
    jal R_memset
    addiu $sp, $sp, 12
    sw $v0, -632($fp)
    addiu $t2, $fp, -252
    lw $t2, 0($t2)
    sw $t2, -636($fp)
    addiu $t2, $fp, -252
    move $t0, $t2
    addiu $t2, $t0, 16
    lw $t2, 0($t2)
    sw $t2, -640($fp)
    addiu $t2, $fp, -232
    move $t0, $t2
    addiu $t2, $t0, 8
    lw $t2, 0($t2)
    sw $t2, -644($fp)
    addiu $t2, $fp, -252
    sw $t2, -648($fp)
    addiu $t2, $fp, -232
    sw $t2, -652($fp)
    li $t2, 20
    sw $t2, -656($fp)
    addiu $sp, $sp, -12
    lw $t0, -648($fp)
    sw $t0, 0($sp)
    lw $t0, -652($fp)
    sw $t0, 4($sp)
    lw $t0, -656($fp)
    sw $t0, 8($sp)
    jal R_memcmp
    addiu $sp, $sp, 12
    sw $v0, -660($fp)
    lw $t0, -660($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    sw $t2, -664($fp)
    addiu $sp, $sp, -20
    la $t0, str37
    sw $t0, 0($sp)
    lw $t0, -636($fp)
    sw $t0, 4($sp)
    lw $t0, -640($fp)
    sw $t0, 8($sp)
    lw $t0, -644($fp)
    sw $t0, 12($sp)
    lw $t0, -664($fp)
    sw $t0, 16($sp)
    jal R_printf
    addiu $sp, $sp, 20
    sw $v0, -668($fp)
    addiu $t2, $fp, -252
    sw $t2, -672($fp)
    li $t0, 1
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -672($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -676($fp)
    addiu $t2, $fp, -252
    sw $t2, -680($fp)
    li $t0, 3
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    sw $t2, -684($fp)
    addiu $sp, $sp, -12
    lw $t0, -676($fp)
    sw $t0, 0($sp)
    lw $t0, -680($fp)
    sw $t0, 4($sp)
    lw $t0, -684($fp)
    sw $t0, 8($sp)
    jal R_memmove
    addiu $sp, $sp, 12
    sw $v0, -688($fp)
    addiu $t2, $fp, -252
    lw $t2, 0($t2)
    sw $t2, -692($fp)
    addiu $t2, $fp, -252
    move $t0, $t2
    addiu $t2, $t0, 4
    lw $t2, 0($t2)
    sw $t2, -696($fp)
    addiu $t2, $fp, -252
    move $t0, $t2
    addiu $t2, $t0, 8
    lw $t2, 0($t2)
    sw $t2, -700($fp)
    addiu $t2, $fp, -252
    move $t0, $t2
    addiu $t2, $t0, 12
    lw $t2, 0($t2)
    sw $t2, -704($fp)
    addiu $t2, $fp, -252
    move $t0, $t2
    addiu $t2, $t0, 16
    lw $t2, 0($t2)
    sw $t2, -708($fp)
    addiu $sp, $sp, -24
    la $t0, str38
    sw $t0, 0($sp)
    lw $t0, -692($fp)
    sw $t0, 4($sp)
    lw $t0, -696($fp)
    sw $t0, 8($sp)
    lw $t0, -700($fp)
    sw $t0, 12($sp)
    lw $t0, -704($fp)
    sw $t0, 16($sp)
    lw $t0, -708($fp)
    sw $t0, 20($sp)
    jal R_printf
    addiu $sp, $sp, 24
    sw $v0, -712($fp)
    li $t2, 42
    sw $t2, -716($fp)
    addiu $sp, $sp, -4
    lw $t0, -716($fp)
    sw $t0, 0($sp)
    jal R_srand
    addiu $sp, $sp, 4
    jal R_rand
    sw $v0, -720($fp)
    lw $t2, -720($fp)
    sw $t2, -256($fp)
    jal R_rand
    sw $v0, -724($fp)
    lw $t2, -724($fp)
    sw $t2, -260($fp)
    li $t2, 42
    sw $t2, -728($fp)
    addiu $sp, $sp, -4
    lw $t0, -728($fp)
    sw $t0, 0($sp)
    jal R_srand
    addiu $sp, $sp, 4
    jal R_rand
    sw $v0, -732($fp)
    lw $t0, -256($fp)
    lw $t1, -732($fp)
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .L0_L17
    jal R_rand
    sw $v0, -736($fp)
    lw $t0, -260($fp)
    lw $t1, -736($fp)
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .L0_L17
    li $t2, 1
    sw $t2, -740($fp)
    j .L0_L18
.L0_L17:
    li $t2, 0
    sw $t2, -740($fp)
.L0_L18:
    addiu $sp, $sp, -8
    la $t0, str39
    sw $t0, 0($sp)
    lw $t0, -740($fp)
    sw $t0, 4($sp)
    jal R_printf
    addiu $sp, $sp, 8
    sw $v0, -744($fp)
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

R_memset:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t2, 0($fp)
    sw $t2, -12($fp)
    li $t2, 0
    sw $t2, -16($fp)
.R0_L1:
    lw $t0, -16($fp)
    lw $t1, 8($fp)
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R0_L3
    lw $t0, -12($fp)
    lw $t1, -16($fp)
    addu $t2, $t0, $t1
    sw $t2, -20($fp)
    lw $t2, 4($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -20($fp)
    sb $t2, 0($t1)
.R0_L2:
    lw $t0, -16($fp)
    addiu $t2, $t0, 1
    sw $t2, -16($fp)
    j .R0_L1
.R0_L3:
    lw $v0, 0($fp)
.Rret0:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_memcpy:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t2, 0($fp)
    sw $t2, -12($fp)
    lw $t2, 4($fp)
    sw $t2, -16($fp)
    li $t2, 0
    sw $t2, -20($fp)
.R1_L4:
    lw $t0, -20($fp)
    lw $t1, 8($fp)
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R1_L6
    lw $t0, -12($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    sw $t2, -24($fp)
    lw $t0, -16($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -24($fp)
    sb $t2, 0($t1)
.R1_L5:
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .R1_L4
.R1_L6:
    lw $v0, 0($fp)
.Rret1:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_memmove:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t2, 0($fp)
    sw $t2, -12($fp)
    lw $t2, 4($fp)
    sw $t2, -16($fp)
    lw $t0, -12($fp)
    lw $t1, -16($fp)
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R2_L8
    li $t2, 0
    lw $t0, 8($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R2_L8
    li $t2, 0
    sw $t2, -24($fp)
    j .R2_L9
.R2_L8:
    li $t2, 1
    sw $t2, -24($fp)
.R2_L9:
    lw $t0, -24($fp)
    beq $t0, $zero, .R2_L7
    lw $v0, 0($fp)
    j .Rret2
.R2_L7:
    lw $t0, -12($fp)
    lw $t1, -16($fp)
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R2_L10
    li $t2, 0
    sw $t2, -20($fp)
.R2_L11:
    lw $t0, -20($fp)
    lw $t1, 8($fp)
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R2_L13
    lw $t0, -12($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    sw $t2, -28($fp)
    lw $t0, -16($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -28($fp)
    sb $t2, 0($t1)
.R2_L12:
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .R2_L11
.R2_L13:
    j .R2_L14
.R2_L10:
    lw $t2, 8($fp)
    sw $t2, -20($fp)
.R2_L15:
    li $t2, 0
    lw $t0, -20($fp)
    move $t1, $t2
    sltu $t2, $t1, $t0
    beq $t2, $zero, .R2_L16
    lw $t0, -20($fp)
    addiu $t2, $t0, -1
    sw $t2, -20($fp)
    lw $t0, -12($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    sw $t2, -32($fp)
    lw $t0, -16($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -32($fp)
    sb $t2, 0($t1)
    j .R2_L15
.R2_L16:
.R2_L14:
    lw $v0, 0($fp)
.Rret2:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_memcmp:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -48
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t2, 0($fp)
    sw $t2, -12($fp)
    lw $t2, 4($fp)
    sw $t2, -16($fp)
    li $t2, 0
    sw $t2, -20($fp)
.R3_L17:
    lw $t0, -20($fp)
    lw $t1, 8($fp)
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R3_L19
    lw $t0, -12($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    lbu $t2, 0($t2)
    sw $t2, -24($fp)
    lw $t0, -16($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    lbu $t2, 0($t2)
    sw $t2, -28($fp)
    lw $t2, -24($fp)
    sw $t2, -32($fp)
    lw $t2, -28($fp)
    lw $t0, -32($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    beq $t2, $zero, .R3_L20
    lw $t0, -12($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    lbu $t2, 0($t2)
    sw $t2, -36($fp)
    lw $t0, -16($fp)
    lw $t1, -20($fp)
    addu $t2, $t0, $t1
    lbu $t2, 0($t2)
    sw $t2, -40($fp)
    lw $t2, -36($fp)
    sw $t2, -44($fp)
    lw $t2, -40($fp)
    lw $t0, -44($fp)
    move $t1, $t2
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R3_L21
    li $t2, -1
    sw $t2, -48($fp)
    j .R3_L22
.R3_L21:
    li $t2, 1
    sw $t2, -48($fp)
.R3_L22:
    lw $v0, -48($fp)
    j .Rret3
.R3_L20:
.R3_L18:
    lw $t0, -20($fp)
    addiu $t2, $t0, 1
    sw $t2, -20($fp)
    j .R3_L17
.R3_L19:
    li $v0, 0
.Rret3:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

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









R_srand:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -72
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R14_L71
    li $t2, 1
    sw $t2, 0($fp)
.R14_L71:
    la $t2, R___fns_rtab
    sw $t2, -32($fp)
    lw $t2, 0($fp)
    lw $t1, -32($fp)
    sw $t2, 0($t1)
    lw $t2, 0($fp)
    sw $t2, -16($fp)
    li $t2, 1
    sw $t2, -12($fp)
.R14_L72:
    lw $t0, -12($fp)
    slti $t2, $t0, 31
    beq $t2, $zero, .R14_L74
    lw $t0, -16($fp)
    li $t1, 127773
    div $t0, $t1
    mflo $t2
    sw $t2, -20($fp)
    lw $t0, -16($fp)
    li $t1, 127773
    div $t0, $t1
    mfhi $t2
    sw $t2, -24($fp)
    li $t0, 16807
    lw $t1, -24($fp)
    mult $t0, $t1
    mflo $t2
    sw $t2, -36($fp)
    li $t0, 2836
    lw $t1, -20($fp)
    mult $t0, $t1
    mflo $t2
    lw $t0, -36($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sw $t2, -16($fp)
    lw $t0, -16($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R14_L75
    lw $t0, -16($fp)
    li $t1, 2147483647
    addu $t2, $t0, $t1
    sw $t2, -16($fp)
.R14_L75:
    la $t2, R___fns_rtab
    sw $t2, -40($fp)
    lw $t0, -12($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -40($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t0, -16($fp)
    sw $t0, 0($t2)
.R14_L73:
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R14_L72
.R14_L74:
    li $t2, 31
    sw $t2, -12($fp)
.R14_L76:
    lw $t0, -12($fp)
    slti $t2, $t0, 34
    beq $t2, $zero, .R14_L78
    la $t2, R___fns_rtab
    sw $t2, -44($fp)
    lw $t0, -12($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -44($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -48($fp)
    la $t2, R___fns_rtab
    sw $t2, -52($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, -31
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -52($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    lw $t1, -48($fp)
    sw $t2, 0($t1)
.R14_L77:
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R14_L76
.R14_L78:
    li $t2, 34
    la $t8, R___fns_ridx
    sw $t2, 0($t8)
    li $t2, 1
    la $t8, R___fns_rseeded
    sw $t2, 0($t8)
    li $t2, 34
    sw $t2, -12($fp)
.R14_L79:
    lw $t0, -12($fp)
    slti $t2, $t0, 344
    beq $t2, $zero, .R14_L81
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    li $t1, 34
    div $t0, $t1
    mfhi $t2
    sw $t2, -28($fp)
    la $t2, R___fns_rtab
    sw $t2, -56($fp)
    lw $t0, -28($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -56($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -60($fp)
    la $t2, R___fns_rtab
    sw $t2, -64($fp)
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    addiu $t2, $t0, -31
    move $t0, $t2
    li $t1, 34
    div $t0, $t1
    mfhi $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -64($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -68($fp)
    la $t2, R___fns_rtab
    sw $t2, -72($fp)
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    addiu $t2, $t0, -3
    move $t0, $t2
    li $t1, 34
    div $t0, $t1
    mfhi $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -72($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    lw $t0, -68($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t1, -60($fp)
    sw $t2, 0($t1)
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    addiu $t2, $t0, 1
    la $t8, R___fns_ridx
    sw $t2, 0($t8)
.R14_L80:
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R14_L79
.R14_L81:
.Rret14:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_rand:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -48
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    la $t0, R___fns_rseeded
    lw $t0, 0($t0)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R15_L82
    li $t2, 1
    sw $t2, -20($fp)
    addiu $sp, $sp, -4
    lw $t0, -20($fp)
    sw $t0, 0($sp)
    jal R_srand
    addiu $sp, $sp, 4
.R15_L82:
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    li $t1, 34
    div $t0, $t1
    mfhi $t2
    sw $t2, -12($fp)
    la $t2, R___fns_rtab
    sw $t2, -24($fp)
    lw $t0, -12($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -24($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -28($fp)
    la $t2, R___fns_rtab
    sw $t2, -32($fp)
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    addiu $t2, $t0, -31
    move $t0, $t2
    li $t1, 34
    div $t0, $t1
    mfhi $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -32($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -36($fp)
    la $t2, R___fns_rtab
    sw $t2, -40($fp)
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    addiu $t2, $t0, -3
    move $t0, $t2
    li $t1, 34
    div $t0, $t1
    mfhi $t2
    move $t0, $t2
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -40($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    lw $t0, -36($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t1, -28($fp)
    sw $t2, 0($t1)
    la $t2, R___fns_rtab
    sw $t2, -44($fp)
    lw $t0, -12($fp)
    li $t1, 4
    mult $t0, $t1
    mflo $t2
    lw $t0, -44($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    lw $t2, 0($t2)
    sw $t2, -16($fp)
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    addiu $t2, $t0, 1
    la $t8, R___fns_ridx
    sw $t2, 0($t8)
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    li $t1, 34000
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R15_L83
    la $t0, R___fns_ridx
    lw $t0, 0($t0)
    li $t1, 33966
    subu $t2, $t0, $t1
    la $t8, R___fns_ridx
    sw $t2, 0($t8)
.R15_L83:
    lw $t0, -16($fp)
    srl $t2, $t0, 1
    move $v0, $t2
.Rret15:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_abs:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 0($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R16_L84
    lw $t0, 0($fp)
    subu $t2, $zero, $t0
    sw $t2, -12($fp)
    j .R16_L85
.R16_L84:
    lw $t2, 0($fp)
    sw $t2, -12($fp)
.R16_L85:
    lw $v0, -12($fp)
.Rret16:
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

R_isupper:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 65
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R19_L90
    li $t2, 90
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R19_L90
    li $t2, 1
    sw $t2, -12($fp)
    j .R19_L91
.R19_L90:
    li $t2, 0
    sw $t2, -12($fp)
.R19_L91:
    lw $v0, -12($fp)
.Rret19:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_islower:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 97
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R20_L92
    li $t2, 122
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R20_L92
    li $t2, 1
    sw $t2, -12($fp)
    j .R20_L93
.R20_L92:
    li $t2, 0
    sw $t2, -12($fp)
.R20_L93:
    lw $v0, -12($fp)
.Rret20:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_isalpha:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_isupper
    addiu $sp, $sp, 4
    sw $v0, -12($fp)
    lw $t0, -12($fp)
    bne $t0, $zero, .R21_L94
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_islower
    addiu $sp, $sp, 4
    sw $v0, -16($fp)
    lw $t0, -16($fp)
    bne $t0, $zero, .R21_L94
    li $t2, 0
    sw $t2, -20($fp)
    j .R21_L95
.R21_L94:
    li $t2, 1
    sw $t2, -20($fp)
.R21_L95:
    lw $v0, -20($fp)
.Rret21:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_isalnum:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_isalpha
    addiu $sp, $sp, 4
    sw $v0, -12($fp)
    lw $t0, -12($fp)
    bne $t0, $zero, .R22_L96
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_isdigit
    addiu $sp, $sp, 4
    sw $v0, -16($fp)
    lw $t0, -16($fp)
    bne $t0, $zero, .R22_L96
    li $t2, 0
    sw $t2, -20($fp)
    j .R22_L97
.R22_L96:
    li $t2, 1
    sw $t2, -20($fp)
.R22_L97:
    lw $v0, -20($fp)
.Rret22:
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
    bne $t2, $zero, .R23_L106
    li $t2, 9
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R23_L106
    li $t2, 0
    sw $t2, -12($fp)
    j .R23_L107
.R23_L106:
    li $t2, 1
    sw $t2, -12($fp)
.R23_L107:
    lw $t0, -12($fp)
    bne $t0, $zero, .R23_L104
    li $t2, 10
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R23_L104
    li $t2, 0
    sw $t2, -16($fp)
    j .R23_L105
.R23_L104:
    li $t2, 1
    sw $t2, -16($fp)
.R23_L105:
    lw $t0, -16($fp)
    bne $t0, $zero, .R23_L102
    li $t2, 13
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R23_L102
    li $t2, 0
    sw $t2, -20($fp)
    j .R23_L103
.R23_L102:
    li $t2, 1
    sw $t2, -20($fp)
.R23_L103:
    lw $t0, -20($fp)
    bne $t0, $zero, .R23_L100
    lw $t0, 0($fp)
    li $t1, 11
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R23_L100
    li $t2, 0
    sw $t2, -24($fp)
    j .R23_L101
.R23_L100:
    li $t2, 1
    sw $t2, -24($fp)
.R23_L101:
    lw $t0, -24($fp)
    bne $t0, $zero, .R23_L98
    lw $t0, 0($fp)
    li $t1, 12
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R23_L98
    li $t2, 0
    sw $t2, -28($fp)
    j .R23_L99
.R23_L98:
    li $t2, 1
    sw $t2, -28($fp)
.R23_L99:
    lw $v0, -28($fp)
.Rret23:
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
    bne $t0, $zero, .R24_L110
    li $t2, 97
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R24_L112
    li $t2, 102
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R24_L112
    li $t2, 1
    sw $t2, -16($fp)
    j .R24_L113
.R24_L112:
    li $t2, 0
    sw $t2, -16($fp)
.R24_L113:
    lw $t0, -16($fp)
    bne $t0, $zero, .R24_L110
    li $t2, 0
    sw $t2, -20($fp)
    j .R24_L111
.R24_L110:
    li $t2, 1
    sw $t2, -20($fp)
.R24_L111:
    lw $t0, -20($fp)
    bne $t0, $zero, .R24_L108
    li $t2, 65
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R24_L114
    li $t2, 70
    lw $t0, 0($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R24_L114
    li $t2, 1
    sw $t2, -24($fp)
    j .R24_L115
.R24_L114:
    li $t2, 0
    sw $t2, -24($fp)
.R24_L115:
    lw $t0, -24($fp)
    bne $t0, $zero, .R24_L108
    li $t2, 0
    sw $t2, -28($fp)
    j .R24_L109
.R24_L108:
    li $t2, 1
    sw $t2, -28($fp)
.R24_L109:
    lw $v0, -28($fp)
.Rret24:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_isprint:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 0($fp)
    li $t1, 32
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R25_L116
    lw $t0, 0($fp)
    slti $t2, $t0, 127
    beq $t2, $zero, .R25_L116
    li $t2, 1
    sw $t2, -12($fp)
    j .R25_L117
.R25_L116:
    li $t2, 0
    sw $t2, -12($fp)
.R25_L117:
    lw $v0, -12($fp)
.Rret25:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_ispunct:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_isprint
    addiu $sp, $sp, 4
    sw $v0, -12($fp)
    lw $t0, -12($fp)
    beq $t0, $zero, .R26_L120
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_isalnum
    addiu $sp, $sp, 4
    sw $v0, -16($fp)
    lw $t0, -16($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R26_L120
    li $t2, 1
    sw $t2, -20($fp)
    j .R26_L121
.R26_L120:
    li $t2, 0
    sw $t2, -20($fp)
.R26_L121:
    lw $t0, -20($fp)
    beq $t0, $zero, .R26_L118
    li $t2, 32
    lw $t0, 0($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    beq $t2, $zero, .R26_L118
    li $t2, 1
    sw $t2, -24($fp)
    j .R26_L119
.R26_L118:
    li $t2, 0
    sw $t2, -24($fp)
.R26_L119:
    lw $v0, -24($fp)
.Rret26:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_toupper:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_islower
    addiu $sp, $sp, 4
    sw $v0, -12($fp)
    lw $t0, -12($fp)
    beq $t0, $zero, .R27_L122
    lw $t0, 0($fp)
    addiu $t2, $t0, -32
    sw $t2, -16($fp)
    j .R27_L123
.R27_L122:
    lw $t2, 0($fp)
    sw $t2, -16($fp)
.R27_L123:
    lw $v0, -16($fp)
.Rret27:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_tolower:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -16
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_isupper
    addiu $sp, $sp, 4
    sw $v0, -12($fp)
    lw $t0, -12($fp)
    beq $t0, $zero, .R28_L124
    lw $t0, 0($fp)
    addiu $t2, $t0, 32
    sw $t2, -16($fp)
    j .R28_L125
.R28_L124:
    lw $t2, 0($fp)
    sw $t2, -16($fp)
.R28_L125:
    lw $v0, -16($fp)
.Rret28:
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

R_strcpy:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
.R30_L128:
    lw $t0, 4($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    beq $t2, $zero, .R30_L129
    lw $t0, 0($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    sw $t2, -16($fp)
    lw $t0, 4($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -16($fp)
    sb $t2, 0($t1)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R30_L128
.R30_L129:
    lw $t0, 0($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    sw $t2, -20($fp)
    li $t2, 0
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -20($fp)
    sb $t2, 0($t1)
    lw $v0, 0($fp)
.Rret30:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strncpy:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
.R31_L130:
    lw $t0, -12($fp)
    lw $t1, 8($fp)
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R31_L132
    lw $t0, 4($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    beq $t2, $zero, .R31_L132
    li $t2, 1
    sw $t2, -16($fp)
    j .R31_L133
.R31_L132:
    li $t2, 0
    sw $t2, -16($fp)
.R31_L133:
    lw $t0, -16($fp)
    beq $t0, $zero, .R31_L131
    lw $t0, 0($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    sw $t2, -20($fp)
    lw $t0, 4($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -20($fp)
    sb $t2, 0($t1)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R31_L130
.R31_L131:
.R31_L134:
    lw $t0, -12($fp)
    lw $t1, 8($fp)
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R31_L135
    lw $t0, 0($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    sw $t2, -24($fp)
    li $t2, 0
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -24($fp)
    sb $t2, 0($t1)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R31_L134
.R31_L135:
    lw $v0, 0($fp)
.Rret31:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strcat:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_strlen
    addiu $sp, $sp, 4
    sw $v0, -12($fp)
    lw $t2, -12($fp)
    lw $t0, 0($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -16($fp)
    addiu $sp, $sp, -8
    lw $t0, -16($fp)
    sw $t0, 0($sp)
    lw $t0, 4($fp)
    sw $t0, 4($sp)
    jal R_strcpy
    addiu $sp, $sp, 8
    sw $v0, -20($fp)
    lw $v0, 0($fp)
.Rret32:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strncat:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_strlen
    addiu $sp, $sp, 4
    sw $v0, -20($fp)
    lw $t2, -20($fp)
    lw $t0, 0($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -12($fp)
    li $t2, 0
    sw $t2, -16($fp)
.R33_L136:
    lw $t0, -16($fp)
    lw $t1, 8($fp)
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R33_L138
    lw $t0, 4($fp)
    lw $t1, -16($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    beq $t2, $zero, .R33_L138
    li $t2, 1
    sw $t2, -24($fp)
    j .R33_L139
.R33_L138:
    li $t2, 0
    sw $t2, -24($fp)
.R33_L139:
    lw $t0, -24($fp)
    beq $t0, $zero, .R33_L137
    lw $t0, -12($fp)
    lw $t1, -16($fp)
    addu $t2, $t0, $t1
    sw $t2, -28($fp)
    lw $t0, 4($fp)
    lw $t1, -16($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    lw $t1, -28($fp)
    sb $t2, 0($t1)
    lw $t0, -16($fp)
    addiu $t2, $t0, 1
    sw $t2, -16($fp)
    j .R33_L136
.R33_L137:
    lw $t0, -12($fp)
    lw $t1, -16($fp)
    addu $t2, $t0, $t1
    sw $t2, -32($fp)
    li $t2, 0
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, -32($fp)
    sb $t2, 0($t1)
    lw $v0, 0($fp)
.Rret33:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strcmp:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
.R34_L140:
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R34_L142
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    sw $t2, -12($fp)
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    sw $t2, -16($fp)
    lw $t2, -12($fp)
    sw $t2, -20($fp)
    lw $t2, -16($fp)
    lw $t0, -20($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R34_L142
    li $t2, 1
    sw $t2, -24($fp)
    j .R34_L143
.R34_L142:
    li $t2, 0
    sw $t2, -24($fp)
.R34_L143:
    lw $t0, -24($fp)
    beq $t0, $zero, .R34_L141
    lw $t0, 0($fp)
    addiu $t2, $t0, 1
    sw $t2, 0($fp)
    lw $t0, 4($fp)
    addiu $t2, $t0, 1
    sw $t2, 4($fp)
    j .R34_L140
.R34_L141:
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    andi $t2, $t2, 0xff
    sw $t2, -28($fp)
    lw $t1, 4($fp)
    lb $t2, 0($t1)
    andi $t2, $t2, 0xff
    lw $t0, -28($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    move $v0, $t2
.Rret34:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strncmp:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
.R35_L144:
    lw $t0, -12($fp)
    lw $t1, 8($fp)
    sltu $t2, $t0, $t1
    beq $t2, $zero, .R35_L146
    lw $t0, 0($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -16($fp)
    lw $t0, 4($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    sw $t2, -20($fp)
    lw $t2, -16($fp)
    sw $t2, -24($fp)
    lw $t2, -20($fp)
    lw $t0, -24($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltu $t2, $zero, $t2
    bne $t2, $zero, .R35_L148
    lw $t0, 0($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    move $t0, $t2
    sltiu $t2, $t0, 1
    bne $t2, $zero, .R35_L148
    li $t2, 0
    sw $t2, -28($fp)
    j .R35_L149
.R35_L148:
    li $t2, 1
    sw $t2, -28($fp)
.R35_L149:
    lw $t0, -28($fp)
    beq $t0, $zero, .R35_L147
    lw $t0, 0($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    andi $t2, $t2, 0xff
    sw $t2, -32($fp)
    lw $t0, 4($fp)
    lw $t1, -12($fp)
    addu $t2, $t0, $t1
    lb $t2, 0($t2)
    andi $t2, $t2, 0xff
    lw $t0, -32($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    move $v0, $t2
    j .Rret35
.R35_L147:
.R35_L145:
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R35_L144
.R35_L146:
    li $v0, 0
.Rret35:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strchr:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
.R36_L150:
    li $t0, 1
    beq $t0, $zero, .R36_L151
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    sw $t2, -12($fp)
    lw $t2, 4($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    sw $t2, -16($fp)
    lw $t2, -12($fp)
    sw $t2, -20($fp)
    lw $t2, -16($fp)
    lw $t0, -20($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R36_L152
    lw $t2, 0($fp)
    move $v0, $t2
    j .Rret36
.R36_L152:
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    move $t0, $t2
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R36_L153
    li $t2, 0
    move $v0, $t2
    j .Rret36
.R36_L153:
    lw $t0, 0($fp)
    addiu $t2, $t0, 1
    sw $t2, 0($fp)
    j .R36_L150
.R36_L151:
    li $t2, 0
    move $v0, $t2
.Rret36:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strrchr:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    li $t2, 0
    sw $t2, -12($fp)
.R37_L154:
    li $t0, 1
    beq $t0, $zero, .R37_L155
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    sw $t2, -16($fp)
    lw $t2, 4($fp)
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    sw $t2, -20($fp)
    lw $t2, -16($fp)
    sw $t2, -24($fp)
    lw $t2, -20($fp)
    lw $t0, -24($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R37_L156
    lw $t2, 0($fp)
    sw $t2, -12($fp)
.R37_L156:
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    move $t0, $t2
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R37_L157
    lw $t2, -12($fp)
    move $v0, $t2
    j .Rret37
.R37_L157:
    lw $t0, 0($fp)
    addiu $t2, $t0, 1
    sw $t2, 0($fp)
    j .R37_L154
.R37_L155:
    li $t2, 0
    move $v0, $t2
.Rret37:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strstr:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -24
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 4($fp)
    sw $t0, 0($sp)
    jal R_strlen
    addiu $sp, $sp, 4
    sw $v0, -16($fp)
    lw $t2, -16($fp)
    sw $t2, -12($fp)
    li $t2, 0
    lw $t0, -12($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R38_L158
    lw $t2, 0($fp)
    move $v0, $t2
    j .Rret38
.R38_L158:
.R38_L159:
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R38_L160
    addiu $sp, $sp, -12
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    lw $t0, 4($fp)
    sw $t0, 4($sp)
    lw $t0, -12($fp)
    sw $t0, 8($sp)
    jal R_strncmp
    addiu $sp, $sp, 12
    sw $v0, -20($fp)
    lw $t0, -20($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R38_L161
    lw $t2, 0($fp)
    move $v0, $t2
    j .Rret38
.R38_L161:
    lw $t0, 0($fp)
    addiu $t2, $t0, 1
    sw $t2, 0($fp)
    j .R38_L159
.R38_L160:
    li $t2, 0
    move $v0, $t2
.Rret38:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_strdup:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -32
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    addiu $sp, $sp, -4
    lw $t0, 0($fp)
    sw $t0, 0($sp)
    jal R_strlen
    addiu $sp, $sp, 4
    sw $v0, -16($fp)
    li $t2, 1
    lw $t0, -16($fp)
    move $t1, $t2
    addu $t2, $t0, $t1
    sw $t2, -20($fp)
    addiu $sp, $sp, -4
    lw $t0, -20($fp)
    sw $t0, 0($sp)
    jal R_malloc
    addiu $sp, $sp, 4
    sw $v0, -24($fp)
    lw $t2, -24($fp)
    sw $t2, -12($fp)
    lw $t0, -12($fp)
    beq $t0, $zero, .R39_L162
    addiu $sp, $sp, -8
    lw $t0, -12($fp)
    sw $t0, 0($sp)
    lw $t0, 0($fp)
    sw $t0, 4($sp)
    jal R_strcpy
    addiu $sp, $sp, 8
    sw $v0, -28($fp)
.R39_L162:
    lw $v0, -12($fp)
.Rret39:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra




R_strtok:
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -40
    move $fp, $t9
    sw $ra, -4($fp)
    sw $t8, -8($fp)
    lw $t0, 0($fp)
    beq $t0, $zero, .R43_L174
    lw $t2, 0($fp)
    la $t8, R___fns_tok_next
    sw $t2, 0($t8)
.R43_L174:
    la $t0, R___fns_tok_next
    lw $t0, 0($t0)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R43_L175
    li $t2, 0
    move $v0, $t2
    j .Rret43
.R43_L175:
    la $t2, R___fns_tok_next
    lw $t2, 0($t2)
    sw $t2, 0($fp)
.R43_L176:
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R43_L178
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    sw $t2, -16($fp)
    addiu $sp, $sp, -8
    lw $t0, 4($fp)
    sw $t0, 0($sp)
    lw $t0, -16($fp)
    sw $t0, 4($sp)
    jal R_strchr
    addiu $sp, $sp, 8
    sw $v0, -20($fp)
    lw $t0, -20($fp)
    beq $t0, $zero, .R43_L178
    li $t2, 1
    sw $t2, -24($fp)
    j .R43_L179
.R43_L178:
    li $t2, 0
    sw $t2, -24($fp)
.R43_L179:
    lw $t0, -24($fp)
    beq $t0, $zero, .R43_L177
    lw $t0, 0($fp)
    addiu $t2, $t0, 1
    sw $t2, 0($fp)
    j .R43_L176
.R43_L177:
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    move $t0, $t2
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R43_L180
    li $t2, 0
    la $t8, R___fns_tok_next
    sw $t2, 0($t8)
    li $t2, 0
    move $v0, $t2
    j .Rret43
.R43_L180:
    lw $t2, 0($fp)
    sw $t2, -12($fp)
.R43_L181:
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R43_L183
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    sw $t2, -28($fp)
    addiu $sp, $sp, -8
    lw $t0, 4($fp)
    sw $t0, 0($sp)
    lw $t0, -28($fp)
    sw $t0, 4($sp)
    jal R_strchr
    addiu $sp, $sp, 8
    sw $v0, -32($fp)
    lw $t0, -32($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R43_L183
    li $t2, 1
    sw $t2, -36($fp)
    j .R43_L184
.R43_L183:
    li $t2, 0
    sw $t2, -36($fp)
.R43_L184:
    lw $t0, -36($fp)
    beq $t0, $zero, .R43_L182
    lw $t0, 0($fp)
    addiu $t2, $t0, 1
    sw $t2, 0($fp)
    j .R43_L181
.R43_L182:
    lw $t1, 0($fp)
    lb $t2, 0($t1)
    beq $t2, $zero, .R43_L185
    li $t2, 0
    sll $t2, $t2, 24
    sra $t2, $t2, 24
    lw $t1, 0($fp)
    sb $t2, 0($t1)
    lw $t0, 0($fp)
    addiu $t2, $t0, 1
    la $t8, R___fns_tok_next
    sw $t2, 0($t8)
    j .R43_L186
.R43_L185:
    li $t2, 0
    la $t8, R___fns_tok_next
    sw $t2, 0($t8)
.R43_L186:
    lw $v0, -12($fp)
.Rret43:
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
.R61_L237:
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
    beq $t0, $zero, .R61_L238
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R61_L237
.R61_L238:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -40($fp)
    li $t2, 45
    lw $t0, -40($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R61_L239
    li $t2, 1
    sw $t2, -20($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R61_L240
.R61_L239:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -44($fp)
    li $t2, 43
    lw $t0, -44($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R61_L241
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
.R61_L241:
.R61_L240:
    lw $t0, 8($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R61_L249
    lw $t0, 8($fp)
    li $t1, 16
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R61_L249
    li $t2, 0
    sw $t2, -48($fp)
    j .R61_L250
.R61_L249:
    li $t2, 1
    sw $t2, -48($fp)
.R61_L250:
    lw $t0, -48($fp)
    beq $t0, $zero, .R61_L247
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -52($fp)
    li $t2, 48
    lw $t0, -52($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R61_L247
    li $t2, 1
    sw $t2, -56($fp)
    j .R61_L248
.R61_L247:
    li $t2, 0
    sw $t2, -56($fp)
.R61_L248:
    lw $t0, -56($fp)
    beq $t0, $zero, .R61_L245
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    lb $t2, 0($t2)
    sw $t2, -60($fp)
    li $t2, 120
    lw $t0, -60($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R61_L251
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    lb $t2, 0($t2)
    sw $t2, -64($fp)
    li $t2, 88
    lw $t0, -64($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R61_L251
    li $t2, 0
    sw $t2, -68($fp)
    j .R61_L252
.R61_L251:
    li $t2, 1
    sw $t2, -68($fp)
.R61_L252:
    lw $t0, -68($fp)
    beq $t0, $zero, .R61_L245
    li $t2, 1
    sw $t2, -72($fp)
    j .R61_L246
.R61_L245:
    li $t2, 0
    sw $t2, -72($fp)
.R61_L246:
    lw $t0, -72($fp)
    beq $t0, $zero, .R61_L243
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
    beq $t0, $zero, .R61_L243
    li $t2, 1
    sw $t2, -84($fp)
    j .R61_L244
.R61_L243:
    li $t2, 0
    sw $t2, -84($fp)
.R61_L244:
    lw $t0, -84($fp)
    beq $t0, $zero, .R61_L242
    lw $t0, -12($fp)
    addiu $t2, $t0, 2
    sw $t2, -12($fp)
    li $t2, 16
    sw $t2, 8($fp)
    j .R61_L253
.R61_L242:
    lw $t0, 8($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R61_L255
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -88($fp)
    li $t2, 48
    lw $t0, -88($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R61_L255
    li $t2, 1
    sw $t2, -92($fp)
    j .R61_L256
.R61_L255:
    li $t2, 0
    sw $t2, -92($fp)
.R61_L256:
    lw $t0, -92($fp)
    beq $t0, $zero, .R61_L254
    li $t2, 8
    sw $t2, 8($fp)
    j .R61_L257
.R61_L254:
    lw $t0, 8($fp)
    li $t1, 0
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R61_L258
    li $t2, 10
    sw $t2, 8($fp)
.R61_L258:
.R61_L257:
.R61_L253:
.R61_L259:
    li $t0, 1
    beq $t0, $zero, .R61_L260
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
    beq $t0, $zero, .R61_L261
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -104($fp)
    li $t2, 48
    lw $t0, -104($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sw $t2, -28($fp)
    j .R61_L262
.R61_L261:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -108($fp)
    li $t2, 97
    lw $t0, -108($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R61_L264
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -112($fp)
    li $t2, 122
    lw $t0, -112($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R61_L264
    li $t2, 1
    sw $t2, -116($fp)
    j .R61_L265
.R61_L264:
    li $t2, 0
    sw $t2, -116($fp)
.R61_L265:
    lw $t0, -116($fp)
    beq $t0, $zero, .R61_L263
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
    j .R61_L266
.R61_L263:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -124($fp)
    li $t2, 65
    lw $t0, -124($fp)
    move $t1, $t2
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R61_L268
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -128($fp)
    li $t2, 90
    lw $t0, -128($fp)
    move $t1, $t2
    slt $t2, $t1, $t0
    xori $t2, $t2, 1
    beq $t2, $zero, .R61_L268
    li $t2, 1
    sw $t2, -132($fp)
    j .R61_L269
.R61_L268:
    li $t2, 0
    sw $t2, -132($fp)
.R61_L269:
    lw $t0, -132($fp)
    beq $t0, $zero, .R61_L267
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
    j .R61_L270
.R61_L267:
    j .R61_L260
.R61_L270:
.R61_L266:
.R61_L262:
    lw $t0, -28($fp)
    lw $t1, 8($fp)
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R61_L271
    j .R61_L260
.R61_L271:
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
    j .R61_L259
.R61_L260:
    lw $t0, 4($fp)
    beq $t0, $zero, .R61_L272
    lw $t0, -24($fp)
    beq $t0, $zero, .R61_L273
    lw $t2, -12($fp)
    sw $t2, -144($fp)
    j .R61_L274
.R61_L273:
    lw $t2, 0($fp)
    sw $t2, -144($fp)
.R61_L274:
    lw $t2, -144($fp)
    lw $t1, 4($fp)
    sw $t2, 0($t1)
.R61_L272:
    lw $t0, -20($fp)
    beq $t0, $zero, .R61_L275
    lw $t0, -16($fp)
    subu $t2, $zero, $t0
    sw $t2, -148($fp)
    j .R61_L276
.R61_L275:
    lw $t2, -16($fp)
    sw $t2, -148($fp)
.R61_L276:
    lw $v0, -148($fp)
.Rret61:
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
.Rret62:
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra

R_atol:
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
    lw $v0, -16($fp)
.Rret63:
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
.R65_L283:
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
    beq $t0, $zero, .R65_L284
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R65_L283
.R65_L284:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -64($fp)
    li $t2, 45
    lw $t0, -64($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R65_L285
    li $t2, 1
    sw $t2, -24($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R65_L286
.R65_L285:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -68($fp)
    li $t2, 43
    lw $t0, -68($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R65_L287
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
.R65_L287:
.R65_L286:
.R65_L288:
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
    beq $t0, $zero, .R65_L289
    lw $t0, -36($fp)
    slti $t2, $t0, 18
    beq $t2, $zero, .R65_L290
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
    j .R65_L291
.R65_L290:
    lw $t0, -32($fp)
    addiu $t2, $t0, 1
    sw $t2, -32($fp)
.R65_L291:
    li $t2, 1
    sw $t2, -28($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R65_L288
.R65_L289:
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -112($fp)
    li $t2, 46
    lw $t0, -112($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R65_L292
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
.R65_L293:
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
    beq $t0, $zero, .R65_L294
    lw $t0, -36($fp)
    slti $t2, $t0, 18
    beq $t2, $zero, .R65_L295
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
.R65_L295:
    li $t2, 1
    sw $t2, -28($fp)
    lw $t0, -12($fp)
    addiu $t2, $t0, 1
    sw $t2, -12($fp)
    j .R65_L293
.R65_L294:
.R65_L292:
    lw $t0, -28($fp)
    beq $t0, $zero, .R65_L297
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -156($fp)
    li $t2, 101
    lw $t0, -156($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R65_L299
    lw $t1, -12($fp)
    lb $t2, 0($t1)
    sw $t2, -160($fp)
    li $t2, 69
    lw $t0, -160($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    bne $t2, $zero, .R65_L299
    li $t2, 0
    sw $t2, -164($fp)
    j .R65_L300
.R65_L299:
    li $t2, 1
    sw $t2, -164($fp)
.R65_L300:
    lw $t0, -164($fp)
    beq $t0, $zero, .R65_L297
    li $t2, 1
    sw $t2, -168($fp)
    j .R65_L298
.R65_L297:
    li $t2, 0
    sw $t2, -168($fp)
.R65_L298:
    lw $t0, -168($fp)
    beq $t0, $zero, .R65_L296
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
    beq $t2, $zero, .R65_L301
    li $t2, 1
    sw $t2, -44($fp)
    lw $t0, -40($fp)
    addiu $t2, $t0, 1
    sw $t2, -40($fp)
    j .R65_L302
.R65_L301:
    lw $t1, -40($fp)
    lb $t2, 0($t1)
    sw $t2, -176($fp)
    li $t2, 43
    lw $t0, -176($fp)
    move $t1, $t2
    subu $t2, $t0, $t1
    sltiu $t2, $t2, 1
    beq $t2, $zero, .R65_L303
    lw $t0, -40($fp)
    addiu $t2, $t0, 1
    sw $t2, -40($fp)
.R65_L303:
.R65_L302:
.R65_L304:
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
    beq $t0, $zero, .R65_L305
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
    j .R65_L304
.R65_L305:
    lw $t0, -52($fp)
    beq $t0, $zero, .R65_L306
    lw $t2, -40($fp)
    sw $t2, -12($fp)
    lw $t0, -44($fp)
    beq $t0, $zero, .R65_L307
    lw $t0, -48($fp)
    subu $t2, $zero, $t0
    sw $t2, -196($fp)
    j .R65_L308
.R65_L307:
    lw $t2, -48($fp)
    sw $t2, -196($fp)
.R65_L308:
    lw $t0, -32($fp)
    lw $t1, -196($fp)
    addu $t2, $t0, $t1
    sw $t2, -32($fp)
.R65_L306:
.R65_L296:
    lw $t0, 4($fp)
    beq $t0, $zero, .R65_L309
    lw $t0, -28($fp)
    beq $t0, $zero, .R65_L310
    lw $t2, -12($fp)
    sw $t2, -200($fp)
    j .R65_L311
.R65_L310:
    lw $t2, 0($fp)
    sw $t2, -200($fp)
.R65_L311:
    lw $t2, -200($fp)
    lw $t1, 4($fp)
    sw $t2, 0($t1)
.R65_L309:
    lw $t0, -28($fp)
    sltiu $t2, $t0, 1
    beq $t2, $zero, .R65_L312
    li.d $f0, 0.0
    j .Rret65
.R65_L312:
    lw $t0, -32($fp)
    slti $t2, $t0, 0
    beq $t2, $zero, .R65_L314
    lw $t0, -32($fp)
    li $t1, -22
    slt $t2, $t0, $t1
    xori $t2, $t2, 1
    beq $t2, $zero, .R65_L314
    li $t2, 1
    sw $t2, -204($fp)
    j .R65_L315
.R65_L314:
    li $t2, 0
    sw $t2, -204($fp)
.R65_L315:
    lw $t0, -204($fp)
    beq $t0, $zero, .R65_L313
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
    j .R65_L316
.R65_L313:
    lw $t0, -32($fp)
    slti $t2, $t0, -22
    beq $t2, $zero, .R65_L317
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
    j .R65_L318
.R65_L317:
    lw $t0, -32($fp)
    li $t1, 0
    slt $t2, $t1, $t0
    beq $t2, $zero, .R65_L319
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
.R65_L319:
.R65_L318:
.R65_L316:
    lw $t0, -24($fp)
    beq $t0, $zero, .R65_L320
    l.d $f4, -20($fp)
    neg.d $f0, $f4
    s.d $f0, -284($fp)
    l.d $f0, -284($fp)
    s.d $f0, -292($fp)
    j .R65_L321
.R65_L320:
    l.d $f0, -20($fp)
    s.d $f0, -292($fp)
.R65_L321:
    l.d $f0, -292($fp)
.Rret65:
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
.Rret66:
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














