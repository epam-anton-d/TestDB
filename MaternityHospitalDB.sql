CREATE DATABASE MaternityHospitalDB;

USE MaternityHospitalDB;

-- Создаем таблицу докторов.
CREATE TABLE Doctors
(
	id INT NOT NULL AUTO_INCREMENT,
    docName VARCHAR(20) NOT NULL,
    father VARCHAR(20) NOT NULL,
    secname VARCHAR(20) NOT NULL,
    qualification ENUM('Врач I категории', 'Врач II категории') NOT NULL,
		PRIMARY KEY (id)
);

-- Создаем таблицу мам.
CREATE TABLE Mothers
(
	id INT NOT NULL AUTO_INCREMENT,
    motherName VARCHAR(20) NOT NULL,
    father VARCHAR(20) NOT NULL DEFAULT '',
    secname VARCHAR(20) NOT NULL,
    birthday DATE NOT NULL,
    doctorId INT NOT NULL,
		PRIMARY KEY (id),
        FOREIGN KEY (doctorId) REFERENCES Doctors(id)
);

-- Создаем таблицу детей.
CREATE TABLE Babies
(
	id INT NOT NULL AUTO_INCREMENT,
    babyName VARCHAR(20) NOT NULL,
    motherId INT NOT NULL,
    birthday DATETIME NOT NULL,
    gender char(1) NOT NULL,
		PRIMARY KEY (id),
        FOREIGN KEY (motherId) REFERENCES Mothers(id)
);

-- Таблица медикаментов, назначаемых больным.
CREATE TABLE Medicament
(
	id INT NOT NULL AUTO_INCREMENT,
    medName VARCHAR(20),
		PRIMARY KEY (id)
);

-- Отношение многие ко многим - мамы-медикаменты.
CREATE TABLE MedsForMoms
(
	id INT NOT NULL AUTO_INCREMENT,
    motherId INT NOT NULL,
    medId INT NOT NULL,
		PRIMARY KEY (id),
        FOREIGN KEY (motherId) REFERENCES Mothers(id),
        FOREIGN KEY (medId) REFERENCES Medicament(id)
);

-- Заполняем таблицу медикаменты.
INSERT INTO Medicament
(medName)
VALUES
('Препарат 1'),
('Препарат 2'),
('Препарат 3'),
('Препарат 4'),
('Препарат 5');

-- Заполняем таблицу medsForMoms.
DELIMITER //
CREATE PROCEDURE FillMedsForMoms()
BEGIN
	SET @iter = 1;
	WHILE @iter <= 100 DO
		SET @randMotherId = floor((SELECT COUNT(*) FROM Mothers) * RAND() + 1);
        Set @randMedId = floor((SELECT COUNT(*) FROM Medicament) * RAND() + 1);
		INSERT INTO MedsForMoms
		(motherId, medId)
		VALUES
		(@randMotherId, @randMedId);
        SET @iter = @iter + 1;
    END WHILE;
END; //
-- DELIMITER;

-- Получаем дату рождения мам.
DELIMITER //
CREATE FUNCTION GetMotherBirthday()
RETURNS date deterministic
BEGIN
	SET @beginDate = date_add(CURDATE(), INTERVAL -40 YEAR);
	SET @endDate = date_add(CURDATE(), INTERVAL -18 YEAR);
	SET @rand = (to_days(@endDate) - to_days(@beginDate)) * rand();
	SET @birthDate = to_days(@beginDate) + @rand;
	RETURN from_days(@birthDate);
END;  //
-- DELIMITER;

-- Получаем дату и время детского рождения.
DELIMITER //
CREATE FUNCTION GetBabyBirthday()
RETURNS DATETIME deterministic
BEGIN
	SET @beginDate = date_add(NOW(), INTERVAL -7200 MINUTE);
	SET @endDate = NOW();
	SET @rand = (to_seconds(@endDate) - to_seconds(@beginDate)) * rand();
	SET @birthDate = date_add(@beginDate, INTERVAL @rand SECOND);
	RETURN @birthDate;
END;  //
-- DELIMITER;

-- Получаем случайные имена для девочек.
DELIMITER //
CREATE FUNCTION GetWomanName()
RETURNS TEXT deterministic
BEGIN
	SET @randWomanName = floor(rand() * 10 + 1);
    SET @tempWomanName = (CASE @randWomanName
		WHEN 1 THEN 'Анастасия'
        WHEN 2 THEN 'Вероника'
        WHEN 3 THEN 'Антонина'
        WHEN 4 THEN 'Алена'
        WHEN 5 THEN 'Полина'
        WHEN 6 THEN 'Екатерина'
        WHEN 7 THEN 'Василиса'
        WHEN 8 THEN 'Серафима'
        WHEN 9 THEN 'Елена'
        ELSE 'Галина'
	END);
	RETURN @tempWomanName;
END;  //
-- DELIMITER;

-- Получаем случайные имена для мальчиков.
DELIMITER //
CREATE FUNCTION GetManName()
RETURNS TEXT deterministic
BEGIN
	SET @randManName = floor(rand() * 10 + 1);
    SET @tempManName = (CASE @randManName
		WHEN 1 THEN 'Александр'
        WHEN 2 THEN 'Павел'
        WHEN 3 THEN 'Инокентий'
        WHEN 4 THEN 'Даниил'
        WHEN 5 THEN 'Гавриил'
        WHEN 6 THEN 'Николай'
        WHEN 7 THEN 'Андрей'
        WHEN 8 THEN 'Василий'
        WHEN 9 THEN 'Роман'
        ELSE 'Пафнутий'
	END);
	RETURN @tempManName;
END;  //
-- DELIMITER;

-- Получаем случайную фамилию  для мам.
DELIMITER //
CREATE FUNCTION GetMotherSecname()
RETURNS TEXT deterministic
BEGIN
	SET @randMotherSecname = floor(rand() * 10 + 1);
    SET @tempMotherSecname = (CASE @randMotherSecname
		WHEN 1 THEN 'Иванова'
        WHEN 2 THEN 'Петрова'
        WHEN 3 THEN 'Сидорова'
        WHEN 4 THEN 'Пришвина'
        WHEN 5 THEN 'Пушкина'
        WHEN 6 THEN 'Есенина'
        WHEN 7 THEN 'Лермонтова'
        WHEN 8 THEN 'Чуковская'
        WHEN 9 THEN 'Сусанина'
        ELSE 'Маслякова'
	END);
	RETURN @tempMotherSecname;
END;  //
-- DELIMITER;

-- Получаем случайное отчество для мам.
DELIMITER //
CREATE FUNCTION GetMotherFather()
RETURNS TEXT deterministic
BEGIN
	SET @randMotherFather = floor(rand() * 10 + 1);
        SET @tempMotherFather = (CASE @randMotherFather
			WHEN 1 THEN 'Петровна'
            WHEN 2 THEN 'Васильевна'
            WHEN 3 THEN 'Антоновна'
            WHEN 4 THEN 'Сергеевна'
            WHEN 5 THEN 'Андреевна'
            WHEN 6 THEN 'Александровна'
            WHEN 7 THEN 'Максимовна'
            WHEN 8 THEN 'Артемовна'
            WHEN 9 THEN 'Алексеевна'
            ELSE 'Константиновна'
		END);
	RETURN @tempMotherFather;
END;  //
-- DELIMITER;

-- Заполняем таблицу мам.
DELIMITER \\
CREATE PROCEDURE FillMotherTable()
BEGIN
	SET @iter = 1;
    WHILE @iter <= 100 DO
		SET @docId = @iter % 10 + 1;
		INSERT INTO Mothers
		(motherName, father, secname, birthday, doctorId)
		VALUES
		(
			GetWomanName(),
            GetMotherFather(),
            GetMotherSecname(),
            GetMotherBirthday(),
            @docId
        );
        SET @iter = @iter + 1;
	END WHILE;
END;

-- Заполняем таблицу докторов.
DELIMITER \\
CREATE PROCEDURE FillDocTable()
BEGIN
	SET @iter = 1;
    WHILE @iter <= 10 DO
		SET @qualif = @iter % 2 + 1;
		INSERT INTO Doctors
		(docName, father, secname, qualification)
		VALUES
		(
			GetWomanName(),
            GetMotherFather(),
            GetMotherSecname(),
            @qualif
        );
        SET @iter = @iter + 1;
	END WHILE;
END;

-- Заполняем таблицу детей.
DELIMITER \\
CREATE PROCEDURE FillBabyTable()
BEGIN
	SET @iter = 1;
    WHILE @iter <= 100 DO
		SET @genderid = floor(rand() * 2);
        IF @genderId = 0 
        THEN 
			SET @gender = 'm';
            SET @babyName = GetManName();
		ELSE
			SET @gender = 'w';
			SET @babyName = GetWomanName();
		END IF;
        SET @motherId = floor(rand() * 100 + 1);
		INSERT INTO Babies
		(babyName, motherId, birthday, gender)
		VALUES
		(
			@babyName,
            @motherId,
            GetBabyBirthday(),
            @gender
        );
        SET @iter = @iter + 1;
	END WHILE;
END;

CALL FillDocTable();
CALL FillMotherTable();
CALL FillBabyTable();
CALL FillMedsForMoms();

-- Женщины и количество рожденных у них детей. Если 0 детей, то женщину не выводит.
SELECT CONCAT(secname, ' ', SUBSTRING(motherName, 1, 1), '.', SUBSTRING(father, 1, 1), '.') AS 'Ф.И.О.', 
	   COUNT(*) AS 'Кол-во детей'
FROM Mothers
JOIN Babies ON motherId = Mothers.id 
GROUP BY motherId;

-- Аналог предыдущего запроса с применением оконной функции (строки задвоены как и в примерах в интернете)
SELECT CONCAT(secname, ' ', SUBSTRING(motherName, 1, 1), '.', SUBSTRING(father, 1, 1), '.') AS 'Ф.И.О.', 
	   COUNT(*) over(partition by motherId) AS 'Кол-во детей'
FROM Mothers
JOIN Babies ON motherId = Mothers.id;

-- Имя последнего рожденного ребенка.
SELECT babyName
FROM Babies
ORDER BY birthday DESC
LIMIT 1;

-- Список женщин с именем последнего рожденного ребенка.
SELECT CONCAT(secname, ' ', SUBSTRING(motherName, 1, 1), '.', SUBSTRING(father, 1, 1), '.') AS 'Ф.И.О.', 
	   (SELECT babyName FROM Babies WHERE motherid = Mom.id ORDER BY Babies.birthday DESC Limit 1) AS 'Имя ребенка',
       (SELECT birthday FROM Babies WHERE motherid = Mom.id ORDER BY Babies.birthday DESC Limit 1) AS 'Дата рож-я ребенка'
FROM Mothers as Mom
JOIN Babies ON motherId = Mom.id
GROUP BY Mom.id;

-- Список женщин с именем последнего рожденного ребенка.
SELECT CONCAT(secname, ' ', SUBSTRING(motherName, 1, 1), '.', SUBSTRING(father, 1, 1), '.') AS 'Ф.И.О.', 
	   (SELECT babyName FROM Babies WHERE motherid = Mom.id ORDER BY Babies.birthday DESC Limit 1) AS 'Имя ребенка',
       (SELECT birthday FROM Babies WHERE motherid = Mom.id ORDER BY Babies.birthday DESC Limit 1) AS 'Дата рож-я ребенка'
FROM Mothers as Mom
JOIN Babies ON motherId = Mom.id
GROUP BY Mom.id;