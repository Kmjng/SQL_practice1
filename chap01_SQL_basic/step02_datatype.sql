-- dataType.sql : Oracle 주요 자료형 

create table student(
sid int primary key,            -- 학번 
name varchar(25) not null,  -- 이름 
phone varchar(30) unique,  -- 전화번호 << UNIQUE KEY 중복불가능하다>>
email char(50),                  -- 이메일 
enter_date date not null     -- 입학년도 <<DATE 데이터타입에 레코드로 sysdate 입력하면 현재 일자 알려줌>>
);


SELECT * FROM students;
SELECT * FROM tab;
DESC student;

-- 레코드 삽입을 해봅시다. 
INSERT INTO student VALUES(2024020701, '김민정','01072631963','ppz7227@naver.com',sysdate); -- 이거 추가해보자~
INSERT INTO student VALUES(2024020702, '강민정','01072631964','ppz7228@naver.com',sysdate);
INSERT INTO student VALUES(2024020703, '이민정','01072631965','ppz7229@naver.com',sysdate);
UPDATE student SET sid = 2024020701 WHERE phone = '01072631963' ; 
ALTER TABLE student RENAME TO students; --테이블 명 바꿔봄
ALTER TABLE students modify (name varchar(50));
ALTER TABLE students ADD (age int);
UPDATE students SET age = 29 WHERE  name = '김민정' ;
UPDATE students SET age = 30 WHERE name = '강민정' ;
UPDATE students SET age = 31 WHERE name = '이민정';
-- 칼럼 이름 바꿀 목적으로 지워보기.. -민정 (2024-02-08)

-- 칼럼 정보 바꾸기.. 
ALTER TABLE students MODIFY (age number(38));


ALTER TABLE students RENAME COLUMN age1 TO age ;

SELECT * FROM students;
commit;
/*
 * Oracle 주요 자료형 
 *  1. number(n) : n 크기 만큼 숫자(실수) 저장 <<실수형>> n은 38자리까지 지원됨. 
 *  2. int : 4바이트 정수 저장 <<정수형>> 오라클에서 integer타입 잘 사용하지 않음. number로 변환된다. 
 *  3. varchar2(n) : n 크기 만큼 가변길이 문자 저장 
 *  4. char(n) : n 크기 만큼 고정길이 문자 저장
 *  5. date : 날짜/시간 저장 - sysdate : system의 날짜/시간 저장 
 */

/*
 * 제약조건 
 *  1. primary key : 해당 칼럼을 기본키로 지정(중복불가+null불가)
 *  2. not null : null값 허용 불가 
 *  3. unique : 중복 불가(null 허용)
 */


