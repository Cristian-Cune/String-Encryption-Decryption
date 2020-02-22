;%include "io.inc"
extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main

xor_strings:
	; TODO TASK 1
        push ebp
        mov ebp,esp
        mov ecx,[ebp+12];string
        mov ebx,[ebp+8];key
        mov eax,0
        mov edx,0;counter pentru cheie si string
xor_byte:       
        mov al ,byte[ecx +edx]
        push ebx
        
        mov bl,byte[ebx+edx]
        
        ;facem xor intre octetii din cheie si string
        xor eax,ebx
        pop ebx
        mov byte[ecx+edx],al;mutam inaoi in string
        inc edx
        
        cmp byte[ecx+edx],0x00
        jne xor_byte
        leave 
	ret

rolling_xor:
	; TODO TASK 2
        push ebp
        mov ebp, esp 
        mov ecx,[ebp+8] ;string
        mov edx,1 ;counter pentru string
        mov eax,0
        mov ebx,0
        
        mov bl,byte[ecx]
        ;mutam byte cu byte
roll_xor_byte:
       mov al,bl;stocam rezultatul xor-ului in al
        mov bl,byte[ecx + edx]
        xor al,bl
        mov byte[ecx + edx ],al;punem rezultatul inapoi in string
        inc edx
        cmp byte[ecx + edx],0x00
        jne roll_xor_byte
        
        
        leave
        ret

xor_hex_strings:

	push ebp
        mov ebp,esp
        
        mov ecx,[ebp+12];string
        mov ebx,[ebp+8];key
        
        ;convertim string-ul la hexa
        push ecx
        call conv_hex_char
        add esp,4
        
        push ecx
        
        ;convertim cheia la hexa
        mov ebx,[ebp+8]
        push ebx
        call conv_hex_char
        add esp,4
        
        mov ebx,ecx
        pop ecx
        ;facem xor intre string si cheie
        push ecx
        push ebx
        call xor_strings
        add esp,8
        
        leave
	ret

base32decode:
	; TODO TASK 4
	ret

bruteforce_singlebyte_xor:
	
        push ebp
        mov ebp,esp
        
        mov ecx,[ebp+8];string
        mov eax,[ebp+12];key
        
        mov edx,0
 brute_xor:
        ;facem xor intre cheia pe care o avem in eax si fiecare byte din string
        mov bl,byte[ecx+edx]
        
        cmp bl,0x00
        je end_brute
        
        xor bl,al
        mov byte[ecx+edx],bl
        inc edx
        jmp brute_xor
        
end_brute:
        leave
	ret

decode_vigenere:
	push ebp
        mov ebp,esp
        
        mov ecx,[ebp+8];string
        mov ebx,[ebp+12];key
        
        mov edx,0;contor pentru string
        mov esi,0;contor pentru key
        mov eax,0;stocam in eax
        
 rep_vigenere:       
        mov al,byte[ecx+edx];luam fiecare byte din string
        cmp al,0x00;
        je end_string
        cmp al,'a';verificam daca e litera
        jl non_alph
        cmp al,'z'
        jg non_alph
        ;vom avea in ah valorile octetilor din cheie
        mov ah,byte[ebx+esi]
        cmp ah,0x00
        jne not_key_end
        mov esi,0
        mov ah,byte[ebx+esi]

 not_key_end:       
        sub ah,'a';facem decodificarea necesara pentru ficare byte
        
        sub al,ah
        cmp al,'a'
        jge okay;cazul in care vom iesi in afara "alfabetului"
        add al,26
        
okay:
        mov byte[ecx+edx],al;punem valoarea in string
        
        inc esi;incrementam fiecare counter
non_alph:        
        inc edx
        
        jmp rep_vigenere
end_string:        
        
        leave
	ret
conv_hex_char:
        push ebp
        mov ebp,esp
        mov ecx,[ebp+8];string
        mov eax,0
        mov edx,0
        mov ebx,0;in ebx vom avea adresa unde se va introduce elementul format
rep_convert:
        push ebx
        mov al, byte[ecx + edx];stocam in al fiecare byte din string-ul de convertit
        
        
        cmp al,0
        je end
        ;vom lua 2 cate 2 biti (in bl punem urmatorul bit)
        mov bl, byte[ecx + edx +1]
        cmp bl,0
        je end
        
        cmp al,'0';verificam daca e cifra
        jl not_digit_a
        cmp al,'9'
        jg not_digit_a
        sub al,'0';convertim la numar
       
 digit_b:       
        cmp bl,'0';verificam daca e cifra
        jl not_digit_b
        cmp bl,'9'
        jg not_digit_b
        sub bl,'0';convertim la numar
        jmp move
        
not_digit_a:
        cmp al,'a';verificam daca e litera
        jl end
        cmp al,'z'
        jg end
        sub al,'a'
        add al,10
        jmp digit_b
not_digit_b:
        cmp bl,'a';verificam daca e litera
        jl end
        cmp bl,'z'
        jg end
        sub bl,'a';facem modificarile necesare convertirii
        add bl,10
move:
         shl al,4
         add al,bl
         pop ebx
         mov byte[ecx + ebx],al;mutam la adresa necesara din string si incrementam counter-ele
         inc edx
         inc edx
         inc ebx
         
         jmp rep_convert
end:
        mov byte[ecx + ebx],0x00;punem terminatorul de sir la sfarsit
        leave
        ret
main:
    mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done

task1:
	; TASK 1: Simple XOR between two byte streams
        
        mov eax,0
        mov edx,0
find:
        mov dl, byte[ecx + eax];cautam byte cu byte in string (ecx) pana gasim terminatorul de sir
        inc eax
        cmp dl,0x00
        jne find
        push ecx
        lea ebx,[ecx + eax];punem adresa cheii in ebx
        push ebx
	
        call xor_strings
        add esp, 8 
	push ecx
	call puts                   ;print resulting string
	add esp, 4

	jmp task_done

task2:
	; TASK 2: Rolling XOR
        ;apelam functia 
        push ecx
        call rolling_xor
        add esp, 4
	push ecx
	call puts
	add esp, 4

	jmp task_done

task3:
	; TASK 3: XORing strings represented as hex strings
        ;gasim adresa cheii ca la task-ul 1
        mov eax,0
        mov edx,0
find_hex:
        mov dl, byte[ecx + eax]
        inc eax
        cmp dl,0x00
        jne find_hex
        push ecx
        lea ebx,[ecx + eax]
        push ebx
        ;apelam functia 
        call xor_hex_strings
        add esp, 8

	push ecx                     ;print resulting string
	call puts
	add esp, 4

	jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding
        mov eax,0;posibila cheie
        mov ebx,0
        mov edx,0
 
test_key:       ;vom testa fiecare cheie cu dimensiune de un byte pana gasim "force"
        mov bl,byte[ecx+edx]
        xor bl,al;decodam fiecare byte apoi testam
        
        cmp bl,'f'
        jne not_key
        inc edx
        
        mov bl,byte[ecx+edx]
        xor bl,al
        cmp bl,'o'
        jne not_key
        inc edx
        
        mov bl,byte[ecx+edx]
        xor bl,al
        cmp bl,'r'
        jne not_key
        inc edx
        
        mov bl,byte[ecx+edx]
        xor bl,al
        cmp bl,'c'
        jne not_key
        inc edx
        
        mov bl,byte[ecx+edx]
        xor bl,al
        cmp bl,'e'
        jne not_key
        ;am gasit force deci am gasit cheia
        jmp found
        
not_key:;incercam cheia urmatoare apoi trecem la urmatorul byte
        inc al
        cmp al,0xff
        jne test_key
        inc edx
        mov al,0
        jmp test_key
found:
        push eax
	; TODO TASK 5: call the bruteforce_singlebyte_xor function
        push eax
        push ecx
        call bruteforce_singlebyte_xor
        add esp,8

	push ecx                    ;print resulting string
	call puts
	pop ecx

        pop eax
	push eax                    ;eax = key value
	push fmtstr
	call printf                 ;print key value
	add esp, 8

	jmp task_done

task6:
	; TASK 6: decode Vignere cipher

	; TODO TASK 6: find the addresses for the input string and key
	; TODO TASK 6: call the decode_vigenere function

        mov eax,0
        mov edx,0
find_vig:                               ;gasim adresa cheii ca la task-ul 1
        mov dl, byte[ecx + eax]
        inc eax
        cmp dl,0x00
        jne find_vig
        
        lea ebx,[ecx + eax]
        
        
        push ebx
	push ecx                   ;ecx = address of input string 
	call decode_vigenere
        add esp, 8

	push ecx
	call puts
	add esp, 4

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
