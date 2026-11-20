.macro load_num_lines($rd)
  li $rd, 8
.end_macro

.macro load_num_columns($rd)
  li $rd, 8
.end_macro

.macro display_pointer($rd, $rx, $ry)
  sll $rd, $ry, 3
  add $rd, $rd, $rx
  sll $rd, $rd, 2
  add $rd, $gp, $rd
.end_macro

.macro load_blue_player($rd)
  li $rd, 0x000000ff
.end_macro

.macro load_red_player($rd)
  li $rd, 0x00ff0000
.end_macro

.macro print_str($label)
  la $a0, $label
  li $v0, 4
  syscall
.end_macro

.macro print_register($rs)
  move $a0, $rs
  li $v0, 1
  syscall
.end_macro

.macro print_register_char($rs)
  move $a0, $rs
  li $v0, 11
  syscall
.end_macro

.macro read_integer($rd)
  li $v0, 5
  syscall
  move $rd, $v0
.end_macro

.macro exit_0
  li $v0, 10
  syscall
.end_macro

