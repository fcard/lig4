clear:
  load_num_lines($t0)
  load_num_columns($t1)
  mul $t2, $t0, $t1
  sll $t2, $t2, 2
  add $t2, $gp, $t2
  move $t0, $gp
  
clear.loop:
  sw $zero, 0($t0)
  addi $t0, $t0, 4
  bne $t0, $t2, clear.loop
  jr $ra
  

place:
  load_num_lines($t0)
  display_pointer($t1, $a0, $t0)
place.loop:
  addi $t0, $t0, -1
  addi $t1, $t1, -32
  lw $t2, 0($t1)
  bne $t2, $zero, place.loop.next
  sw $a1, 0($t1)
  li $v0, 1
  jr $ra
place.loop.next:
  bne $t0, $zero, place.loop
  li $v0, 0
  jr $ra
  

check_victory:
  load_num_lines($t0)
  load_num_columns($t1)
  
check_victory.check_horizontal:
  li $t2, 0
  move $t8, $gp
  addi $t9, $t1, -4
check_victory.check_horizontal.outer_loop:
  li $t3, 0
check_victory.check_horizontal.inner_loop:
  lw $t4, 0($t8)
  bne $t4, $a0, check_victory.check_horizontal.inner_loop.end
  lw $t4, 4($t8)
  bne $t4, $a0, check_victory.check_horizontal.inner_loop.end
  lw $t4, 8($t8)
  bne $t4, $a0, check_victory.check_horizontal.inner_loop.end
  lw $t4, 12($t8)
  bne $t4, $a0, check_victory.check_horizontal.inner_loop.end
  li $v0, 1
  jr $ra
check_victory.check_horizontal.inner_loop.end:
  addi $t3, $t3, 1
  addi $t8, $t8, 4
  bne $t3, $t9, check_victory.check_horizontal.inner_loop
  
  addi $t2, $t2, 1
  addi $t8, $t8, 16
  bne $t2, $t0, check_victory.check_horizontal.outer_loop
  
check_victory.check_vertical:
  li $t2, 0
  move $t8, $gp
  addi $t9, $t0, -4
check_victory.check_vertical.outer_loop:
  li $t3, 0
check_victory.check_vertical.inner_loop:
  lw $t4, 0($t8)
  bne $t4, $a0, check_victory.check_vertical.inner_loop.end
  lw $t4, 32($t8)
  bne $t4, $a0, check_victory.check_vertical.inner_loop.end
  lw $t4, 64($t8)
  bne $t4, $a0, check_victory.check_vertical.inner_loop.end
  lw $t4, 96($t8)
  bne $t4, $a0, check_victory.check_vertical.inner_loop.end
  li $v0, 1
  jr $ra
check_victory.check_vertical.inner_loop.end:
  addi $t3, $t3, 1
  addi $t8, $t8, 4
  bne $t3, $t1, check_victory.check_vertical.inner_loop
  
  addi $t2, $t2, 1
  bne $t2, $t9, check_victory.check_vertical.outer_loop
  
check_victory.check_diagonal:
  li $t2, 0
  move $t8, $gp
  addi $t7, $t0, -4
  addi $t9, $t1, -4
check_victory.check_diagonal.outer_loop:
  li $t3, 0
check_victory.check_diagonal.inner_loop:
  lw $t4, 0($t8)
  bne $t4, $a0, check_victory.check_diagonal.inner_loop.end
  lw $t4, 36($t8)
  bne $t4, $a0, check_victory.check_diagonal.inner_loop.end
  lw $t4, 80($t8)
  bne $t4, $a0, check_victory.check_diagonal.inner_loop.end
  lw $t4, 120($t8)
  bne $t4, $a0, check_victory.check_diagonal.inner_loop.end
  li $v0, 1
  jr $ra
check_victory.check_diagonal.inner_loop.end:
  addi $t3, $t3, 1
  addi $t8, $t8, 4
  bne $t3, $t1, check_victory.check_diagonal.inner_loop
  
  addi $t2, $t2, 1
  addi $t8, $t8, 16
  bne $t2, $t9, check_victory.check_diagonal.outer_loop

check_victory.check_sec_diagonal:
  li $t2, 0
  add $t8, $gp, 128
  addi $t7, $t0, -4
  addi $t9, $t1, -4
check_victory.check_sec_diagonal.outer_loop:
  li $t3, 0
check_victory.check_sec_diagonal.inner_loop:
  lw $t4, 0($t8)
  bne $t4, $a0, check_victory.check_sec_diagonal.inner_loop.end
  lw $t4, -28($t8)
  bne $t4, $a0, check_victory.check_sec_diagonal.inner_loop.end
  lw $t4, -56($t8)
  bne $t4, $a0, check_victory.check_sec_diagonal.inner_loop.end
  lw $t4, -84($t8)
  bne $t4, $a0, check_victory.check_sec_diagonal.inner_loop.end
  li $v0, 1
  jr $ra
check_victory.check_sec_diagonal.inner_loop.end:
  addi $t3, $t3, 1
  addi $t8, $t8, 4
  bne $t3, $t1, check_victory.check_sec_diagonal.inner_loop
  
  addi $t2, $t2, 1
  addi $t8, $t8, 16
  bne $t2, $t9, check_victory.check_sec_diagonal.outer_loop

check_victory.end:
  li $v0, 0
  jr $ra
  
  
check_full:
  add $t0, $gp, 32
check_full.loop:
  addi $t0, $t0, -4
  lw $t1, 0($t0)
  bne $t1, $zero check_full.loop.next
  li $v0, 1
  jr $ra
check_full.loop.next:
  bne $t0, $gp, check_full.loop
  li $v0, 0
  jr $ra
