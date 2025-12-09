;guarda os numeros nas variaveis
;dq eh define quadword (64bytes)
segment .data
a:      dq 0    
cnt:    dq 31
temp:   dq 0


;define strings de C, db eh define byte
fmt_in:     db "%lld", 0
msg_input:  db "Fala tu, manda um numero decimal ai: ", 0
msg_res:    db "O binario desse numero eh: ", 0
str_0:      db "0", 0
str_1:      db "1", 0
newline:    db 10, 0

segment .text
global main
extern printf
extern scanf

main:
    push rbp
    mov rbp, rsp

    ;output para pedir numero
    mov rax, 0
    mov rdi, msg_input
    call printf

    ;input do numero
    mov rax, 0
    mov rdi, fmt_in
    mov rsi, a
    call scanf

    ;printa o binario
    mov rax, 0
    mov rdi, msg_res
    call printf

    ;passa indice para o loop
    mov qword [cnt], 31

;i--
BIT_LOOP:
    ;verificao do loop, se i < 0 sai do loop
    cmp qword [cnt], 0
    jl END_LOOP

    ;carrega o numero decimal e contador 
    mov rax, [a]
    mov rcx, [cnt]
    
    shr rax, cl
    and rax, 1
    cmp rax, 1
    je PRINT_1
    jmp PRINT_0

PRINT_1:
    mov rax, 0
    mov rdi, str_1
    call printf
    jmp LOOP_DEC

PRINT_0:
    mov rax, 0
    mov rdi, str_0
    call printf
    jmp LOOP_DEC

LOOP_DEC:
    dec qword [cnt]
    jmp BIT_LOOP

END_LOOP:
    mov rax, 0
    mov rdi, newline
    call printf

    mov rsp, rbp
    pop rbp
    ret
