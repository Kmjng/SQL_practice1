-- SELECT_work.sql 
/*
SELECT
[DISTINCT] {*, column [Alias],..}
FROM
FROM테이블명
[WHERE
condition]
[ORDER BY {column, expression} [ASC | DESC]];
<< []: 생략가능, {}:예 >>
SELECT
원하는 컬럼 선택
* 테이블의 모든 컬럼출력
alias
해당 컬럼에 대한 별칭 다른 이름 부여
DISTINCT
중복 행 제거 옵션
FROM
원하는 데이터가 저장된 테이블 명 기술
WHERE
조회되는 행 제한 조건절
condition
조건식 컬럼 표현식 상수 및 비교 연산자
ORDER
BY 정렬을 위한 옵션(ASC 오름차순 기본값 DESCDESC내림차순)


<< 절과 절은 순서가 정해져 있음 >>
<< SELECT 문 실행(동작Algorithm) 순서 >>
1. 대상 테이블을 선택한다. 
2. 조건을 만족하는 레코드를 필터링한다.  
3. 칼럼을 선택한다. 
FROM > WHERE > SELECT > ORDER BY 
*/

--1. 전체 레코드(행) 조회 
SELECT * FROM emp; -- 테이블의 전체 열에 대한 행들을 조회한다. 
DESC emp; --테이블 구조 확인

SELECT empno, ename, sal, job FROM emp; -- 해당 열에 대한 행들을 조회한다. 

SELECT empno, ename, sal+300 FROM emp; -- "숫자형" 칼럼에 산술연산하여 조회 

SELECT empno, ename, sal*1.1 FROM emp; -- ★★★현재 SELECT문장에만 유효하다.★★★
    
--1.1. NULL값 처리 
SELECT empno, ename, sal, comm, sal+comm/100 FROM emp; -- (NULL)이 있는데 연산을 진행하면? 그대로 (NULL)
-- ★★★현재 SELECT문장에만 유효하다.★★★
/*
null : 값이 없음 
★★★ 주의: 0, 공백은 null이 아님. ★★★
*/

SELECT * FROM emp WHERE comm IS NULL; -- 수당(comm) 열 값이 null인 사람 출력 
SELECT empno, ename, sal, comm, sal+NVL(comm,0)/100 FROM emp; -- (NULL)값을 0 으로 처리해서 수행
-- 함수 NVL(null값이 존재하는 열, 대체할 값) 
SELECT ename,sal,comm,sal*12+NVL(comm,0) "연봉" FROM emp; -- ★★★ 수식으로 나타나는 열의 이름에 별칭(Alias)을 붙여준다. 
-- ★★★현재 SELECT문장에만 유효하다.★★★
SELECT ename,sal,comm,sal*12+NVL(comm,0) 연봉 FROM emp; --결과는 동일 
SELECT ename,sal,comm,sal*12+NVL(comm,0) AS 연봉 FROM emp; --결과는 동일 

/*
 이중 인용부호(" ") : 칼럼의 별칭 표기 
 단일 인용부호(' ') : 문자형(문자상수) 칼럼의 값 표기 (주로 DML에서) ★★★ 주의: 부호 안에 대소문자 구분됨 ★★★
*/
--1.2. 별칭(Alias) 활용 : 별칭을 사용하면 가독성이 좋아진다. 
SELECT ename 이름, sal "급여" FROM emp;

--1.3. 연결연산자 (||) 사용  ||''|| : 칼럼과 칼럼을 연결하는 역할이다. 
SELECT ename ||' '|| job FROM emp;
SELECT ename ||'_'|| job AS "사원명_직업" FROM emp;

SELECT ename ||' '||'is a'||' '|| job AS "Employess Details" FROM emp;

--1.4. DISTINCT : 특정 컬럼의 유일값을 제공 (default: 오름차순인데, 인덱스(원형 테이블 자료) 기준임...)
SELECT DISTINCT job FROM emp; -- 유일한 직책을 확인한다. 
SELECT DISTINCT deptno FROM emp;
SELECT DISTINCT deptno,job FROM emp; -- 두 개의 칼럼에 대한 유일값을 보고 싶을 때 <<행은 칼럼의 조합들이 중복되지 않게 출력>>
-- ★★★ DISTINCT 칼럼명: 범주형 ★★★ (이름ename처럼 유일성을 갖는 범주형은 굳이 사용되지 않는다)



--2. 특정 레코드(행) 조회: WHERE절 사용
--EMP 테이블에서 job이 MANAGER인 사원의empno , ename , job, sal , deptno 출력
SELECT empno, ename, job, sal 
FROM emp 
WHERE sal >= 3000; --조건절: WHERE 칼럼명 비교연산자(동등연산자) 숫자상수(문자상수)

SELECT * FROM emp WHERE ename = 'SCOTT' ; --대소문자 주의 

SELECT * FROM emp WHERE job = 'MANAGER';

SELECT * FROM emp WHERE job != 'MANAGER';

SELECT * FROM emp WHERE NOT job = 'MANAGER';

-- 82년도 이후 입사자 확인. 날짜형 칼럼: to_date() 함수 사용 (함수없이도 문자상수형태 -> (내부에서)숫자상수로 읽음)
SELECT * 
FROM emp
WHERE hiredate >= to_date('1982/01/01','yyyy/mm/dd'); --날짜형 칼럼: 대소/동등 비교연산자 사용 가능 (내부에서 숫자로 해석한다)

SELECT * 
FROM emp
WHERE hiredate >= '1982/01/01';

-- 2.1.SQL 연산자 (주로 WHERE문 안에 사용한다.)
/*

WHERE 칼럼명 SQL연산자

BETWEEN a AND b
a와b사이에 있다.(a, b값 포함)

IN (list) 
list(목록)의 값 중 어느 하나와 일치한다

LIKE
LIKE문자 형태와 일치한다 사용 포함문자 검색

IS NULL
NULL값을 가졌다

NOT BETWEEN a AND b 
a와b사이에 있지 않다.(a, b값 포함하지 않음)

NOT IN (list)
list의 값과 일치하지 않는다

NOT LIKE
LIKE문자 형태와 일치하지 않는다

IS NOT NULL
NULL값을 갖지 않는다
*/
SELECT ename, job, sal, deptno
FROM emp
WHERE sal BETWEEN 1300 AND 1500; -- 칼럼명 BETWEEN ~ AND ~ 

SELECT empno, ename, job, sal, hiredate
FROM emp
WHERE empno IN (7902,7788,7566);

SELECT empno, ename, job, sal, hiredate
FROM emp
WHERE job IN ('MANAGER','ANALYST');

-- LIKE연산자: 특정 문자를 포함한 문자열을 가진 행을 출력 -- 칼럼명 LIKE '패턴문자' 
--패턴문자: % 문자 여러개를 칭한다, _ 문자 한개를 칭한다. 
SELECT * FROM student WHERE name LIKE '서%' ; -- 접두어 포함 문자 검색 시 
SELECT * FROM student WHERE name LIKE '%재%' ;
SELECT * FROM student WHERE name LIKE '%수' ;
SELECT * FROM student WHERE name LIKE '__수' ;
SELECT * FROM student WHERE name LIKE '김_수' ;

-- 날짜형 타입의 특수성(2) 
SELECT * FROM emp WHERE hiredate LIKE '82%';

SELECT hiredate FROM emp;

SELECT empno, ename, job, sal, comm, deptno
FROM emp
WHERE comm IS NULL; 

SELECT empno, ename, job, sal, comm, deptno
FROM emp
WHERE comm IS NOT NULL; 

-- 2.2. 논리연산자 
/* 
★★★ 연산자 우선순위 ★★★
산술연산자 > 비교연산자 > 논리연산자
*/
SELECT empno, ename, job, sal, hiredate, deptno
FROM emp 
WHERE sal >= 1100 AND job = 'MANAGER';

SELECT empno, ename, job, sal, hiredate, deptno
FROM emp 
WHERE sal >= 1100 AND sal <= 1300;

SELECT empno, ename, job, sal, hiredate, deptno
FROM emp 
WHERE sal >= 1100 OR job ='MANAGER';

SELECT empno, ename, job, sal, hiredate, deptno
FROM emp 
WHERE job NOT IN ('MANAGER','CLERK','ANALYST');