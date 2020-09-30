CREATE DATABASE IF NOT EXISTS  CONSULTORIO;
USE CONSULTORIO;

CREATE TABLE IF NOT EXISTS PACIENTE(
	IDPACIENTE INT PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(30),
	SEXO CHAR(1),
	EMAIL VARCHAR(30),
	NASCIMENTO DATE
);

CREATE TABLE IF NOT EXISTS MEDICO(
	IDMEDICO INT PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(30),
	SEXO CHAR(1),
	ESPECIALIDADE VARCHAR(30),
	FUNCIONARIO ENUM('S','N')
);

CREATE TABLE IF NOT EXISTS HOSPITAL(
	IDHOSPITAL INT PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(30),
	BAIRRO VARCHAR(30),
	CIDADE VARCHAR(30),
	ESTADO CHAR(2)
);

CREATE TABLE IF NOT EXISTS CONSULTA(
	IDCONSULTA INT PRIMARY KEY AUTO_INCREMENT,
	ID_PACIENTE INT,
	ID_MEDICO INT,
	ID_HOSPITAL INT,
	DATA DATETIME,
	DIAGNOSTICO VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS INTERNACAO(
	IDINTERNACAO INT PRIMARY KEY AUTO_INCREMENT,
	ENTRADA DATETIME,
	QUARTO INT,
	SAIDA DATETIME,
	OBSERVACOES VARCHAR(50),
	ID_CONSULTA INT UNIQUE	
);  

ALTER TABLE CONSULTA ADD CONSTRAINT FK_CONSULTA_PACIENTE FOREIGN KEY (ID_PACIENTE) REFERENCES PACIENTE(IDPACIENTE);
ALTER TABLE CONSULTA ADD CONSTRAINT FK_CONSULTA_MEDICO FOREIGN KEY (ID_MEDICO) REFERENCES MEDICO(IDMEDICO);
ALTER TABLE CONSULTA ADD CONSTRAINT FK_CONSULTA_HOSPITAL FOREIGN KEY (ID_HOSPITAL) REFERENCES HOSPITAL(IDHOSPITAL);
ALTER TABLE INTERNACAO ADD CONSTRAINT FK_INTERNACAO_CONSULTA FOREIGN KEY (ID_CONSULTA) REFERENCES CONSULTA(IDCONSULTA);