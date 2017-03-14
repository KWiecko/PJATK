
CREATE TABLE Magazyn(
Id_produktu NUMBER(6) PRIMARY KEY,
Produkt VARCHAR(20) NOT NULL,
Stan NUMBER(10) NOT NULL
  CONSTRAINT Mag_stan CHECK(Stan >= 0)
 );

CREATE TABLE Zakupy(
podsumowanie_zakupow VARCHAR(50),
data_zakupow DATE,

CONSTRAINT Zak_pk PRIMARY KEY(podsumowanie_zakupow, data_zakupow)
);

CREATE TABLE dziennik_bledow(
error_msg VARCHAR(100)
);

INSERT INTO Magazyn VALUES(1, 'Fiat', 1);
INSERT INTO Magazyn VALUES(2, 'Mitsubishi', 3);
INSERT INTO Magazyn VALUES(3, 'Lamborghini', 2);
INSERT INTO Magazyn VALUES(4, 'Ferrari', 0);

COMMIT;


INSERT INTO Zakupy VALUES('Kupiono Fiata', SYSDATE);
INSERT INTO Zakupy VALUES('Kupiono Ferrari', SYSDATE);
INSERT INTO Zakupy VALUES('Kupiono Lamborghini', SYSDATE);
INSERT INTO Zakupy VALUES('Kupiono Ferrari', SYSDATE);

COMMIT;

DECLARE
  ilosc NUMBER(5);
BEGIN
  SELECT m.Stan INTO ilosc FROM Magazyn m
  WHERE m.Produkt = 'Fiat';
  /* Gdy w kolumnie Produkt tabeli Magazyn nie ma wartości 'Fiat' jest podnoszony wyjątek o nazwie no_data_found. */
  IF ilosc> 0 THEN
    UPDATE Magazyn SET Stan = Stan - 1
    WHERE Produkt = 'Fiat';
    INSERT INTO Zakupy
    VALUES ('Kupiono Fiata', Sysdate);
  ELSE
    INSERT INTO Zakupy
    VALUES ('Brak Fiatów', Sysdate);
  END IF;
  COMMIT;
EXCEPTION -- Początek sekcji wyjątków
WHEN no_data_found THEN
   INSERT INTO dziennik_bledow
   VALUES ('Nie znaleziono produktu FIAT');
END;
/


Table MAGAZYN created.
Table ZAKUPY created.
Table DZIENNIK_BLEDOW created.

PL/SQL procedure successfully completed.
PL/SQL procedure successfully completed.

Zad 2.
DECLARE
    zarobki NUMBER(7,2);
    pi NUMBER(7,5) := 3.14159;
    nazwisko VARCHAR2(25) := 'Kowalski';
    data DATE := Sysdate;
    zonaty BOOLEAN := False;
     Data DATE DEFAULT Sysdate;
    
BEGIN
COMMIT;
END;
/


/*Skrypt 2.*/

SET SERVEROUTPUT ON
ACCEPT rocz_zarob PROMPT 'Podaj roczne zarobki: '
DECLARE
mies NUMBER(9,2) := &rocz_zarob;
BEGIN
  mies := mies/12;
  DBMS_OUTPUT.PUT_LINE ('Miesięczne zarobki = ' ||mies);
END;
/

old:DECLARE
mies NUMBER(9,2) := &rocz_zarob;
BEGIN
  mies := mies/12;
  DBMS_OUTPUT.PUT_LINE ('Miesięczne zarobki = ' ||mies);
END;

new:DECLARE
mies NUMBER(9,2) := 10000;
BEGIN
  mies := mies/12;
  DBMS_OUTPUT.PUT_LINE ('Miesięczne zarobki = ' ||mies);
END;


/*Skrypt 3*/


ACCEPT rocz_zarob PROMPT 'Podaj roczne zarobki: '
VARIABLE mies NUMBER
BEGIN
  :mies := &rocz_zarob/12;
END;
/
PRINT Mies

old:BEGIN
  :mies := &rocz_zarob/12;
END;

new:BEGIN
  :mies := 10000/12;
END;
