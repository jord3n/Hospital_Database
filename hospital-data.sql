USE hospital;

/*room*/
INSERT INTO room VALUE (345, 3, 100.00, 2);
INSERT INTO room VALUE (346, 3, 100.00, 2);
INSERT INTO room VALUE (347, 2, 150.00, 3);
INSERT INTO room VALUE (348, 3, 100.00, 2);
INSERT INTO room VALUE (349, 2, 50.00, 1);

/*patient*/
INSERT INTO patient SELECT 'Joe Shmoe', 34567, '2487 Alexander Ct', '444-444-4444',  room_num FROM room WHERE room_num = 345;
INSERT INTO patient SELECT 'Mark Spectre', 45678, '2896 Cherry Ct', '555-555-5555',  room_num FROM room WHERE room_num = 346;
INSERT INTO patient SELECT 'Steven Berry', 56789, '4892 Raspberry Ct', '666-666-6666',  room_num FROM room WHERE room_num = 347;
INSERT INTO patient SELECT 'James Howlett', 67890, '6043 Strawberry Ct', '777-777-7777',  room_num FROM room WHERE room_num = 348;
INSERT INTO patient SELECT 'Joe Shmoe', 78910, '8923 Orange Ct', '888-888-8888',  room_num FROM room WHERE room_num = 349;

/*health_rcrd*/
INSERT INTO health_rcrd SELECT p_id, 6472, 'pnumonia', '02/23/2024', 'he good', 'fever and heavy breathing' FROM patient WHERE p_id = 34567;
INSERT INTO health_rcrd SELECT p_id, 2845, 'influenza', '02/24/2024', 'dicey', 'damaging couch' FROM patient WHERE p_id = 45678;
INSERT INTO health_rcrd SELECT p_id, 3248, '2nd degree burn', '02/25/2024', 'recovered', 'house arson victim' FROM patient WHERE p_id = 56789;
INSERT INTO health_rcrd SELECT p_id, 2947, 'ankle fracture', '02/26/2024', 'in caste', 'fracture in soccer game' FROM patient WHERE p_id = 67890;
INSERT INTO health_rcrd SELECT p_id, 2446, 'a boo boo', '02/27/2024', 'critical condition', 'really big boo boo' FROM patient WHERE p_id = 78910;

/*physician*/
INSERT INTO physician SELECT 'Jason Lee', 12345, 1111, 'family', '2301 Egg Ln', '111-111-1111';
INSERT INTO physician SELECT 'Robin Lee', 23456, 2222, 'internal', '2301 Egg Ln', '222-222-2222';
INSERT INTO physician SELECT 'Simu Liu', 13245, 3333, 'radiology', '8456 Berry Rd', '333-333-3333';
INSERT INTO physician SELECT 'Shawn Cee', 75643, 4444, 'oncology', '5342 Gary Av', '999-999-9999';
INSERT INTO physician SELECT 'Sara Septic', 86754, 5555, 'critical-care', '9010 Booker Ct', '260-260-2650';

/*nurse*/
INSERT INTO nurse VALUE (12122, 0909, 'Ben Stiller', 'health informatics', '9362 Harris Ln', '340-292-7392');
INSERT INTO nurse VALUE (23233, 0808, 'Keke Palmer', 'pain management', '4923 Chewy Ln', '240-323-3449');
INSERT INTO nurse VALUE (34344, 0202, 'Winston James', 'family', '3284 Letter Ln', '240-292-7392');
INSERT INTO nurse VALUE (45455, 0303, 'Peter Parker', 'anesthetist', '2370 Uru Av', '301-234-2088');
INSERT INTO nurse VALUE (56566, 0404, 'Rosario Dawson', 'critical-care', '2039 Polar Rd', '202-037-8003');

/*instructions*/
INSERT INTO instructions VALUE (00021, 200.00, "give pills");
INSERT INTO instructions VALUE (00022, 200.00, "give pills");
INSERT INTO instructions VALUE (00023, 200.00, "give pills");
INSERT INTO instructions VALUE (00024, 200.00, "give pills");
INSERT INTO instructions VALUE (00025, 200.00, "give pills");

/*ordered*/
INSERT INTO ordered SELECT phy_id, instruction_id, patient.p_id, '02/24/2024' FROM physician, instructions, patient
WHERE phy_id = 12345 AND instruction_id = 00021 AND patient.p_id = 34567;
INSERT INTO ordered SELECT phy_id, instruction_id, patient.p_id, '02/25/2024' FROM physician, instructions, patient
WHERE phy_id = 23456 AND instruction_id = 00022 AND patient.p_id = 45678;
INSERT INTO ordered SELECT phy_id, instruction_id, patient.p_id, '02/26/2024' FROM physician, instructions, patient
WHERE phy_id = 13245 AND instruction_id = 00023 AND patient.p_id = 56789;
INSERT INTO ordered SELECT phy_id, instruction_id, patient.p_id, '02/27/2024' FROM physician, instructions, patient
WHERE phy_id = 75643 AND instruction_id = 00024 AND patient.p_id = 67890;
INSERT INTO ordered SELECT phy_id, instruction_id, patient.p_id, '02/27/2024' FROM physician, instructions, patient
WHERE phy_id = 86754 AND instruction_id = 00025 AND patient.p_id = 78910;

/*pharmacy*/
INSERT INTO pharmacy VALUE (1985, '2003 Shasho Pl');
INSERT INTO pharmacy VALUE (1986, '2308 Derek Rd');
INSERT INTO pharmacy VALUE (1987, '2014 Forest Hill Dr');
INSERT INTO pharmacy VALUE (1988, '1093 MLK Blvd');
INSERT INTO pharmacy VALUE (1989, '1393 Nector Pl');

/*medication*/
INSERT INTO medication (med_id, amount, issued_to, from_nurse, type)
SELECT 2134, 3, p_id, n_id, 'percocet' FROM patient, nurse 
WHERE p_id = 34567 AND n_id = 12122;
INSERT INTO medication (med_id, amount, issued_to, from_pharm, type) 
SELECT 2144, 1, p_id, pharm_id, 'xanax' FROM patient, pharmacy 
WHERE pharm_id = 1986 AND p_id = 45678;
INSERT INTO medication (med_id, amount, issued_to, from_pharm, type)
SELECT 2154, 6, p_id, pharm_id, 'ibuprofen' FROM patient, pharmacy 
WHERE pharm_id = 1987 AND p_id = 56789;
INSERT INTO medication (med_id, amount, issued_to, from_nurse, type)
SELECT 2164, 2, p_id, n_id, 'aspirin' FROM patient, nurse 
WHERE p_id = 67890 AND n_id = 45455;
INSERT INTO medication (med_id, amount, issued_to, from_nurse, type)
SELECT 2174, 5, p_id, n_id, 'morphine' FROM patient, nurse 
WHERE p_id = 78910 AND n_id = 56566;

/*invoice*/
INSERT INTO invoice SELECT 1222, issued_to, fee*nights, IF(from_nurse IS NOT NULL, 540, null) FROM patient P, room R, medication M
WHERE P.p_id = 34567 AND P.room_num = R.room_num AND P.p_id = M.issued_to; 
INSERT INTO invoice SELECT 1333, p_id, fee*nights, IF(from_nurse IS NOT NULL, 600, NULL) FROM patient P, room R, medication M
WHERE P.p_id = 45678 AND P.room_num = R.room_num AND P.p_id = M.issued_to; 
INSERT INTO invoice SELECT 1444, p_id, fee*nights, IF(from_nurse IS NOT NULL, 700, NULL) FROM patient P, room R, medication M
WHERE P.p_id = 56789 AND P.room_num = R.room_num AND P.p_id = M.issued_to; 
INSERT INTO invoice SELECT 1555, p_id, fee*nights, IF(from_nurse IS NULL, null, 340) FROM patient P, room R, medication M
WHERE P.p_id = 67890 AND P.room_num = R.room_num AND P.p_id = M.issued_to; 
INSERT INTO invoice SELECT 1666, p_id, fee*nights, IF(from_nurse IS NOT NULL, 963, NULL) FROM patient P, room R, medication M
WHERE P.p_id = 78910 AND P.room_num = R.room_num AND P.p_id = M.issued_to; 

/*payable items*/
INSERT INTO payable_items SELECT invoice_id, P.p_id, instruction_id, room.room_num, IF(from_nurse = null, null, med_id) 
FROM patient P, instructions, room, medication, invoice
WHERE P.p_id = 34567 AND instruction_id = 00021 AND room.room_num = 345 AND med_id = 2134 AND invoice_id = 1222;
INSERT INTO payable_items SELECT invoice_id, P.p_id, instruction_id, room.room_num, IF(from_nurse = null, null, med_id) 
FROM patient P, instructions, room, medication, invoice
WHERE P.p_id = 45678 AND instruction_id = 00022 AND room.room_num = 346 AND med_id = 2144 AND invoice_id = 1333;
INSERT INTO payable_items SELECT invoice_id , P.p_id, instruction_id, room.room_num, IF(from_nurse = null, null, med_id) 
FROM patient P, instructions, room, medication, invoice
WHERE P.p_id = 56789 AND instruction_id = 00023 AND room.room_num = 347 AND med_id = 2154 AND invoice_id = 1444;
INSERT INTO payable_items SELECT invoice_id, P.p_id, instruction_id, room.room_num, IF(from_nurse = null, null, med_id) 
FROM patient P, instructions, room, medication, invoice 
WHERE P.p_id = 67890 AND instruction_id = 00024 AND room.room_num = 348 AND med_id = 2164 AND invoice_id = 1555;
INSERT INTO payable_items SELECT invoice_id, P.p_id, instruction_id, room.room_num, IF(from_nurse = null, null, med_id) 
FROM patient P, instructions, room, medication, invoice 
WHERE P.p_id = 78910 AND instruction_id = 00025 AND room.room_num = 349 AND med_id = 2174 AND invoice_id = 1666;

/*moniters*/
INSERT INTO moniters SELECT phy_id, p_id, 68 FROM physician, patient 
WHERE phy_id = 12345 AND patient.p_id = 34567;
INSERT INTO moniters SELECT phy_id, p_id, 112 FROM physician, patient 
WHERE phy_id = 23456 AND patient.p_id = 45678;
INSERT INTO moniters SELECT phy_id, p_id, 72 FROM physician, patient 
WHERE phy_id = 13245 AND patient.p_id = 56789;
INSERT INTO moniters SELECT phy_id, p_id, 34 FROM physician, patient 
WHERE phy_id = 75643 AND patient.p_id = 67890;
INSERT INTO moniters SELECT phy_id, p_id, 55 FROM physician, patient
WHERE phy_id = 86754 AND patient.p_id = 78910;

/*execute instructions*/
INSERT INTO exec_instructions SELECT DISTINCT n_id, instruction_id FROM nurse, instructions
WHERE n_id = 12122 AND instruction_id = 21;
INSERT INTO exec_instructions SELECT DISTINCT n_id, instruction_id FROM nurse, instructions
WHERE n_id = 23233 AND instruction_id = 22;
INSERT INTO exec_instructions SELECT DISTINCT n_id, instruction_id FROM nurse, instructions
WHERE n_id = 34344 AND instruction_id = 23;
INSERT INTO exec_instructions SELECT DISTINCT n_id, instruction_id FROM nurse, instructions
WHERE n_id = 45455 AND instruction_id = 24;
INSERT INTO exec_instructions SELECT DISTINCT n_id, instruction_id FROM nurse, instructions
WHERE n_id = 56566 AND instruction_id = 25;

