CREATE DATABASE online_learning;
USE online_learning;
CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    total_sessions INT NOT NULL CHECK (total_sessions > 0),
    teacher_id INT NOT NULL,
	FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);
CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    enroll_date DATE NOT NULL,

    CONSTRAINT pk_enrollment PRIMARY KEY (student_id, course_id),
	FOREIGN KEY (student_id) REFERENCES Student(student_id),
	FOREIGN KEY (course_id) REFERENCES Course(course_id)
);
CREATE TABLE Result (
    student_id INT,
    course_id INT,
    mid_score DECIMAL(3,1) CHECK (mid_score BETWEEN 0 AND 10),
    final_score DECIMAL(3,1) CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);
INSERT INTO Student (full_name, date_of_birth, email) VALUES
('Nguyễn Văn A', '2003-05-10', 'a@gmail.com'),
('Trần Thị B', '2002-11-20', 'b@gmail.com'),
('Lê Văn C', '2003-03-15', 'c@gmail.com'),
('Phạm Thị D', '2004-01-08', 'd@gmail.com'),
('Hoàng Văn E', '2002-09-25', 'e@gmail.com');
INSERT INTO Teacher (full_name, email) VALUES
('ThS. Nguyễn Minh', 'minh@uni.edu'),
('TS. Trần Hùng', 'hung@uni.edu'),
('ThS. Lê Hoa', 'hoa@uni.edu'),
('TS. Phạm Long', 'long@uni.edu'),
('ThS. Đỗ Lan', 'lan@uni.edu');
INSERT INTO Course (course_name, description, total_sessions, teacher_id) VALUES
('Cơ sở dữ liệu', 'Học về SQL và thiết kế CSDL', 15, 1),
('Lập trình Java', 'Java căn bản', 20, 2),
('Cấu trúc dữ liệu', 'Danh sách, cây, đồ thị', 18, 3),
('Mạng máy tính', 'Kiến thức mạng', 15, 4),
('Trí tuệ nhân tạo', 'Giới thiệu AI', 12, 5);
INSERT INTO Enrollment VALUES
(1, 1, '2025-01-10'),
(1, 2, '2025-01-11'),
(2, 1, '2025-01-10'),
(3, 3, '2025-01-12'),
(4, 4, '2025-01-13');
INSERT INTO Result VALUES
(1, 1, 7.5, 8.0),
(1, 2, 6.5, 7.0),
(2, 1, 8.0, 8.5),
(3, 3, 7.0, 7.5),
(4, 4, 6.0, 6.5);
UPDATE Student
SET email = 'new_a@gmail.com'
WHERE student_id = 1;
UPDATE Course
SET description = 'SQL nâng cao và tối ưu CSDL'
WHERE course_id = 1;
UPDATE Result
SET final_score = 9.0
WHERE student_id = 1 AND course_id = 1;
DELETE FROM Enrollment
WHERE student_id = 4 AND course_id = 4;
DELETE FROM Result
WHERE student_id = 4 AND course_id = 4;
SELECT * FROM Student;
SELECT * FROM Teacher;
SELECT * FROM Course;