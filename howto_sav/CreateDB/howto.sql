-- phpMyAdmin SQL Dump
-- version 3.3.7deb6
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 13, 2011 at 10:14 PM
-- Server version: 5.1.49
-- PHP Version: 5.3.3-7+squeeze3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `howto`
--

-- --------------------------------------------------------

--
-- Table structure for table `Annees`
--

CREATE TABLE IF NOT EXISTS `annees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `annee_courante` int(11) NOT NULL,
  `mois_courant` int(11) NOT NULL,
  `jour_courant` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Classements`
--

CREATE TABLE IF NOT EXISTS `classements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `points` int(11) NOT NULL DEFAULT '0',
  `victoire` int(11) NOT NULL DEFAULT '0',
  `defaite` int(11) NOT NULL DEFAULT '0',
  `nul` int(11) NOT NULL DEFAULT '0',
  `bp` int(11) NOT NULL DEFAULT '0',
  `bc` int(11) NOT NULL DEFAULT '0',
  `ext_victoire` int(11) NOT NULL DEFAULT '0',
  `ext_defaite` int(11) NOT NULL DEFAULT '0',
  `ext_nul` int(11) NOT NULL DEFAULT '0',
  `ext_points` int(11) NOT NULL DEFAULT '0',
  `ext_bp` int(11) NOT NULL DEFAULT '0',
  `ext_bc` int(11) NOT NULL DEFAULT '0',
  `dom_victoire` int(11) NOT NULL DEFAULT '0',
  `dom_defaite` int(11) NOT NULL DEFAULT '0',
  `dom_nul` int(11) NOT NULL DEFAULT '0',
  `dom_points` int(11) NOT NULL DEFAULT '0',
  `dom_bp` int(11) NOT NULL DEFAULT '0',
  `dom_bc` int(11) NOT NULL DEFAULT '0',
  `historique_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Clubs`
--

CREATE TABLE IF NOT EXISTS `clubs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `president` varchar(50) NOT NULL,
  `couleur1` int(11) NOT NULL,
  `couleur2` int(11) NOT NULL,
  `stade` varchar(100) NOT NULL,
  `capacite_stade` int(11) NOT NULL,
  `argent` int(11) NOT NULL,
  `centre_de_formation` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Contrats`
--

CREATE TABLE IF NOT EXISTS `contrats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `anne_debut` int(11) NOT NULL,
  `mois_debut` int(11) NOT NULL,
  `duree` int(11) NOT NULL,
  `anne_fin` int(11) NOT NULL,
  `mois_fin` int(11) NOT NULL,
  `salaire` int(11) NOT NULL,
  `equipe_id` int(11) NOT NULL,
  `joueur_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Divisions`
--

CREATE TABLE IF NOT EXISTS `divisions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Entraineurs`
--

CREATE TABLE IF NOT EXISTS `entraineurs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(30) NOT NULL,
  `prenom` varchar(30) NOT NULL,
  `pseudo` varchar(30) NOT NULL,
  `equipe_id` int(11) NOT NULL,
  `mail` varchar(50) NOT NULL,
  `pwd` varchar(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Equipes`
--

CREATE TABLE IF NOT EXISTS `equipes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) NOT NULL,
  `club_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Historiques`
--

CREATE TABLE IF NOT EXISTS `historiques` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `saison_id` int(11) NOT NULL,
  `equipe_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Joueurs`
--

CREATE TABLE IF NOT EXISTS `joueurs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `age` int(11) NOT NULL,
  `xp` int(11) NOT NULL,
  `talent` int(11) NOT NULL,
  `tactique` int(11) NOT NULL,
  `technique` int(11) NOT NULL,
  `physique` int(11) NOT NULL,
  `vitesse` int(11) NOT NULL,
  `mental` int(11) NOT NULL,
  `off` int(11) NOT NULL,
  `def` int(11) NOT NULL,
  `drt` int(11) NOT NULL,
  `ctr` int(11) NOT NULL,
  `gch` int(11) NOT NULL,
  `liste_transfert` tinyint(1) NOT NULL,
  `liste_pret` tinyint(1) NOT NULL,
  `condition` int(11) NOT NULL DEFAULT '100',
  `blessure` int(11) NOT NULL DEFAULT '0',
  `moral` int(11) NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Matchs`
--

CREATE TABLE IF NOT EXISTS `matchs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `equipe1_id` int(11) NOT NULL,
  `equipe2_id` int(11) NOT NULL,
  `score1` int(11) DEFAULT NULL,
  `score2` int(11) DEFAULT NULL,
  `num_journee` int(11) NOT NULL,
  `saison_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Staffs`
--

CREATE TABLE IF NOT EXISTS `staffs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(30) NOT NULL,
  `prenom` varchar(30) NOT NULL,
  `age` int(11) NOT NULL,
  `xP` int(11) NOT NULL,
  `talent` int(11) NOT NULL,
  `physique` int(11) NOT NULL,
  `technique` int(11) NOT NULL,
  `tactique` int(11) NOT NULL,
  `mental` int(11) NOT NULL,
  `medecine` int(11) NOT NULL,
  `recrutement` int(11) NOT NULL,
  `off` int(11) NOT NULL,
  `def` int(11) NOT NULL,
  `moral` int(11) NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Saisons`
--

CREATE TABLE IF NOT EXISTS `saisons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `annee_id` int(11) NOT NULL,
  `division_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------
--
-- Table structure for table `Staff_Contrats`
--

CREATE TABLE IF NOT EXISTS `staff_contrats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `annee_debut` int(11) NOT NULL,
  `mois_debut` int(11) NOT NULL,
  `duree` int(11) NOT NULL,
  `annee_fin` int(11) NOT NULL,
  `mois_fin` int(11) NOT NULL,
  `salaire` int(11) NOT NULL,
  `equipe_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `poste` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
