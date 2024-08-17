# Nome completo
#WERBERT ARLES DE SOUZA BARRADAS
# MatrÃ­cula
#20240002606
# Definindo segmento de dados

.data

# Alinhando a memÃ³ria para words de 4 bytes


   # Array com os 168 elementos (words) para contagem de valores
   #MATRIZ I .word 7x24 (7 linhas e 24 colunas) i =7 e j=24 168 numeros
   I: .word 0, 0,  0,  0,  0,  0,  0,  0,  0, 0,  0,  0,  0,  0,  0,  0,  0, 0, 0,  0,  0,  0,  0,  0
      .word 0, 3,  3,  3,  3,  0,  0,  7,  7, 7,  7,  0,  0, 11, 11, 11, 11, 0, 0, 15, 15, 15, 15,  0
      .word 0, 3,  0,  0,  0,  0,  0,  7,  0, 0,  0,  0,  0, 11,  0,  0,  0, 0, 0, 15,  0,  0, 15,  0
      .word 0, 3,  3,  3,  0,  0,  0,  7,  7, 7,  0,  0,  0, 11, 11, 11,  0, 0, 0, 15, 15, 15, 15,  0
      .word 0, 3,  0,  0,  0,  0,  0,  7,  0, 0,  0,  0,  0, 11,  0,  0,  0, 0, 0, 15,  0,  0,  0,  0
      .word 0, 3,  0,  0,  0,  0,  0,  7,  7, 7,  7,  0,  0, 11, 11, 11, 11, 0, 0, 15,  0,  0,  0,  0
      .word 0, 0,  0,  0,  0,  0,  0,  0,  0, 0,  0,  0,  0,  0,  0,  0,  0, 0, 0,  0,  0,  0,  0,  0
      
     

    # Alocacao de espaco para o vetor de contagem (H)
    # São 64 bytes para armazenar (4 bytes * 16 posicoes)
    H: 	.space 64
    	.align 2


#MENSAGENS
	msg1: 	.asciiz "\nNivel de cinza: Contagem \n"
	msg2:   .asciiz ":  "
	msg3:   .asciiz " \n"
	#msg4:0:
	

# Definindo segmento de texto (instruções)
.text

    main:
       	# Tomando endereco base do vetor H!
       	la $s3, H

	# Usando $t5 como indice do vetor H multiplo de 4!
	# Garantindo que inicie com valor zero
	move $t5, $zero
	# Usando $t6 como contador de indice do vetor e de cores de tom de cinza
	# Garantindo que inicie com valor zero
	move $t6, $zero
		
	# Numero de maximo de iterações do loop que percorre H
	li $t7,64
	# contador das repetiçoes dos tons de cinza na matriz de led
	move $t8,$zero


 percorre_H:     	
        
    beq $t5,$t7,exit2 #condiçõão de saida do loop que armazena em H  
         	     	
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
        bne   $t2, $t6,exit 	#verifica se o valor armazenado na matriz é não é igual a um dos diferentes valores de n?vel de cinza entre 0 - 16.
	add   $t8,$t8,1 	#contador da quantas vezes se repete o valor do ton de cinza é incrementado quando valores são iguais	
	exit:
	
	# incrementa os contadores da matriz

        addi     $s1, $s1, 1            	# INCREMENTA O CONTADOR DA COLUNA
        bne      $s1, $t1, Leitura_matriz       # not at end of row so loop back
        move     $s1, $zero             	# reseta o contador da coluna
        addi     $s0, $s0, 1           		# incrementa o contador de linha
        bne      $s0, $t0, Leitura_matriz      	# not at end of matrix so loop back
        j exit1
     exit1:
     
     #após percorrer a matriz completa incrementa o vetor H
     
		
     sw   $t8,H($t5)			#armazena o numero de repetições do ton de cinza no vetor H
     move $t8,$zero 			#zera o contaor de repetições
     addi $t5, $t5,4			#desloca a posição do indice do vetor H
     addi $t6, $t6,1			#incrementa o ton de cinza
     j percorre_H 

exit2:

move $t5,$zero
move $t6,$zero


#imprimindo H
		li $v0,4
		la $a0,msg1 		#mensagem inicial - Nivel de cinza: Contagem
		syscall
imprime1:
		beq $t5,$t7, exit3	# Condição de saida do loop de impressão
		
		li $v0,1
		la $a0,($t6)		# Impressão do ton de cinza
		syscall
		
		li $v0,4
		la $a0,msg2		# Impressão do separador - ":"
		syscall
		
		
		li $v0,1
		lw $a0,H($t5)		# Impressão do numero de repetições
		syscall
		
		li $v0,4
		la $a0,msg3		#Inlusão do espaço de separação e quebra de linha
		syscall
		
		
		addi $t5,$t5,4		#incremento do indice do vetor H
		addi $t6,$t6,1		#incremento do valor do ton de cinza
		j imprime1
exit3:
		
#encerrando o programa

li $v0, 10
syscall

