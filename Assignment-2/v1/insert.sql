.mode column
.headers on

--Inserts

INSERT INTO Course VALUES("CS101","IC",9,3,3,3);
INSERT INTO Course VALUES("CS102","DE",9,3,3,3);
INSERT INTO Course VALUES("CS103","DE",9,3,3,3);
INSERT INTO Course VALUES("CS104","OE",9,3,3,3);
INSERT INTO Course VALUES("CS105","DC",11,6,3,2);


INSERT INTO Faculty VALUES(1,"AB","Head","M","O-1","1@ab.com");
INSERT INTO Faculty VALUES(2,"BC","Prof","F","O-2","2@ab.com");
INSERT INTO Faculty VALUES(3,"CD","Ast. Prof","M","O-3","3@ab.com");
INSERT INTO Faculty VALUES(4,"DE","Aso. Prof","F","O-4","4@ab.com");

INSERT INTO Department VALUES(1,"CS","RM","AB","cs@cs.com");
INSERT INTO Department VALUES(2,"MS","MM","KH","ms@ms.com");

INSERT INTO Student VALUES(1,"AB","M",10,"1@1.com","Normal",18,"1999-01-01",2016);
INSERT INTO Student VALUES(2,"2","F",10,"2@1.com","Normal",27,"1999-01-01",2016);
INSERT INTO Student VALUES(3,"3","M",4,"3@1.com","AP",9,"1999-01-01",2016);
INSERT INTO Student VALUES(4,"4","F",4,"4@1.com","AP",9,"1999-01-01",2016);
INSERT INTO Student VALUES(5,"5","M",8,"5@1.com","Normal",36,"1999-01-01",2016);

INSERT INTO Programme VALUES(1,"BT/BS");
INSERT INTO Programme VALUES(2,"MT/MS");
INSERT INTO Programme VALUES(3,"PHD");

INSERT INTO Students_Department VALUES(1,1);
INSERT INTO Students_Department VALUES(2,2);
INSERT INTO Students_Department VALUES(3,1);
INSERT INTO Students_Department VALUES(4,2);
INSERT INTO Students_Department VALUES(5,1);

INSERT INTO Course_Department VALUES("CS101",1);
INSERT INTO Course_Department VALUES("CS102",2);
INSERT INTO Course_Department VALUES("CS103",1);
INSERT INTO Course_Department VALUES("CS104",2);
INSERT INTO Course_Department VALUES("CS105",1);

INSERT INTO Students_Programme VALUES(1,1);
INSERT INTO Students_Programme VALUES(2,2);
INSERT INTO Students_Programme VALUES(1,3);
INSERT INTO Students_Programme VALUES(2,4);
INSERT INTO Students_Programme VALUES(3,5);

INSERT INTO Faculty_Department VALUES(1,1);
INSERT INTO Faculty_Department VALUES(2,2);
INSERT INTO Faculty_Department VALUES(3,1);
INSERT INTO Faculty_Department VALUES(4,2);

INSERT INTO Course_Ta VALUES("CS101",5,2019,"First");
INSERT INTO Course_Ta VALUES("CS102",5,2019,"First");
INSERT INTO Course_Ta VALUES("CS103",5,2019,"First");
INSERT INTO Course_Ta VALUES("CS104",5,2019,"First");

INSERT INTO Course_Offerings VALUES("CS101",1,2019,"First","1@c.com");
INSERT INTO Course_Offerings VALUES("CS102",2,2019,"First","2@c.com");
INSERT INTO Course_Offerings VALUES("CS103",3,2019,"First","3@c.com");
INSERT INTO Course_Offerings VALUES("CS104",4,2019,"First","4@c.com");
INSERT INTO Course_Offerings VALUES("CS105",1,2019,"First","5@c.com");

INSERT INTO Current_Registration VALUES(1,"CS101");
INSERT INTO Current_Registration VALUES(2,"CS102");
INSERT INTO Current_Registration VALUES(3,"CS103");
INSERT INTO Current_Registration VALUES(4,"CS104");

INSERT INTO Prerequisites VALUES("CS102","CS101");

INSERT INTO Credits_Required VALUES (1,1,"9","9","9","9","9","9","9","9","9");
INSERT INTO Credits_Required VALUES (2,2,"9","9","9","6","9","11","9","11","9");
INSERT INTO Credits_Required VALUES (3,1,"9","9","9","6","9","11","9","11","9");

INSERT INTO Second_Major VALUES (3,2);

INSERT INTO Dual_Degree VALUES (2,2);

INSERT INTo Minors VALUES (1,1,"ALGO");
INSERT INTo Minors VALUES (1,2,"SYS");
INSERT INTo Minors VALUES (3,2,"TOC");

INSERT INTO Phd_Supervisor VALUES(5,1,2);

INSERT INTO Transcript VALUES ("CS103",1,2016,"First","A","IC","fresh");
INSERT INTO Transcript VALUES ("CS104",1,2016,"First","A","IC","fresh");
INSERT INTO Transcript VALUES ("CS101",2,2016,"First","A","IC","fresh");
INSERT INTO Transcript VALUES ("CS103",2,2017,"First","A","IC","fresh");
INSERT INTO Transcript VALUES ("CS104",2,2017,"First","A","IC","fresh");
INSERT INTO Transcript VALUES ("CS104",3,2016,"First","D","IC","repeat");
INSERT INTO Transcript VALUES ("CS103",4,2016,"First","D","IC","repeat");
INSERT INTO Transcript VALUES ("CS101",5,2016,"First","B","IC","fresh");
INSERT INTO Transcript VALUES ("CS102",5,2017,"First","B","IC","fresh");
INSERT INTO Transcript VALUES ("CS103",5,2016,"First","B","IC","fresh");
INSERT INTO Transcript VALUES ("CS104",5,2016,"First","B","IC","fresh");

--Queries
SELECT "Student with same name as faculty in a course they are taking";
SELECT A.faculty_id,Student.roll_number FROM ((Faculty NATURAL JOIN Course_Offerings) NATURAL JOIN Current_Registration) AS A ,Student WHERE
A.roll_number = Student.roll_number
AND Student.name = A.name;

SELECT "Students whose CPI is greater than average CPI";
SELECT roll_number from Student as A WHERE CPI > (SELECT avg(CPI) from Student);

SELECT "Students name and cpi who are doing double major and minor from same Department";
SELECT Student.name,Student.CPI FROM (Minors NATURAL JOIN Second_Major) as A NATURAL JOIN Student 
WHERE Student.roll_number = A.roll_number;

SELECT "Total name of faculty who have taken more than 1 courses at any point of time";
SELECT DISTINCT faculty_id,year,half FROM Faculty NATURAL JOIN Course_Offerings
GROUP BY faculty_id,year,half
HAVING COUNT(faculty_id)>1;

SELECT "Total credits a student is doing in this semester";
SELECT Student.roll_number,SUM(total_credits) FROM (Student NATURAL JOIN (Current_Registration NATURAL JOIN Course)) 
GROUP BY Student.roll_number;

SELECT Student.roll_number FROM (Student NATURAL JOIN Students_Programme) as A WHERE A.programme_id>=2 AND A.CPI>=8;
