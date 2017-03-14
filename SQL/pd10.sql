/*zad. 2.*/
DROP TYPE KlienciType;
DROP TYPE ZamowieniaType;
DROP TYPE ProduktyType;

CREATE TYPE KlienciType
AS OBJECT(
Id_klienta NUMBER,
Imie VARCHAR2(100),
Nazwisko VARCHAR2(100)

);
/

CREATE TYPE ProduktyType
AS OBJECT(
Id_towaru NUMBER,
Nazwa VARCHAR2(50),
Ilosc_w_mag NUMBER,
Cena_jedn NUMBER
);
/


DROP TABLE Klienci1;
CREATE TABLE Klienci1 OF KlienciType;
DROP TABLE Produkty1;
CREATE TABLE Produkty1 OF ProduktyType;
DROP TABLE Zamowienia1;



CREATE TABLE Zamowienia1(
Id_zamowienia NUMBER PRIMARY KEY,
Id_klienta REF KlienciType SCOPE IS Klienci1,
Id_towaru REF ProduktyType SCOPE IS Produkty1,
Ilosc_zamowionych NUMBER,
Cena_sum NUMBER
);


/*zad. 3*/
INSERT INTO Klienci1 VALUES (1, 'Jan', 'Kowalski');
INSERT INTO Klienci1 VALUES(KlienciType(2, 'Jan', 'Dugosz'));
COMMIT;


INSERT INTO Produkty1 VALUES(ProduktyType(1, 'komputer', 10, 5000));
INSERT INTO Produkty1 VALUES(ProduktyType(2, 'suszarka', 20, 200));
INSERT INTO Produkty1 VALUES(ProduktyType(3, 'pralka', 10, 1000));
INSERT INTO Produkty1 VALUES(ProduktyType(4, 'œmigowiec', 25, 100000));
INSERT INTO Produkty1 VALUES(ProduktyType(5, 'radio', 30, 60));
COMMIT;

INSERT INTO Zamowienia1 VALUES(1, 
                              (SELECT ref(k) FROM Klienci1 k WHERE Id_klienta = 1), 
                              (SELECT ref(d) FROM Produkty1 d WHERE Id_towaru = 2), 3, 600);
INSERT INTO Zamowienia1 VALUES(2,
                              (SELECT ref(k) FROM Klienci1 k WHERE Id_klienta = 2), 
                              (SELECT ref(d) FROM Produkty1 d WHERE Id_towaru = 2), 3, 600);
INSERT INTO Zamowienia1 VALUES(3, 
                              (SELECT ref(k) FROM Klienci1 k WHERE Id_klienta = 1), 
                              (SELECT ref(d) FROM Produkty1 d WHERE Id_towaru = 1), 1, 5000);
INSERT INTO Zamowienia1 VALUES(4, 
                               (SELECT ref(k) FROM Klienci1 k WHERE Id_klienta = 2), 
                               (SELECT ref(d) FROM Produkty1 d WHERE Id_towaru = 5), 2, 120);
COMMIT;

/*zad. 4.*/
SELECT * FROM Zamowienia1;

SELECT * FROM Zamowienia1 WHERE Id_towaru = (SELECT ref(d) FROM Produkty1 d WHERE Id_towaru = 5);
