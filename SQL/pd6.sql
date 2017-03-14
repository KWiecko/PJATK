/*Zad. 1*/
DROP TABLE Towary_w_magazynie;
DROP TABLE Partia_towarow;

CREATE TABLE Towary_w_magazynie(
    Nazwa_towaru VARCHAR (100) Primary Key,
    Ilosc NUMERIC (10)
);

INSERT INTO Towary_w_magazynie VALUES('Marchewka',  10);
INSERT INTO Towary_w_magazynie VALUES('Groszek',  12);
INSERT INTO Towary_w_magazynie VALUES('Kukurydza',  1);
INSERT INTO Towary_w_magazynie VALUES('Czosnek',  20);
INSERT INTO Towary_w_magazynie VALUES('Cebula',  18);


CREATE TABLE Partia_towarow(
    Nazwa_towaru VARCHAR (100) Primary Key,
    Ilosc NUMERIC (10)
);

INSERT INTO Partia_towarow VALUES('Marchewka',  10);
INSERT INTO Partia_towarow VALUES('Groszek',  10);
INSERT INTO Partia_towarow VALUES('Soczewica',  13);
INSERT INTO Partia_towarow VALUES('Ciastka',  20);
INSERT INTO Partia_towarow VALUES('Pietruszka',  10);
INSERT INTO Partia_towarow VALUES('Cebula',  10);
INSERT INTO Partia_towarow VALUES('Czosnek',  10);

commit;

MERGE INTO Towary_w_magazynie twm
USING Partia_towarow pt ON (twm.Nazwa_towaru = pt.Nazwa_towaru)
WHEN MATCHED THEN UPDATE SET twm.Ilosc = twm.Ilosc + pt.Ilosc
WHEN NOT MATCHED THEN INSERT (twm.Nazwa_towaru, twm.Ilosc) VALUES (pt.Nazwa_towaru, pt.Ilosc);

commit;

/*Zad. 2*/
DROP VIEW Emp_na_urlopie_bezp³atnym;

CREATE VIEW Emp_na_urlopie_bezp³atnym
AS SELECT * 
   FROM Emp
   WHERE Emp.Sal = 0 OR Emp.Sal IS NULL
WITH CHECK OPTION;

INSERT INTO EMP VALUES(1256, 'CROSS', 'CLERK', 7839, '1987/10/10', 0, null, 20);
commit;

SELECT DISTINCT * FROM Emp_na_urlopie_bezp³atnym;

/*nie dziala*/
INSERT INTO Emp_na_urlopie_bezp³atnym VALUES(1259, 'SEEKER', 'MANAGER', 7839, '1989/10/10', 10, null, 20);
commit;
/*dziala*/
INSERT INTO Emp_na_urlopie_bezp³atnym VALUES(1259, 'SEEKER', 'MANAGER', 7839, '1989/10/10', null, null, 20);
commit;

DROP VIEW Pracownicy;

CREATE VIEW Pracownicy
AS SELECT * FROM Emp
   WITH READ ONLY;

/*nie dziala*/   
INSERT INTO Pracownicy VALUES(1239, 'CEMENT', 'MANAGER', 7839, '1989/10/10', 10, null, 20);
commit;


/*Zad. 3*/
DROP VIEW empPerLocAndDept;
CREATE VIEW empPerLocAndDept
AS 
SELECT d1.Loc, COUNT(*) AS liczDzial, res1.Liczprac
FROM 
(SELECT d.Loc,  COUNT(e.Ename) as liczPrac
FROM Dept d LEFT JOIN Emp e ON d.Deptno = e.Deptno
GROUP BY d.Loc, d.Deptno) res1 LEFT JOIN Dept d1 ON res1.Loc = d1.Loc
GROUP BY d1.Loc, res1.Liczprac;

/*Zad. 4*/
DROP VIEW empData;
CREATE VIEW empData
AS
SELECT e.Empno, e.Ename, e.Job, e.Mgr, e.Hiredate, e.Sal, e.Comm, e.Deptno,
       d.Dname, d.Loc, 
       s.Grade, s.Losal, s.Hisal
FROM Emp e LEFT JOIN Dept d ON e.Deptno = d.Deptno, Salgrade s
WHERE e.Empno IN (SELECT User FROM Dual) AND
      e.Sal BETWEEN s.Losal AND s.Hisal;

/*Zad. 5*/
DROP VIEW tableInfo;
CREATE VIEW tableInfo
AS
SELECT utc.Table_name, COUNT(*) AS liczKol ,u.Num_rows AS liczWiersz
FROM User_Tab_Columns utc LEFT JOIN User_Tables u ON utc.Table_name = u.Table_name
WHERE utc.Table_name IN (SELECT u1.Table_name FROM User_Tables u1)
GROUP BY utc.Table_name, u.Num_rows;

/*Zad. 6*/
CREATE ROLE Dyrektor;
CREATE ROLE Pracownik;
CREATE ROLE Klient;
CREATE ROLE Kadrowy;
CREATE ROLE Sprzedawca;
CREATE ROLE ObslugaKlienta;

/*perspektywa dla pracowników*/
CREATE VIEW daneDlaPracownikow
AS
SELECT * FROM Pracownicy;

/*Perspektywa dla sprzedawców*/
CREATE VIEW daneKlientowDlaSprzedawcow
AS
SELECT * 
FROM (Sprzedaz sp LEFT JOIN Klienci kl ON sp.Id_klienta = kl.Id_klienta)
LEFT JOIN Produkty prod ON Id_produktu = prod.Id_produktu;

/*Perspektywa dla klientow*/
CREATE VIEW daneDlaKlientow
AS
SELECT * /*Poza kolumna z nazwiskie, data urodzenia i adresem pracownika*/
FROM (Sprzedaz sprzed LEFT JOIN Klienci kl ON sprzed.Id_klienta = kl.Id_klienta)
     LEFT JOIN Pracownicy prac ON Id_prac = prac.Id_prac;


/*Perspektywa dla Obslugi klienta*/
CREATE VIEW daneDlaObslugiKlienta
AS
SELECT * /*wszystko poza data urodzenia i adresem*/
FROM ((Sprzedaz sp LEFT JOIN Klienci kl ON sp.Id_klienta = kl.Id_klienta) 
      LEFT JOIN Produkty prod ON Id_produktu = prod.Id_produktu)
      LEFT JOIN Pracownicy prac ON Id_prac = prac.Id_prac;
      
/*Perspektywa dla Obslugi klienta*/
CREATE VIEW daneDlaKard
AS
SELECT * 
FROM Pracownicy prac LEFT JOIN Zatrudnienie zat ON prac.Id_prac = zat.Id_prac;

/*Zad. 7*/
/*

Zmianie ulegnie perspektywa:
  - sprzedawców (powinny zostac uwzglednione kategorie produktow)
  - klientów (powinny zostac uwzglednione kategorie produktow)
  - obslugi klienta (powinny zostac uwzglednione kategorie produktow)
  - Kadr (powinny zostac uwzglednione dane o premiach)
  - pracownikow (powinny zostac uwzglednione dane o premiach)
*/

/*Zad. 8*/
DROP TABLE Studenci CASCADE CONSTRAINTS;
DROP TABLE Wykladowcy CASCADE CONSTRAINTS;
DROP TABLE Kursy CASCADE CONSTRAINTS;
DROP TABLE Rejestracje CASCADE CONSTRAINTS;

CREATE TABLE Studenci(
NrIndeksu NUMBER(4) PRIMARY KEY,
Nazwisko VARCHAR(30),
RokUrodzenia INTEGER,
Kierunek VARCHAR(30)
);

CREATE TABLE Wykladowcy(
IdWykladowcy NUMBER(8) PRIMARY KEY,
Nazwisko VARCHAR(30),
Stopien VARCHAR(30),
Stanowisko VARCHAR(30)
);

CREATE TABLE Kursy(
IdKursu INTEGER PRIMARY KEY,
Nazwa VARCHAR(30),
IdWykladowcy NUMBER(8) REFERENCES Wykladowcy
);

CREATE TABLE Rejestracje(
NrIndeksu NUMBER(4) REFERENCES Studenci,
IdKursu INTEGER REFERENCES Kursy,
DataRejestracji DATE,
CONSTRAINT PRIM_KEY_Rejestracje PRIMARY KEY (NrIndeksu, IdKursu)
);

DROP SEQUENCE wyk_id;
CREATE SEQUENCE wyk_id
INCREMENT BY 1
Start WITH 1010;

INSERT INTO Wykladowcy VALUES (wyk_id.NextVal, 'Kowalski Jan', 'Dr', 'Adiunkt');
INSERT INTO Wykladowcy VALUES (wyk_id.NextVal, 'Jakubowski Emil', 'Dr hab', 'Docent');
INSERT INTO Wykladowcy VALUES (wyk_id.NextVal, 'Gazda Mirosawa', 'Dr', 'Profesor');
COMMIT;

Drop Sequence kur_id;
Create Sequence kur_id
INCREMENT BY 1
Start WITH 1;

INSERT INTO Kursy VALUES (kur_id.NextVal, 'Bazy danych', 1010);
INSERT INTO Kursy VALUES (kur_id.NextVal, 'Systemy operacyjne', 1012);
INSERT INTO Kursy VALUES (kur_id.NextVal, 'Multimedia', 1011);
INSERT INTO Kursy(IdKursu, Nazwa) VALUES (4, 'Sieci komputerowe');
COMMIT;

Drop Sequence stud_id;
Create Sequence stud_id
INCREMENT BY 1
Start WITH 101;

INSERT INTO Studenci VALUES (stud_id.NextVal, 'Kuczyñska Ewa', 1980, 'Bazy danych');
INSERT INTO Studenci VALUES (stud_id.NextVal, 'Lubicz Robert', 1985, 'Multimedia');
INSERT INTO Studenci VALUES (stud_id.NextVal, 'Krajewski Bogdan', 1988, 'Bazy danych');
INSERT INTO Studenci VALUES (stud_id.NextVal, 'Lityñska Anna', 1987, 'Multimedia');
INSERT INTO Studenci VALUES (stud_id.NextVal, 'Marzec Marcin', 1982, 'Multimedia');
INSERT INTO Studenci VALUES (stud_id.NextVal, 'Cichocki Rafal', 1989, 'Bazy danych');
COMMIT;

Drop Sequence stud_id;
Create Sequence stud_id
INCREMENT BY 1
Start WITH 101;

INSERT INTO Rejestracje(NrIndeksu, IdKursu) VALUES(stud_id.NextVal, 1);
INSERT INTO Rejestracje(NrIndeksu, IdKursu) VALUES(stud_id.CurrVal, 4);
INSERT INTO Rejestracje(NrIndeksu, IdKursu) VALUES(stud_id.NextVal, 3);
INSERT INTO Rejestracje(NrIndeksu, IdKursu) VALUES(stud_id.NextVal, 1);
INSERT INTO Rejestracje(NrIndeksu, IdKursu) VALUES(stud_id.NextVal, 2);
INSERT INTO Rejestracje(NrIndeksu, IdKursu) VALUES(stud_id.CurrVal, 3);
INSERT INTO Rejestracje(NrIndeksu, IdKursu) VALUES(stud_id.NextVal, 1);
INSERT INTO Rejestracje(NrIndeksu, IdKursu) VALUES(stud_id.NextVal, 1);

COMMIT;


/*Zad. 9*/
SELECT u.TABLE_NAME
FROM User_Tables u
WHERE u.TABLE_NAME NOT IN(SELECT uv.View_name FROM User_Views uv) ;


/*Zad. 10*/
SELECT uv.View_name FROM User_Views uv;

/*Zad. 11*/
SELECT us.Sequence_name FROM User_Sequences us;



