-- Создаем базу.
CREATE DATABASE TestDB;

USE TestDB;

-- Создаем таблицу сотрудников.
CREATE TABLE Employee
(
	id TINYINT unsigned NOT NULL AUTO_INCREMENT, -- Первичный ключ.
	emplName VARCHAR(20) NOT NULL, -- Имя сотрудника.
	father VARCHAR(20) NOT NULL default '', -- Отчество сотрудника.
	secname VARCHAR(20) NOT NULL, -- Фамилия сотрудника.
	birthday DATE NOT NULL, -- Дата рождения сотрудника.
	departmentName varchar(10) NOT NULL, -- Id департамента, в котором работает сотрудник.
    PRIMARY KEY (id)
);

-- Создаем таблицу департаментов.
CREATE TABLE Department
(
	-- id INT NOT NULL AUTO_INCREMENT, -- Первичный ключ.
	depName varchar(10) NOT NULL unique, -- Название департамента.
	chiefId TINYINT unsigned NULL,		-- Id сотрудника, который является начальником отдела
    PRIMARY KEY (depName),
	FOREIGN KEY (chiefId) REFERENCES Employee(id)
);

-- Добавляем в таблицу сотрудников внешний ключ на id департамента.
ALTER TABLE Employee
ADD CONSTRAINT FK_DepartmentId
FOREIGN KEY (departmentName) REFERENCES Department(depName);

-- 2. Заполняем таблицу тестовыми данными.
-- Создаем два департамента.
INSERT INTO Department
(depName)
VALUES
('отдел IT'),
('отдел HR');

drop function getadultbirthday;

-- Создаем функцию которая возвращает случайную дату рождения в диапазоне возрастов от 18 лет до 60 лет.
DELIMITER //
CREATE FUNCTION GetAdultBirthday()
RETURNS date deterministic
BEGIN
	SET @beginDate = date_add(CURDATE(), INTERVAL -60 YEAR);
	SET @endDate = date_add(CURDATE(), INTERVAL -18 YEAR);
	SET @rand = (to_days(@endDate) - to_days(@beginDate)) * rand();
	SET @birthDate = to_days(@beginDate) + @rand;
	RETURN from_days(@birthDate);
END;  //
-- DELIMITER;

-- Заполняем таблицу сотрудников.
INSERT INTO Employee
(emplName, father, secname, birthday, departmentName)
VALUES
('Иван', 'Иванович', 'Иванов', GetAdultBirthday(), 'отдел IT'),
('Петр', 'Петрович', 'Петров', GetAdultBirthday(), 'отдел HR'),
('Андрей', 'Васильевич', 'Сидоров', GetAdultBirthday(), 'отдел IT'),
('Максим', 'Юрьевич', 'Пришвин', GetAdultBirthday(),'отдел HR'),
('Александр', 'Сергеевич', 'Пушкин', GetAdultBirthday(), 'отдел IT'),
('Сергей', 'Александрович', 'Есенин', GetAdultBirthday(),'отдел HR'),
('Михаил', 'Юрьевич', 'Лермонтов', GetAdultBirthday(), 'отдел IT'),
('Корней', 'Михайлович', 'Чуковский', GetAdultBirthday(),'отдел HR'),
('Афанасий', 'Афанасьевич', 'Фет', GetAdultBirthday(), 'отдел IT'),
('Иван', 'Алексеевич', 'Бунин', GetAdultBirthday(),'отдел HR'),
('Иван', 'Савельевич', 'Сусанин', GetAdultBirthday(), 'отдел IT'),
('Аркадий', 'Исаакович', 'Райкин', GetAdultBirthday(),'отдел HR'),
('Александр', 'Васильевич', 'Масляков', GetAdultBirthday(), 'отдел IT');

-- Назначаем начальников отделов.
UPDATE Department
SET chiefId = 5
WHERE depName LIKE 'отдел IT';
UPDATE Department
SET chiefId = 6
WHERE depName LIKE 'отдел HR';

-- Функция, возвращающая количество полных лет из даты рождения.
DELIMITER //
CREATE FUNCTION GetFullYears(birthday DATE)
RETURNS TINYINT deterministic
BEGIN
SET @YEARS = year(CURDATE()) - year(birthday); -- DATEDIFF(YEAR, @birthday, GETDATE());
IF MONTH(birthday) > MONTH(CURDATE())
	THEN SET @YEARS = @YEARS - 1;
    END IF;
IF (MONTH(birthday) = MONTH(CURDATE())) AND (DAY(birthday) > DAY(CURDATE()))
	THEN SET @YEARS = @YEARS - 1;
END IF;
RETURN @YEARS;
END; //
-- DELIMITER


SELECT CONCAT(Emp1.secname, ' ', SUBSTRING(Emp1.emplName, 1, 1), '.', SUBSTRING(Emp1.father, 1, 1), '.') AS 'Ф.И.О.', 
	   GetFullYears(Emp1.birthday) AS 'Возраст',
	   Dep.depName AS 'Отдел',
	   Emp2.secname AS 'Начальник отдела'
FROM Employee AS Emp1
JOIN Department Dep
ON departmentName = Dep.depName
JOIN Employee Emp2 ON Dep.chiefId = Emp2.id
LIMIT 10;

