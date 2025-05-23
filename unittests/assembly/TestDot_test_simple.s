.import ../../src/utils.s
.import ../../src/dot.s

.data
m0: .word 1 -2 3 -4 5 -6 7 -8 9
m1: .word 1 2 7 -4 5 -6 10 12 9
msg0: .asciiz "expected a0 to be 150 not: "

.globl main_test
.text
# main_test function for testing
main_test:
    # Prologue
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)


    # load address to array m0 into a0
    la a0 m0

    # load address to array m1 into a1
    la a1 m1

    # load 9 into a2
    li a2 9

    # load 1 into a3
    li a3 1

    # load 1 into a4
    li a4 1

    # call dot function
    jal ra dot

    # save all return values in the save registers
    mv s0 a0


    # check that a0 == 150
    li t0 150
    beq s0 t0 a0_eq_150
    # print error and exit
    la a1, msg0
    jal print_str
    mv a1 s0
    jal print_int
    # Print newline
    li a1 '\n'
    jal ra print_char
    # exit with code 8 to indicate failure
    li a1 8
    jal exit2
    a0_eq_150:


    # exit normally
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8

    jal exit
