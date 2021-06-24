## SQL for DBMS PROJECT : Attendance Management System 
## Done by : 1. Yashas Uttangi  2. Prajeeth Bharadwaj 

#--- Creating a new database 
#--- Database name : attendance management system

DROP DATABASE IF EXISTS `attendance_management_system`; # Deletes if there is any existing database with the same name. 
CREATE DATABASE `attendance_management_system`;
# Use the database.
USE `attendance_management_system`;
SET SQL_SAFE_UPDATES=0;
#-----------------------------------------------------------------------------
SET NAMES utf8;

# --- Creating table - "Library_card_index"
CREATE TABLE `Library_card_index` (
	`lib_id` INT UNIQUE NOT NULL,
	`college_id` VARCHAR(20) UNIQUE,
	`faculty_id` CHAR(15) UNIQUE,
    `password` VARCHAR(40),
	PRIMARY KEY(`lib_id`)
);
			
# Creating table - "Students"
CREATE TABLE `Students` (
	`USN` VARCHAR(20) NOT NULL UNIQUE,
    `name` CHAR(40) NOT NULL,
    `Date_of_birth` DATE NOT NULL,
    `branch` VARCHAR(40) NOT NULL,
    `semester` INT NOT NULL,
    `email` VARCHAR(50) UNIQUE,
    `phone` BIGINT UNIQUE,
    `lib_id` INT UNIQUE,
    `type` CHAR(2) NOT NULL,
    PRIMARY KEY(`USN`),
    FOREIGN KEY(`lib_id`) REFERENCES Library_card_index(lib_id)
);

#--- Creating Table : "Faculty"
CREATE TABLE `Faculty` (
	`faculty_id` CHAR(15) NOT NULL UNIQUE,
    `name` CHAR(50) NOT NULL,
    `Date_of_joining` DATE NOT NULL,
    `branch` CHAR(50),
    `email` VARCHAR(40) NOT NULL UNIQUE,
    `phone` CHAR(10) UNIQUE,
    `lib_id` INT UNIQUE,
    `type` CHAR(3) NOT NULL,
    `Designation` CHAR(50) NOT NULL,
    PRIMARY KEY(`faculty_id`),
    FOREIGN KEY(`lib_id`) REFERENCES Library_card_index(`lib_id`)
);

#--- Creating table : "Outsiders"
CREATE TABLE `Outsider_student` (
	`lib_id` INT UNIQUE,
	`name` CHAR(40) NOT NULL,
    `phone` BIGINT NOT NULL UNIQUE,
    `college` CHAR(50) NOT NULL,
    `branch` CHAR(40),
    `semester` INT,
    `college_id` CHAR(15),
    PRIMARY KEY(`college_id`),
	FOREIGN KEY(`lib_id`) REFERENCES Library_card_index(`lib_id`)
);

#--- Creating table : "Outsider_faculty" - holds the record of outside visitors
CREATE TABLE `Outsider_faculty` (
	`lib_id` INT UNIQUE,
	`name` CHAR(40) NOT NULL,
    `phone` BIGINT NOT NULL UNIQUE,
    `college` CHAR(50) NOT NULL,
    `department` CHAR(40) NOT NULL,
    `designation` CHAR(40),
    `faculty_id` VARCHAR(15),
    PRIMARY KEY(`faculty_id`),
	FOREIGN KEY(`lib_id`) REFERENCES Library_card_index(`lib_id`)
);

#--- Creating table : "Library_ledger" => This will hold the record of visitors to the library.
CREATE TABLE `Library_ledger` (
	`lib_id` INT NOT NULL,
    `status` BOOLEAN DEFAULT TRUE,
    `entry` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `exit` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `elapsed_time` TIME,
    PRIMARY KEY(`lib_id`, `entry`),
	FOREIGN KEY(`lib_id`) REFERENCES Library_card_index(`lib_id`)
);

#--- Creating table : "Reference_section" => This will hold the record of visitors to the reference section.
CREATE TABLE `Reference_section` (
	`lib_id` INT NOT NULL,
    `status` BOOLEAN DEFAULT TRUE,
    `entry` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `exit` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `elapsed_time` TIME,
    PRIMARY KEY(`lib_id`, `entry`),
	FOREIGN KEY(`lib_id`) REFERENCES Library_card_index(`lib_id`)
);

DELIMITER //
CREATE PROCEDURE attendance_management_system.exit_library(id INT)
	LANGUAGE SQL 
	MODIFIES SQL DATA 
    BEGIN
		SET SQL_SAFE_UPDATES=0;
		SET @lib_id = id;
		SELECT CAST(current_timestamp() AS DATETIME) INTO @exit_time;
        SELECT CAST((SELECT `entry` FROM `Library_ledger` WHERE lib_id=@lib_id AND `status`=1) AS DATETIME) INTO @entry_time;
		-- SET @entry_time = (SELECT `entry` FROM `Library_ledger` WHERE lib_id= @lib_id AND `status`=1);
        SELECT CAST(TIMEDIFF(@exit_time, @entry_time) AS TIME) INTO @elapsed_time;
        UPDATE Library_ledger SET `exit`=@exit_time WHERE lib_id=@lib_id AND `exit`=@entry_time;
		UPDATE Library_ledger SET `elapsed_time`=@elapsed_time WHERE `exit`=@exit_time;
        UPDATE Library_ledger SET `status`= false WHERE `lib_id`= @lib_id AND `status`=true;  # Updates the exit time. 
	END	
    // 
DELIMITER ;

DELIMITER //
CREATE PROCEDURE attendance_management_system.exit_reference(id INT)
	LANGUAGE SQL 
	MODIFIES SQL DATA 
    BEGIN
		SET SQL_SAFE_UPDATES=0;
		SET @lib_id = id;
		SELECT CAST(current_timestamp() AS DATETIME) INTO @exit_time;
        SELECT CAST((SELECT `entry` FROM `Reference_section` WHERE lib_id=@lib_id AND `status`=1) AS DATETIME) INTO @entry_time;
		-- SET @entry_time = (SELECT `entry` FROM `Library_ledger` WHERE lib_id= @lib_id AND `status`=1);
        SELECT CAST(TIMEDIFF(@exit_time, @entry_time) AS TIME) INTO @elapsed_time;
        UPDATE Reference_section SET `exit`=@exit_time WHERE lib_id=@lib_id AND `exit`=@entry_time;
		UPDATE Reference_section SET `elapsed_time`=@elapsed_time WHERE `exit`=@exit_time;
        UPDATE Reference_section SET `status`= false WHERE `lib_id`= @lib_id AND `status`=true;  # Updates the exit time. 
	END	
    // 
DELIMITER ;



#--- Event - Executes everyday at 5:30pm and changes the state of all entries to 0.
CREATE EVENT exit_library_event
  ON SCHEDULE
    EVERY 1 DAY
    STARTS '2021-06-20 17:30:00' ON COMPLETION PRESERVE ENABLE 
  DO
    UPDATE `Library_ledger` SET `status`=0 WHERE `status`=1;

#--- Event - Executes everyday at 8:00pm and changes the state of all entries to 0.
CREATE EVENT exit_reference_section_event
  ON SCHEDULE
    EVERY 1 DAY
    STARTS '2021-06-20 20:00:00' ON COMPLETION PRESERVE ENABLE 
  DO
    UPDATE `Library_ledger` SET `status`=0 WHERE `status`=1;

#--- Adding data to Staff table :
INSERT INTO `Faculty` VALUES 
	('197806', 'Dr. B S Mahanand', '2008-03-04', 'Information Science and Engineering', 'bsmahanand@sjce.ac.in', '9988993322', null, 'TF', 'Head of the Department'),
	('197809', 'Dr. R J Pratibha', '2010-03-10', 'Information Science and Engineering', 'rjpratibha@sjce.ac.in', '9988993324', null, 'TF', 'Assistant Professor'),
	('197808', 'Dr. Anand Raj Ulle', '2012-03-04', 'Information Science and Engineering', 'anandulle@sjce.ac.in', '9988863326', null, 'TF', 'Assistant Professor'),
	('197810', 'Manju N', '2015-03-04', 'Information Science and Engineering', 'manju@sjce.ac.in', '9985593326', null, 'NTF', 'Assistant Professor'),
	('197811', 'Shilpa', '2012-05-06', 'Information Science and Engineering', 'shilpa@sjce.ac.in', '9988993376', null, 'TF', 'Associate Professor'),
	('197812', 'Dr. B S Harish', '2015-06-07', 'Information Science and Engineering', 'harishbs@sjce.ac.in', '998859332', null, 'TF', 'Assistant Professor'),
	('197813', 'Dr. Vinod D S', '2010-03-04', 'Information Science and Engineering', 'vinod@sjce.ac.in', '9988233327', null, 'TF', 'Assistant Professor'),
	('197814', 'Dr. Mahadev', '2019-12-04', 'Information Science and Engineering', 'mahadev@sjce.ac.in', '9988993986', null, 'TF', 'Head of the Department'),
	('197815', 'Dr. Prasad', '2002-03-05', 'Computer Science Engineering', 'prasad@sjce.ac.in', '9988992126', null, 'TF', 'Associate Professor'),
	('197816', 'Prasanna', '2012-03-05', 'Mechanical Engineering', 'prasanna@sjce.ac.in', '9988993556', null, 'NTF', 'Associate Professor'),
    ('197817', 'Dr. Mahadev Prasad', '2010-05-08', 'Department of Physics', 'mprasad@sjce.ac.in', '9876587986', null, 'TF', 'Assistant Professor'),
    ('197818', 'Smitha M', '2012-08-10', 'Department of Maths', 'smitha@sjce.ac.in', '9090889988', null, 'TF', 'Assistant Professor'),
    ('197819', 'Dr. Maheshan', '2014-08-09', 'Information Science and Engineering', 'maheshan@sjce.ac.in', '9876332323', null, 'TF', 'Assistant Professor'),
    ('197820', 'Dr.Umesh K K', '2008-09-05', 'Information Science and Engineering', 'umeshkk@sjce.ac.in', '9870034500', null, 'TF', 'Assistant Professor'),
    ('197821', 'Dr. Ramya M V', '2015-09-06', 'Electronics and Communication', 'ramyamv@sjce.ac.in', '9087680976', null, 'TF', 'Associate Professor'),
    ('197822', 'Dr. Ramesh', '2018-08-04', 'Electrical Engineering', 'ramesh@sjce.ac.in', '9933993322', null, 'TF', 'Head of the Department'),
    ('197823', 'Manjunath', '2017-06-10', 'Office', 'manjunath@sjce.ac.in', '9329329325', null, 'NTF', 'Office Staff'), 
    ('197824', 'Manjula', '2017-06-10', 'Office', 'manjula@sjce.ac.in', '9898658822', null, 'NTF', 'Accountant'), 
    ('197825', 'Swati Sachith', '2016-05-06', 'Office', 'swati@sjce.ac.in', '9639635423', null, 'NTF' ,'Receptionist'), 
    ('197826', 'Dallit Singh', '2015-09-02', 'Mechanical Engineering', 'dallit@sjce.ac.in', '9988123456', null, 'NTF', 'Lab assistant'),
    ('197827', 'Parinitha', '2019-09-03', 'Environmental Engineering', 'parinitha@sjce.ac.in', '9988996699', null, 'TF', 'Assistant Professor'), 
    ('197828', 'Arjun Pandey', '2019-03-06', 'Department of Chemistry', 'arjun@sjce.ac.in', '9955995544', null, 'TF', 'Associate Professor'), 
    ('197829', 'Manoj Kumar', '2018-05-02', 'Mechanical Engineering', 'manojkumar@sjce.ac.in', '9000000332', null, 'TF', 'Assistant Professor'),
    ('197830', 'Dr Pradeep M', '2010-09-05', 'Placement Cell', 'pradeep@sjce.ac.in', '9111122223', null, 'NTF', 'Placement Officer'), 
    ('197831', 'Kriti ', '2015-07-02', 'Electronics and Communication', 'kriti@sjce.ac.in', '9933393908', null, 'TF', 'Assistant Professor');


#--- Adding the data to the Students table :  	
INSERT INTO `Students` VALUES 
	('01JST19CB050', 'Yashas Uttangi', '2001-10-20', 'CSBS', 4, 'yashuttangi@gmail.com', 9480945628, 194036, 'UG'),
	('01JST19CB033', 'Prajeeth Baradwaj', '2001-08-02', 'CSBS', 4, 'prajeeth@gmail.com', 9990009900, 194037, 'PG'),
	('01JST19CB017', 'Harsh R Shah', '2002-03-04', 'CSBS', 4,'harshshah@gmail.com', 8899880099, 194038, 'EC'),
    ('01JST19CS018', 'Meghanath', '2002-03-04', 'CSE', 4,'m@gmail.com', 8899881099, 194039, 'EC'),
    ('01JST19CB019', 'Danussh', '2002-03-04', 'CSBS', 4,'d@gmail.com', 8899812099, 194040, 'EC'),
    ('01JST19IS015', 'Sita', '2002-03-04', 'ISE', 4,'sita@gmail.com', 8899823099, 194041, 'EC'),
    ('01JST19IS020', 'Ram', '2002-03-04', 'ISE', 4,'ram@gmail.com', 8899845099, 194042, 'EC'),
    ('01JST19ME023', 'Harsh', '2002-03-04', 'ME', 4,'harsh@gmail.com', 8899834099, 194043, 'EC'),
    ('01JST19EE024', 'Harsha', '2002-03-04', 'EEE', 4,'harsha@gmail.com', 8892380099, 194044, 'EC'),
    ('01JST19CB025', 'Hardik', '2002-03-04', 'CSBS', 4,'hardik@gmail.com', 8899555099, 194045, 'UG'),
    ('01JST19CB026', ' Shah', '2002-03-04', 'CSBS', 4,'shah@gmail.com', 8899866099, 194046, 'UG'),
    ('01JST19CB027', 'Sam', '2002-03-04', 'CSBS', 4,'sam@gmail.com', 88998864099, 194047, 'UG'),
    ('01JST19CB028', 'Meena', '2002-03-04', 'CSBS', 4,'meena@gmail.com', 8899844099, 194048, 'UG'),
    ('01JST19CB029', 'Ashwin', '2002-03-04', 'CSBS', 4,'ashwin@gmail.com', 8899867099, 194049, 'UG'),
    ('01JST19CB030', 'Samantha', '2002-03-04', 'CSBS', 4,'samantha@gmail.com', 8899887099, 194050, 'UG'),
    ('01JST19CB031', 'Harshvardhan', '2002-03-04', 'CSBS', 4,'harshvardhan@gmail.com', 8899456099, 194051, 'UG'),
    ('01JST19CB032', 'Smitha', '2002-03-04', 'CSBS', 4,'smitha@gmail.com', 88998809099, 194052, 'UG');

-- DELIMITER //
-- CREATE PROCEDURE attendance_management_system.exit_library(id INT)
-- 	LANGUAGE SQL 
-- 	MODIFIES SQL DATA 
--     BEGIN
-- 		SET SQL_SAFE_UPDATES=0;
-- 		SET @lib_id = id;
-- 		SELECT CAST(current_timestamp() AS DATETIME) INTO @exit_time;
--         SELECT CAST((SELECT `entry` FROM `Library_ledger` WHERE lib_id=@lib_id AND `status`=1) AS DATETIME) INTO @entry_time;
-- 		-- SET @entry_time = (SELECT `entry` FROM `Library_ledger` WHERE lib_id= @lib_id AND `status`=1);
--         SELECT CAST(TIMEDIFF(@exit_time, @entry_time) AS TIME) INTO @elapsed_time;
--         UPDATE Library_ledger SET `exit`=@exit_time WHERE lib_id=@lib_id AND `exit`=@entry_time;
-- 		UPDATE Library_ledger SET `elapsed_time`=@elapsed_time WHERE `exit`=@exit_time;
--         UPDATE Library_ledger SET `status`= false WHERE `lib_id`= @lib_id AND `status`=true;  # Updates the exit time. 
-- 	END	
--     // 
-- DELIMITER ;

-- DELIMITER //
-- CREATE PROCEDURE attendance_management_system.exit_reference()
-- 	LANGUAGE SQL 
-- 	MODIFIES SQL DATA 
--     BEGIN
-- 		UPDATE Reference_section SET `status`= false WHERE `lib_id`= @lib_id;  # Updates the exit time. 
-- 		SET @entry_time = (SELECT `entry` FROM `Reference_section` WHERE lib_id= @lib_id);
--         SET @exit_time = (SELECT `exit` FROM `Reference_section` WHERE lib_id= @lib_id);
--         SET @elapsed_time = (SELECT TIMEDIFF(@exit_time, @entry_time));
-- 		UPDATE Reference_section SET `elapsed_time`=@elapsed_time WHERE `lib_id`= @lib_id;
-- 	END	
--     // 
-- DELIMITER ;

-- CALL exit_reference();












