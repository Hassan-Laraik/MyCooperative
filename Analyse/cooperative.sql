-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema gestion_litiaire
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `gestion_litiaire` ;

-- -----------------------------------------------------
-- Schema gestion_litiaire
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `gestion_litiaire` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `gestion_litiaire` ;

-- -----------------------------------------------------
-- Table `gestion_litiaire`.`adherents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestion_litiaire`.`adherents` ;

CREATE TABLE IF NOT EXISTS `gestion_litiaire`.`adherents` (
  `cin_adherent` VARCHAR(10) NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `gsm` CHAR(10) NULL DEFAULT NULL,
  `douar` VARCHAR(255) NULL DEFAULT NULL,
  `photo` MEDIUMBLOB NULL DEFAULT NULL,
  PRIMARY KEY (`cin_adherent`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `gsm_UNIQUE` ON `gestion_litiaire`.`adherents` (`gsm` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gestion_litiaire`.`responsables`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestion_litiaire`.`responsables` ;

CREATE TABLE IF NOT EXISTS `gestion_litiaire`.`responsables` (
  `cin_responsable` VARCHAR(10) NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `gsm` CHAR(10) NULL DEFAULT NULL,
  `douar` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`cin_responsable`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `gsm_UNIQUE` ON `gestion_litiaire`.`responsables` (`gsm` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `gestion_litiaire`.`collectes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestion_litiaire`.`collectes` ;

CREATE TABLE IF NOT EXISTS `gestion_litiaire`.`collectes` (
  `idcotisations` INT NOT NULL AUTO_INCREMENT,
  `datecotisation` DATE NOT NULL,
  `quantite` FLOAT(8,2) NOT NULL DEFAULT '5.00',
  `periode` VARCHAR(6) NULL DEFAULT 'MATAIN',
  `cin_adherent` VARCHAR(10) NOT NULL,
  `cin_responsable` VARCHAR(10) NOT NULL,
  `tarif` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`idcotisations`),
  CONSTRAINT `fk_collectes_adherents`
    FOREIGN KEY (`cin_adherent`)
    REFERENCES `gestion_litiaire`.`adherents` (`cin_adherent`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_collectes_responsables1`
    FOREIGN KEY (`cin_responsable`)
    REFERENCES `gestion_litiaire`.`responsables` (`cin_responsable`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 25
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_collectes_adherents_idx` ON `gestion_litiaire`.`collectes` (`cin_adherent` ASC) INVISIBLE;

CREATE INDEX `fk_collectes_responsables1_idx` ON `gestion_litiaire`.`collectes` (`cin_responsable` ASC) INVISIBLE;


-- -----------------------------------------------------
-- Table `gestion_litiaire`.`tarifs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestion_litiaire`.`tarifs` ;

CREATE TABLE IF NOT EXISTS `gestion_litiaire`.`tarifs` (
  `idtarifs` INT NOT NULL AUTO_INCREMENT,
  `prix` FLOAT NOT NULL DEFAULT '5',
  `debut_applique` DATE NULL DEFAULT NULL,
  `fin_applique` VARCHAR(45) NULL DEFAULT NULL,
  `active` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`idtarifs`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
