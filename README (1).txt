====================TEMA 2 IOCLA========================

TASK 1

In cadrul task-ului 1 vom avea string-ul si cheia in ecx. Vom cauta byte cu byte in valoarea de la adresa lui ecx primul terminator de sir.Punem octet cu octet in dl,daca este termiator iesim din loop,altfel trecem la urmatorul octet. Stocam adresa de inceput a cheii (ecx + eax) in ebx. Vom avea introduse pe stiva adresa de inceput a string ului si adresa de inceput a cheii. Apelam xor_strings.

XOR_STRINGS : Preluam parametrii functiei de pe stiva , dupa care punem in al si in bl cate un byte din string si respectiv cheie.Facem xor si punem rezultatul la adresa corecta din ecx la offset ul edx. Repetam pentru fiecare byte pan intalnim terminatorul de sir.

Apelam functia puts.

TASK 2

Introducem adresa de inceput a string-ului pe stiva si apelam rolling_xor

ROLLING_XOR : Preluam parametrul de pe stiva,iar apoi vom parcurge sirul cu un contor de la 1(primul caracter ramane neschimbat).Vom salva mereu rezultatul xor-ului in al astfel ca mereu vom avea rezutatul operatiilor de xor facute anterior.
Punem al-ul la pozitia coresunzatoare din ecx si iesim cand intalnim 0x00.

Apelam puts pentru afisare

TASK 3

Vom gasi adresa de inceput a cheii si o vom introduce pe stiva alaturi de string exact ca la task-ul 1 si apelam xor_hex_strings

XOR_HEX_STRINGS : Preluam parametrii de pe stiva ,iar apoi vom apela functia conv_hex_char pentru string si pentru cheie.Aceasta le va transforma in format hexa.Vom apela xor_strings de la task-ul 1 si iesim din functie.

CONV_HEX_CHAR : Vom prelua de pe stiva string-ul pe care dorim sa il convertim.Vom parcurge cu cate 2 octeti pe care ii stocam in al si bl. Cele 2 vor forma un byte in hexa.Vom verfica daca cele 2 valori reprezinta cifre si daca da scadem '0' ceea ce le va da exact valoarea indicata. Daca reprezinta litere scadem 'a' si adunam 10. Obtinem astfel 2 octeti cu valoarea in hexazecimal indicata de valoarea initiala din string.Il vom shifta la stanga pe primul cu 4 pozitii si il adunam pe al doilea.Am obtinut octetul in hexa format din cele 2 anterioare.In ebx vom avea offset-ul fata de ecx unde trebuie sa inseram.Dimensiunea va fi de 2 ori mai mica.Plasam octetul format la adresa corespunzatoare,actualizam fiecare counter si repetam procesul pentru tot string-ul. Punem terminatorul dupa ce am converiti to sirul  si iesim.

TASK 5

Vom testa toate valorile pentru o cheie de un byte pentru fiecare byte din sir.Stim ca avem cuvantul "force" deci vom verifica pentru fiecare byte si pentru fiecare posibila cheie faca gasim un 'f'. Facem xor intre cheie si byte. Daca gasim un 'f', repetam procedeul pentru urmatorii octeti pana gasim "force".Daca am gasit force inseamna ca posibila cheie este cea adevarata. Daca nu il gasim incercam cheia umatoare (incrementam al).Daca am incercat toate valorile posibil pentru cheie,vom trece la byte-ul urmator.Dupa ce am gasit cheia, o punem pe stiva alaturi de string si apelam bruteforce_singlebyte_xor. In aceasta functie vom face xor pe fiecare byte din string cu cheia.Rezultatul il plasam tot la aceeasi adresa.

TASK 6

Vom gasi adresa de inceput a cheii ca la task-ul 1 apoi o introducem pe stiva alaturi de string-ul cerut.Vom apela decode_vigenere

DECODE_VIGENERE : Preluam argumentele de pe stiva.Vom avea in al si ah cate un byte din string/cheie. Ne vom opri daca in al vom avea 0x00. Edx si esi vor fi countere cu care vom obtine octetii din sir / cheie . Daca octetul nu este litera, vom trece la umatorul octet. Daca vom ajunge cu ah la sfarsitul cheii (pentru ca aceasta este mai mica decat string),vom face esi-ul 0 adica parcutgem cheia de la inceput. Obtinem offset-ul fata de 'a' al octetului din cheie si il scadem din octetul din string pentru a il decodifica. Daca ne rezulta un caracter din afara alfabetului (mai mic decat a) adunam 26 (dimensiunea alfabetului) pentru a obtine valoarea corecta.Mutam valoarea obtinuta la pozitia corespunzatoare din ecx si incrementam cunterele esi (pentru cheie) si edx (pentru string).Repetam procsul pana cand decodificam to string-ul si iesim din functie.

Afisam rezultatul folosind functia puts.
