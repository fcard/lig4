# Lig4: Projeto de Arquitetura de Computadores

Jogo baseado em Connect4 desenvolvido em assembly de um processador baseado na arquitetura MIPS.

# Relatório

## Comportamento geral

O programa reserva o registrador `$gp`, que contém o local aonde está localizada a memória que afeta o display bitmap.
O programa atribui a este registrador o valor `0x10010000` e assume que este valor é mantido até o fim da execução do programa.
Isso se faz apenas por conveniencia e para teste.

A matriz do tabuleiro ocupa as 64 posições iniciais da memória global, o resto da memória é reservada para strings usadas para interagir com o(s) jogadore(s).

O programa, quando executado no MARS, assume que a ferramenta de Display Bitmap está aberta e conectada ao MARS.

O Stack não é utilizado em nenhum momento, logo não é inicializado.

As seguintes instruções foram adicionadas:

|-------|--------|-------|
| Nome  | Opcode | Funct |
|-------|--------|-------|
| addu  | 0x00   | 0x21  |
| slt   | 0x00   | 0x2A  |
| bne   | 0x05   | N/A   |
| blez  | 0x06   | N/A   |
| bgtz  | 0x07   | N/A   |
| addiu | 0x09   | N/A   |
| andi  | 0x0c   | N/A   |
| ori   | 0x0d   | N/A   |
| lui   | 0x0f   | N/A   |
|-------|--------|-------|

`blez` e `bgtz` não foram utilizadas na versão final do programa.
As instruções ditas sem overflow `addu` e `addiu` foram implementadas apenas como cópias das instruções com overflow,
já que não há necessidade para fazer essa distinção neste programa.


## Macros

### `load_num_lines` / `load_num_columns`

Esses macros atribuem a um registrador de entrada as dimensões da matriz.
Estes macros existem apenas para diminuir o número de "valores mágicos" no programa.

### `display_pointer`

Este macro atribui a um registrador de entrada o endereço de uma posição na matriz, por exemplo, se `$t0 = 1` e `$t1 = 2`, então

```
  display_pointer($t2, $t0, $t1)
```

Atribui em `$t2` o endereço `&matrix[2][1]`, tomando em consideração que a posição horizontal vem primeiro antes da posição vertical.


### load_blue_player

Atribui a um registrador o valor RGB da cor azul.

### load_red_player

Atribui a um registrador o valor RGB da cor vermelha.

### print_str

Recebe um endereço de uma string e a imprime para o usuário.

### print_register

Recebe um registrador e imprime seu valor númerico inteiro para o usuário.

### print_register_char

Recebe um registrador e imprime seu valor como caractere.

### read_integer

Lê um valor inteiro apartir de um input do usuário e o atribui a um registrador.

### exit_0

Termina a execução do programa com o valor 0.

## `main`

A função `main` assume que não será chamada por nenhuma função e logo não faz uso do Stack nas suas chamadas de outras funções.
Toda função chamada pela `main` retorna diretamente para esta sem chamar nenhuma outra função.

A função `main` é onde a lógica do programa está concentrada, a interação com o usuário, o tratamento de inputs, chamada de funções auxiliares para checar o estado do jogo, mudança de jogadores, e o termino do programa.

## `clear`

A função `clear` zera todos os valores da matriz, usada primariamente para testes, para evitar a necessidade de reiniciar a simulação sempre que o estado do tabuleiro necessita estar em seu modo inicial.

## `place`

Coloca uma peça no tabuleiro em uma certa coluna, se possível. Começa da linha mais baixa, e procura o primeiro espaço vázio. Se não houver um único espaço vázio, retorna 0, mas se a operação for realizada com successo, retorna 1.

## `check_victory`

Verifica se o dado jogador venceu o jogo. Isso ocorre quando 4 blocos de sua cor estão posicionados adjacentes, horizontalmente, verticalmente ou diagonalmente. Se sim, retorna 1, se não, retorna 0.

## `check_full`

Verifica se o tabuleiro está cheio, ou seja, houve um empate. Se sim, retorna 1, se não, retorna 0.
