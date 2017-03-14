/*Zad 1.1*/
SELECT e1.Ename 
FROM (SELECT e.Ename, ROW_NUMBER() OVER (PARTITION BY e.Deptno ORDER BY e.Ename) rn FROM Emp e) e1
WHERE rn = 1;

/*Zad 1.2*/
SELECT e.Job, COUNT (*) AS NEmp ,ROUND(AVG(e.Sal), 2) AS avgJobSal
FROM Emp e
GROUP BY e.Job;

/*Zad 1.3*/
SELECT e1.Job, SUM (e1.NDept) AS NumDempt
FROM (SELECT e.Job, COUNT (*) AS NDept
FROM Emp e
GROUP BY  e.Deptno, e.Job) e1
GROUP BY e1.Job;
/*Zad 1.4*/
SELECT e3.Ename
FROM (SELECT e.Mgr AS MGRId
      FROM (SELECT  e1.Mgr, COUNT(*) AS  NOfEmps
            FROM Emp e1
            GROUP BY e1.Mgr)  e
            WHERE e.NOfEmps = 2) e2, Emp e3
WHERE e3.Empno = e2.MGRId;

/*Zad 1.5*/
SELECT e.Ename,  AVG(e.Sal) OVER (PARTITION BY e.Deptno 
                                 ORDER BY e.Sal 
                                 RANGE BETWEEN 100 PRECEDING AND 100 FOLLOWING) 
                                 AS Srednia_Zarobkow,
                                 e.Deptno
FROM Emp e;

/*Zad 2.1*/
SELECT stud.Nazwisko, COUNT(*) AS IloscKursow
FROM Studenci stud INNER JOIN Rejestracje rej ON stud.NrIndeksu = Rej.NrIndeksu
GROUP BY stud.Nazwisko;

/*Zad 2.2*/
SELECT tempTab.Nazwa, tempTab.Nazwisko, COUNT(*) AS LiczbaUczestnikow
FROM (SELECT rej.NrIndeksu, rej.IdKursu, kur.Nazwa, kur.IdWykladowcy, wyk.Nazwisko
      FROM Rejestracje rej, Kursy kur, Wykladowcy wyk
      WHERE rej.IdKursu = kur.IdKursu AND kur.IdWykladowcy = wyk.IdWykladowcy) tempTab
GROUP BY tempTab.Nazwa, tempTab.Nazwisko;

/*Zad 2.3*/
SELECT kur.Nazwa, tempTab.IloscSluchaczy
FROM (SELECT  rej.IdKursu, COUNT(*) AS IloscSluchaczy
      FROM Studenci stud INNER JOIN Rejestracje rej ON stud.NrIndeksu = Rej.NrIndeksu
      GROUP BY rej.IdKursu) tempTab,
      Kursy kur
WHERE kur.IdKursu = tempTab.IdKursu AND tempTab.IloscSluchaczy >=5;

/*Zad 2.4*/
SELECT tempTab.Nazwisko, tempTab.IloscKursow
FROM(SELECT stud.Nazwisko, COUNT(*) AS IloscKursow
     FROM Studenci stud INNER JOIN Rejestracje rej ON stud.NrIndeksu = Rej.NrIndeksu
     GROUP BY stud.Nazwisko) tempTab
WHERE tempTab.IloscKursow >2;

/*Zad 2.5*/
/*maksymalna ilosc kursów na jaka zapisany jest kazdy student */
SELECT stud.Nazwisko, COUNT(*) AS IloscKursow
FROM Studenci stud INNER JOIN Rejestracje rej ON stud.NrIndeksu = Rej.NrIndeksu
GROUP BY stud.Nazwisko;

/*lub najwieksza ilosc kursow na jaka zapisany jest jeden student*/

SELECT MAX(tempTab.IloscKursow) AS MaxIloscKursow
FROM (SELECT stud.Nazwisko, COUNT(*) AS IloscKursow
      FROM Studenci stud INNER JOIN Rejestracje rej ON stud.NrIndeksu = Rej.NrIndeksu
      GROUP BY stud.Nazwisko) tempTab;




