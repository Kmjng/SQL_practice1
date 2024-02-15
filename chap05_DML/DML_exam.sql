-- [1] SUBQUERY 이용 테이블 생성 
-- DEPT 테이블의 부서위치(LOC)가 'BOSTON'을 제외한 나머지 내용으로 DEPT_TEST 테이블을 생성하시오. 
CREATE TABLE dept_test AS SELECT * FROM dept WHERE loc != 'BOSTON';
SELECT * FROM dept_test;
-- [2] SUBQUERY 이용 레코드 수정 
-- DEPT 테이블의 부서번호 40번의 지역명을 이용하여 DEPT_TEST 테이블의 부서번호 30번 부서의 지역명을 변경하시오.
UPDATE dept_test SET loc = (SELECT loc FROM dept WHERE deptno = 40) WHERE deptno = 30 ;
SELECT * FROM dept;
-- [3] SUBQUERY 이용 레코드 수정 
-- DEPT 테이블의 부서번호 20번의 부서명과 지역명을 이용하여 DEPT_TEST 테이블의 부서번호 10번의 부서명과 지역명을 변경하시오.
UPDATE dept_test SET (dname, loc) = (SELECT dname, loc FROM dept_test WHERE deptno = 20 ) 
WHERE deptno = 10 ;

-- [4] SUBQUERY이용 테이블 만들기 
-- EMP 테이블에서 사번, 이름, 급여, 수당, 부서번호 칼럼의 내용으로 EMP_TEST 테이블을 생성하시오. 
SELECT * FROM emp; 
CREATE TABLE emp_test AS SELECT empno, ename, sal, comm, deptno FROM emp ; 

-- [5] SUBQUERY이용 레코드 삭제 
-- 'RESEARCH'부서에서 근무하는 모든 사원을 삭제하시오. 
-- 서브쿼리 : DEPT_TEST 테이블
-- 메인쿼리 : EMP_TEST 테이블 
SELECT * FROM dept_test;
SELECT * FROM emp_test;
DELETE FROM emp_test WHERE deptno IN (SELECT deptno FROM dept_test WHERE dname = 'RESEARCH');

-- [6] SUBQUERY이용 레코드 삭제 
-- 사원의 이름이 'M'로 시작하는 모든 레코드를 삭제하시오. 
-- 서브쿼리 : EMP 테이블
-- 메인쿼리 : EMP_TEST 테이블 
SELECT * FROM emp ; 
SELECT * FROM emp_test;
DELETE FROM emp_test WHERE empno IN (SELECT empno FROM emp WHERE ename LIKE 'M%' ) ;  

-- [7] SUBQUERY이용 테이블 만들기 
-- 동물 보호소 테이블에서  입양 간 동물을 제외하여 새 테이블을 생성하시오.
-- 동물 보호소 테이블 : ANIMAL_INS
-- 입양 동물 테이블 : ANIMAL_OUTS
-- 새 테이블 : ANIMAL_INS_FINAL
SELECT * FROM animal_ins;
SELECT * FROM animal_outs;
CREATE TABLE animal_ins_final AS SELECT * FROM animal_ins WHERE aid NOT IN (SELECT aid FROM animal_outs);
SELECT * FROM animal_ins_final;
-- [8] SUBQUERY이용 레코드 삽입 
-- 입양 간 동물 중에서 2020년도 8월 이후에 입양 간 동물을 대상으로 레코드를 삽입하시오.
-- 입양 테이블 : ANIMAL_OUTS
-- 삽입할 테이블 : ANIMAL_INS_FINAL
-- <조건> 삽입할 값이 없는 칼럼은 NULL 처리한다.  
INSERT INTO animal_ins_final (aid, atype, datetime, name) 
SELECT aid, atype, datetime, name FROM animal_outs 
WHERE datetime >= '20-08-01';

-- [9] SUBQUERY이용 테이블 만들기 & 레코드 삭제  
-- student 테이블을 이용하여 student2 테이블을 만들고, student 테이블에서 
-- 주 전공(DEPTNO1)이 201인 학생 중 77년도 출생한 학생을 student2 테이블에서 삭제하시오. 

-- 단계1. 테이블 만들기 
CREATE TABLE student2 AS SELECT * FROM student ; 
-- 단계2. 서브쿼리 이용 레코드 삭제 
SELECT * FROM student2;
DELETE FROM student2 WHERE studno IN (SELECT studno FROM student WHERE deptno1 = 201 ) 
AND birthday LIKE '77%';
-- 2개 행이 삭제됨... 

-- 단계3. 레코드 확인                       
SELECT * FROM student2;

-- [10] SUBQUERY이용 레코드 수정  
-- student 테이블을 이용하여 주전공이 102인 학생 중에서 부전공(DEPTNO2)이 NULL인 학생을
-- 조회하고, student2 테이블에서 해당 학생의 부전공을 최대 자릿수 만큼 9로 채워서 수정시오.

-- 단계1. 테이블의 칼럼 자릿수 확인 
DESC student;
SELECT * FROM student WHERE deptno1 = 102
AND deptno2 IS NULL ;


-- 단계2. 서브쿼리 이용 레코드 수정 
UPDATE student2 SET deptno2 = 999 
WHERE studno IN (SELECT studno FROM student WHERE deptno1 = 102
AND deptno2 IS NULL); 
-- 단계3. 레코드 확인 
SELECT * FROM student2;
commit;