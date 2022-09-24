DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS patient CASCADE;
DROP TABLE IF EXISTS health_rcrd CASCADE;
DROP TABLE IF EXISTS physician CASCADE;
DROP TABLE IF EXISTS nurse CASCADE;
DROP TABLE IF EXISTS ordered CASCADE;
DROP TABLE IF EXISTS instructions CASCADE;
DROP TABLE IF EXISTS medication CASCADE;
DROP TABLE IF EXISTS payable_items CASCADE;
DROP TABLE IF EXISTS pharmacy CASCADE;
DROP TABLE IF EXISTS exec_instructions CASCADE;
DROP TABLE IF EXISTS invoice CASCADE;
DROP TABLE IF EXISTS moniter CASCADE;

CREATE TABLE room(
	room_num INT,
    capacity INT,
    fee FLOAT,
    nights INT,
    PRIMARY KEY (room_num)
);


CREATE TABLE patient(
	pname CHAR(50),
    p_id INT,
    address CHAR(50),
    phone CHAR(12),
    room_num INT,
    PRIMARY KEY (p_id, room_num),
    FOREIGN KEY (room_num) REFERENCES room(room_num)
);

CREATE TABLE health_rcrd(
	p_id INT,
    health_id INT,
    disease CHAR(50),
    date VARCHAR(10),
    status CHAR(50),
    decription CHAR(50),
    PRIMARY KEY (p_id, health_id), 
    FOREIGN KEY (p_id) REFERENCES patient(p_id)
);
CREATE TABLE physician(
	phy_name CHAR(50),
    phy_id INT,
    cert_id INT,
    field CHAR(50),
    address CHAR(50),
    phone CHAR(12),
    PRIMARY KEY (phy_id, cert_id)
);

CREATE TABLE nurse(
	n_id INT,
    cert_num INT,
    n_name CHAR(50),
    field CHAR(50),
    address CHAR(50),
    phone CHAR(12),
    PRIMARY KEY (n_id, cert_num) 
);

CREATE TABLE instructions(
	instruction_id INT,
    fee FLOAT,
    description CHAR(50),
	PRIMARY KEY (instruction_id)
);

CREATE TABLE ordered(
	phy_id INT,
    instruction_id INT,
    patient_id INT,
    date VARCHAR(10),
    PRIMARY KEY (phy_id, instruction_id, patient_id),
    FOREIGN KEY (phy_id) REFERENCES physician(phy_id),
    FOREIGN KEY (instruction_id) REFERENCES instructions(instruction_id),
    FOREIGN KEY (patient_id) REFERENCES patient(p_id)
);

CREATE TABLE pharmacy(
	pharm_id INT,
    address CHAR(50),
    PRIMARY KEY (pharm_id)
);

CREATE TABLE medication(
	med_id INT,
    amount INT,
    issued_to INT,
    from_nurse INT DEFAULT NULL,
    from_pharm INT DEFAULT NULL,
    type CHAR(50),
    PRIMARY KEY(med_id, issued_to),
    FOREIGN KEY (issued_to) REFERENCES patient(p_id),
    FOREIGN KEY (from_nurse) REFERENCES nurse(n_id),
    FOREIGN KEY (from_pharm) REFERENCES pharmacy(pharm_id)
);

CREATE TABLE invoice(
	invoice_id INT,
    p_id INT,
    room_bill INT,
    medicine_bill INT,
    PRIMARY KEY(invoice_id, p_id),
    FOREIGN KEY (p_id) REFERENCES patient(p_id)
);

CREATE TABLE exec_instructions(
	n_id INT,
    instruction_id INT,
    PRIMARY KEY(n_id, instruction_id),
    FOREIGN KEY (n_id) REFERENCES nurse(n_id),
    FOREIGN KEY (instruction_id) REFERENCES instructions(instruction_id)
);

CREATE TABLE moniters(
	phy_id INT,
    p_id INT,
    time_moniter INT,
    PRIMARY KEY(p_id, phy_id),
    FOREIGN KEY (phy_id) REFERENCES physician(phy_id),
    FOREIGN KEY (p_id) REFERENCES patient(p_id)
);

CREATE TABLE payable_items(
	invoice_id INT,
    p_id INT,
    instruction_id INT,
    room_num INT,
    med_id INT,
    FOREIGN KEY (p_id) REFERENCES patient(p_id),
    FOREIGN KEY (instruction_id) REFERENCES instructions(instruction_id),
    FOREIGN KEY (room_num) REFERENCES room(room_num),
    FOREIGN KEY (med_id) REFERENCES medication(med_id),
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)
);
