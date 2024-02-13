-- PRIMARY KEY 연습 
CREATE TABLE menu (
name varchar2(20) primary key,
health varchar2(10)
);
INSERT INTO menu(name, health) values('김치찌개','BAD');
INSERT INTO menu values('수제버거','BAD');

SELECT * FROM menu;

ALTER TABLE menu ADD(kcal number(10));

UPDATE menu SET kcal =500 WHERE name = '김치찌개';
UPDATE menu SET kcal =350 WHERE name = '수제버거';

-- 문자형으로 데이터 유형 변환하기(TO_CHAR) 
-- SELECT문의 함수이므로, 검색에만 반영되는 것인지

DESC menu;

ALTER TABLE menu DROP PRIMARY KEY; -- 설정했던 PK 삭제하기 

ALTER TABLE menu ADD(c_day date);
ALTER TABLE menu DROP COLUMN day;
ALTER TABLE menu DROP COLUMN cday;

UPDATE menu SET c_date = '2024/02/07' WHERE name ='김치찌개';
UPDATE menu SET c_date = '2024/02/09' WHERE name ='수제버거';

ALTER TABLE menu RENAME COLUMN c_day TO c_date;

