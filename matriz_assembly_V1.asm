

.data

# Alinhando a memoria para words de 4 bytes


   # Array com os 168 elementos (words) para contagem de valores
   #MATRIZ I .word 7x24 (7 linhas e 24 colunas) i =7 e j=24 168 numeros
   I: .word 0, 0,  0,  0,  0,  0,  0,  0,  0, 0,  0,  0,  0,  0,  0,  0,  0, 0, 0,  0,  0,  0,  0,  0
      .word 0, 3,  3,  3,  3,  0,  0,  7,  7, 7,  7,  0,  0, 11, 11, 11, 11, 0, 0, 15, 15, 15, 15,  0
      .word 0, 3,  0,  0,  0,  0,  0,  7,  0, 0,  0,  0,  0, 11,  0,  0,  0, 0, 0, 15,  0,  0, 15,  0
      .word 0, 3,  3,  3,  0,  0,  0,  7,  7, 7,  0,  0,  0, 11, 11, 11,  0, 0, 0, 15, 15, 15, 15,  0
      .word 0, 3,  0,  0,  0,  0,  0,  7,  0, 0,  0,  0,  0, 11,  0,  0,  0, 0, 0, 15,  0,  0,  0,  0
      .word 0, 3,  0,  0,  0,  0,  0,  7,  7, 7,  7,  0,  0, 11, 11, 11, 11, 0, 0, 15,  0,  0,  0,  0
      .word 0, 0,  0,  0,  0,  0,  0,  0,  0, 0,  0,  0,  0,  0,  0,  0,  0, 0, 0,  0,  0,  0,  0,  0
      

    	.align 2


#MENSAGENS
	msg1:   .asciiz "\nM[linha]: "
	msg2: 	.asciiz " [coluna]: "
	msg3: 	.asciiz " valor: "
	

# Definindo segmento de texto (instruções)
.text

    main:
       	

         	     	
    Percorre_matriz: # atribuição de variaveis para percorrer a matriz contando o valor do ton
       	
	li       $t0, 7       # $t0: número de linhas
        li       $t1, 24      # $t1: número de colunas
        move     $s0, $zero   # $s0: contador da linha
        move     $s1, $zero   # $s1: contador da coluna
        move     $t2, $zero   # $t2: recebe o valor a ser lido da matriz I
        
    Leitura_matriz:  #loop  que percorre a matriz verificando os valores 
        # calcula o endereço correto do array
        mult     $s0, $t1    	# $s2 = linha * numero de colunas 
        mflo     $s2         	# move o resultado da multiplicação do registrador lo para $s2
        add      $s2, $s2, $s1  # $s2 += contador de coluna
        sll      $s2, $s2, 2    # $s2 *= 4 (deslocamento 2 bits para a esquerda) para deslocamento de byte    
    
        # obtem o valor do elemento armazenado
        lw    $t2, I($s2) 
        
        li $v0,4
	la $a0,msg1 		#mensagem  - Linha
	syscall
	
	li $v0,1
	la $a0,($s0)		# numero da linha
	syscall
        
	li $v0,4
	la $a0,msg2 		#mensagem  - coluna
	syscall
	
	li $v0,1
	la $a0,($s1)		# numero da coluna
	syscall
	
	li $v0,4
	la $a0,msg3 		#mensagem  - valor
	syscall
	
	li $v0,1
	la $a0,($t2)		# valor
	syscall
	
	# incrementa os contadores da matriz

        addi     $s1, $s1, 1            	# INCREMENTA O CONTADOR DA COLUNA
        bne      $s1, $t1, Leitura_matriz       # not at end of row so loop back
        move     $s1, $zero             	# reseta o contador da coluna
        addi     $s0, $s0, 1           		# incrementa o contador de linha
        bne      $s0, $t0, Leitura_matriz      	# not at end of matrix so loop back
        j exit1
exit1:
     

		
#encerrando o programa

li $v0, 10
syscall

