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

INSERT INTO emp01 VALUES(1001,'HONG',1234.1);
INSERT INTO emp01 VALUES(1001,'HONG',1234.123); --소숫점자리 반올림됨.
INSERT INTO emp01 VALUES(1001,'HONG',123456.12); -- 전체자릿수 초과 돼 버림


--CTAS 원본과 뚁깥이 복제한다. (기존 테이블 내용과 구조 복제)
CREATE TABLE emp02
AS 
SELECT * FROM emp; 

--CTAS 특정칼럼들만 복제한다.
CREATE TABLE emp03
AS 
SELECT empno, ename FROM emp ; 