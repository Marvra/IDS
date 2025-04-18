DROP TABLE IF EXISTS Citatel;
DROP TABLE IF EXISTS Pracovnik;
DROP TABLE IF EXISTS Osoba;
DROP TABLE IF EXISTS Pozicanie;
DROP TABLE IF EXISTS Rezervacie;
DROP TABLE IF EXISTS Casopis;
DROP TABLE IF EXISTS Kniha;
DROP TABLE IF EXISTS Exemplar;

CREATE TABLE Exemplar(
  ID_EXEMPLAR INT PRIMARY KEY NOT NULL,
  NAZOV VARCHAR(255) NOT NULL,
  ZANER VARCHAR(255) NOT NULL,
  ROK_VYDANIA YEAR NOT NULL,
  VYDAVATELSTVO VARCHAR(255) NOT NULL,
  POCET_KUSOV INT
);

CREATE TABLE Kniha(
  ID_KNIHA INT PRIMARY KEY NOT NULL,
  AUTOR VARCHAR(255) NOT NULL,
  CONSTRAINT FK_ID_EXEMPLAR FOREIGN KEY (ID_KNIHA) REFERENCES Exemplar(ID_EXEMPLAR) ON DELETE SET NULL
);

CREATE TABLE Casopis(
  ID_CASOPIS INT PRIMARY KEY NOT NULL,
  FREKVENCIA_VYDAVANIA VARCHAR(255) NOT NULL, --contrain na mesicny rocny tyzdeny denny
  CONSTRAINT FK_ID_EXEMPLAR FOREIGN KEY (ID_CASOPIS) REFERENCES Exemplar(ID_EXEMPLAR) ON DELETE SET NULL
);

CREATE TABLE Rezervacie(
  ID_REZERVACIA INT PRIMARY KEY NOT NULL,
  DATUM_ZACIATKU_R DATE NOT NULL,
  DATUM_KONCA_R DATE NOT NULL

--  REZERVOVANE
-- SPRAVOVANIE
--  CONSTRAIN FK_ID_EXEMPLAR FOREIGN KEY (ID_CASOPIS) REFERENCES Exemplar(ID_EXEMPLAR) ON DELETE SET NULL
-- CONSTRAIN FK_ID_EXEMPLAR FOREIGN KEY (ID_CASOPIS) REFERENCES Exemplar(ID_EXEMPLAR) ON DELETE SET NULL
);

CREATE TABLE Pozicanie(
  ID_POZICANIE INT PRIMARY KEY NOT NULL,
  DATUM_VYZDVYHNUTIA_C DATE NOT NULL,
  DATU_VRATENIA DATE NOT NULL
);

CREATE TABLE Osoba(
  ID_OSOBA INT PRIMARY KEY NOT NULL,
  MENO VARCHAR(20) NOT NULL,
  PRIEZVISKO VARCHAR(50) NOT NULL,
  TEL_CISLO VARCHAR(10),-- specialny regex constain
  EMAIL VARCHAR(80), -- constrains ze musi byt dane bud telc alebo mail
  PSC VARCHAR(5) NOT NULL, -- specialny regex constraint
  ADRESA VARCHAR(50) NOT NULL,
  DATUM_NARODENIA DATE NOT NULL
);

CREATE TABLE Citatel(
  ID_CITATEL INT PRIMARY KEY NOT NULL,

  CONSTRAINT FK_ID_OSOBA FOREIGN KEY (ID_CITATEL) REFERENCES Osoba(ID_OSOBA) ON DELETE SET NULL
);

CREATE TABLE Pracovnik(
  ID_PRACOVNIK INT PRIMARY KEY NOT NULL,
  POZICIA VARCHAR(30) NOT NULL,

  CONSTRAINT FK_ID_OSOBA FOREIGN KEY (ID_PRACOVNIK) REFERENCES Osoba(ID_OSOBA) ON DELETE SET NULL
);

INSERT INTO Exemplar (ID_EXEMPLAR, NAZOV, ZANER, ROK_VYDANIA, VYDAVATELSTVO, POCET_KUSOV)
VALUES 
    (1, 'Book 1', 'Fiction', 2020, 'Publisher A', 100),
    (2, 'Casopis 2', 'Non-Fiction', 2019, 'Publisher B', 50),
    (3, 'Book 3', 'Science Fiction', 2021, 'Publisher C', 75);
    
INSERT INTO Kniha
VALUES
	(1, 'JRR TOLKIEN'),
    (3, 'SAPKOWSKI');
    
INSERT INTO Casopis
VALUES (2, 'Mesacne');
