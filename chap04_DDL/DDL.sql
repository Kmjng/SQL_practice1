/*
의사칼럼(Pseudo Column)이란?
실존하지 않는 칼럼 (모든 테이블에서 이용되는 칼럼) 
★★ SELECT, WHERE 절에서 사용가능하다. 
SElECT 절에서 사용할 경우(★): 추출하는 데이터 순번을 부여하는 용도 
WHERE 절에서 사용할 경우(★★): 추출할 데이터 중 일부만 가져올 용도로 사용 (인덱스 특성을 이용해 부분범위 처리 유도가 가능)

ROWNUM 레코드의 순번★ (검색 순서를 출력함) - 보통 입력순서(INSERT)인듯.
ROWID 레코드의 고유값 (중복되지 않는 유일값) 
- 모든 테이블에 공용으로 쓰임

DDL - 자동커밋, 자동롤백
*/

--1. 의사칼럼 (ROWNUM, ROWID)
--1.1. ROWNUM (TOP_N개 레코드 조회)
SELECT ROWNUM, empno, ename, sal,ROWID
FROM emp;

SELECT ROWNUM, empno, ename, sal,ROWID
FROM emp
WHERE ROWNUM <= 5 ;

SELECT ROWNUM, empno, ename, sal,ROWID
FROM emp
WHERE empno LIKE '%79%';

-- 의사칼럼과 전체칼럼 출력하기 
SELECT ROWNUM, emp.*, ROWID --★POINT 사용★ 테이블명.* 
FROM emp 
WHERE ROWNUM <= 5 ; 

--단, 특정 범위의 의사칼럼을 조회하는 것은 불가능 (무조건 1부터 N까지만 가능)
SELECT ROWNUM, emp.*, ROWID 
FROM emp 
WHERE ROWNUM >= 5 AND ROWNUM <=10; --문법적 오류는 없지만 조회되지 않음. 

-- ★★★ 특정 범위의 순번을 검색하려면, '서브쿼리'와 '별칭'을 사용한다. ★★★
SELECT rnum, empno, ename, sal 
FROM (SELECT emp.*, ROWNUM rnum FROM emp) --FROM [테이블] 자리에 [서브쿼리] 온다. 
WHERE rnum >=5 AND rnum <=10;
-- FROM [서브쿼리] 안의 칼럼들을 [메인쿼리]에서 사용할 수 있다. 
-- 서브쿼리 별칭을 메인쿼리의 SELECT, WHERE절에서 사용이 가능하다. 

-- 전체 사원의 급여를 내림차순으로 정리해서 TOP 5 명을 선정해라 
SELECT * FROM emp 
ORDER BY sal DESC 
FETCH FIRST 5 ROWS ONLY; --FETCH와 ROWNUM(의사코드) 활용


-- 2. 테이블 생성 (CREATE TABLE) 
/* 
CREATE TABLE [schema.]table_name(
column datatype [DEFAULT expr] [column_constraint],...
[table_constraint]);

[DEFAULT expr]: insert 문자에서 값 입력 생략시 기본적으로 입력되는 값 지정 
[column_constraint]: 열 정의 부분에서 무결성 제약조건을 기술 (primary key, not null,,,)
[table_constraint]: 테이블 정의 부분에서 무결성 제약 조건을 기술 
*/

CREATE TABLE emp01(
empno NUMBER(4),
ename VARCHAR2(20),
sal NUMBER(7,2)); -- 전체자릿수, 소숫점자릿수 -- 정수자릿수 5

INSERT INTO emp01 VALUES(1001,'HONG',1234.1); -- [정상]
INSERT INTO emp01 VALUES(1001,'HONG',1234.123); --[정상] 소숫점자리 반올림됨.
INSERT INTO emp01 VALUES(1001,'HONG',123456.12); -- [오류] 전체자릿수 초과 돼 버림


--CTAS 원본과 뚁깥이 복제한다. (기존 테이블 내용과 구조 복제)
CREATE TABLE emp02
AS 
SELECT * FROM emp; 

-- 테이블 구조를 확인해볼까?
DESC emp02; --Describe

--CTAS 특정칼럼들만 복제한다.
CREATE TABLE emp03
AS 
SELECT empno, ename FROM emp ; 

-- (2024.02.14) 
CREATE TABLE emp04 AS SELECT empno, ename, sal FROM emp;
SELECT * FROM emp04;

-- 원하는 행만 선택적으로 복제 생성하기 
CREATE TABLE emp05 AS SELECT * FROM emp WHERE deptno = 10;
SELECT * FROM emp05;

-- 테이블 구조만 복사하기 ★★★ WHERE절에 (FALSE)로 작성하면 구조만 복사됨
CREATE TABLE emp06 AS SELECT * FROM emp WHERE 1=0;
SELECT * FROM emp06;
DESC emp06;
  
  
CREATE TABLE dept02 AS SELECT * FROM dept WHERE 1=0;
SELECT * FROM dept02;

--3. 테이블 제약조건(Constraint) 
-- 신뢰성 확보. 부적절한 자료 입력을 방지하기 위해 사용
-- 칼럼단위, 테이블 단위로 지정이 가능 

-- 3.1. Primary Key (기본키: PK) 
-- 두가지 기능: NOT NULL(생략불가), UNIQUE(중복불가)
-- 전제조건: 테이블당 Only 1. 

-- 칼럼 Level
CREATE TABLE test_tab1(
id NUMBER(2) CONSTRAINT test_id_pk PRIMARY KEY, 
name VARCHAR2(10) 
);
DESC test_tab1;

CREATE TABLE test_tab2(
id NUMBER(2), 
name VARCHAR2(10),
CONSTRAINT test2_id_pk PRIMARY KEY (id)
);

INSERT INTO test_tab1 VALUES(11, 'HONg'); --[정상]
INSERT INTO test_tab1 VALUES(11, 'HONG'); --[무결성 제약조건 위배]
INSERT INTO test_tab1(id) VALUES(12); --[가능]
INSERT INTO test_tab1(name) VALUES('HONg'); --[불가능]

--3.2. Foreign Key (외래키: FK)
-- 다른 테이블의 특정 칼럼(기본키)을 참조하는 칼럼 
-- 특징: NOT NULL 필수로 입력해야함 ★?????????

--(1) 기본키를 갖는 테이블 작성 
CREATE TABLE dept_tab(  -- ★★★ 마스터테이블 (참조의 주체가 되는 테이블)
deptno NUMBER(2), --기본키
dname CHAR(14),
loc CHAR(13),
PRIMARY KEY(deptno)
);

--(2) 마스터테이블의 레코드 추가 
INSERT INTO dept_tab VALUES(10,'기획실','서울');
INSERT INTO dept_tab VALUES(20,'영업부','싱가폴');

--(3) 외래키를 갖는 테이블 작성 
-- REFERENCES [참조할마스터테이블](기본키)
CREATE TABLE emp_tab(  -- ★★★ 트랜잭션테이블 (거래테이블)
empno    NUMBER(4),
ename   VARCHAR2(10),
job VARCHAR2(9),
mgr  NUMBER(4),
hiredate    DATE,
sal  NUMBER(7,2),
comm  NUMBER(7,2),
deptno  NUMBER(2) NOT NULL, --외래키 
FOREIGN KEY (deptno) REFERENCES dept_tab(deptno) 

);

--(4) 거래테이블에 레코드 추가 
INSERT INTO emp_tab(empno, ename, deptno) VALUES(1001, '홍길동', 10); 
INSERT INTO emp_tab(empno, ename, deptno) VALUES(1002, '이순신', 20); 
-- deptno는 외래키이기 때문에, 마스터테이블에서 참조하는 값이다. 
INSERT INTO emp_tab(empno, ename, deptno) VALUES(1001, '홍길동', 30); -- [무결성 제약조건 오류]


--문제) 사번이 1002 사원의 부서정보(마스터테이블)를 출력하시오 (서브쿼리 이용) 
SELECT * FROM dept_tab 
WHERE deptno = (SELECT deptno FROM emp_tab WHERE empno = 1002); 


-- 3.3. Unique Key (유일키: UK) 
-- 생략은 가능하되, 중복은 불가능
-- UK에 대해 Unique INDEX가 자동생성된다. ????????

CREATE TABLE uni_tab1(
deptno  NUMBER(2) UNIQUE, --유일키
dname CHAR(14),
loc CHAR(13)
);

INSERT INTO uni_tab1 VALUES(1, 'aaaa','bbbb'); --[정상]
INSERT INTO uni_tab1 VALUES(1, 'aaaa','bbbb'); --[오류]
INSERT INTO uni_tab1(dname, loc) VALUES( 'aaaa','bbbb'); --[가능]

DESC uni_tab1;
SELECT * FROM uni_tab1;

--테이블 Level 
CREATE TABLE uni_tab2(
deptno  NUMBER(2), --유일키
dname CHAR(14),
loc CHAR(13),
CONSTRAINT uni_tab2_deptno_uk UNIQUE (deptno)
);
DESC uni_tab2;

-- 3.4. NOT NULL (NN) 
-- 생략불가, 중복은 가능
-- ★★★ 칼럼 Level로만 생성 가능 

CREATE TABLE nn_ta1(
deptno NUMBER(2)  NOT NULL,
dname CHAR(14),
loc CHAR(13)
);

INSERT INTO nn_ta1(dname, loc) VALUES('AAAA','BBBB'); --[오류]
INSERT INTO nn_ta1 VALUES(11,'AAAA','BBBB'); --[정상]
INSERT INTO nn_ta1 VALUES(11,'AAAA','BBBB'); --[정상]
INSERT INTO nn_ta1 VALUES(11,'AAAA',NULL); --[정상]

--★★★ 여러 제약조건을 걸 수도 있음 
CREATE TABLE nn_ta12(
deptno NUMBER(2)  NOT NULL UNIQUE,
dname CHAR(14),
loc CHAR(13)
);

--3.5. CHECK (CK) -- CHECK(조건식) 
--칼럼 Level
CREATE TABLE ck_tab(
deptno NUMBER(2) CHECK (deptno IN(10,20,30,40,50)),
dname CHAR(14),
loc CHAR(13)
);
--테이블 Level
CREATE TABLE ck_tab2(
deptno NUMBER(2) ,
dname CHAR(14),
loc CHAR(13),
CONSTRAINT ck_tab2_deptno_ck CHECK (deptno IN(10,20,30,40,50))
);

INSERT INTO ck_tab VALUES(10, 'aaaa','bbbb'); --[정상]
INSERT INTO ck_tab VALUES(null, 'aaaa','bbbb'); --[정상]
INSERT INTO ck_tab VALUES(60, 'aaaa','bbbb'); -- [오류] check 제약조건에 위배

SELECT * FROM ck_tab;

-- 예시) 부서번호: 1~10 범위로 제약
CREATE TABLE ck_tab3(
deptno NUMBER(2) NOT NULL,
dname CHAR(14),
loc CHAR(13) NOT NULL UNIQUE,
CONSTRAINT ck_tab3_deptno_ck CHECK (deptno>=1 AND deptno<=10) 
);

INSERT INTO ck_tab3 VALUES(10, 'AAA','BBB');
INSERT INTO ck_tab3 VALUES(9, 'AAA',NULL); --[오류]
INSERT INTO ck_tab3 VALUES(11, 'AAA','CBB'); --[오류]

-- 4. 테이블 구조변경 (ALTER TABLE) 
-- RENAME COLUMN 절: 칼럼명 수정 
-- ADD COLUMN 절: 새로운 칼럼 추가 
-- MODIFY COLUMN 절: 기존 칼럼 속성 수정 
-- DROP COLUMN 절: 기존 칼럼 삭제 

SELECT * FROM emp01;
DESC emp01;
-- 4.1. 칼럼명 바꾸기 
ALTER TABLE emp01 RENAME COLUMN empno TO emp2no;
ALTER TABLE emp01 RENAME COLUMN emp2no TO eno;
-- 4.2. 새로운 칼럼 추가하기 
ALTER TABLE emp01 ADD (job VARCHAR2(9)); --새로운 칼럼에 값 채우려면 INSERT INTO ~ 
-- 문제)dept02 테이블에 문자타입의 부서장(dmgr) 칼럼 추가하기 
SELECT * FROM dept02;
ALTER TABLE dept02 ADD(dmgr VARCHAR2(10));

-- 4.3. 기존 칼럼 수정하기 (속성 수정) -- 칼럼이름 기준으로 변경
-- 속성 종류: 자료형, 크기, 기본값, 제약조건

-- (1) 특정 칼럼의 자료형 변경 
DESC emp01 ;
SELECT * FROM emp01;
ALTER TABLE emp01 MODIFY (eno CHAR(4));  --[오류]
-- 빈 칼럼만 변경이 가능
ALTER TABLE emp01 MODIFY (job NUMBER(9)); -- VARCHAR2 -> NUMBER 로 형변환 

-- (2) 특정 칼럼의 자료 크기 변경 
ALTER TABLE emp01 MODIFY (job VARCHAR2(30)); -- 자료형과 함께 변경도 가능 
-- ★★★ 주의: 괄호는 데이터 크기. 30글자가 아님. 10글자임 ★★★
-- 한글 기준: 10개 음절 입력 (1음절 = 3 byte) ** 해당 오라클 버전 기준

-- (3) 기본값 추가 및 변경 (기본값: NULL) 
ALTER TABLE emp01 MODIFY (job default '직책없음'); -- (NULL) 대신 '직책없음' 으로 들어간다.
-- ★★★ 주의: 기존의 (NULL)은 변경되지 않음 !!!

INSERT INTO emp01 VALUES(1004, 'test',250,NULL); 
INSERT INTO emp01(eno, ename, sal)  VALUES(1004, 'test',250); -- This 

-- (4) 제약조건 추가 및 변경 
DESC emp01; 
ALTER TABLE emp01 MODIFY ( eno NOT NULL);
ALTER TABLE emp01 MODIFY (job NOT NULL); --[오류] NULL이 이미 있으면 변경 불가능 

-- 5. 기존 칼럼 삭제하기 (DROP COLUMN) 
-- DROP 명령어로 테이블삭제 뿐만 아니라 칼럼삭제도 가능하다. 
ALTER TABLE emp01 DROP COLUMN job;
DESC emp01;

-- 5.1. 테이블 이름 변경 (RENAME TO)
ALTER TABLE emp01 RENAME TO emp01_copy;

-- 문제)dept02 테이블의 부서장(dmgr) 칼럼을 숫자타입으로 변경하시오
DESC dept02;
ALTER TABLE dept02 MODIFY (dmgr NUMBER(10));

-- 문제) dept02 테이블의 부서장(dmgr) 칼럼을 삭제하시오 
ALTER TABLE dept02 DROP COLUMN dmgr;

-- 6. 테이블 삭제 (DROP TABLE) 버전9부터 임시파일 제공을 함. (원치않을경우 PURGE)
-- 6.1. 테이블 삭제 BUT, 임시파일 유지 (테이블 목록 확인하면 존재함) 
DROP TABLE emp01_copy;
-- FLASHBACK으로 복구 가능하다. 
-- 전체 테이블 목록 보기 (TAB: 의사 테이블) 
SELECT * FROM TAB; 

-- 임시테이블 삭제
PURGE RECYCLEBIN; 

-- 테이블 구조만 냄기고 싶을 때 : TRUNCATE (DDL) - 취소와 플래쉬백 불가능
-- 데이터만 지우고 싶을 때: DELETE (DML) - 구조와 공간 남음 - 취소와 플래쉬백 가능 



-- 7. 데이터 사전과 뷰
/*
데이터 사전 = 시스템 카탈로그
- 데이터 베이스가 취급하는 모든 자원의 정보를 기록한 시스템 테이블
- 관리자(DBA)가 사용하는 도구(테이블 생성, 사용자 정보 등) 
- 일반 사용자는 '데이터 사전'을 직접 수정, 삭제, 조회등을 할 수 없다. 

★★★'데이터 사전'의 주요내용★★★
테이블 이름, 속성 정보, 물리적 위치, 무결성 제약 조건, 생성자 이름, 사용자 정보, 보안 및 접근 권한, 기타 

데이터 사전 뷰 (Data Dictionary View) - 객체 정보 조회 
- DBA_XXXX : 관리자용 데이터사전 뷰
- ALL_XXXX : 전체사용자 데이터사전 뷰 
- USER_XXXX : 현재 접속자용 데이터사전 뷰
*/

-- 7.1. [_XXXX] 사용자 VIEW
SELECT * FROM DBA_USERS; -- DBA_USERS: 관리자와 일반'사용자(USERS)' 정보를 확인하고 싶을 때 
SELECT * FROM ALL_USERS; -- 현재 접속 사용 및 접속권한 가진 사람들 
SELECT * FROM USER_USERS; -- 현재 접속 사용자 (현재 작업하고 있는 사람) 
-- 또는 
SHOW USER;

-- 7.2. [_XXXX] 테이블 VIEW 
-- USER_TABLES (현재 접속한 사용자 계정이 소유한 모든 테이블 정보를 조회할 수 있는 뷰) 
SELECT * FROM USER_TABLES ORDER BY TABLE_NAME ASC;

SELECT * FROM TAB; 

-- [_XXXX] 특정 테이블 VIEW 
SELECT TABLE_NAME FROM USER_TABLES 
WHERE TABLE_NAME LIKE 'E%' --★★★ 주의: 테이블 이름 대문자로 조회해야 함. 
ORDER BY TABLE_NAME ASC; 

-- 7.3. [_XXXX] 임시 파일을 조회할 수 있는 VIEW
SELECT * FROM USER_RECYCLEBIN; 

-- 7.4. [_XXXX] 테이블 제약조건 확인하는 VIEW 
-- 단, 어떤 칼럼에 제약조건이 들어갔는지 알 수 없음. 
DESC emp;  -- 이것만으로는 모든 제약조건을 확인하기 어려움 (ex. UNIQUE KEY) 

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMP' ; 
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'UNI_TAB1' ; 
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'CK_TAB2' ; -- CONSTRAINT_NAME 설정해서 들어가 있음. 



-- 7.5. 제약조건이 들어간 칼럼을 찾기 위한 VIEW
-- 단, 어떤 제약조건이 들어갔는지 알 수는 없음.
SELECT * FROM USER_CONS_COLUMNS;
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'EMP';

-- ★ 한번에 알고 싶을 때는? ★
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMP' ;
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'EMP';
--CONSTRAINT_NAME: SYS_C008325, CONSTRAINT_TYPE: PK


-- ★ NO~~ 
-- ★★★ 공통 칼럼을 기준으로 JOIN 한다!! ★★★
SELECT U1.CONSTRAINT_NAME, U1.CONSTRAINT_TYPE, U2.COLUMN_NAME
FROM USER_CONSTRAINTS U1, USER_CONS_COLUMNS U2 -- FROM ~, ~ 묶는다. / TABLE명도 별칭을 붙일 수 있다.
WHERE U1.CONSTRAINT_NAME = U2.CONSTRAINT_NAME --JOIN 조건 
        AND U1.TABLE_NAME = 'EMP'; --추가 조건