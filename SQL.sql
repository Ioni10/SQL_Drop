CREATE TABLE Clienti(
  id_client INTEGER PRIMARY KEY AUTOINCREMENT,
  nume TEXT NOT NULL,
  oras TEXT,
  varsta INTEGER
  
);

CREATE TABLE Produs(
  id_produs INTEGER PRIMARY KEY AUTOINCREMENT,
  nume TEXT NOT NULL,
  pret REAL,
  stoc INTEGER
  );
  
CREATE TABLE Comenzi(
  id_comanda INTEGER PRIMARY KEY AUTOINCREMENT,
  id_client INTEGER NOT NULL,
  data_comanda DATE,
  FOREIGN KEY (id_client) REFERENCES Clienti(id_client)
  );
  
 CREATE TABLE DetaliiComanda(
   id_detaliu INTEGER PRIMARY KEY AUTOINCREMENT,
   id_comanda INTEGER,
   id_produs INTEGER,
   cantitate INTEGER NOT NULL,
   FOREIGN KEY (id_comanda) REFERENCES Comenzi(id_comanda),
   FOREIGN KEY (id_produs) REFERENCES Produse(id_produs)
   );
   
 INSERT INTO Clienti(nume, oras, varsta) VALUES
 ('Ion Popescu', 'Bucuresti', 45),
 ('Ana Ionescu', 'Cluj', 30),
 ('Maria Georgescu', 'Bucuresti', 28),
 ('Vasile Dobre', 'Iasi', 50),
 ('Elena Matei', 'Timisoara', 35);
 
 INSERT INTO Produs(nume, pret, stoc) VALUES
 ('Laptop', 2500, 10),
 ('Telefon', 1200, 20),
 ('Mouse', 50, 100),
 ('Tastatura', 150, 50),
 ('Monitor', 800, 30),
 ('Casti', 200, 40),
 ('HDD Extern', 400, 25);
 
 INSERT INTO Comenzi (id_client, data_comanda) VALUES
 (1, '2025-09-20'),
 (1, '2025-10-01'),
 (2, '2025-09-25'),
 (3, '2025-10-10'),
 (4, '2025-09-30');
 
 INSERT INTO DetaliiComanda (id_comanda, id_produs, cantitate) VALUES
 (1, 1, 1),
 (1, 3, 2),
 (2, 2, 1),
 (2, 4, 1),
 (3, 5, 2),
 (4, 3, 1),  
 (4, 6, 2),  
 (4, 6, 1);
 
 -- 1.Afisare toti clientii din orasul "Bucuresti"
SELECT * FROM Clienti WHERE oras = 'Bucuresti';
 
 --2.Selectam toate produsele cu pretul mai mare de 100 
SELECT * FROM Produs WHERE pret > 100;
 
 --3.Listam comenzile ordonate descrescator dupa data
SELECT * FROM Comenzi ORDER BY data_comanda DESC
 
 --4.Afisam primii 5 clienti dupa varsta.
SELECT * FROM Clienti ORDER BY varsta DESC LIMIT 5;
 
 --5.Afisam cati clienti sunt in fiecare oras. 
SELECT oras, COUNT(*) AS Clienti_Oras FROM Clienti GROUP BY oras;
 
 --6.Calculam pretul mediu al produselor. 
SELECT AVG(pret)AS Pretul_Mediu FROM Produs;
 
 --7.Afisam suma totala a stocului disponibil (cantitate x pret).
SELECT SUM(pret*stoc) AS total_valoare_stoc FROM Produs;
 
 --8.Pentru fiecare client, aratam cate comenzi a facut. 
SELECT id_client, COUNT(*) AS Comenzi_Efectuate FROM Comenzi GROUP BY id_client;
 
 --9.Afisam toate comenzile cu numele clientului si data. 
SELECT c.id_comanda, cl.nume, c.data_comanda
FROM Comenzi c
JOIN Clienti cl
 ON c.id_client = cl.id_client;
 
 --10.Afisam toate produsele comandate de clientul "Ion Popescu"
SELECT p.nume AS Produse
FROM Produs p
JOIN DetaliiComanda d
 ON p.id_produs = d.id_produs
JOIN Comenzi c
 ON c.id_comanda = d.id_comanda
JOIN Clienti cl
 ON cl.id_client = c.id_client
WHERE cl.nume = 'Ion Popescu';
 
 --11.Afisam valoarea totala a fiecarei comenzi.
SELECT d.id_comanda, SUM(p.pret* d.cantitate) AS total
FROM DetaliiComanda d
JOIN Produs p ON d.id_produs = p.id_produs
GROUP BY d.id_comanda;
 
 --12.Afisam produsele care nu au fost comandate niciodata. 
SELECT * FROM Produs
WHERE id_produs NOT IN (SELECT id_produs FROM DetaliiComanda);

--13.Clientul cu cea mai mare varsta. 
SELECT * FROM Clienti
WHERE varsta = (SELECT MAX(varsta)FROM Clienti)

--14.Afisam produsele cu pret mai mare decat media tuturor produselor.
SELECT pret FROM Produs
WHERE pret > (SELECT AVG(pret) FROM Produs);

--15.Afisam clientii care au facut cel putin o comanda in ultimele 30 de zile.
SELECT DISTINCT cl.*
FROM Clienti cl
JOIN Comenzi c ON cl.id_client = c.id_client
WHERE c.data_comanda >= date('now','-30 days');

--16.Cream o vizualizare care arata valoarea totala a fiecarei comenzi. 
CREATE VIEW V_TotalComenzi AS
SELECT d.id_comanda, SUM(p.pret * d.cantitate) AS total
FROM DetaliiComanda d
JOIN Produs p ON d.id_produs = p.id_produs
GROUP BY d.id_comanda;

SELECT * FROM V_TotalComenzi;

--17.Creeam un index pe coloana 'nume' din tabela Produse.
CREATE INDEX idx_produs_nume ON Produs(nume);
PRAGMA index_list(Produs);

--18.Scriem un Trigger care scade automat stocul unui produs dupa inserarea unei comenzi.
CREATE TRIGGER trg_update_stoc
AFTER INSERT ON DetaliiComanda
FOR EACH ROW
BEGIN 
	UPDATE Produs
	SET stoc = stoc - NEW.cantitate
	WHERE id_produs = NEW.id_produs;
END;

INSERT INTO DetaliiComanda (id_comanda, id_produs, cantitate)
VALUES (1, 1, 2); -- scade stocul produsului 1 cu 2

SELECT * FROM Produs WHERE id_produs = 1;

--19. Scrie o procedură stocată care, dat un id_client, returnează totalul cheltuit.

CREATE PROCEDURE TotalCheltuit(IN client_id INT)
BEGIN
SELECT SUM(p.pret * d.cantitate) AS total
FROM Comenzi c
JOIN DetaliiComanda d ON c.id_comanda = d.id_comanda
JOIN Produse p ON p.id_produs = d.id_produs
WHERE c.id_client = client_id;
END;
