#DROP THE DATABASE
DROP DATABASE IF EXISTS `db_quarkus_jvm`;
DROP DATABASE IF EXISTS `db_quarkus_native`;
DROP DATABASE IF EXISTS `db_springboot`;
DROP DATABASE IF EXISTS `db_eap`;


#CREATE THE DATABASE & TABLES
CREATE DATABASE `db_quarkus_jvm`;
USE `db_quarkus_jvm`;
CREATE TABLE `ToDo` (
  `ID` int(11) NOT NULL,
  `IS_COMPLETE` varchar(255) DEFAULT NULL,
  `TASK_NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;
INSERT INTO db_quarkus_jvm.ToDo values ("1","Yes","Task in Quarkus JVM DB");

#CREATE THE DATABASE & TABLES
CREATE DATABASE `db_quarkus_native`;
USE `db_quarkus_native`;
CREATE TABLE `ToDo` (
  `ID` int(11) NOT NULL,
  `IS_COMPLETE` varchar(255) DEFAULT NULL,
  `TASK_NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;
INSERT INTO db_quarkus_native.ToDo values ("1","Yes","Task in Quarkus Native DB");

#CREATE THE DATABASE & TABLES
CREATE DATABASE `db_springboot`;
USE `db_springboot`;
CREATE TABLE `ToDo` (
  `ID` int(11) NOT NULL,
  `IS_COMPLETE` varchar(255) DEFAULT NULL,
  `TASK_NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;
INSERT INTO db_springboot.ToDo values ("1","Yes","Task in Spring DB");


#CREATE THE DATABASE & TABLES
CREATE DATABASE `db_eap`;
USE `db_eap`;
CREATE TABLE `ToDo` (
  `ID` int(11) NOT NULL,
  `IS_COMPLETE` varchar(255) DEFAULT NULL,
  `TASK_NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;
INSERT INTO db_eap.ToDo values ("1","Yes","Task in EAP DB");



#SET MAX CONNECTIONS
SET GLOBAL max_connections = 512;
SHOW STATUS LIKE 'max_used_connections';
SHOW VARIABLES LIKE 'max_connections';
SHOW STATUS WHERE `variable_name` = 'Threads_connected';