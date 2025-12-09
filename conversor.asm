; Programa: Converte decimal para binário (32 bits)
; Estrutura baseada no exemplo de ordenação fornecido
; Lógica: Loop de 31 até 0, shift right e AND com 1.

segment .data
a: dq 0              ; Variável para guardar o numero digitado (n)
cnt: dq 31           ; Contador do loop (começa em 31 igual no C)
temp: dq 0           ; Variável auxiliar para calculos
fmt_in: dq "%lld", 0 ; Ler numero (long long int)
msg_input: dq "Fala tu, manda um numero decimal ai: ", 0
msg_res: dq "O binario desse numero eh: ", 0
str_0: dq "0", 0     ; String para imprimir 0
str_1: dq "1", 0     ; String para imprimir 1
newline: dq 10, 0    ; Pular linha (\n)

segment .bss
; O codigo original tinha arrays aqui, deixei vazio ou voce pode tirar
; pois nao precisamos de vetor pra essa logica especifica, mas mantive a section.

segment .text
global main
extern printf
extern scanf

main:
    push RBP

    ; --- Parte 1: Printf "Fala tu..." ---
    mov RAX, 0
    mov RDI, msg_input
    call printf

    ; --- Parte 2: Scanf (Ler o numero 'n') ---
    mov RAX, 0
    mov RDI, fmt_in
    mov RSI, a      ; Salva o input na variavel 'a' (que seria o 'n' do C)
    call scanf

    ; --- Parte 3: Printf "O binario eh..." ---
    mov RAX, 0
    mov RDI, msg_res
    call printf

    ; Inicializa o loop. No C é: for (int i = 31; i >= 0; i--)
    mov qword [cnt], 31 

BIT_LOOP:
    ; Verifica se o contador (i) é menor que 0. Se for, acabou.
    cmp qword [cnt], 0
    jl END_LOOP

    ; --- Logica do C: int k = n >> i; ---
    mov RAX, [a]        ; Carrega 'n' em RAX
    mov RCX, [cnt]      ; Carrega 'i' em RCX
    
    ; O shift right (>>) usa o registrador CL (parte baixa de RCX)
    shr RAX, cl         ; RAX = RAX >> CL (n >> i)
    
    ; --- Logica do C: if (k & 1) ---
    and RAX, 1          ; Faz o AND bit a bit com 1
    cmp RAX, 1          ; Compara se o resultado é 1
    je PRINT_1          ; Se for igual, pula pro print 1
    
    ; Se não pulou, é zero:
    jmp PRINT_0

PRINT_1:
    mov RAX, 0
    mov RDI, str_1
    call printf
    jmp LOOP_DEC        ; Pula pro final do loop pra decrementar

PRINT_0:
    mov RAX, 0
    mov RDI, str_0
    call printf
    jmp LOOP_DEC        ; Pula pro final do loop pra decrementar

LOOP_DEC:
    ; --- Logica do C: i-- ---
    dec qword [cnt]     ; Decrementa o contador na memória
    jmp BIT_LOOP        ; Volta pro inicio do loop

END_LOOP:
    ; --- Printf final ("\n") ---
    mov RAX, 0
    mov RDI, newline
    call printf

    mov RAX, 0
    pop RBP
    ret