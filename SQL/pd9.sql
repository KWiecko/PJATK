CREATE OR REPLACE PROCEDURE WstawMiejscowosc (vInsID IN NUMBER,
                                              vInsNazwa IN Miejscowosc.Nazwa%Type) 
                                               AS 
vIsPresent NUMBER;
BEGIN

  SELECT COUNT(*) INTO vIsPresent
  FROM Miejscowosc m
  WHERE m.Nazwa = vInsNazwa;

  IF vIsPresent = 0 
  THEN
  
  INSERT INTO Miejscowosc
  VALUES (vInsId, vInsNazwa);
  COMMIT;
  END IF;

END WstawMiejscowosc;
/
CALL WstawMiejscowosc(12, 'Kluczbork');


CREATE OR REPLACE PROCEDURE WstawPraprzodka (vPesel IN Osoba.Pesel%Type,
                                             vImie IN Osoba.Imie%Type,
                                             vNazwisko IN Osoba.Nazwisko%Type,
                                             vDatUr IN Osoba.Data_Urodzenia%Type,
                                             vMiejUr IN Osoba.Miejsce_Urodzenia%Type)
AS
isPresent NUMBER;
BEGIN

  SELECT COUNT(*) INTO isPresent
  FROM Osoba o
  WHERE o.Pesel = vPesel;
  
  IF isPresent = 0 
  THEN
  INSERT INTO Osoba (Osoba.Pesel, 
                     Osoba.Imie, 
                     Osoba.Nazwisko, 
                     Osoba.Data_Urodzenia, 
                     Osoba.Miejsce_Urodzenia)
  VALUES (vPesel, vImie, vNazwisko, vDatUr, vMiejUr);
  COMMIT;
  END IF;

END WstawPraprzodka;
/

CALL WstawPraprzodka(12345778913, 'Janusz', 'Tracz', TO_DATE('31-07-1981', 'DD-MM-YYYY'), 4);


SET SERVEROUTPUT ON


CREATE OR REPLACE PROCEDURE WstawPotomka (   vPesel IN Osoba.Pesel%Type,
                                             vImie IN Osoba.Imie%Type,
                                             vNazwisko IN Osoba.Nazwisko%Type,
                                             vDatUr IN Osoba.Data_Urodzenia%Type,
                                             vMiejUr IN Osoba.Miejsce_Urodzenia%Type,
                                             vMatka IN Osoba.Matka%Type,
                                             vOjciec IN Osoba.Ojciec%Type)
AS
isPresent NUMBER;
hasMother NUMBER;
hasFather NUMBER;
BEGIN
  
  SELECT COUNT(*) INTO isPresent
  FROM Osoba o
  WHERE o.Pesel = vPesel;
  
  SELECT COUNT(*) INTO hasMother
  FROM Osoba o
  WHERE o.Pesel = vMatka AND o.Plec = 'K';
  
  SELECT COUNT(*) INTO hasFather
  FROM Osoba o
  WHERE o.Pesel = vOjciec AND o.Plec = 'M';
  
  IF isPresent = 0 AND vMatka >= 1 AND vOjciec >= 1
  THEN
  INSERT INTO Osoba (Osoba.Pesel, 
                     Osoba.Imie, 
                     Osoba.Nazwisko, 
                     Osoba.Data_Urodzenia, 
                     Osoba.Miejsce_Urodzenia,
                     Osoba.Matka,
                     Osoba.Ojciec)
  VALUES (vPesel, vImie, vNazwisko, vDatUr, vMiejUr, vMatka, vOjciec);
  COMMIT;
  
  ELSE 
  DBMS_OUTPUT.PUT_LINE ('Osoba wystepuje w bazie lub jej rodzice nie sa zarejestrowani');
  END IF;


END WstawPotomka;
/
CALL WstawPotomka('12345678915', 'Jan', 'Ban', TO_DATE('31-07-1981', 'DD-MM-YYYY'), 8, 12345678901, '12345678911');



SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE RejestrujZgon (vPesel IN Osoba.Pesel%Type,
                                           vDataZgon IN Osoba.Data_Zgonu%Type)
AS
isAlive NUMBER;
BEGIN

SELECT COUNT(*) INTO isAlive
FROM Osoba o3
WHERE o3.Pesel = vPesel;


IF isAlive > 0 THEN
DBMS_OUTPUT.PUT_LINE (isAlive);
UPDATE Osoba o
SET o.Data_Zgonu = vDataZgon
WHERE o.Pesel = vPesel;
COMMIT;
END IF;


END RejestrujZgon;
/

CALL RejestrujZgon ('12345678910', TO_DATE('31-07-1981', 'DD-MM-YYYY'));


CREATE OR REPLACE PROCEDURE PodajRodziców (vPesel IN Osoba.Pesel%Type)

AS

mName Osoba.Imie%Type;
mSurname Osoba.Nazwisko%Type;

oName Osoba.Imie%Type;
oSurname Osoba.Nazwisko%Type;

BEGIN

SELECT o.Imie ||' ' || o.Nazwisko INTO mName
FROM Osoba o
WHERE o.Pesel IN (  SELECT o1.Matka
                    FROM Osoba o1
                    WHERE o1.Pesel = vPesel);
                    

                    
SELECT o.Imie ||' ' || o.Nazwisko INTO oName
FROM Osoba o
WHERE o.Pesel IN (  SELECT o1.Ojciec
                    FROM Osoba o1
                    WHERE o1.Pesel = vPesel);
                    

                    
DBMS_OUTPUT.PUT_LINE (mName);
DBMS_OUTPUT.PUT_LINE (oName);

END PodajRodziców;
/

CALL PodajRodziców('12345678903');


SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE PodajRodzenstwo(vPesel IN Osoba.Pesel%Type)
AS

vNazwisko Osoba.Nazwisko%Type;
vMatka Osoba.Matka%Type;
vOjciec Osoba.Ojciec%Type;

vPlec Osoba.Plec%Type;
vPeselMalz Osoba.Pesel%Type;

vRodz Osoba.Imie%Type;
vRodzPes Osoba.Pesel%Type;

BEGIN


  SELECT o.Nazwisko INTO vNazwisko
  FROM Osoba o
  WHERE o.Pesel = vPesel;
  
  SELECT o.Matka INTO vMatka
  FROM Osoba o 
  WHERE o.Pesel = vPesel;
  
  SELECT o.Ojciec INTO vOjciec
  FROM Osoba o
  WHERE o.Pesel = vPesel;
    
  SELECT o.Plec INTO vPlec
  FROM Osoba o 
  WHERE o.Pesel = vPesel;
  
  IF vPlec = 'K'
  THEN
    SELECT zm.Maz INTO vPeselMalz
    FROM Zwiazek_malzenski zm
    WHERE zm.Zona = vPesel;
    
  ELSE
    SELECT zm.Zona INTO vPeselMalz
    FROM Zwiazek_malzenski zm
    WHERE zm.Maz = vPesel;
    
  END IF;

IF vMatka IS NULL AND vOjciec IS NULL
THEN

   DBMS_OUTPUT.PUT_LINE('Za malo danych aby wyszukac rodzenstwo');
       
ELSE

  FOR curPesel IN(SELECT o1.Pesel
                 FROM Osoba o1
                 WHERE 
                 (o1.Matka = vMatka
                 OR
                 o1.Ojciec = vOjciec)
                 AND
                 o1.Pesel != vPeselMalz
                 )
    LOOP
    
    SELECT o.Imie||' '||o.Nazwisko INTO vRodz
    FROM Osoba o
    WHERE o.Pesel = curPesel.Pesel;
    DBMS_OUTPUT.PUT_LINE(vRodz);
    
    END LOOP;

END IF;

END PodajRodzenstwo;
/
  



CALL PodajRodzenstwo('12345678910');



DROP TABLE Statystyka;

CREATE TABLE Statystyka(
rok NUMBER,
ileM NUMBER,
ileR NUMBER
);


/*zad. 1.g*/
  
CREATE OR REPLACE PROCEDURE StatystykaZwiazkow

AS


vIleMalzenstw NUMBER;
vIleRozwodow NUMBER;

BEGIN




FOR curYear IN (SELECT DISTINCT EXTRACT(YEAR FROM zm.Data_Zawarcia_Zwiazku) AS Rok
                FROM Zwiazek_Malzenski zm
                ORDER BY Rok)
      LOOP
      
      SELECT COUNT(*) INTO vIleMalzenstw
      FROM Zwiazek_Malzenski zm
      WHERE zm.Data_Zawarcia_Zwiazku BETWEEN TO_DATE(curYear.Rok||'/01/01') AND TO_DATE(curYear.Rok||'/12/31');
     
     
      SELECT COUNT(*) INTO vIleRozwodow
      FROM Zwiazek_Malzenski zm
      WHERE zm.Data_Wygasniecia_Zwiazku IS NOT NULL 
      AND zm.Data_Wygasniecia_Zwiazku BETWEEN TO_DATE(curYear.Rok||'/01/01') AND TO_DATE(curYear.Rok||'/12/31')
      AND zm.Powod_Wygasniecia_Zwiazku = 'Rozwod';

      
       INSERT INTO Statystyka
       VALUES(curYear.Rok, vIleMalzenstw, vIleRozwodow);
       COMMIT;
      END LOOP;
      

END;
/

SET SERVEROUTPUT ON

CALL StatystykaZwiazkow();


/*zad 2.a*/
CREATE OR REPLACE TRIGGER upd_Zwiazek_Malzenski
BEFORE UPDATE OF Data_wygasniecia_zwiazku
ON Zwiazek_Malzenski
FOR EACH ROW
DECLARE

vMDate Zwiazek_Malzenski.Data_Zawarcia_Zwiazku%Type;


BEGIN

  vMDate := :OLD.Data_Zawarcia_Zwiazku;

  
 
  IF vMDate > :NEW.Data_Wygasniecia_Zwiazku
  THEN
  
   Raise_application_error(-20500, 'Data wygasniecia zwiazku mniejsza od daty zawracia zwiazku');
  
  END IF;
END;
/
UPDATE Zwiazek_Malzenski
SET data_wygasniecia_zwiazku = to_date('1970/02/25')
WHERe id_zwiazku = 3;

UPDATE Zwiazek_Malzenski
SET data_wygasniecia_zwiazku = to_date('1970/02/22')
WHERe id_zwiazku = 3;


/*zad 2.b*/
SET SERVEROUTPUT ON

CREATE OR REPLACE TRIGGER ins_osoba_pesel
BEFORE INSERT
ON Osoba
FOR EACH ROW
DECLARE
vInsPesel NUMBER;
BEGIN
vInsPesel := TO_NUMBER(:NEW.Pesel);
IF (LENGTH(vInsPesel) != 11)
THEN
Raise_application_error(-20500, 'Zla ilosc znakow w PESELu');
  
END IF;
END;
/

INSERT INTO Osoba (Osoba.Pesel, 
                     Osoba.Imie, 
                     Osoba.Nazwisko, 
                     Osoba.Data_Urodzenia, 
                     Osoba.Miejsce_Urodzenia)
  VALUES ('122', 'Jan', 'tan', TO_DATE('31-07-1981', 'DD-MM-YYYY'), 2);


  DROP SEQUENCE Seq_Miejscowosc;
  
  CREATE SEQUENCE Seq_Miejscowosc
  INCREMENT BY 1
  START WITH 10;


  CREATE OR REPLACE TRIGGER nxt_Miejsc_Id
  BEFORE INSERT
  ON Miejscowosc
  FOR EACH ROW
  DECLARE
  BEGIN
  :NEW.Id_Miejscowosci := Seq_Miejscowosc.NextVal;
  DBMS_OUTPUT.PUT_LINE(:NEW.Id_Miejscowosci);
  END;
  /

  
  INSERT INTO Miejscowosc
  VALUES (2, 'Grudziadz');
  COMMIT;








