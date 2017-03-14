/* Zad 1.1 */
SELECT DISTINCT  rn.Deptno, rn.Ename, rn.Empno,  rn.Job, rn.Mgr, rn.Sal
FROM (SELECT d.Deptno, f.Job, f.Mgr, f.Sal, f.Ename, f.Empno, ROW_NUMBER() OVER (PARTITION BY f.Deptno ORDER BY f.Ename) AS numer
      FROM Dept d LEFT JOIN Emp f ON d.Deptno = f.Deptno) rn, Emp e 
WHERE  rn.numer = 1
ORDER BY rn.Deptno; 

/* Zad 1.2 */
SELECT e.Ename, d.Loc, e.Sal, s.Grade
FROM (SELECT e1.Mgr
      FROM Emp e1
      WHERE e1.Mgr IN (SELECT  e.Empno 
                       FROM Emp e
                       WHERE e.Job  = 'MANAGER'
                       ) 
      GROUP BY e1.Mgr
      HAVING COUNT(*) = 2
      ) mgr, Emp e JOIN Dept d ON e.Deptno = d.Deptno, Salgrade s
WHERE e.Empno = mgr.Mgr AND (e.Sal BETWEEN s.Losal AND s.Hisal);

/* Zad 1.3 */
/*Pracownicy zarabiaj¹ najwiêcej w dziale ...., a najmniej w dziale ...... Ró¿nica wynosi ....*/
SELECT 'Pracownicy zarabiaj¹ najwiêcej w dziale ' || dzialyMax.Dzial || 
       ', a najmniej w dziale ' || dzialyMin.Dzial || '.' ||
       'Ró¿nica wynosi ' || CAST(maks.maksSuma - mini.minSuma AS INTEGER) || '.'
FROM 
      (
      SELECT MAX(dzialy.Suma) AS maksSuma
      FROM (SELECT SUM(e.Sal) AS Suma, e.Deptno AS Dzial
      FROM Emp e
      GROUP BY e.Deptno) dzialy
      ) maks,
      (
      SELECT MIN(dzialy.Suma)AS minSuma
      FROM (SELECT SUM(e.Sal) AS Suma, e.Deptno AS Dzial
      FROM Emp e
      GROUP BY e.Deptno) dzialy
      ) mini,
      (
      SELECT SUM(e.Sal) AS Suma, e.Deptno AS Dzial
      FROM Emp e
      GROUP BY e.Deptno
      ) dzialyMax ,
      (
      SELECT SUM(e.Sal) AS Suma, e.Deptno AS Dzial
      FROM Emp e
      GROUP BY e.Deptno
      ) dzialyMin
WHERE dzialyMax.Suma = maks.maksSuma AND dzialyMin.Suma = mini.minSuma;

/* Zad 1.4 */
BREAK ON rn SKIP 40
SELECT Ename, Deptno, ROW_NUMBER() OVER (ORDER BY Deptno) AS rn
FROM Emp
ORDER BY Deptno, Hiredate
;


/* Zad 2.1 */
SELECT stud.Nrindeksu, stud.Nazwisko
FROM Studenci stud
WHERE stud.NrIndeksu IN (SELECT rej.Nrindeksu
                         FROM Rejestracje rej
                         GROUP BY rej.Nrindeksu
                         HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                            FROM Rejestracje rej
                                            GROUP BY rej.Nrindeksu));
                                            
/* Zad 2.2 */                    
SELECT wyk.Idwykladowcy, wyk.Nazwisko
FROM Wykladowcy wyk
WHERE wyk.Idwykladowcy IN (SELECT kur.Idwykladowcy
                         FROM Kursy kur
                         GROUP BY kur.Idwykladowcy
                         HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                            FROM Kursy kur
                                            GROUP BY kur.Idwykladowcy))
                        AND wyk.Idwykladowcy IS NOT Null;
                        
/* Zad 2.3 */ 
SELECT stud.Nrindeksu, stud.Nazwisko
FROM Studenci stud LEFT JOIN Rejestracje rej ON stud.Nrindeksu = rej.Nrindeksu
WHERE rej.Idkursu IS NULL;
                         
/* Zad 2.4 */ 
SELECT wyk.Idwykladowcy, wyk.Nazwisko
FROM Wykladowcy wyk LEFT JOIN Kursy kur ON wyk.Idwykladowcy = kur.Idwykladowcy
WHERE kur.Idkursu IS NULL;

/* Zad 2.5 */
SELECT spisKur.Nazwa
FROM (
      SELECT COUNT(*) AS ileOsob, kur.Nazwa
      FROM Kursy kur RIGHT JOIN Rejestracje rej ON kur.Idkursu = rej.Idkursu
      GROUP BY  kur.Nazwa
      ) spisKur
WHERE spisKur.ileOsob IN (SELECT MAX(COUNT(*))
                          FROM Kursy kur RIGHT JOIN Rejestracje rej ON kur.Idkursu = rej.Idkursu
                          GROUP BY kur.Idkursu)
UNION
SELECT spisKur.Nazwa || '*'
FROM (
      SELECT COUNT(*) AS ileOsob, kur.Nazwa
      FROM Kursy kur RIGHT JOIN Rejestracje rej ON kur.Idkursu = rej.Idkursu
      GROUP BY  kur.Nazwa
      ) spisKur
WHERE spisKur.ileOsob IS Null;

/* Zad 5.1 */
DROP TABLE Autorstwa CASCADE CONSTRAINTS;
DROP TABLE Na_tematy CASCADE CONSTRAINTS;
DROP TABLE Autorzy;
DROP TABLE Ksiazki;
DROP TABLE Tematy;


CREATE TABLE Autorzy (
    Id_autora NUMBER(4) PRIMARY KEY,
    Imie VARCHAR(50),
    Nazwisko VARCHAR(50)
);

CREATE TABLE Ksiazki (
    ISBN VARCHAR(50) PRIMARY KEY,
    Wydawca VARCHAR(50),
    Tytul VARCHAR(50),
    Rok INTEGER
);

CREATE TABLE Autorstwa (
    ISBN VARCHAR(50)  REFERENCES Ksiazki,
    Id_autora NUMBER(4) REFERENCES Autorzy,
    PRIMARY KEY(ISBN, Id_autora)
   
);

CREATE TABLE Tematy (
    Nrtematu NUMBER(4) PRIMARY KEY,
    Nazwa VARCHAR(50),
    Wyjasnienie VARCHAR(50)
);

CREATE TABLE Na_tematy (
    ISBN VARCHAR(50) REFERENCES Ksiazki,
    Nrtematu NUMBER(4) REFERENCES Tematy,
    PRIMARY KEY(ISBN, Nrtematu)
);
                      

INSERT INTO Autorzy VALUES (1, 'Kevin','Murphy');
INSERT INTO Autorzy VALUES (2, 'Alan','Robinson');
INSERT INTO Autorzy VALUES (3, 'Andrei','Voronkov');
INSERT INTO Autorzy VALUES (4, 'Jesse','Liberty');
INSERT INTO Autorzy VALUES (5, 'Dan','Hurwitz');
INSERT INTO Autorzy VALUES (6, 'Arkadiusz','Jakubowski');
INSERT INTO Autorzy VALUES (7, 'Bruce','Eckel');
INSERT INTO Autorzy VALUES (8, 'Paul','Wilton');
INSERT INTO Autorzy VALUES (9, 'John','Colby');


/*
CREATE TABLE Ksiazki (
    ISBN VARCHAR PRIMARY KEY,
    Wydawca VARCHAR,
    Tytul VARCHAR,
    Rok DATE
);
*/

INSERT INTO Ksiazki VALUES ('978-0262018029', 'Helion', 'Machine Learning: A Probabilistic Perspective', 2010);
INSERT INTO Ksiazki VALUES ('0-444-82949-0', 'WNT', 'Handbook of Automated Reasoning', 200);
INSERT INTO Ksiazki VALUES ('83-246-0361-1', 'Helion', 'Programming ASP.NET', 2006);
INSERT INTO Ksiazki VALUES ('83-7197-427-2', 'Krzak', 'Podstawy SQL. Æwiczenia praktyczne', 2001);
INSERT INTO Ksiazki VALUES ('83-7197-452-3', 'WNT', 'Bazy Danych Mockup1', 2001);
INSERT INTO Ksiazki VALUES ('83-7197-709-3', 'WNT', 'Bazy Danych Mockup2', 2002);

/*
CREATE TABLE Autorstwa (
    ISBN VARCHAR PRIMARY KEY REFERENCES Ksiazki,
    Id_autora NUMBER PRIMARY KEY REFERENCES Autorzy
   
);
*/
INSERT INTO Autorstwa VALUES('978-0262018029', 1);
INSERT INTO Autorstwa VALUES('0-444-82949-0', 2);
INSERT INTO Autorstwa VALUES('83-246-0361-1', 4);
INSERT INTO Autorstwa VALUES('83-7197-427-2', 6);
INSERT INTO Autorstwa VALUES('83-7197-452-3', 7);
INSERT INTO Autorstwa VALUES('83-7197-709-3', 7);

/*
CREATE TABLE Tematy (
    Nrtematu NUMBER PRIMARY KEY,
    Nazwa VARCHAR,
    Wyjasnienie VARCHAR
);
*/

INSERT INTO Tematy VALUES(1, 'Programowanie', 'Opis tematu programowanie');
INSERT INTO Tematy VALUES(2, 'Uczenie Maszynowe', 'Opis tematu ML');
INSERT INTO Tematy VALUES(3, 'Bazy Danych', 'Opis tematu BD');

/*
CREATE TABLE Na_tematy (
    ISBN VARCHAR PRIMARY KEY REFERENCES Ksiazki,
    Nrtematu NUMBER PRIMARY KEY REFERENCES Tematy
);
*/

INSERT INTO Na_tematy VALUES('978-0262018029', 2);
INSERT INTO Na_tematy VALUES('0-444-82949-0', 2);
INSERT INTO Na_tematy VALUES('83-246-0361-1', 1);
INSERT INTO Na_tematy VALUES('83-7197-427-2', 3);
INSERT INTO Na_tematy VALUES('83-7197-452-3', 3);
INSERT INTO Na_tematy VALUES('83-7197-709-3', 3);

COMMIT;
                      
/* Zad 5.2.1 */   
SELECT autrz.Imie, autrz.Nazwisko, tem.Nazwa
FROM ((Tematy tem LEFT JOIN Na_tematy ntem ON tem.Nrtematu = ntem.NrTematu) 
      RIGHT JOIN Autorstwa aut ON ntem.ISBN = aut.ISBN) JOIN Autorzy autrz ON autrz.Id_autora = aut.Id_autora
      GROUP BY  tem.Nazwa, autrz.Imie, autrz.Nazwisko
      HAVING tem.Nazwa = 'Bazy Danych';

/* Zad 5.2.2 */  
SELECT COUNT(*) AS ileKsiag, autrz.Imie, autrz.Nazwisko, tem.Nazwa
FROM ((Tematy tem LEFT JOIN Na_tematy ntem ON tem.Nrtematu = ntem.NrTematu) 
      RIGHT JOIN Autorstwa aut ON ntem.ISBN = aut.ISBN) JOIN Autorzy autrz ON autrz.Id_autora = aut.Id_autora
      GROUP BY  tem.Nazwa, autrz.Imie, autrz.Nazwisko
      HAVING tem.Nazwa = 'Bazy Danych'; 
      
SELECT pisOBaz.Imie, pisOBaz.Nazwisko
FROM (
      SELECT COUNT(*) AS ileKsiag, autrz.Imie, autrz.Nazwisko, tem.Nazwa
      FROM ((Tematy tem LEFT JOIN Na_tematy ntem ON tem.Nrtematu = ntem.NrTematu) 
            RIGHT JOIN Autorstwa aut ON ntem.ISBN = aut.ISBN) JOIN Autorzy autrz ON autrz.Id_autora = aut.Id_autora
            GROUP BY  tem.Nazwa, autrz.Imie, autrz.Nazwisko
            HAVING tem.Nazwa = 'Bazy Danych'
      ) pisOBaz
WHERE pisOBaz.ileKsiag IN (SELECT MAX(maksKsiag.ileKsiag) 
                           FROM(
                                SELECT COUNT(*) AS ileKsiag
                                FROM ((Tematy tem LEFT JOIN Na_tematy ntem ON tem.Nrtematu = ntem.NrTematu) 
                                RIGHT JOIN Autorstwa aut ON ntem.ISBN = aut.ISBN) JOIN Autorzy autrz ON autrz.Id_autora = aut.Id_autora
                                GROUP BY  tem.Nazwa, autrz.Imie, autrz.Nazwisko
                                HAVING tem.Nazwa = 'Bazy Danych'
                                ) maksKsiag                                
                                );    
/* Zad 5.3 */          
INSERT INTO Autorzy VALUES (10, 'nowyImie','nowyNazwisko');
INSERT INTO Ksiazki VALUES ('nowaISBN', 'nowaWydawnictwo', 'NowaTytul', 2002/*nowyRok*/);
INSERT INTO Autorstwa VALUES('nowaISBN', 10/*id nowego autora*/);
COMMIT;

/* Zad 4.0 */      
DROP TABLE Dept1 CASCADE CONSTRAINTS;
DROP TABLE Prac CASCADE CONSTRAINTS;
DROP TABLE Pracuje CASCADE CONSTRAINTS;
DROP TABLE Projekty CASCADE CONSTRAINTS;


CREATE TABLE Dept1(
NumDz NUMERIC(4) PRIMARY KEY,
NazwaDz VARCHAR(50),
NumKier NUMERIC(4)
);

INSERT INTO Dept1 VALUES(1, 'A', 1);
INSERT INTO Dept1 VALUES(2, 'B', 2);
INSERT INTO Dept1 VALUES(3, 'C', 3);

COMMIT;

CREATE TABLE Prac(
NumP NUMERIC(4) PRIMARY KEY,
Nazw VARCHAR(50),
Imie VARCHAR(50),
DataUr DATE,
DataZatr DATE,
NumDz NUMERIC(4) REFERENCES Dept1,
Zarob NUMERIC(10),
Pietro NUMERIC(4)
);


INSERT INTO Prac VALUES(1, 'Nowak', 'Jan', '1993/10/10' , '2001/10/10', 1, 120, 1);
INSERT INTO Prac VALUES(2, 'Myk', 'Jon', '1992/10/10', '2002/10/10', 1, 121, 1);
INSERT INTO Prac VALUES(3, 'Hyc', 'Anna', '1996/10/10', '2006/10/10', 1, 122, 1);
INSERT INTO Prac VALUES(4, 'Pec', 'Ela', '1989/10/10', '2007/10/10', 2, 123, 1);
INSERT INTO Prac VALUES(5, 'Bec', 'Mela', '1990/10/10', '2004/10/10', 2, 124, 2);
INSERT INTO Prac VALUES(6, 'KAc', 'Hela', '1992/10/10', '2001/10/10', 2, 125, 2);
INSERT INTO Prac VALUES(7, 'Kat', 'Adam', '1987/10/10', '2002/10/10', 3, 126, 2);
INSERT INTO Prac VALUES(8, 'Szpak', 'Piotr', '1978/10/10', '2000/10/10', 3, 127, 3);
INSERT INTO Prac VALUES(9, 'Rak', 'Janusz', '1983/10/10', '2010/10/10', 3, 128, 3);
INSERT INTO Prac VALUES(10, 'Raj', 'Jan', '1984/10/10', '2009/10/10', 3, 129, 3);

COMMIT;

CREATE TABLE Pracuje(
NumP NUMERIC(4) REFERENCES Prac,
NumProj NUMERIC(4) REFERENCES Projekty,
Rola VARCHAR(50),
PRIMARY KEY(NumP, NumProj, Rola)
);

INSERT INTO Pracuje VALUES(1, 1, 'AAA');
INSERT INTO Pracuje VALUES(2, 1, 'BBB');
INSERT INTO Pracuje VALUES(3, 1, 'CCC');
INSERT INTO Pracuje VALUES(4, 2, 'AAA');
INSERT INTO Pracuje VALUES(5, 2, 'BBB');
INSERT INTO Pracuje VALUES(6, 2, 'BBB');
INSERT INTO Pracuje VALUES(7, 2, 'AAA');
INSERT INTO Pracuje VALUES(8, 2, 'CCC');
INSERT INTO Pracuje VALUES(9, 1, 'AAA');
INSERT INTO Pracuje VALUES(9, 1, 'BBB');
INSERT INTO Pracuje VALUES(10, 1, 'AAA');
INSERT INTO Pracuje VALUES(10, 2, 'AAA');

COMMIT;

CREATE TABLE Projekty(
NumProj NUMERIC(4) PRIMARY KEY,
NazwaProj VARCHAR(50),
Budzet NUMERIC(10)
);

INSERT INTO Projekty VALUES(1, 'AA', 10000);
INSERT INTO Projekty VALUES(2, 'BB', 50000);

COMMIT;

/* Zad 4.1 */ 
SELECT prac.Nazw, dep.NumDz
FROM Dept1 dep, Prac prac
WHERE prac.NumP = dep.NumKier;

/* Zad 4.2 */

SELECT  pracu.Rola,  prac.Nazw, pracu.NumProj
FROM Pracuje pracu LEFT JOIN Prac prac ON pracu.NumP = prac.NumP
GROUP BY  pracu.Rola, prac.Nazw, pracu.NumProj
ORDER BY pracu.Rola;

SELECT prac.Nazw
FROM Pracuje pracu LEFT JOIN Prac prac ON pracu.NumP = prac.NumP
GROUP BY prac.Nazw, pracu.NumProj
HAVING COUNT(*) = 2
UNION
SELECT prac.Nazw
FROM Pracuje pracu LEFT JOIN Prac prac ON pracu.NumP = prac.NumP
GROUP BY prac.Nazw, pracu.Rola
HAVING COUNT(*) > 1
;

/* Zad 4.3 */

SELECT pracu.NumProj, prac.Imie, COUNT(*) 
FROM Pracuje pracu LEFT JOIN Prac prac ON pracu.NumP = prac.NumP
GROUP BY pracu.NumProj,prac.Imie
HAVING COUNT(*) > 1
ORDER BY pracu.NumProj
;

/* Zad 4.4 */ 
SELECT prac.Nazw
FROM Pracuje pracu LEFT JOIN Prac prac ON pracu.NumP = prac.NumP
GROUP BY pracu.NumProj, prac.Nazw
HAVING pracu.NumProj != 1;

/* Zad 4.5 */

SELECT prac.Nazw , COUNT(*)
FROM Pracuje pracu RIGHT JOIN Prac prac ON pracu.NumP = prac.NumP
GROUP BY prac.Nazw,  pracu.NumProj
HAVING COUNT(*) = (SELECT COUNT(*) FROM Projekty);


/* Zad 4.6 */
SELECT prac1.Nazw, prac2.Nazw
FROM Prac prac1 INNER JOIN Prac prac2 ON prac1.NumDz = prac2.NumDz
WHERE prac1.Nazw > prac2.Nazw;


/* Zad 4.8 */
SELECT COUNT(*) AS iluPrac, SUM(prac.Zarob)/COUNT(*) AS srednieZarob
FROM Pracuje pracu LEFT JOIN Prac prac ON pracu.NumP = prac.NumP
GROUP BY pracu.NumProj;

/* Zad 4.9 */
SELECT COUNT(*) AS ileDzialow, subTab.NumProj 
FROM (
      SELECT pracu.NumProj, prac.NumDz
      FROM Pracuje pracu LEFT JOIN Prac prac ON pracu.NumP = prac.NumP
      GROUP BY pracu.NumProj, prac.NumDz
      ) subTab
GROUP BY subTab.NumProj
HAVING COUNT(*) = 1;

/* Zad 4.10 */
SELECT pracu.Rola, COUNT(*) iluRola, trunc(SUM(prac.Zarob)/COUNT(*), 2) AS  srednieRola
FROM  Pracuje pracu LEFT JOIN Prac prac ON pracu.NumP = prac.NumP
GROUP BY pracu.Rola
ORDER BY pracu.Rola;




