
.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>






	# =====================================
    # LOAD MATRICES
    # =====================================
    
    # Prologue
        addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)
    
    # =====================================
    # 检查参数个数
    # =====================================
    li t0, 5
    bne a0, t0, incorrect_arg
    
    mv s0, a0       # argc
    mv s1, a1       # argv
    mv s2, a2       # print_classification

    # =====================================
    # 读取 m0 矩阵
    # =====================================
    li a0, 8
    jal malloc
    beq a0, x0, malloc_error
    mv s3, a0                       # m0 的 rows 和 cols 存储区
    
    lw a0, 4(s1)                   # argv[1] (m0 路径)
    mv a1, s3                      # m0->rows
    addi a2, s3, 4                 # m0->cols
    jal read_matrix
    mv s4, a0                      # m0 矩阵指针

    # =====================================
    # 读取 m1 矩阵
    # =====================================
    li a0, 8
    jal malloc
    beq a0, x0, malloc_error
    mv s5, a0                       # m1 的 rows 和 cols 存储区
    
    lw a0, 8(s1)                   # argv[2] (m1 路径)
    mv a1, s5                      # m1->rows
    addi a2, s5, 4                 # m1->cols
    jal read_matrix
    mv s6, a0                      # m1 矩阵指针

    # =====================================
    # 读取 input 矩阵
    # =====================================
    li a0, 8
    jal malloc
    beq a0, x0, malloc_error
    mv s7, a0                       # input 的 rows 和 cols 存储区
    
    lw a0, 12(s1)                  # argv[3] (input 路径)
    mv a1, s7                      # input->rows
    addi a2, s7, 4                 # input->cols
    jal read_matrix
    mv s8, a0                      # input 矩阵指针

    # =====================================
    # 线性层 1: m0 * input
    # =====================================
    mv a0, s4
    lw a1, 0(s3)
    lw a2, 4(s3)
    mv a3, s8
    lw a4, 0(s7)
    lw a5, 4(s7)
    mul t0, a1, a5                 # 输出矩阵 size = m0.rows * input.cols

    # 分配输出矩阵内存
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a6, 8(sp)
    mv a0, t0
    jal malloc
    beq a0, x0, malloc_error
    mv s9, a0
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a6, 8(sp)
    addi sp, sp, 12

    mv a6, s9
    jal matmul                   # s9 = m0 * input

    # =====================================
    # 非线性层: ReLU(m0 * input)
    # =====================================
    mul t0, a1, a5               # size = rows * cols
    mv a0, s9
    mv a1, t0
    jal relu                     # in-place 修改 s9

    # =====================================
    # 线性层 2: m1 * ReLU(m0 * input)
    # =====================================
    lw t0, 0(s5)
    lw t1, 4(s7)
    mul t2, t0, t1               # 输出矩阵 size = m1.rows * relu.cols

    mv a0, t2
    jal malloc
    beq a0, x0, malloc_error
    mv s10, a0                   # s10 = m1 * relu 输出区

    mv a0, s6
    lw a1, 0(s5)
    lw a2, 4(s5)
    mv a3, s9
    lw a4, 0(s3)
    lw a5, 4(s7)
    mv a6, s10
    jal matmul                   # s10 = m1 * relu

    # =====================================
    # 写入输出矩阵到文件
    # =====================================
    lw a0, 16(s1)                # argv[4] (output 路径)
    mv a1, s10
    lw a2, 0(s5)
    lw a3, 4(s7)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw t0, 0(s5)
    lw t1, 4(s7)
    mul t2, t0, t1               # size
    mv a0, s10
    mv a1, t2
    jal argmax                   # a0 = 分类下标
    mv s11, a0

    # Print classification
    mv a0, s11
    jal print_int



    # Print newline afterwards for clarity
    li a0, 10                   # '\n'
    jal print_char
    
    # =====================================
    # FREE MEMORY
    # =====================================
    mv a0, s3
    jal free

    mv a0, s4
    jal free

    mv a0, s5
    jal free

    mv a0, s6
    jal free

    mv a0, s7
    jal free

    mv a0, s8
    jal free

    mv a0, s9
    jal free

    mv a0, s10
    jal free

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52

    ret
    
incorrect_arg:
    li a0, 89
    j exit2
    
malloc_error:
    li a0, 88
    j exit2
    
skip_print:
    # =====================================
    # Epilogue 恢复寄存器
    # =====================================
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    ret