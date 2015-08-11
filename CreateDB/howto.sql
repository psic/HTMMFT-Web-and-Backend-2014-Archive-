-- phpMyAdmin SQL Dump
-- version 3.5.3
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Dim 02 Décembre 2012 à 20:42
-- Version du serveur: 5.5.28
-- Version de PHP: 5.4.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `howto`
--

-- --------------------------------------------------------

--
-- Structure de la table `annees`
--

CREATE TABLE IF NOT EXISTS `annees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `annee_courante` int(11) NOT NULL,
  `mois_courant` int(11) NOT NULL,
  `jour_courant` int(11) NOT NULL,
  `journee` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Structure de la table `classements`
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
  `nb_journee` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=129 ;

-- --------------------------------------------------------

--
-- Structure de la table `clubs`
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=129 ;

-- --------------------------------------------------------

--
-- Structure de la table `contrats`
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2915 ;

-- --------------------------------------------------------

--
-- Structure de la table `divisions`
--

CREATE TABLE IF NOT EXISTS `divisions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

-- --------------------------------------------------------

--
-- Structure de la table `equipes`
--

CREATE TABLE IF NOT EXISTS `equipes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) NOT NULL,
  `club_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=129 ;

-- --------------------------------------------------------

--
-- Structure de la table `feuilles_de_matchs`
--

CREATE TABLE IF NOT EXISTS `feuilles_de_matchs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stats_j1_id` int(11) DEFAULT NULL,
  `stats_j2_id` int(11) DEFAULT NULL,
  `stats_j3_id` int(11) DEFAULT NULL,
  `stats_j4_id` int(11) DEFAULT NULL,
  `stats_j5_id` int(11) DEFAULT NULL,
  `stats_j6_id` int(11) DEFAULT NULL,
  `stats_j7_id` int(11) DEFAULT NULL,
  `stats_j8_id` int(11) DEFAULT NULL,
  `stats_j9_id` int(11) DEFAULT NULL,
  `stats_j10_id` int(11) DEFAULT NULL,
  `stats_j11_id` int(11) DEFAULT NULL,
  `stats_j12_id` int(11) DEFAULT NULL,
  `stats_j13_id` int(11) DEFAULT NULL,
  `stats_j14_id` int(11) DEFAULT NULL,
  `stats_j15_id` int(11) DEFAULT NULL,
  `stats_j16_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci AUTO_INCREMENT=1921 ;

-- --------------------------------------------------------

--
-- Structure de la table `historiques`
--

CREATE TABLE IF NOT EXISTS `historiques` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `saison_id` int(11) NOT NULL,
  `equipe_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=129 ;

-- --------------------------------------------------------

--
-- Structure de la table `joueurs`
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
  `cond` int(11) NOT NULL DEFAULT '100',
  `blessure` int(11) NOT NULL DEFAULT '0',
  `moral` int(11) NOT NULL DEFAULT '100',
  `numero` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3416 ;

-- --------------------------------------------------------

--
-- Structure de la table `matchs`
--

CREATE TABLE IF NOT EXISTS `matchs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `equipe1_id` int(11) NOT NULL,
  `equipe2_id` int(11) NOT NULL,
  `score1` int(11) DEFAULT NULL,
  `score2` int(11) DEFAULT NULL,
  `num_journee` int(11) NOT NULL,
  `saison_id` int(11) NOT NULL,
  `fdm_equipe1` int(11) DEFAULT NULL,
  `fdm_equipe2` int(11) DEFAULT NULL,
  `tactique_equipe1` int(11) DEFAULT NULL,
  `tactique_equipe2` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1921 ;

-- --------------------------------------------------------

--
-- Structure de la table `positions`
--

CREATE TABLE IF NOT EXISTS `positions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `x1` int(11) DEFAULT NULL,
  `y1` int(11) DEFAULT NULL,
  `x2` int(11) DEFAULT NULL,
  `y2` int(11) DEFAULT NULL,
  `x3` int(11) DEFAULT NULL,
  `y3` int(11) DEFAULT NULL,
  `x4` int(11) DEFAULT NULL,
  `y4` int(11) DEFAULT NULL,
  `x5` int(11) DEFAULT NULL,
  `y5` int(11) DEFAULT NULL,
  `x6` int(11) DEFAULT NULL,
  `y6` int(11) DEFAULT NULL,
  `x7` int(11) DEFAULT NULL,
  `y7` int(11) DEFAULT NULL,
  `x8` int(11) DEFAULT NULL,
  `y8` int(11) DEFAULT NULL,
  `x9` int(11) DEFAULT NULL,
  `y9` int(11) DEFAULT NULL,
  `x10` int(11) DEFAULT NULL,
  `y10` int(11) DEFAULT NULL,
  `x11` int(11) DEFAULT NULL,
  `y11` int(11) DEFAULT NULL,
  `x12` int(11) DEFAULT NULL,
  `y12` int(11) DEFAULT NULL,
  `x+` int(11) DEFAULT NULL,
  `x-` int(11) DEFAULT NULL,
  `y+` int(11) DEFAULT NULL,
  `y-` int(11) DEFAULT NULL,
  `offensif` tinyint(1) DEFAULT NULL,
  `defensif` tinyint(1) DEFAULT NULL,
  `id_joueur` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci AUTO_INCREMENT=22511 ;

-- --------------------------------------------------------

--
-- Structure de la table `saisons`
--

CREATE TABLE IF NOT EXISTS `saisons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `annee_id` int(11) NOT NULL,
  `division_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

-- --------------------------------------------------------

--
-- Structure de la table `staffs`
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=861 ;

-- --------------------------------------------------------

--
-- Structure de la table `staff_contrats`
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=710 ;

-- --------------------------------------------------------

--
-- Structure de la table `stats`
--

CREATE TABLE IF NOT EXISTS `stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ballon+` int(11) DEFAULT NULL,
  `ballon-` int(11) DEFAULT NULL,
  `passe+` int(11) DEFAULT NULL,
  `passe-` int(11) DEFAULT NULL,
  `tackle+` int(11) DEFAULT NULL,
  `tackle-` int(11) DEFAULT NULL,
  `tir+` int(11) DEFAULT NULL,
  `tir-` int(11) DEFAULT NULL,
  `note` float DEFAULT '0',
  `id_joueur` int(11) DEFAULT NULL,
  `but` int(11) NOT NULL,
  `drible+` int(11) NOT NULL,
  `drible-` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_joueur` (`id_joueur`),
  KEY `id_joueur_2` (`id_joueur`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci AUTO_INCREMENT=4215 ;

-- --------------------------------------------------------

--
-- Structure de la table `tactiques`
--

CREATE TABLE IF NOT EXISTS `tactiques` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position_j1_id` int(11) DEFAULT NULL,
  `position_j2_id` int(11) DEFAULT NULL,
  `position_j3_id` int(11) DEFAULT NULL,
  `position_j4_id` int(11) DEFAULT NULL,
  `position_j5_id` int(11) DEFAULT NULL,
  `position_j6_id` int(11) DEFAULT NULL,
  `position_j7_id` int(11) DEFAULT NULL,
  `position_j8_id` int(11) DEFAULT NULL,
  `position_j9_id` int(11) DEFAULT NULL,
  `position_j10_id` int(11) DEFAULT NULL,
  `position_j11_id` int(11) DEFAULT NULL,
  `remplacant1_id` int(11) DEFAULT NULL,
  `remplacant2_id` int(11) DEFAULT NULL,
  `remplacant3_id` int(11) DEFAULT NULL,
  `remplacant4_id` int(11) DEFAULT NULL,
  `remplacant5_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci AUTO_INCREMENT=2045 ;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(30) NOT NULL,
  `equipe_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `crypted_password` varchar(255) NOT NULL,
  `password_salt` varchar(255) CHARACTER SET utf8 COLLATE utf8_swedish_ci NOT NULL,
  `persistence_token` varchar(255) CHARACTER SET utf8 COLLATE utf8_swedish_ci NOT NULL,
  `login_count` int(11) NOT NULL DEFAULT '0',
  `last_login_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `current_login_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
