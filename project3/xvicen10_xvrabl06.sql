-- Zadanie č.: 21. (Knihovna1)
-- Boris Vícena: xvicen10
-- Martin Vrablec: xvrabl06

-- DROP TABLES --
DROP TABLE Citatel CASCADE CONSTRAINTS ;
DROP TABLE Pracovnik CASCADE CONSTRAINTS ;
DROP TABLE Osoba CASCADE CONSTRAINTS ;
DROP TABLE Pozicanie CASCADE CONSTRAINTS ;
DROP TABLE Rezervacie CASCADE CONSTRAINTS ;
DROP TABLE Casopis CASCADE CONSTRAINTS ;
DROP TABLE Autor CASCADE CONSTRAINTS ;
DROP TABLE Kniha CASCADE CONSTRAINTS ;
DROP TABLE Exemplar CASCADE CONSTRAINTS ;

-- CREATE TABLES --
CREATE TABLE Osoba(
  ID_OSOBA INT GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY,
  MENO VARCHAR(50) NOT NULL,
  PRIEZVISKO VARCHAR(50) NOT NULL,
  TEL_CISLO VARCHAR(50),
    -- kontrola tel. čísla (SK a CZ)
    CONSTRAINT CHECK_TEL_CISLO CHECK ( REGEXP_LIKE(TEL_CISLO, '^((\+421\s?)|(\+420\s?))?[0-9]{3}\s?[0-9]{3}\s?[0-9]{3}$') ),
  EMAIL VARCHAR(80),
    -- kontrola mailovej adresy
    CONSTRAINT CHECK_EMAIL CHECK ( REGEXP_LIKE(EMAIL, '^[A-Za-z0-9!#$%&*+=?^_.`{|}~-]+@[A-Za-z0-9.-]+.[A-Za-z0-9]+$' ) ),
    -- kontrola ci je aspon jedno z atributov zadane (TEL_CISLO alebo EMAIL)
    CONSTRAINT CHECK_TEL_OR_EMAIL CHECK ( TEL_CISLO IS NOT NULL OR EMAIL IS NOT NULL ),
  PSC VARCHAR(6) NOT NULL,
    -- kontrola PSC
    CONSTRAINT CHECK_PSC CHECK ( REGEXP_LIKE(PSC, '^([0-9]{3}\s?[0-9]{2})$') ),
  ADRESA VARCHAR(100) NOT NULL,
    -- kontrola adresy (názov a číslo ulice)
    CONSTRAINT CHECK_ADRESA CHECK ( REGEXP_LIKE(ADRESA, '^[a-zA-Z]+\s[0-9]+(\/[0-9]+)?$') ),
  DATUM_NARODENIA DATE NOT NULL
);

CREATE TABLE Citatel(
  ID_CITATEL INT NOT NULL PRIMARY KEY,

  -- FK: generalizacia/specializacia
  CONSTRAINT FK_CITATEL_OSOBA FOREIGN KEY (ID_CITATEL) REFERENCES Osoba(ID_OSOBA) ON DELETE SET NULL
);

CREATE TABLE Pracovnik(
  ID_PRACOVNIK INT NOT NULL PRIMARY KEY,
  POZICIA VARCHAR(30) NOT NULL,

  -- FK: generalizacia/specializacia
  CONSTRAINT FK_PRACOVNIK_OSOBA FOREIGN KEY (ID_PRACOVNIK) REFERENCES Osoba(ID_OSOBA) ON DELETE SET NULL
);

CREATE TABLE Rezervacie(
  ID_REZERVACIA VARCHAR(255) NOT NULL PRIMARY KEY,
  DATUM_ZACIATKU_R DATE NOT NULL,
  DATUM_KONCA_R DATE NOT NULL,

  SPRAVUJE INT NOT NULL,
  VYTVORIL INT NOT NULL,
  -- FK Pracovnika, ktory rezervaciu spravuje
  CONSTRAINT FK_SPRAVUJE FOREIGN KEY (SPRAVUJE) REFERENCES Pracovnik(ID_PRACOVNIK) ON DELETE SET NULL,
  -- FK Citatela, ktory rezervaciu vytvoril
  CONSTRAINT FK_VYTVORIL FOREIGN KEY (VYTVORIL) REFERENCES Citatel(ID_CITATEL) ON DELETE SET NULL
);

CREATE TABLE Pozicanie(
  ID_POZICANIE VARCHAR(255) NOT NULL PRIMARY KEY,
  DATUM_VYZDVYHNUTIA DATE NOT NULL,
  DATUM_VRATENIA DATE NOT NULL,

  PREDAVA INT NOT NULL,
  VYZDVIHNE INT NOT NULL,
  -- FK Pracovnika, ktory predava/poziciva
  CONSTRAINT FK_PREDAVA FOREIGN KEY (PREDAVA) REFERENCES Pracovnik(ID_PRACOVNIK) ON DELETE SET NULL,
  -- FK Citatela, ktory si poziciava exemplar
  CONSTRAINT FK_VYZDVIHNE FOREIGN KEY (VYZDVIHNE) REFERENCES Citatel(ID_CITATEL) ON DELETE SET NULL
);

CREATE TABLE Exemplar(
  ID_EXEMPLAR VARCHAR(255) NOT NULL PRIMARY KEY,
  NAZOV VARCHAR(255) NOT NULL,
  ZANER VARCHAR(255) NOT NULL,
  ROK_VYDANIA INT,
  -- kontrola pre validny rok
  CONSTRAINT CHECK_ROK_VYDANIA CHECK ( REGEXP_LIKE(ROK_VYDANIA, '^([1-2][0-9][0-9][0-9])$') ),
  VYDAVATELSTVO VARCHAR(255) NOT NULL,
  POCET_KUSOV INT,
  -- kontrola pre pocet kusov
  CONSTRAINT CHECK_POCET_KUSOV CHECK ( POCET_KUSOV >= 0 ),

  REZERVOVANE VARCHAR(255),
  POZICANE VARCHAR(255),
  -- FK Rezervacie
  CONSTRAINT FK_REZERVOVANE FOREIGN KEY (REZERVOVANE) REFERENCES Rezervacie(ID_REZERVACIA) ON DELETE SET NULL,
  -- FK Pozicania
  CONSTRAINT FK_POZICANE FOREIGN KEY (POZICANE) REFERENCES Pozicanie(ID_POZICANIE) ON DELETE SET NULL
);

CREATE TABLE Autor(
  ID_AUTOR VARCHAR(255) NOT NULL PRIMARY KEY,
  MENO VARCHAR(255) NOT NULL,
  DATUM_NARODENIA DATE NOT NULL,
  DATUM_UMRTIA DATE,
  KRAJINA_POVODU VARCHAR(100) NOT NULL
);

CREATE TABLE Kniha(
  ID_KNIHA VARCHAR(255) NOT NULL PRIMARY KEY,
  AUTOR VARCHAR(255) NOT NULL,

  CONSTRAINT FK_AUTOR FOREIGN KEY (AUTOR) REFERENCES Autor(ID_AUTOR) ON DELETE SET NULL,
  CONSTRAINT FK_KNIHA_EXEMPLAR FOREIGN KEY (ID_KNIHA) REFERENCES Exemplar(ID_EXEMPLAR) ON DELETE SET NULL
);
CREATE TABLE Casopis(
  ID_CASOPIS VARCHAR(255) NOT NULL PRIMARY KEY,
  FREKVENCIA_VYDAVANIA VARCHAR(255) NOT NULL,
  -- kontrola pre validnu frekvenciu vydavania
  CONSTRAINT CHECK_FREKVENCIA_VYDAVANIA CHECK ( LOWER(FREKVENCIA_VYDAVANIA) IN ('mesacne', 'rocne', 'denne', 'tyzdenne')),

  -- FK: generalizacia/specializacia
  CONSTRAINT FK_CASOPIS_EXEMPLAR FOREIGN KEY (ID_CASOPIS) REFERENCES Exemplar(ID_EXEMPLAR) ON DELETE SET NULL
);

-- INSERT VALUES INTO TABLES --
INSERT INTO Osoba
VALUES (default, 'Jan', 'Novak', '+421 838 473 654', 'jan.novak@gmail.com', '903 72', 'Sokolska 36/1', TO_DATE('25.04.2001', 'dd.mm.yyyy'));
INSERT INTO Osoba
VALUES (default, 'Peter', 'Banas', '+420958323757', 'banas_p@yahoo.com', '416 53', 'Certikova 46', TO_DATE('14.08.1993', 'dd.mm.yyyy'));
INSERT INTO Osoba
VALUES (default, 'Jozef', 'Roztomil', '', 'roztomilJozef@seznam.cz', '652 61', 'Kartouzska 105/4', TO_DATE('05.02.1997', 'dd.mm.yyyy'));
INSERT INTO Osoba
VALUES (default, 'Kristina', 'Polarova', '+420 919 353 567', '', '758 13', 'Kriva 989', TO_DATE('11.09.1986', 'dd.mm.yyyy'));

INSERT INTO Pracovnik
VALUES (1, 'Manazer');
INSERT INTO Pracovnik
VALUES (2, 'Predavac');
INSERT INTO Citatel
VALUES (3);
INSERT INTO Citatel
VALUES (4);

INSERT INTO Rezervacie
VALUES ('77866', TO_DATE('20.02.2024', 'dd.mm.yyyy'), TO_DATE('11.09.2024', 'dd.mm.yyyy'), 1, 3);
INSERT INTO Rezervacie
VALUES ('86357', TO_DATE('20.01.2024', 'dd.mm.yyyy'), TO_DATE('27.02.2024', 'dd.mm.yyyy'), 2, 4);

INSERT INTO Pozicanie
VALUES ('14758', TO_DATE('26.01.2024', 'dd.mm.yyyy'), TO_DATE('27.02.2024', 'dd.mm.yyyy'), 2, 4);


INSERT INTO Exemplar
VALUES ('54146', 'Maly Princ', 'Detska literatura', 1949, 'Elist', 36, '77866', '');
INSERT INTO Exemplar
VALUES ('24514', 'Zaklinac', 'Fantasy', 1989, 'Nestor', 21, '86357', '14758');
INSERT INTO Exemplar
VALUES ('45144', 'Enigma', 'Mysteriozny', 2005, 'Venus press', 64, '', '14758');
INSERT INTO Exemplar
VALUES ('62358', 'Sport Magazin', 'Sport', 2012, 'Marken', 48, '', '');

INSERT INTO Autor
VALUES ('00567', 'Antoine de Saint-Exupery', TO_DATE('29.06.1900', 'dd.mm.yyyy'), TO_DATE('31.07.1944', 'dd.mm.yyyy'), 'Francuzko');
INSERT INTO Autor
VALUES ('04121', 'Andrzej Sapkowski', TO_DATE('21.06.1948', 'dd.mm.yyyy'), '', 'Polsko');

INSERT INTO Kniha
VALUES ('54146', '00567');
INSERT INTO Kniha
VALUES ('24514', '04121');

INSERT INTO Casopis
VALUES ('45144', 'mesacne');
INSERT INTO Casopis
VALUES ('62358', 'Tyzdenne');

SELECT * FROM Exemplar;
SELECT * FROM Autor;
SELECT * FROM Kniha;
SELECT * FROM Casopis;
SELECT * FROM Rezervacie;
SELECT * FROM Pozicanie;
SELECT * FROM Osoba;
SELECT * FROM Citatel;
SELECT * FROM Pracovnik;

--dva dotazy využívající spojení dvou tabulek

-- Ukazuje dokedy aky Exemplar treba vratit
SELECT Ex.NAZOV, Po.DATUM_VRATENIA
FROM Exemplar Ex
JOIN Pozicanie Po ON Ex.POZICANE = Po.ID_POZICANIE;

-- Ukazuje kto pracuje na akej pozicii
SELECT Os.MENO, Os.PRIEZVISKO, Pr.POZICIA
FROM Osoba Os
JOIN Pracovnik Pr ON Os.ID_OSOBA = Pr.ID_PRACOVNIK;


--jeden využívající spojení tří tabulek

-- Ukazuje kto si co rezervoval
SELECT Os.MENO, Os.PRIEZVISKO, Ex.NAZOV, Re.DATUM_ZACIATKU_R
FROM Exemplar Ex
JOIN Rezervacie Re ON Ex.REZERVOVANE = Re.ID_REZERVACIA
JOIN Osoba Os ON Re.VYTVORIL = Os.ID_OSOBA;

--dva dotazy s klauzulí GROUP BY a agregační funkcí

-- Ukazuje pocet exemplarov ku kazdemu zanru
SELECT ZANER, COUNT(*) AS POCET_ZANROV
FROM Exemplar
GROUP BY ZANER;

-- Ukazuje pocet ceskych a slovenskych telefonnych cisiel podla predvolby
SELECT CASE
WHEN TEL_CISLO LIKE '+420%' THEN '+420'
WHEN TEL_CISLO LIKE '+421%' THEN '+421'
END AS cz_sk_predvolba,
COUNT(*) AS CZ_SK_PREDVOLBA
FROM  Osoba
WHERE TEL_CISLO LIKE '+420%' OR TEL_CISLO LIKE '+421%'
GROUP BY CASE
WHEN TEL_CISLO LIKE '+420%' THEN '+420'
WHEN TEL_CISLO LIKE '+421%' THEN '+421'
END;

--jeden dotaz obsahující predikát EXISTS

-- Ukazuje citatela ktory este nevratil knizku po dobe vratenia
SELECT Os.MENO, Os.PRIEZVISKO, Os.TEL_CISLO, Os.EMAIL, Os.ADRESA, Os.PSC
FROM Osoba Os
JOIN Citatel Ci ON Os.ID_OSOBA = Ci.ID_CITATEL
WHERE EXISTS (
    SELECT *
    FROM Pozicanie Po
    WHERE Po.VYZDVIHNE = Os.ID_OSOBA AND Po.DATUM_VRATENIA < CURRENT_DATE
);


--jeden dotaz s predikátem IN s vnořeným selectem (nikoliv IN s množinou konstantních dat)

-- Ukazuje kto si rezervoval knihu vo february roku 2024
SELECT Os.MENO, Os.PRIEZVISKO, Os.TEL_CISLO, Os.EMAIL, Os.ADRESA, Os.PSC
FROM Osoba Os
JOIN Citatel Ci ON Os.ID_OSOBA = Ci.ID_CITATEL
WHERE Ci.ID_CITATEL IN (
    SELECT Re.VYTVORIL
    FROM Rezervacie Re
    WHERE Re.DATUM_ZACIATKU_R BETWEEN TO_DATE('01.02.2024', 'dd.mm.yyyy') AND TO_DATE('28.02.2024', 'dd.mm.yyyy')
);

