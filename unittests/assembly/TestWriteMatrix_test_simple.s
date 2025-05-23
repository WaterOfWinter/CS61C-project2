.import ../../src/utils.s
.import ../../src/write_matrix.s

.data
msg0: .asciiz "outputs/test_write_matrix/student.bin"
m0: .word 1 2 3 4 5 6 7 8 9

.globl main_test
.text
# main_test function for testing
main_test:

    # load filename outputs/test_write_matrix/student.bin into a0
    la a0 msg0

    # load address to array m0 into a1
    la a1 m0

    # load 3 into a2
    li a2 3

    # load 3 into a3
    li a3 3

    # call write_matrix function
    jal ra write_matrix

    # exit normally
    jal exit
