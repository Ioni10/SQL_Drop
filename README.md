# SQL_Drop
* Schema de bază (--> Magazin <--)
Tabele:
        - Clienti(id_client, nume, oras, varsta)
        - Produse(id_produs, nume, pret, stoc)
        - Comenzi(id_comanda, id_client, data_comanda)
        - DetaliiComanda(id_comanda, id_produs, cantitate)

* Nivel 1 – SELECT, WHERE, ORDER BY
1. Afișează toți clienții din orașul „București”.
2. Selectează toate produsele cu prețul mai mare de 100.
3. Listează comenzile ordonate descrescător după dată.
4. Afișează primii 5 clienți după vârstă.

* Nivel 2 – Agregare (COUNT, SUM, AVG, GROUP BY)
5. Afișează câți clienți sunt în fiecare oraș.
6. Calculează prețul mediu al produselor.
7. Afișează suma totală a stocului disponibil (cantitate × preț).
8. Pentru fiecare client, arată câte comenzi a făcut.

* Nivel 3 – JOIN
9. Afișează toate comenzile cu numele clientului și data.
10. Afișează toate produsele comandate de clientul „Ion Popescu”.
11. Afișează valoarea totală a fiecărei comenzi.
12. Afișează produsele care nu au fost comandate niciodată.

* Nivel 4 – Subinterogări
13. Găsește clientul cu cea mai mare vârstă.
14. Afișează produsele cu preț mai mare decât media tuturor produselor.
15. Afișează clienții care au făcut cel puțin o comandă în ultimele 30 de zile.

* Nivel 5 – Extra (avansat)
16. Creează o vizualizare care arată valoarea totală a fiecărei comenzi.
17. Creează un index pe coloana `nume` din tabela Produse.
18. Scrie un trigger care scade automat stocul unui produs după inserarea unei comenzi.
19. Scrie o procedură stocată care, dat un id_client, returnează totalul cheltuit.
