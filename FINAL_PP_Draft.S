    .globl main

    .data
errMsg:
    .asciz "You must include at least one argument\n"
buf:
    .space 512

    .text

# Flatten a row of a 2D array and store it in a 1D array
flatten_row:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    sw      s0, 8(sp)
    mv      s0, sp
    li      t0, 0

loop1:
    li      t1, 0

loop2:
    slli    t2, t0, 1   # t2 = row * 2
    add     t2, a0, t2  # Address = base + row*2
    add     t3, a1, t0  # Target position
    lb      t4, 0(t2)   # Load byte from source
    sb      t4, 0(t3)   # Store byte in target

    addi    t1, t1, 1
    li      t5, 2
    bge     t1, t5, end_inner_loop

    j       loop2

end_inner_loop:
    addi    t0, t0, 1
    li      t6, 2
    bge     t0, t6, end_outer_loop

    j       loop1

end_outer_loop:
    lw      ra, 12(sp)
    lw      s0, 8(sp)
    addi    sp, sp, 16
    ret

# Convert a 2D matrix into a lower triangular form
lowerTensor:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    sw      s0, 8(sp)
    mv      s0, sp

    mv      t0, a1  # Number of rows
    addi    t0, t0, -1
    li      t1, 0

loop_Lower:
    li      t2, 0

loop_inner:
    mul     t3, t1, a1
    add     t3, a2, t3
    add     t4, a3, t1
    add     t5, t4, t3
    lb      t6, 0(t5)
    sb      t6, 1(t4)

    addi    t2, t2, 1
    blt     t2, a1, loop_inner

    addi    t1, t1, 1
    blt     t1, a0, loop_Lower

    lw      ra, 12(sp)
    lw      s0, 8(sp)
    addi    sp, sp, 16
    ret

# Copy values between two arrays
pass_values:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    sw      s0, 8(sp)
    mv      s0, sp

    li      t0, 0

copy_loop:
    add     t1, a0, t0
    add     t2, a2, t0
    lb      t3, 1(t1)
    sb      t3, 1(t2)

    addi    t0, t0, 1
    bge     t0, a1, end_copy

    j       copy_loop

end_copy:
    lw      ra, 12(sp)
    lw      s0, 8(sp)
    addi    sp, sp, 16
    ret

main:
    addi    sp, sp, -32
    sw      ra, 28(sp)
    sw      s0, 24(sp)
    mv      s0, sp

    # Allocate space for arrays (modify these based on required size)
    li      a0, 0x1000
    li      a1, 64
    li      a2, 32
    li      a3, 0x2000
    call    lowerTensor

    # Example call to pass_values function
    li      a0, 0x1000
    li      a1, 64
    li      a2, 0x2000
    call    pass_values

    # Exit
    li      a7, 93
    li      a0, 0
    ecall
