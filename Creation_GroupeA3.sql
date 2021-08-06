-- phpMyAdmin SQL Dump
-- version 4.0.4.2
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Mar 22 Décembre 2020 à 22:52
-- Version du serveur: 5.6.13
-- Version de PHP: 5.4.17

/*
FIchier : Creation_GroupeA3.sql
Auteurs : 
Merwane Rakkaoui 21914058
Ali Dabachil 21719405
Nom du groupe : A3

*/

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `tournoisportif`
--
CREATE DATABASE IF NOT EXISTS `tournoisportif` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `tournoisportif`;

DELIMITER $$
--
-- Fonctions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getNbSetsGagnes1Match`(`numM` INT) RETURNS int(11)
    NO SQL
BEGIN
	DECLARE nbS1 INT(5); 
	DECLARE v INT(5); 
	SELECT COUNT(*) INTO nbS1 FROM sets WHERE sets.numMatch = numM AND getVainqueurSet(numSet)=1;
    RETURN nbS1;
 END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNivE`(`numEq` INT, `numSp` INT) RETURNS int(11)
    NO SQL
BEGIN 
	DECLARE nb1 INT(5);
	DECLARE nb2 INT(5);
	DECLARE nb3 INT(5);
	DECLARE nb4 INT(5);
	DECLARE nb5 INT(5);
	DECLARE nb6 INT(5);
	DECLARE nb7 INT(5);

	SELECT COUNT(*) INTO nb1 FROM joueurjoue, joueur WHERE joueurjoue.numJoueur=joueur.numJoueur AND nivJoueur=1 AND numEquipe = numEq AND numSport = numSp;
	SELECT COUNT(*) INTO nb2 FROM joueurjoue, joueur WHERE joueurjoue.numJoueur=joueur.numJoueur AND nivJoueur=2 AND numEquipe = numEq AND numSport = numSp;
	SELECT COUNT(*) INTO nb3 FROM joueurjoue, joueur WHERE joueurjoue.numJoueur=joueur.numJoueur AND nivJoueur=3 AND numEquipe = numEq AND numSport = numSp;
	SELECT COUNT(*) INTO nb4 FROM joueurjoue, joueur WHERE joueurjoue.numJoueur=joueur.numJoueur AND nivJoueur=4 AND numEquipe = numEq AND numSport = numSp;
	SELECT COUNT(*) INTO nb5 FROM joueurjoue, joueur WHERE joueurjoue.numJoueur=joueur.numJoueur AND nivJoueur=5 AND numEquipe = numEq AND numSport = numSp;
	SELECT COUNT(*) INTO nb6 FROM joueurjoue, joueur WHERE joueurjoue.numJoueur=joueur.numJoueur AND nivJoueur=6 AND numEquipe = numEq AND numSport = numSp;
	SELECT COUNT(*) INTO nb7 FROM joueurjoue, joueur WHERE joueurjoue.numJoueur=joueur.numJoueur AND nivJoueur=7 AND numEquipe = numEq AND numSport = numSp;

	RETURN (1*nb1 + (1+4/7)*nb2 + (1+2*4/7)*nb3 + (1+3*4/7)*nb4 
            + (1+4*4/7)*nb5 + (1+5*4/7)*nb6 + (1+7*4/7)*nb7)/(nb1+nb2+nb3+nb4+nb5+nb6+nb7);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getVainqueurSet`(`numS` INT) RETURNS int(11)
    NO SQL
BEGIN
	DECLARE nbP1 INT(5); 
	DECLARE nbP2 INT(5); 
	DECLARE v INT(5); 

	SELECT nbPoints1 INTO nbP1 FROM sets WHERE numSet=numS; 
	SELECT nbPoints2 INTO nbP2 FROM sets WHERE numSet=numS; 

    IF nbP1 > nbP2 THEN SET v = 1;
    ELSEIF nbP2 = nbP1 THEN SET v = 0;
    ELSE SET v = 2;
    END IF;

    RETURN v;
 END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getWr`(`nomE` TEXT) RETURNS float
    DETERMINISTIC
BEGIN 
	DECLARE numE INT(5);
	DECLARE nbWin1 INT(5); 
	DECLARE nbWin2 INT(5); 
	DECLARE nbGames1 INT(5); 
	DECLARE nbGames2 INT(5); 
	SELECT numEquipe into numE FROM EQUIPE where nomE=nomEquipe;
	SELECT COUNT(*) INTO nbWin1 FROM matchs WHERE numEquipe1=numE AND vainqueur=1; 
	SELECT COUNT(*) INTO nbWin2 FROM matchs WHERE numEquipe2=numE AND vainqueur=2; 
	SELECT COUNT(*) INTO nbGames1 FROM matchs WHERE numEquipe1=numE; 
	SELECT COUNT(*) INTO nbGames2 FROM matchs WHERE numEquipe2=numE; 
	RETURN ((nbWin1+nbWin2)/(nbGames1+nbGames2)); 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `equipe`
--

CREATE TABLE IF NOT EXISTS `equipe` (
  `numEquipe` int(4) NOT NULL,
  `nomEquipe` varchar(20) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`numEquipe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `equipe`
--

INSERT INTO `equipe` (`numEquipe`, `nomEquipe`) VALUES
(1, 'a'),
(2, 'b'),
(3, 'c'),
(4, 'd'),
(5, 'e'),
(6, 'f'),
(7, 'g');

-- --------------------------------------------------------

--
-- Structure de la table `equipejoue`
--

CREATE TABLE IF NOT EXISTS `equipejoue` (
  `numEquipe` int(11) NOT NULL,
  `numSport` int(11) NOT NULL,
  `nivEquipe` int(11) NOT NULL,
  PRIMARY KEY (`numEquipe`,`numSport`),
  KEY `numEquipe` (`numEquipe`),
  KEY `numSport` (`numSport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Structure de la table `evenement`
--

CREATE TABLE IF NOT EXISTS `evenement` (
  `numEvenement` int(4) NOT NULL,
  `numSport` int(11) NOT NULL,
  `nomEvenement` text COLLATE utf8_bin NOT NULL,
  `dateEvenement` date NOT NULL,
  `lieuEvenement` text COLLATE utf8_bin NOT NULL,
  `nbTournoi` int(11) NOT NULL,
  `typeJeu` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`numEvenement`),
  KEY `numSport` (`numSport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `evenement`
--

INSERT INTO `evenement` (`numEvenement`, `numSport`, `nomEvenement`, `dateEvenement`, `lieuEvenement`, `nbTournoi`, `typeJeu`) VALUES
(1, 2, 'FêteNat', '2020-07-14', 'Montpellier', 1, '3x3');

-- --------------------------------------------------------

--
-- Structure de la table `inscription`
--

CREATE TABLE IF NOT EXISTS `inscription` (
  `numEquipe` int(11) NOT NULL,
  `numEvenement` int(11) NOT NULL,
  `droitPaye` tinyint(1) NOT NULL DEFAULT '0',
  `dateInscription` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`numEquipe`,`numEvenement`),
  KEY `numEquipe` (`numEquipe`),
  KEY `numEvenement` (`numEvenement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `inscription`
--

INSERT INTO `inscription` (`numEquipe`, `numEvenement`, `droitPaye`, `dateInscription`) VALUES
(1, 1, 0, '2020-12-22 19:04:57'),
(2, 1, 0, '2020-12-22 19:05:20'),
(3, 1, 0, '2020-12-22 19:05:57'),
(4, 1, 0, '2020-12-22 19:05:57'),
(5, 1, 0, '2020-12-22 19:05:57'),
(6, 1, 0, '2020-12-22 19:05:57'),
(7, 1, 0, '2020-12-22 19:05:57');

-- --------------------------------------------------------

--
-- Structure de la table `joueur`
--

CREATE TABLE IF NOT EXISTS `joueur` (
  `numJoueur` int(4) NOT NULL,
  `numEquipe` int(4) NOT NULL,
  `nomJoueur` text COLLATE utf8_bin NOT NULL,
  `prenomJoueur` text COLLATE utf8_bin NOT NULL,
  `ageJoueur` int(3) NOT NULL,
  PRIMARY KEY (`numJoueur`),
  KEY `numEquipe` (`numEquipe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Contient la liste des joueurs';

--
-- Contenu de la table `joueur`
--

INSERT INTO `joueur` (`numJoueur`, `numEquipe`, `nomJoueur`, `prenomJoueur`, `ageJoueur`) VALUES
(1, 1, 'A', 'Aa', 20),
(2, 1, 'B', 'Bb', 21),
(3, 1, 'C', 'Cc', 22),
(4, 2, 'D', 'Dd', 24),
(5, 2, 'E', 'Ee', 25),
(6, 2, 'F', 'Ff', 26),
(7, 3, 'G', 'Gg', 27),
(8, 3, 'H', 'Hh', 28),
(9, 3, 'I', 'Ii', 29),
(10, 4, 'J', 'Jj', 30),
(11, 4, 'K', 'Kk', 31),
(12, 4, 'L', 'Ll', 32),
(13, 5, 'M', 'Mm', 33),
(14, 5, 'N', 'Nn', 34),
(15, 5, 'O', 'Oo', 35),
(16, 6, 'P', 'Pp', 36),
(17, 6, 'Q', 'Qq', 37),
(18, 6, 'R', 'Rr', 38),
(19, 7, 'S', 'Ss', 39),
(20, 7, 'T', 'Tt', 40),
(21, 7, 'U', 'Uu', 41);

--
-- Déclencheurs `joueur`
--
DROP TRIGGER IF EXISTS `setNivJoueur`;
DELIMITER //
CREATE TRIGGER `setNivJoueur` AFTER INSERT ON `joueur`
 FOR EACH ROW BEGIN
	DECLARE i INT(5);
	SET i=1;
    WHILE i < 5 do
		INSERT INTO joueurjoue VALUES (new.numJoueur, i,1);
        SET i = i + 1;
    END WHILE;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `joueurjoue`
--

CREATE TABLE IF NOT EXISTS `joueurjoue` (
  `numJoueur` int(11) NOT NULL,
  `numSport` int(11) NOT NULL,
  `nivJoueur` enum('loisir','departemental','regional','N3','N2','elite','pro') COLLATE utf8_bin NOT NULL DEFAULT 'loisir',
  PRIMARY KEY (`numJoueur`,`numSport`),
  KEY `numJoueur` (`numJoueur`),
  KEY `numSport` (`numSport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `joueurjoue`
--

INSERT INTO `joueurjoue` (`numJoueur`, `numSport`, `nivJoueur`) VALUES
(3, 1, 'loisir'),
(3, 2, 'loisir'),
(3, 3, 'loisir'),
(3, 4, 'loisir'),
(4, 1, 'loisir'),
(4, 2, 'loisir'),
(4, 3, 'loisir'),
(4, 4, 'loisir'),
(5, 1, 'loisir'),
(5, 2, 'loisir'),
(5, 3, 'loisir'),
(5, 4, 'loisir'),
(6, 1, 'loisir'),
(6, 2, 'loisir'),
(6, 3, 'loisir'),
(6, 4, 'loisir'),
(7, 1, 'loisir'),
(7, 2, 'loisir'),
(7, 3, 'loisir'),
(7, 4, 'loisir'),
(8, 1, 'loisir'),
(8, 2, 'loisir'),
(8, 3, 'loisir'),
(8, 4, 'loisir'),
(9, 1, 'loisir'),
(9, 2, 'loisir'),
(9, 3, 'loisir'),
(9, 4, 'loisir'),
(10, 1, 'loisir'),
(10, 2, 'loisir'),
(10, 3, 'loisir'),
(10, 4, 'loisir'),
(11, 1, 'loisir'),
(11, 2, 'loisir'),
(11, 3, 'loisir'),
(11, 4, 'loisir'),
(12, 1, 'loisir'),
(12, 2, 'loisir'),
(12, 3, 'loisir'),
(12, 4, 'loisir'),
(13, 1, 'loisir'),
(13, 2, 'loisir'),
(13, 3, 'loisir'),
(13, 4, 'loisir'),
(14, 1, 'loisir'),
(14, 2, 'loisir'),
(14, 3, 'loisir'),
(14, 4, 'loisir'),
(15, 1, 'loisir'),
(15, 2, 'loisir'),
(15, 3, 'loisir'),
(15, 4, 'loisir'),
(16, 1, 'loisir'),
(16, 2, 'loisir'),
(16, 3, 'loisir'),
(16, 4, 'loisir'),
(17, 1, 'loisir'),
(17, 2, 'loisir'),
(17, 3, 'loisir'),
(17, 4, 'loisir'),
(18, 1, 'loisir'),
(18, 2, 'loisir'),
(18, 3, 'loisir'),
(18, 4, 'loisir'),
(19, 1, 'loisir'),
(19, 2, 'loisir'),
(19, 3, 'loisir'),
(19, 4, 'loisir'),
(20, 1, 'loisir'),
(20, 2, 'loisir'),
(20, 3, 'loisir'),
(20, 4, 'loisir'),
(21, 1, 'loisir'),
(21, 2, 'loisir'),
(21, 3, 'loisir'),
(21, 4, 'loisir');

--
-- Déclencheurs `joueurjoue`
--
DROP TRIGGER IF EXISTS `updateDELETE_nivEquipe`;
DELIMITER //
CREATE TRIGGER `updateDELETE_nivEquipe` AFTER DELETE ON `joueurjoue`
 FOR EACH ROW BEGIN
    DECLARE numE INT(5);
    SELECT numEquipe into numE FROM joueur WHERE numJoueur=old.numJoueur;
    /*IF not EXISTs (SELECT * FROM equipeJoue WHERE numE=numEquipe)
      THEN
        INSERT INTO equipeJoue values (numE,new.numSport, getNivE(numE,new.numSport));
    ELSE
*/
	UPDATE tournoisportif.equipeJoue 
	SET equipeJoue.nivEquipe = getNivE(numE,old.numSport)
	WHERE numE=numEquipe AND numSport=old.numSport;
	
   /*END IF;*/
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `updateINSERT_nivEquipe`;
DELIMITER //
CREATE TRIGGER `updateINSERT_nivEquipe` AFTER INSERT ON `joueurjoue`
 FOR EACH ROW BEGIN
    DECLARE numE INT(5);
    SELECT numEquipe into numE FROM joueur WHERE numJoueur=new.numJoueur;
    /*IF not EXISTs (SELECT * FROM equipeJoue WHERE numE=numEquipe)
      THEN
        INSERT INTO equipeJoue values (numE,new.numSport, getNivE(numE,new.numSport));
    ELSE
*/
	UPDATE tournoisportif.equipeJoue 
	SET equipeJoue.nivEquipe = getNivE(numE,new.numSport)
	WHERE numE=numEquipe AND numSport=new.numSport;

   /*END IF;*/
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `updateUPDATE_nivEquipe`;
DELIMITER //
CREATE TRIGGER `updateUPDATE_nivEquipe` AFTER UPDATE ON `joueurjoue`
 FOR EACH ROW BEGIN
    DECLARE numE INT(5);
    SELECT numEquipe into numE FROM joueur WHERE numJoueur=new.numJoueur;
    /*IF not EXISTs (SELECT * FROM equipeJoue WHERE numE=numEquipe)
      THEN
        INSERT INTO equipeJoue values (numE,new.numSport, getNivE(numE,new.numSport));
    ELSE
*/
	UPDATE tournoisportif.equipeJoue 
	SET equipeJoue.nivEquipe = getNivE(numE,new.numSport)	
	WHERE numE=numEquipe AND numSport=new.numSport;

	
   /*END IF;*/
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `matchs`
--

CREATE TABLE IF NOT EXISTS `matchs` (
  `numMatch` int(11) NOT NULL,
  `numEquipe1` int(11) NOT NULL,
  `numEquipe2` int(11) NOT NULL,
  `numPoule` int(11) NOT NULL,
  `vainqueur` int(11) DEFAULT NULL,
  PRIMARY KEY (`numMatch`),
  KEY `numEquipe1` (`numEquipe1`),
  KEY `numEquipe2` (`numEquipe2`),
  KEY `numPoule` (`numPoule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `matchs`
--

INSERT INTO `matchs` (`numMatch`, `numEquipe1`, `numEquipe2`, `numPoule`, `vainqueur`) VALUES
(1, 1, 3, 1, 2),
(2, 1, 5, 1, 2),
(3, 1, 7, 1, 2),
(4, 3, 5, 1, 2),
(5, 3, 7, 1, 2),
(6, 5, 7, 1, 2),
(7, 2, 4, 2, 1),
(8, 2, 6, 2, 1),
(9, 4, 6, 2, 1),
(10, 4, 7, 3, 2),
(11, 2, 5, 4, 2),
(12, 5, 7, 5, 2),
(13, 2, 4, 6, 2),
(14, 1, 3, 7, 1),
(15, 1, 6, 7, 2),
(16, 3, 6, 7, 2);

-- --------------------------------------------------------

--
-- Structure de la table `poule`
--

CREATE TABLE IF NOT EXISTS `poule` (
  `numPoule` int(4) NOT NULL,
  `numTour` int(11) NOT NULL,
  `nomPoule` text COLLATE utf8_bin NOT NULL,
  `nbSets` int(11) NOT NULL,
  `nbPoints` int(11) NOT NULL,
  PRIMARY KEY (`numPoule`),
  KEY `numTour` (`numTour`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `poule`
--

INSERT INTO `poule` (`numPoule`, `numTour`, `nomPoule`, `nbSets`, `nbPoints`) VALUES
(1, 1, 'Poule1', 1, 25),
(2, 1, 'Poule2', 2, 25),
(3, 2, 'Poule1', 1, 25),
(4, 2, 'Poule2', 1, 25),
(5, 3, 'grande finale', 1, 25),
(6, 3, 'petite finale', 1, 25),
(7, 4, 'Poule1', 1, 25);

-- --------------------------------------------------------

--
-- Structure de la table `respoule`
--

CREATE TABLE IF NOT EXISTS `respoule` (
  `numEquipe` int(11) NOT NULL,
  `numPoule` int(11) NOT NULL,
  `rankPoule` int(11) DEFAULT NULL,
  PRIMARY KEY (`numEquipe`,`numPoule`),
  KEY `numEquipe` (`numEquipe`),
  KEY `numPoule` (`numPoule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `respoule`
--

INSERT INTO `respoule` (`numEquipe`, `numPoule`, `rankPoule`) VALUES
(1, 1, NULL),
(1, 7, NULL),
(2, 2, NULL),
(2, 4, NULL),
(2, 6, NULL),
(3, 1, NULL),
(3, 7, NULL),
(4, 2, NULL),
(4, 3, NULL),
(4, 6, NULL),
(5, 1, NULL),
(5, 4, NULL),
(5, 5, NULL),
(6, 2, NULL),
(6, 7, NULL),
(7, 1, NULL),
(7, 3, NULL),
(7, 5, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `sets`
--

CREATE TABLE IF NOT EXISTS `sets` (
  `numSet` int(11) NOT NULL AUTO_INCREMENT,
  `numMatch` int(11) NOT NULL,
  `nbPoints1` int(11) NOT NULL,
  `nbPoints2` int(11) NOT NULL,
  PRIMARY KEY (`numSet`),
  KEY `numMatch` (`numMatch`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=22 ;

--
-- Contenu de la table `sets`
--

INSERT INTO `sets` (`numSet`, `numMatch`, `nbPoints1`, `nbPoints2`) VALUES
(1, 1, 6, 25),
(2, 2, 8, 25),
(3, 3, 15, 25),
(4, 4, 16, 25),
(5, 5, 14, 25),
(6, 6, 22, 25),
(7, 7, 25, 20),
(8, 7, 25, 19),
(9, 8, 25, 12),
(10, 8, 25, 16),
(11, 9, 25, 20),
(12, 9, 25, 4),
(13, 10, 14, 25),
(14, 11, 23, 25),
(15, 12, 12, 25),
(16, 13, 23, 25),
(17, 14, 25, 2),
(18, 15, 19, 25),
(19, 16, 16, 25);

-- --------------------------------------------------------

--
-- Structure de la table `sport`
--

CREATE TABLE IF NOT EXISTS `sport` (
  `numSport` int(11) NOT NULL,
  `nomSport` enum('petanque','volley','tennis','foot') COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`numSport`),
  UNIQUE KEY `nomSport` (`nomSport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `sport`
--

INSERT INTO `sport` (`numSport`, `nomSport`) VALUES
(1, 'petanque'),
(2, 'volley'),
(3, 'tennis'),
(4, 'foot');

--
-- Déclencheurs `sport`
--
DROP TRIGGER IF EXISTS `nomSportnotNULL`;
DELIMITER //
CREATE TRIGGER `nomSportnotNULL` BEFORE INSERT ON `sport`
 FOR EACH ROW BEGIN
	IF new.nomSport=0
	THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = "Veuillez donner un nom au sport.";
	END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `tour`
--

CREATE TABLE IF NOT EXISTS `tour` (
  `numTour` int(11) NOT NULL,
  `numTournoi` int(11) NOT NULL,
  `nomTour` text COLLATE utf8_bin NOT NULL,
  `formule` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`numTour`),
  KEY `numTournoi` (`numTournoi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `tour`
--

INSERT INTO `tour` (`numTour`, `numTournoi`, `nomTour`, `formule`) VALUES
(1, 1, 'Tour1', '7 equipes 2 poules'),
(2, 1, 'Tour2', '4 equipes 2 poules'),
(3, 1, 'Tour3 ', '2 equipes 1 poule'),
(4, 2, 'Tour1', '3 equipes 1 poule');

-- --------------------------------------------------------

--
-- Structure de la table `tournoi`
--

CREATE TABLE IF NOT EXISTS `tournoi` (
  `numTournoi` int(4) NOT NULL,
  `numEvenement` int(4) NOT NULL,
  `nomTournoi` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`numTournoi`),
  KEY `numEvenement` (`numEvenement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `tournoi`
--

INSERT INTO `tournoi` (`numTournoi`, `numEvenement`, `nomTournoi`) VALUES
(1, 1, 'principal'),
(2, 1, 'consolante');

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `equipejoue`
--
ALTER TABLE `equipejoue`
  ADD CONSTRAINT `fk_equipejoue_equipe` FOREIGN KEY (`numEquipe`) REFERENCES `equipe` (`numEquipe`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `evenement`
--
ALTER TABLE `evenement`
  ADD CONSTRAINT `fk_sport_evenement` FOREIGN KEY (`numSport`) REFERENCES `sport` (`numSport`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `inscription`
--
ALTER TABLE `inscription`
  ADD CONSTRAINT `fk_inscription_equipe` FOREIGN KEY (`numEquipe`) REFERENCES `equipe` (`numEquipe`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inscription_evenement` FOREIGN KEY (`numEvenement`) REFERENCES `evenement` (`numEvenement`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `joueur`
--
ALTER TABLE `joueur`
  ADD CONSTRAINT `fk_joueur_equipe` FOREIGN KEY (`numEquipe`) REFERENCES `equipe` (`numEquipe`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `joueurjoue`
--
ALTER TABLE `joueurjoue`
  ADD CONSTRAINT `fk_sport_joue` FOREIGN KEY (`numSport`) REFERENCES `sport` (`numSport`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_joueur_joue` FOREIGN KEY (`numJoueur`) REFERENCES `joueur` (`numJoueur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `matchs`
--
ALTER TABLE `matchs`
  ADD CONSTRAINT `fk_match_equipe1` FOREIGN KEY (`numEquipe1`) REFERENCES `equipe` (`numEquipe`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_match_equipe2` FOREIGN KEY (`numEquipe2`) REFERENCES `equipe` (`numEquipe`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_match_poule` FOREIGN KEY (`numPoule`) REFERENCES `poule` (`numPoule`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `poule`
--
ALTER TABLE `poule`
  ADD CONSTRAINT `fk_poule_tour` FOREIGN KEY (`numTour`) REFERENCES `tour` (`numTour`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `respoule`
--
ALTER TABLE `respoule`
  ADD CONSTRAINT `dk_respoule_poule` FOREIGN KEY (`numPoule`) REFERENCES `poule` (`numPoule`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_respoule_equipe` FOREIGN KEY (`numEquipe`) REFERENCES `equipe` (`numEquipe`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `sets`
--
ALTER TABLE `sets`
  ADD CONSTRAINT `fk_match_set` FOREIGN KEY (`numMatch`) REFERENCES `matchs` (`numMatch`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `tour`
--
ALTER TABLE `tour`
  ADD CONSTRAINT `fk_tour_tournoi` FOREIGN KEY (`numTournoi`) REFERENCES `tournoi` (`numTournoi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `tournoi`
--
ALTER TABLE `tournoi`
  ADD CONSTRAINT `fk_evenement_tournoi` FOREIGN KEY (`numEvenement`) REFERENCES `evenement` (`numEvenement`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
