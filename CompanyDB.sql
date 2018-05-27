-- 12. Сделай таблицу компаний. Учти, что у компаний могут быть филиалы, у которых тоже могут быть свои филиалы.
CREATE DATABASE CompanyDB;

USE CompanyDB;

-- Создаем таблиwe компаний.
CREATE TABLE Companies
(
	id TINYINT NOT NULL AUTO_INCREMENT,
    compName VARCHAR(20) NOT NULL DEFAULT 'company name',
		PRIMARY KEY (id)
);

-- Создаем таблицу зависимости компаний типа: головная компания - филиал.
CREATE TABLE CompanyDependency
(	
	parentId TINYINT NOT NULL,
    childId TINYINT NOT NULL,
		FOREIGN KEY (parentId) REFERENCES Companies(id),
		FOREIGN KEY (childId) REFERENCES Companies(id)
);

-- Процедура генерирования имен компаний и заполнения таблицы Companies.
DELIMITER //
CREATE PROCEDURE CompaniesInputLoop(numLoops TINYINT)
BEGIN
	SET @iter = 1;
	WHILE @iter <= numLoops DO
		SET @compName = CONCAT('Company ', @iter);
		INSERT INTO Companies
        (compName)
        VALUES (@compName);
        SET @iter = @iter + 1;
	END WHILE;
END; //
-- DELIMITER

-- Вызов процедуры, заполняющей таблицу Companies.
CALL CompaniesInputLoop(25);

-- Заполняем таблицу CompanyDependency.
INSERT INTO CompanyDependency
VALUES
( 1,  2),
( 1,  3),
( 1,  4),
( 5,  6),
( 5,  7),
( 5,  8),
( 9, 10),
( 9, 11),
( 9, 12),
( 2, 13),
( 3, 14),
( 4, 15),
( 5, 16),
( 6, 17),
( 7, 18),
( 8, 19),
( 9, 20),
(10, 21),
(11, 22),
(12, 23),
( 1, 24),
( 5, 25);

-- 13. Напиши запрос, который выведет компании и кол-во филиалов у них (без учета филиалов филиалов).
-- Выводим только головные компании, филиалы филиалов исключаются из выборки.
SELECT Com1.compName AS 'Название компании', Count(*) AS 'Кол-во дочек'
FROM Companies AS Com1
JOIN CompanyDependency AS Dep1 ON Com1.id = Dep1.parentId
WHERE Com1.id NOT IN
(
	SELECT childId FROM CompanyDependency
)
GROUP BY Com1.compName;
