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
  CONSTRAINT CHECK_POCET_KUSOV CHECK ( POCET_KUSOV >= 0 )

  --REZERVOVANE VARCHAR(255),
  --POZICANE VARCHAR(255),
  -- FK Rezervacie
  --CONSTRAINT FK_REZERVOVANE FOREIGN KEY (REZERVOVANE) REFERENCES Rezervacie(ID_REZERVACIA) ON DELETE SET NULL,
  -- FK Pozicania
  --CONSTRAINT FK_POZICANE FOREIGN KEY (POZICANE) REFERENCES Pozicanie(ID_POZICANIE) ON DELETE SET NULL
);

CREATE TABLE Rezervacie(
  ID_REZERVACIA VARCHAR(255) NOT NULL PRIMARY KEY,
  DATUM_ZACIATKU_R DATE NOT NULL,
  DATUM_KONCA_R DATE NOT NULL,

  SPRAVUJE INT NOT NULL,
  VYTVORIL INT NOT NULL,
  REZ_EXEMPLAR VARCHAR(255) NOT NULL,
  -- FK Pracovnika, ktory rezervaciu spravuje
  CONSTRAINT FK_SPRAVUJE FOREIGN KEY (SPRAVUJE) REFERENCES Pracovnik(ID_PRACOVNIK) ON DELETE SET NULL,
  -- FK Citatela, ktory rezervaciu vytvoril
  CONSTRAINT FK_VYTVORIL FOREIGN KEY (VYTVORIL) REFERENCES Citatel(ID_CITATEL) ON DELETE CASCADE,
  -- FK Exemplar, ktory sa rezervuje
  CONSTRAINT FK_REZ_EXEMPLAR FOREIGN KEY (REZ_EXEMPLAR) REFERENCES Exemplar(ID_EXEMPLAR) ON DELETE SET NULL
);

CREATE TABLE Pozicanie(
  ID_POZICANIE VARCHAR(255) NOT NULL PRIMARY KEY,
  DATUM_VYZDVYHNUTIA DATE NOT NULL,
  DATUM_VRATENIA DATE NOT NULL,

  PREDAVA INT NOT NULL,
  VYZDVIHNE INT NOT NULL,
  POZ_EXEMPLAR VARCHAR(255) NOT NULL,
  -- FK Pracovnika, ktory predava/poziciva
  CONSTRAINT FK_PREDAVA FOREIGN KEY (PREDAVA) REFERENCES Pracovnik(ID_PRACOVNIK) ON DELETE SET NULL,
  -- FK Citatela, ktory si poziciava exemplar
  CONSTRAINT FK_VYZDVIHNE FOREIGN KEY (VYZDVIHNE) REFERENCES Citatel(ID_CITATEL) ON DELETE CASCADE,
  -- FK Exemplar, ktory je pozicany
  CONSTRAINT FK_POZ_EXEMPLAR FOREIGN KEY (POZ_EXEMPLAR) REFERENCES Exemplar(ID_EXEMPLAR) ON DELETE SET NULL
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

INSERT INTO Exemplar
VALUES ('54146', 'Maly Princ', 'Detska literatura', 1949, 'Elist', 36);
INSERT INTO Exemplar
VALUES ('54123', 'Zem ludi', 'Biografia', 1939, 'Elist', 18);
INSERT INTO Exemplar
VALUES ('51143', 'Dopis rukojmimu', 'Fikcia', 1943, 'Elist', 23);
INSERT INTO Exemplar
VALUES ('24514', 'Zaklinac', 'Fantasy', 1989, 'Nestor', 21);
INSERT INTO Exemplar
VALUES ('45144', 'Enigma', 'Mysteriozny', 2005, 'Venus press', 12);
INSERT INTO Exemplar
VALUES ('62358', 'Sport Magazin', 'Sport', 2012, 'Marken', 92);

INSERT INTO Autor
VALUES ('00567', 'Antoine de Saint-Exupery', TO_DATE('29.06.1900', 'dd.mm.yyyy'), TO_DATE('31.07.1944', 'dd.mm.yyyy'), 'Francuzko');
INSERT INTO Autor
VALUES ('04121', 'Andrzej Sapkowski', TO_DATE('21.06.1948', 'dd.mm.yyyy'), '', 'Polsko');

INSERT INTO Kniha
VALUES ('54146', '00567');
INSERT INTO Kniha
VALUES ('54123', '00567');
INSERT INTO Kniha
VALUES ('51143', '00567');
INSERT INTO Kniha
VALUES ('24514', '04121');

INSERT INTO Casopis
VALUES ('45144', 'mesacne');
INSERT INTO Casopis
VALUES ('62358', 'Tyzdenne');

INSERT INTO Rezervacie
VALUES ('77866', TO_DATE('20.02.2024', 'dd.mm.yyyy'), TO_DATE('11.09.2024', 'dd.mm.yyyy'), 1, 3, '54146');
INSERT INTO Rezervacie
VALUES ('86357', TO_DATE('20.01.2024', 'dd.mm.yyyy'), TO_DATE('27.02.2024', 'dd.mm.yyyy'), 2, 4, '24514');

INSERT INTO Pozicanie
VALUES ('14758', TO_DATE('26.01.2024', 'dd.mm.yyyy'), TO_DATE('27.02.2024', 'dd.mm.yyyy'), 2, 4, '54146');
INSERT INTO Pozicanie
VALUES ('15674', TO_DATE('26.01.2024', 'dd.mm.yyyy'), TO_DATE('29.03.2024', 'dd.mm.yyyy'), 1, 4, '45144');

SELECT * FROM Exemplar;
SELECT * FROM Autor;
SELECT * FROM Kniha;
SELECT * FROM Casopis;
SELECT * FROM Rezervacie;
SELECT * FROM Pozicanie;
SELECT * FROM Osoba;
SELECT * FROM Citatel;
SELECT * FROM Pracovnik;

--------------------------EXPLAIN PLAN--------------------------
EXPLAIN PLAN FOR
SELECT
    Ex.ID_EXEMPLAR,
    Ex.NAZOV AS NAZOV_KNIHY,
    Ex.ZANER,
    COUNT(Po.ID_POZICANIE) AS POCET_POZICANICH,
    Ex.POCET_KUSOV
FROM
    Exemplar Ex
LEFT JOIN
    Pozicanie Po ON Ex.ID_EXEMPLAR = Po.POZ_EXEMPLAR
GROUP BY
    Ex.ID_EXEMPLAR, Ex.NAZOV, Ex.ZANER, Ex.POCET_KUSOV;
--------------------------EXPLAIN PLAN--------------------------

--------------------------EXPLAIN PLAN SELECT--------------------------
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
--------------------------EXPLAIN PLAN SELECT--------------------------


--------------------------INDEX EXPLAIN PLAN--------------------------
CREATE INDEX ExemplarIndex ON Exemplar(ID_EXEMPLAR, NAZOV, ZANER, POCET_KUSOV);
EXPLAIN PLAN FOR
SELECT
    Ex.ID_EXEMPLAR,
    Ex.NAZOV AS NAZOV_KNIHY,
    Ex.ZANER,
    COUNT(Po.ID_POZICANIE) AS POCET_POZICANICH,
    Ex.POCET_KUSOV
FROM
    Exemplar Ex
LEFT JOIN
    Pozicanie Po ON Ex.ID_EXEMPLAR = Po.POZ_EXEMPLAR
GROUP BY
    Ex.ID_EXEMPLAR, Ex.NAZOV, Ex.ZANER, Ex.POCET_KUSOV;
--- index explain plan select
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
DROP INDEX ExemplarIndex;
--------------------------INDEX EXPLAIN PLAN --------------------------


--------------------------MATERIALIZED VIEW --------------------------
DROP MATERIALIZED VIEW PracovnaPozicia_MV;
CREATE MATERIALIZED VIEW PracovnaPozicia_MV AS
SELECT
    Os.MENO, Os.PRIEZVISKO, Pr.POZICIA
FROM
    XVRABL06.Osoba Os
JOIN
    XVRABL06.Pracovnik Pr ON Os.ID_OSOBA = Pr.ID_PRACOVNIK;
--------------------------MATERIALIZED VIEW --------------------------

--------------------------SELECT CASE,WITH--------------------------
WITH Status_Rezervacie AS(
    SELECT
        ID_REZERVACIA,
        DATUM_ZACIATKU_R,
        DATUM_KONCA_R,
        CASE
            WHEN DATUM_KONCA_R < CURRENT_DATE THEN 'Ukončená'
            WHEN DATUM_ZACIATKU_R <= CURRENT_DATE AND DATUM_KONCA_R >= CURRENT_DATE THEN 'Rezervovaná'
        END AS Status_Rezervacie
    FROM Rezervacie
    ORDER BY Rezervacie.DATUM_ZACIATKU_R
)
SELECT * FROM Status_Rezervacie;
--------------------------SELECT CASE,WITH--------------------------

--------------------------TRIGGERS--------------------------
--update kusov pri pozicani exempalru||zrusenie pozicania
CREATE OR REPLACE TRIGGER UpdateKusovPozicanie
BEFORE INSERT OR DELETE ON Pozicanie
FOR EACH ROW
BEGIN
    IF DELETING THEN
        UPDATE Exemplar
        SET POCET_KUSOV = POCET_KUSOV + 1
        WHERE ID_EXEMPLAR = :OLD.POZ_EXEMPLAR;
    ELSIF INSERTING THEN
        UPDATE Exemplar
        SET POCET_KUSOV = POCET_KUSOV - 1
        WHERE ID_EXEMPLAR = :NEW.POZ_EXEMPLAR;
    END IF;
END;

--zrusenie rezervacii a pozicani pre osobu ktora je zrusena z databaze
CREATE OR REPLACE TRIGGER ZrusenieOsoby
BEFORE DELETE ON Osoba
FOR EACH ROW
BEGIN
    DELETE FROM Rezervacie
    WHERE VYTVORIL = :OLD.ID_OSOBA;
    DELETE FROM Pozicanie
    WHERE VYZDVIHNE = :OLD.ID_OSOBA;
END;
--------------------------TRIGGERS--------------------------

--------------------------DEMONSTRATION TRIGGERS--------------------------
-- povodna hodnota
SELECT * FROM Exemplar WHERE ID_EXEMPLAR = '54146';
INSERT INTO Pozicanie (ID_POZICANIE, DATUM_VYZDVYHNUTIA, DATUM_VRATENIA, PREDAVA, VYZDVIHNE, POZ_EXEMPLAR)
VALUES ('12345', TO_DATE('2024-04-30', 'YYYY-MM-DD'), TO_DATE('2024-05-15', 'YYYY-MM-DD'), 2, 3, '54146');
-- hodnota po pridani pozicania
SELECT * FROM Exemplar WHERE ID_EXEMPLAR = '54146';

-- rezervacie a pozicanie danej osoby
SELECT * FROM Rezervacie WHERE VYTVORIL = 4;
SELECT * FROM Pozicanie WHERE VYZDVIHNE = 4;
-- zrusenie osoby s danym id
DELETE FROM Citatel WHERE ID_CITATEL = 4;
-- zrusia sa jej pozicania a rezevacie
SELECT * FROM Rezervacie WHERE VYTVORIL = 4;
SELECT * FROM Pozicanie WHERE VYZDVIHNE = 4;
-- zrusilo sa pozicanie pocet kusov sa navysi
SELECT * FROM Exemplar WHERE ID_EXEMPLAR = '54146';
--------------------------DEMONSTRATION TRIGGERS--------------------------

--------------------------PROCEDURES--------------------------
-- procedura pre vypisanie priemerneho poctu pozicania
CREATE OR REPLACE PROCEDURE PriemernaDlzkaPozicania AS
    celkova_doba NUMBER := 0;
    pocet NUMBER := 0;
    rozdiel_dni NUMBER := 0;
    priemer NUMBER;
    datum_vyzdvihnutia Pozicanie.DATUM_VYZDVYHNUTIA%TYPE;
    datum_vratenia Pozicanie.DATUM_VRATENIA%TYPE;
    CURSOR c_pozicanie IS
        SELECT DATUM_VYZDVYHNUTIA, DATUM_VRATENIA
        FROM Pozicanie;
BEGIN
    OPEN c_pozicanie;
    FETCH c_pozicanie INTO datum_vyzdvihnutia, datum_vratenia;
    LOOP
        EXIT WHEN c_pozicanie%NOTFOUND;

        rozdiel_dni := datum_vratenia - datum_vyzdvihnutia;
        celkova_doba := celkova_doba + rozdiel_dni;
        pocet := pocet + 1;

        FETCH c_pozicanie INTO datum_vyzdvihnutia, datum_vratenia;
    END LOOP;
    CLOSE c_pozicanie;
    BEGIN
        priemer := celkova_doba / pocet;
        DBMS_OUTPUT.PUT_LINE('Priemerná dĺžka požičania: '  || priemer || ' dní.');
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('Delenie nulou.');
    END;
END;

-- procedura pre vypis aky autor ake knihy napisal  vypis:(Meno autora, dane knihy + ich zaner, pocet napisanych knih)
CREATE OR REPLACE PROCEDURE KnihyOdAutora(
    in_meno_autor IN Autor.MENO%TYPE
) AS
    id_autora Autor.ID_AUTOR%TYPE;
    pocet_knih NUMBER := 0;
BEGIN
    SELECT ID_AUTOR INTO id_autora
    FROM Autor
    WHERE MENO = in_meno_autor;

    DBMS_OUTPUT.PUT_LINE('Autor: ' || in_meno_autor);
    FOR zaznam_knih IN (
        SELECT Ex.NAZOV AS nazov_knihy, Ex.ZANER AS zaner_knihy
        FROM Exemplar Ex
        JOIN Kniha Kn ON Kn.ID_KNIHA = Ex.ID_EXEMPLAR
        WHERE Kn.AUTOR = id_autora
    ) LOOP
        pocet_knih := pocet_knih + 1;
        DBMS_OUTPUT.PUT_LINE('  Kniha: ' || zaznam_knih.nazov_knihy);
        DBMS_OUTPUT.PUT_LINE('    Zaner: ' || zaznam_knih.zaner_knihy);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Pocet napisanych knih: ' || pocet_knih);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Dany autor neexistuje.');
END;
--------------------------PROCEDURES--------------------------

--------------------------PROCEDURES CALL--------------------------
BEGIN
    PriemernaDlzkaPozicania();
END;

BEGIN
    KnihyOdAutora(' de Saint-Exupery');
END;
--------------------------PROCEDURES CALL--------------------------

--------------------------GRANT RIGHTS--------------------------
GRANT ALL ON Citatel TO XVICEN10;
GRANT ALL ON Pracovnik TO XVICEN10;
GRANT ALL ON Osoba TO XVICEN10;
GRANT ALL ON Pozicanie TO XVICEN10;
GRANT ALL ON Rezervacie TO XVICEN10;
GRANT ALL ON Casopis TO XVICEN10;
GRANT ALL ON Autor TO XVICEN10;
GRANT ALL ON Kniha TO XVICEN10;
GRANT ALL ON Exemplar TO XVICEN10;
GRANT ALL ON PracovnaPozicia_MV TO XVICEN10;
GRANT EXECUTE ON PriemernaDlzkaPozicania TO XVICEN10;
GRANT EXECUTE ON KnihyOdAutora TO XVICEN10;
--------------------------GRANT RIGHTS--------------------------
