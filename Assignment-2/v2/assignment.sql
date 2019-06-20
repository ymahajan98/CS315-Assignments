PRAGMA foreign_keys = ON;

CREATE TABLE Course(
course_code TEXT PRIMARY KEY,
course_type TEXT NOT NULL CHECK(course_type in ("IC","DC","DE","OE","ESO/SO","HSS_1","HSS-2","Thesis","PG-Course")),
total_credits INTEGER NOT NULL CHECK(total_credits>=0) ,
lecture_credits INTEGER NOT NULL CHECK(lecture_credits>=0),
tutorial_credits INTEGER NOT NULL CHECK(tutorial_credits>=0),
lab_credits INTEGER NOT NULL CHECK(tutorial_credits>=0),
CHECK(total_credits=lecture_credits+lab_credits+tutorial_credits)
);

CREATE TABLE Faculty(
faculty_id INTEGER PRIMARY KEY CHECK(faculty_id>=0),
name TEXT NOT NULL,
designation TEXT NOT NULL,
gender TEXT NOT NULL CHECK(gender IN ("M","F","Other")),
office TEXT NOT NULL UNIQUE,
e_mail TEXT NOT NULL UNIQUE
);

CREATE TABLE Department(
department_id INTEGER PRIMARY KEY CHECK(department_id>=0),
department_name TEXT UNIQUE NOT NULL,
department_building TEXT NOT NULL UNIQUE ,
hod TEXT NOT NULL UNIQUE,
webpage TEXT NOT NULL UNIQUE
);

CREATE TABLE Student(
roll_number INTEGER PRIMARY KEY CHECK(roll_number>=0),
name TEXT NOT NULL,
gender TEXT NOT NULL CHECK(gender IN ("M","F","Other")),
cpi REAL DEFAULT 0 CHECK(cpi>=0.0) CHECK(cpi<=10.0),
e_mail TEXT NOT NULL UNIQUE,
academic_probation_status TEXT NOT NULL CHECK(academic_probation_status IN ("AP","Warning","Normal")),
credits_done INTEGER NOT NULL CHECK(credits_done>=0),
dob DATE NOT NULL,
joining_year INTEGER NOT NULL CHECK(joining_year>=1950) CHECK(joining_year<=3000) 
);

CREATE TABLE Programme(
programme_id INTEGER PRIMARY KEY CHECK(programme_id>=0),
programe_name TEXT UNIQUE NOT NULL CHECK(programe_name in ("BT/BS","MT/MS","DUAL","DOUBLE MAJOR","PHD","B.Des.","M.Des.")) 
);

CREATE TABLE Course_Offerings(
course_code TEXT NOT NULL,
faculty_id INTEGER NOT NULL CHECK(faculty_id>=0),
year INTEGER NOT NULL CHECK(year>=1950) CHECK(year<=3000) ,
half TEXT NOT NULL CHECK(half IN ("First","Second","Summer")),
webpage TEXT,
PRIMARY KEY (course_code,faculty_id,year,half),
FOREIGN KEY (course_code) REFERENCES Course (course_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (faculty_id) REFERENCES Faculty (faculty_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Current_Registration(
roll_number INTEGER NOT NULL CHECK(roll_number>=0),
course_code TEXT NOT NULL,
PRIMARY KEY (roll_number,course_code ),
FOREIGN KEY (course_code) REFERENCES Course (course_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (roll_number) REFERENCES Student (roll_number) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Prerequisites(
course_code TEXT NOT NULL,
prerequisites_course_code TEXT NOT NULL,
PRIMARY KEY (course_code,prerequisites_course_code),
FOREIGN KEY (course_code) REFERENCES Course (course_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (prerequisites_course_code) REFERENCES Course (course_code) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Credits_Required(
programme_id INTEGER NOT NULL CHECK(programme_id>=0),
department_id INTEGER NOT NULL CHECK(department_id>=0),
ic TEXT NOT NULL CHECK(ic>=0),
dc TEXT NOT NULL CHECK(dc>=0),
de TEXT NOT NULL CHECK(de>=0),
oe TEXT NOT NULL CHECK(oe>=0),
eso_so TEXT NOT NULL CHECK(eso_so>=0),
hss_1 TEXT NOT NULL CHECK(hss_1>=0),
hss_2 TEXT NOT NULL CHECK(hss_2 >=0),
thesis TEXT NOT NULL CHECK(thesis >=0),
pg_courses TEXT NOT NULL CHECK(pg_courses >=0),
PRIMARY KEY (programme_id,department_id), 
FOREIGN KEY (programme_id) REFERENCES Programme (programme_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (department_id) REFERENCES Department (department_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Second_Major(
roll_number INTEGER UNIQUE NOT NULL CHECK(roll_number>=0),
department_id INTEGER NOT NULL CHECK(department_id>=0),
PRIMARY KEY (roll_number,department_id),
FOREIGN KEY (department_id) REFERENCES Department (department_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (roll_number) REFERENCES Student (roll_number) ON UPDATE CASCADE ON DELETE CASCADE
); 

CREATE TABLE Dual_Degree(
roll_number INTEGER UNIQUE NOT NULL CHECK(roll_number>=0),
department_id INTEGER NOT NULL CHECK(department_id>=0),
PRIMARY KEY (roll_number,department_id),
FOREIGN KEY (department_id) REFERENCES Department (department_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (roll_number) REFERENCES Student (roll_number) ON UPDATE CASCADE ON DELETE CASCADE
); 

CREATE TABLE Minors(
roll_number INTEGER NOT NULL CHECK(roll_number>=0),
department_id INTEGER NOT NULL CHECK(department_id>=0),
specialization TEXT UNIQUE NOT NULL,
PRIMARY KEY (roll_number,department_id),
FOREIGN KEY (department_id) REFERENCES Department (department_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (roll_number) REFERENCES Student (roll_number) ON UPDATE CASCADE ON DELETE CASCADE
); 

CREATE TABLE Students_Department(
roll_number INTEGER UNIQUE NOT NULL CHECK(roll_number>=0),
department_id INTEGER NOT NULL CHECK(department_id>=0),
PRIMARY KEY (roll_number,department_id ),
FOREIGN KEY (department_id) REFERENCES Department (department_id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (roll_number) REFERENCES Student (roll_number) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Phd_Supervisor(
roll_number INTEGER UNIQUE NOT NULL CHECK(roll_number>=0),
faculty_id INTEGER NOT NULL CHECK(faculty_id>=0),
additional_supervisor_id INTEGER CHECK(additional_supervisor_id>=0),
PRIMARY KEY (roll_number,faculty_id ),
FOREIGN KEY (faculty_id) REFERENCES Faculty  (faculty_id ) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (roll_number) REFERENCES Student (roll_number) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Faculty_Department(
faculty_id INTEGER UNIQUE NOT NULL CHECK(faculty_id>=0),
department_id INTEGER NOT NULL CHECK(department_id>=0),
PRIMARY KEY (faculty_id,department_id ),
FOREIGN KEY (faculty_id) REFERENCES Faculty  (faculty_id ) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (department_id) REFERENCES Department (department_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Course_Ta(
course_code TEXT NOT NULL,
roll_number INTEGER NOT NULL CHECK(roll_number>=0),
year INTEGER NOT NULL CHECK(year>=1950) CHECK(year<=3000),
half TEXT NOT NULL CHECK(half IN ("First","Second","Summer")),
PRIMARY KEY (course_code,roll_number,year,half ),
FOREIGN KEY (course_code) REFERENCES Course (course_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (roll_number) REFERENCES Student (roll_number) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Course_Department(
course_code INTEGER UNIQUE NOT NULL,
department_id INTEGER NOT NULL CHECK(department_id>=0),
PRIMARY KEY (course_code,department_id),
FOREIGN KEY (course_code) REFERENCES Course (course_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (department_id) REFERENCES Department (department_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Students_Programme(
programme_id INTEGER NOT NULL CHECK(programme_id>=0),
roll_number INTEGER UNIQUE NOT NULL CHECK(roll_number>=0),
PRIMARY KEY (programme_id,roll_number),
FOREIGN KEY (roll_number) REFERENCES Student (roll_number) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (programme_id) REFERENCES Programme(programme_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Transcript(
course_code TEXT NOT NULL,
roll_number INTEGER NOT NULL CHECK(roll_number>=0),
year INTEGER NOT NULL CHECK(year>=1950) CHECK(year<=3000),
half TEXT NOT NULL CHECK(half IN ("First","Second","Summer")),
grade TEXT NOT NULL CHECK(grade IN("A*","A","B","C","D","E","F","S","X")),
course_type TEXT NOT NULL CHECK(course_type IN ("IC","DC","DE","OE","ESO/SO","HSS_1","HSS-2","Thesis","PG-Course")),
fresh_or_repeat TEXT NOT NULL CHECK(fresh_or_repeat IN ("fresh","repeat")),
PRIMARY KEY (course_code,roll_number,year,half),
FOREIGN KEY (course_code) REFERENCES Course (course_code) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (roll_number) REFERENCES Student (roll_number) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TRIGGER phd_insert BEFORE INSERT ON Phd_Supervisor
BEGIN
SELECT CASE 
WHEN ((SELECT Students_Programme.roll_number FROM Students_Programme WHERE NEW.roll_number = Students_Programme.roll_number AND Students_Programme.programme_id = (SELECT Programme.programme_id FROM Programme WHERE Programme.programe_name = "PHD")) ISNULL)
THEN RAISE(ABORT,"This student doesn't exist or isn't a PHD.")
END;
END;

CREATE TRIGGER double_major_insert BEFORE INSERT ON Second_Major
BEGIN
SELECT CASE 
WHEN ((SELECT Students_Department.roll_number FROM Students_Department WHERE NEW.roll_number = Students_Department.roll_number AND Students_Department.department_id  != NEW.department_id ) ISNULL)
THEN RAISE(ABORT,"This student doesn't exist or second major isn't the same as original major.")
END;
END;

CREATE TRIGGER credits_update AFTER INSERT ON Transcript
BEGIN
UPDATE Student SET credits_done = credits_done + (SELECT Course.total_credits FROM Course WHERE Course.course_code = NEW.course_code ) WHERE NEW.grade IN ("A*","A","B","C","D") AND Student.roll_number = Transcript.roll_number;
END;
