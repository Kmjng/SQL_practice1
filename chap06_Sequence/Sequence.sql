/* 
시퀀스 개념 
오라클에서는 행을 구분하기 위해 기본키를 사용한다. 
시퀀스는 테이블 내의 유일한 숫자를 자동 생성하는 자동번호 발생기이다. 
기본키의 자료를 입력할 때 시퀀스를 이용한다. 

예시) 학번, 사번, 고객번호, 환자번호 등의 기본키에 자료 생성용 이용 

6가지 형식이 존재 
CREATE SEQUENCE 시퀀스이름 
START WITH n 
INCREMENT BY n 
MAXVALUE n | NOMAXVALUE 
MINVALUE n | NOMINVALUE 
CYCLE | NOCYCLE
CACHE n | NOCACHE 
*/

CREATE SEQUENCE deptno_seq 
INCREMENT BY 1 
START WITH 1; 

-- 시퀀스 데이터사전뷰 : USER_SEQUENCES 
SELECT * FROM USER_SEQUENCES;

-- 1. 시퀀스 <객체> 생성 
CREATE SEQUENCE empno_seq
START WITH 1
INCREMENT BY 1 
MAXVALUE 100000;

-- 2. 시퀀스 확인 : 데이터사전뷰 
SELECT SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG 
FROM USER_SEQUENCES; 

-- 3. 시퀀스 이용 

-- 실습용테이블 생성 
DROP TABLE emp01 PURGE; 
CREATE TABLE emp01 (
empno NUMBER(4) PRIMARY KEY, 
ename VARCHAR2(10), 
hiredate DATE
);

/*
형식: 객체.멤버 ( = 시퀀스객체.속성)
 ★ NEXTVAL : next value 
 ★ CURRVAL : current value (현재 값을 확인하고 싶을 때) 
*/
INSERT INTO emp01 (empno, ename, hiredate) VALUES(empno_seq.NEXTVAL, 'JULIA', SYSDATE);

SELECT * FROM emp01; 

INSERT INTO emp01 VALUES(empno_seq.NEXTVAL, 'KANG', SYSDATE); -- next value인 2가 INSERT 됨.

SELECT empno_seq.CURRVAL FROM dual; -- ★★★ dual 테이블은 시스템의 의사테이블임.★★★

-- 4. 시퀀스 수정 
-- start with 옵션은 수정할 수 없음. 
CREATE SEQUENCE dept_deptno_seq 
START WITH 10 
INCREMENT BY 10 
MAXVALUE 30 ; 

-- ★★★ 전체 시퀀스 목록 확인 ★★★
SELECT * FROM USER_SEQUENCES; 

SELECT dept_deptno_seq.NEXTVAL FROM dual ; -- 10
SELECT dept_deptno_seq.NEXTVAL FROM dual ; -- 20
SELECT dept_deptno_seq.NEXTVAL FROM dual ; -- 30
SELECT dept_deptno_seq.NEXTVAL FROM dual ; -- [오류] (MAXVALUE 초과) 
-- ★ 기존에 생성했을 당시, CYCLE 옵션을 지정하지 않음으로써 기본값으로 NOCYCLE을 갖게 되어 오류 발생 

-- 시퀀스 수정 - 최댓값 수정 
ALTER SEQUENCE dept_deptno_seq MAXVALUE 1000;

-- 5. 시퀀스 삭제 
DROP SEQUENCE dept_deptno_seq ; -- 시퀀스는 임시파일 개념이 없음. 


-- 문제(p.11): 부서 번호를 생성하는 시퀀스 객체 생성과 적용 
CREATE TABLE dept_example(
deptno NUMBER(4) primary key, 
dname VARCHAR(15), 
loc VARCHAR(15) 
);
-- 부서번호가 10,20,30,40 으로 삽입될 수 있도록 시퀀스 객체 (deptno_seq)을 생성하고 이를 이용해 레코드 삽입하기 
CREATE SEQUENCE deptno2_seq 
START WITH 10 
MAXVALUE 40 
INCREMENT BY 10 ; 

INSERT INTO dept_example VALUES( deptno2_seq.NEXTVAL , '인사과','서울');
INSERT INTO dept_example VALUES( deptno2_seq.NEXTVAL , '경리과','서울');
INSERT INTO dept_example VALUES( deptno2_seq.NEXTVAL , '총무과','대전');
INSERT INTO dept_example VALUES( deptno2_seq.NEXTVAL , '기술팀','인천');

SELECT * FROM dept_example;

SELECT * FROM deptno2_seq ;