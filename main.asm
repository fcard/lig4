.include "macros.inc"

.text
main:
  la $gp, matrix
  jal clear

  li $s0, 0
  li $s1, 0
  li $s2, 'A'
  li $s3, 0
  load_blue_player($s4)
  load_num_columns($s5)
  
  print_str(str.welcome)
  
main.game_loop:
  bne $s3, $zero, main.end
  jal check_full
  beq $v0, $zero, main.end
  
main.game_loop.continue:
  andi $t0, $s0, 1
  beq $t0, $zero, main.game_loop.even_turn
main.game_loop.odd_turn:
  li $s2, 'V'
  load_red_player($s4)
  j main.game_loop.after_turn_check
main.game_loop.even_turn:
  li $s2, 'A'
  load_blue_player($s4)

main.game_loop.after_turn_check: 
  print_str(str.player_turn.a)
  print_register_char($s2)
  print_str(str.player_turn.b)

  read_integer($s1)
  
  slt $t0, $s1, $zero
  bne $t0, $zero, main.game_loop.invalid_column
  bge $s1, $s5, main.game_loop.invalid_column
  
  move $a0, $s1
  move $a1, $s4
  jal place
  beq $v0, $zero, main.game_loop.invalid_placement
  
  move $a0, $s4
  jal check_victory
  move $s3, $v0
  bne $s3, $zero, main.game_loop
  addi $s0, $s0, 1
  j main.game_loop
  
main.game_loop.invalid_placement:
  print_str(str.full_column.a)
  print_register($s1)
  print_str(str.full_column.b)
  j main.game_loop.continue
  
main.game_loop.invalid_column:
  print_str(str.invalid_column)
  j main.game_loop.continue
  
main.end:
  beq $s3, $zero, main.tie
  print_str(str.victory.a)
  print_register_char($s2)
  print_str(str.victory.b)
  exit_0
  
main.tie:
  print_str(str.tie)
  exit_0

 
.include "tabuleiro.asm"
  
  
.data
matrix: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
str.welcome:        .asciiz "=== BEM-VINDO AO LIG 4 (8x8) ===\nJogador 1: 'A' | Jogador 2: 'V'\n"
str.player_turn.a:  .asciiz "Vez do jogador '"
str.player_turn.b:  .asciiz "'. Escolha uma coluna (0-7): "
str.invalid_input:  .asciiz "Entrada invalida! Saindo do jogo.\n"
str.invalid_column: .asciiz "\n=> Coluna invalida! Escolha um numero entre 0 e 7.\n"
str.full_column.a:  .asciiz "\n=> A coluna "
str.full_column.b:  .asciiz " esta cheia! Escolha outra.\n"
str.victory.a:      .asciiz "\n*** PARABENS! O JOGADOR '"
str.victory.b:      .asciiz "' VENCEU! ***\n\n"
str.tie:            .asciiz "\n*** EMPATE! O TABULEIRO ESTA CHEIO! ***\n\n"

  
