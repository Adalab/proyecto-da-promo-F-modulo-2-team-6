-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema movies_database
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema movies_database
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `movies_database` DEFAULT CHARACTER SET utf8 ;
USE `movies_database` ;

-- -----------------------------------------------------
-- Table `movies_database`.`peliculas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `movies_database`.`peliculas` (
  `id_pelicula` VARCHAR(19) NOT NULL,
  `genero` VARCHAR(45) NULL DEFAULT NULL,
  `tipo` VARCHAR(45) NULL DEFAULT NULL,
  `anio_estreno` INT NULL DEFAULT NULL,
  `mes_estreno` INT NULL DEFAULT NULL,
  `titulo` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id_pelicula`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `movies_database`.`actor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `movies_database`.`actor` (
  `id_actor` INT NOT NULL AUTO_INCREMENT,
  `nombre_actor` VARCHAR(45) NOT NULL,
  `nacimiento` VARCHAR(45) NULL DEFAULT NULL,
  `curriculum` VARCHAR(600) NULL DEFAULT NULL,
  `profesion` VARCHAR(300) NULL DEFAULT NULL,
  `premios` VARCHAR(45) NULL DEFAULT NULL,
  `peliculas_id_pelicula` VARCHAR(19) NOT NULL,
  PRIMARY KEY (`id_actor`),
  INDEX `fk_actor_peliculas1_idx` (`peliculas_id_pelicula` ASC) VISIBLE,
  CONSTRAINT `fk_actor_peliculas1`
    FOREIGN KEY (`peliculas_id_pelicula`)
    REFERENCES `movies_database`.`peliculas` (`id_pelicula`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `movies_database`.`imdb`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `movies_database`.`imdb` (
  `id_ficha` INT NOT NULL AUTO_INCREMENT,
  `puntuacion` DECIMAL(3,2) NULL DEFAULT NULL,
  `direccion` VARCHAR(45) NULL DEFAULT NULL,
  `guionistas` VARCHAR(255) NULL DEFAULT NULL,
  `argumento` VARCHAR(600) NULL DEFAULT NULL,
  `duracion` INT NULL DEFAULT NULL,
  `nombre_imdb` VARCHAR(100) NULL DEFAULT NULL,
  `tomatometer` INT NULL DEFAULT NULL,
  `peliculas_id_pelicula` VARCHAR(19) NOT NULL,
  PRIMARY KEY (`id_ficha`),
  INDEX `fk_imdb_peliculas1_idx` (`peliculas_id_pelicula` ASC) VISIBLE,
  CONSTRAINT `fk_imdb_peliculas1`
    FOREIGN KEY (`peliculas_id_pelicula`)
    REFERENCES `movies_database`.`peliculas` (`id_pelicula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `movies_database`.`oscars`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `movies_database`.`oscars` (
  `id_pelicula` VARCHAR(19) NOT NULL,
  `mejor_pelicula` VARCHAR(45) NULL DEFAULT NULL,
  `mejor_director` VARCHAR(45) NULL DEFAULT NULL,
  `mejor_actor` VARCHAR(45) NULL DEFAULT NULL,
  `mejor_actriz` VARCHAR(45) NULL DEFAULT NULL,
  `ceremonia` VARCHAR(45) NULL DEFAULT NULL,
  `anio_estreno` VARCHAR(45) NULL DEFAULT NULL,
  `peliculas_id_pelicula` VARCHAR(19) NOT NULL,
  PRIMARY KEY (`id_pelicula`),
  INDEX `fk_oscars_peliculas1_idx` (`peliculas_id_pelicula` ASC) VISIBLE,
  CONSTRAINT `fk_oscars_peliculas1`
    FOREIGN KEY (`peliculas_id_pelicula`)
    REFERENCES `movies_database`.`peliculas` (`id_pelicula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
