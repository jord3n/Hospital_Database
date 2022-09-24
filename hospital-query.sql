USE hospital;

/***JOIN***/
/*Group Patient name with disease*/
select P.p_id, pname, disease from health_rcrd H
join patient P on P.p_id = H.p_id
group by P.p_id, pname, disease;

/*Group patients by name with assigned physician by name*/
select distinct P.p_id, P.pname, H.phy_id, H.phy_name from patient P
join physician H
join moniters M on P.p_id = M.p_id AND H.phy_id = M.phy_id;

/*Group physician with the instructions they ordered and the patients their for*/
select phy_name as Orderer, instruction_id, pname as Patient from patient P
join physician H
join ordered O on O.phy_id = H.phy_id AND p_id = patient_id
group by phy_name, instruction_id, pname;

/***Aggregate***/
/*How many patients got their medication from the pharmacy and how many from the nurse*/
select COUNT(from_pharm) as 'From Pharmacy', COUNT(from_nurse) as 'From Nurse'from medication;

/*How much did physicians spend on instructions*/
select SUM(fee) as 'Total Spent on Instructions' from instructions I;

/*Which room could make the most money and which could make the least*/
select MAX(fee*capacity) as 'Highest Price Potential Per Night', MIN(fee*capacity) as 'Lowest Price Potential Per Night' 
from room;

/***Nested Queries***/
/*Patients that got their medication from the pharmacy*/
select issued_to, pname, from_pharm from medication M
join patient P
where from_pharm IN (select from_pharm from medication where from_pharm IS NOT NULL)
and issued_to = p_id;

/*Patients that got their medication from the hospital*/
select issued_to, pname, from_nurse from medication M
join patient P
where from_nurse IN (select from_nurse from medication where from_nurse IS NOT NULL)
and issued_to = p_id;

/*Find patients who's total payment doesn't exceed 500*/
select distinct I.p_id, pname, invoice_id from patient P, invoice I
where I.p_id NOT IN (select I.p_id from invoice I where room_bill + medicine_bill > 500) and I.p_id = P.p_id;
 
/***Other queries***/
/*nurses and the instruction they have to carry out for the patients*/
select N.n_id, N.n_name, description, P.p_id, P.pname from exec_instructions E
join nurse N on N.n_id = E.n_id
join ordered O on O.instruction_id = E.instruction_id
join instructions I on I.instruction_id = E.instruction_id
join patient P on P.p_id = O.patient_id
group by N.n_id, P.p_id;

/*The patient and ailment that the instructions are meant to treat*/
select pname, disease as ailment, I.instruction_id, description from instructions I
join ordered O on O.instruction_id = I.instruction_id
join patient P on P.p_id = O.patient_id
join health_rcrd H on H.p_id = P.p_id
order by pname;

/*Patients, their ailment, and the medication they need to take to treat it*/
select pname as name, disease as ailment, type as medication from medication M
join patient P on P.p_id = M.issued_to
join health_rcrd H on H.p_id = P.p_id
order by pname;

/*last three*/
/*patients and the amount of time they have to be monitered by the assigned physicians*/
select phy_name, time_moniter, pname from moniters M
join patient P on P.p_id = M.p_id
join physician H on H.phy_id = M.phy_id
order by time_moniter;

/*id of patients who got their medicine from a pharmacy, medication and address of the pharmacy*/
select distinct p_id, type, from_pharm, PH.address from medication M
join patient P on p_id = issued_to
join pharmacy PH on from_pharm = pharm_id
order by p_id;
 
/*The names of physician and nurses that are in same field*/
select phy_id, phy_name as PName, n_id, n_name as NName, P.field as Field from physician P
join nurse N on N.field = P.field
group by phy_id, phy_name, n_id, n_name, P.field;

/***Views***/
/*All staff with all information*/
drop view if exists staff cascade;
create view staff as
select phy_name as Name, phy_id as ID, cert_id as Certification, field as Field, address as Address, phone as Phone from physician
union
select n_name, n_id, cert_num, field, address, phone from nurse order by ID;
select * from staff;

/*Instruction ID, who the instruction was ordered by, fee, description, date it was ordered, and ID of the patient it was for*/
drop view if exists instruction_tracker cascade;
create view instruction_tracker as
select I.instruction_id as "Instruction ID", phy_name as Name, P.phy_id as "P-ID", fee as Fee, description as Description, 
date as Date, p_id as "Patient-ID"
from ordered O
join instructions I on I.instruction_id = O.instruction_id
join physician P on P.phy_id = O.phy_id
join patient on patient_id = p_id
order by I.instruction_id;
select * from instruction_tracker;

/*See the patients name, address, phone number, room, number, disease, status, description, and date admitted*/
drop view if exists patient_docInfo cascade;
create view patient_docInfo as 
select pname as Name, room_num as Room, disease as Disease, status as Status, decription as Description, date as Date from patient P
right join health_rcrd H ON P.p_id= H.P_id;
select * from patient_docInfo;

/***Triggers***/
/*auto increment the id of physician on every insert*/
drop trigger if exists auto_increment_patientID;
create trigger auto_increment_patientID after insert on patient
for each row
update patient set p_id = (select distinct MAX(p_id) from patient)+1000
where p_id = null;

/*assign an unassigned physician to a patient who has not been assigned a physician*/
drop trigger if exists assign_to_patient;
create trigger assign_to_patient after insert on moniters
for each row
update moniters set phy_id = (select phy_id from physician
where phy_id not in (select phy_id from moniters))
where phy_id = null;

/*auto increment invoice_id on every insert*/
drop trigger if exists auto_inc_invoiceID;
create trigger auto_inc_invoiceID after insert on invoice
for each row
update invoice set invoice_id = (select distinct MAX(invoice_id) from invoice)+111
where invoice_id = null;
