-- 통계
/* 
그룹함수 (통계함수) : 그룹별 통계를 구하는 함수 
예 ) 직급별 급여 평균 구하기 

그룹 칼럼 = > 범주형 칼럼 이라 한다. 
*/

-- 1. Group 함수 
-- 그룹함수는 (NULL)을 제외한 값들로 계산한다.
-- ★★★ 산술연산에서는 NULL 들어가면 NULL 임 ★★★ ex) NULL + 5 = NULL 
-- 수학함수와 비교할 필요가 있다. 
SELECT ROUND(sal, -1) FROM emp; -- 전체 레코드 행 반환 (수학함수)
SELECT AVG(sal) FROM emp; -- 한 행만 반환 (그룹함수)
-- 한 행만 반환하기 때문에 다른 레코드와 함께 SELECT이 불가능하다. 

SELECT * FROM emp WHERE comm IS NULL ; 

SELECT SUM(comm) FROM emp ; 

SELECT AVG(comm) FROM emp ;

-- 그룹함수 + 산술연산 
SELECT SUM(sal + comm) FROM emp ; -- 순서: ★★★ 괄호 안 산술 > 총계
-- null을 포함하고 싶을 때 
SELECT SUM (sal + NVL(comm, 0) ) FROM emp ; 

-- 예제 
SELECT SUM(sal), AVG(sal) FROM emp ; 

SELECT SUM(sal), AVG(sal) FROM emp 
WHERE deptno = (SELECT deptno FROM emp WHERE ename = 'SCOTT'); 

CREATE TABLE tab_a (
C1 NUMBER(3),
C2 NUMBER(3),
C3 NUMBER(3)
);
INSERT INTO tab_a VALUES(10, 2, 5);
INSERT INTO tab_a VALUES(NULL, 3, 5); 
INSERT INTO tab_a values(3, null, null);

SELECT SUM(C1+C3) FROM TAB_A; 
SELECT SUM(C1 + NVL(C2, 0)) FROM TAB_A;

-- 1.2. MAX(), MIN() 
SELECT ename, MAX(sal) FROM emp ; -- [오류] 그룹함수는 하나의 행 만 반환한다. 

-- 날짜형도 MAX(), MIN() 사용 가능 
-- 예제)가장 최근에 입사한 사원의 입사일과 입사한지 가장 오래된 사원의 입사일을 출력해라 
SELECT MAX(hiredate) 최근입사일, MIN(hiredate) 오래된입사일 FROM emp ;

-- 1.3. 행(레코드) 갯수를 구하는 count 함수 (null 제외)
-- null을 포함한 전체 레코드 수를 반환하고 싶을 때 - COUNT(*)  
SELECT COUNT(*), COUNT(COMM) FROM emp ; 

SELECT JOB FROM EMP ; 
SELECT COUNT(job) FROM emp ; -- 14개 (중복포함) 
SELECT COUNT(DISTINCT job) FROM emp ; -- 5개 (중복제외) 함수 안에 명령어

-- 예제) 정교수와 조교수 모든 인원수 
SELECT COUNT(position) FROM professor 
WHERE position IN('정교수' ,'조교수'); -- 우선순위: FROM > WHERE > SELECT 

-- 1.4. 분산과 표준편차 
/* 
X: 변량 
모수 값 => N 개
표본의 통계량 = 자유도 (n-1) -- 셀 수 있으므로 표본 선택의 자유도가 n-1개임 
*/
-- ★★★ 변량의 수가 적으므로 표본분산, 표본표준편차임 ★★★ (n-1)으로 나눔
SELECT VARIANCE(bonus) FROM professor;
SELECT STDDEV(bonus) FROM professor; 
SELECT SQRT(VARIANCE(bonus)) FROM professor; 
SELECT POWER(STDDEV(bonus), 2) FROM professor; 

-- 표본 분산 계산 과정 
-- 산술평균 
SELECT AVG(bonus) FROM professor;  -- 78

-- 편차 = (변량 - 산술평균)
SELECT bonus-AVG(bonus) FROM professor; --[오류]
SELECT bonus-78 FROM professor; 
-- 편차 제곱 
SELECT POWER(bonus-78, 2) FROM professor; 
-- 편차 제곱 합 
SELECT SUM(POWER(bonus-78,2)) FROM professor; 
-- n값 확인
SELECT COUNT(bonus) FROM professor; -- null 제외한 갯수 
-- 계산 
SELECT SUM(POWER(bonus-78,2))/(COUNT(bonus)-1) FROM professor; 


-- 2. Group by 절 
/* 작성 순서
SELECT 칼럼명(별칭 사용O) 
FROM 테이블명, 테이블 명 (별칭 사용O)
WHERE 조건
GROUP BY 칼럼명 (별칭 사용X) 
HAVING 조건
ORDER BY 칼럼명

-- ★★★ Algorithm: FROM > (WHERE) > GROUP BY > (HAVING) > SELECT > ORDER BY 

-- GROUP BY 뒤에는 [범주형칼럼] 이 온다. 

*/

-- 사원 테이블을 대상으로 부서 번호로 그룹 
SELECT deptno FROM emp GROUP BY deptno ;

-- ★★★ 주의: GROUP BY 에 해당하는 칼럼만 SELECT 에 올 수 있다. ★★★
-- 단, 다른 데이터 함께 출력하고 싶은 경우 - 집계함수나 LISTAGG 함수 등 출력 가능
SELECT deptno, AVG(sal) FROM emp GROUP BY deptno; -- 부서번호 별 평균으로 집계
SELECT AVG(sal) FROM emp WHERE deptno = 20;

-- 각 부서별 최대급여, 최소급여 수령 금액 출력 
SELECT deptno , MAX(SAL), MIN(SAL) FROM emp 
GROUP BY deptno; 
SELECT deptno , MAX(SAL), MIN(SAL) FROM emp 
GROUP BY deptno; 

SELECT deptno,ROUND(AVG(SAL)), COUNT(*) FROM emp 
GROUP BY deptno; -- COUNT(*) 그룹(해당 부서)에 대한 전체 COUNT  

SELECT deptno,ROUND(AVG(SAL)), COUNT(*) FROM emp 
GROUP BY deptno
ORDER BY deptno; -- SELECT에 언급된 칼럼으로 정렬 적용 가능

-- NULL값도 그룹의 범주에 해당된다. 
DROP TABLE emp02 purge; 
CREATE TABLE emp02 AS SELECT ename, job, deptno FROM emp ; 
SELECT * FROM emp02;
INSERT INTO emp02 VALUES('TEST1',NULL,NULL) ;
INSERT INTO emp02 VALUES('TEST2',NULL,NULL) ;

SELECT deptno, COUNT(*) FROM emp02 GROUP BY deptno ORDER BY deptno;
SELECT job, COUNT(*) FROM emp02 GROUP BY job ORDER BY job;

-- ★★★ 예제) 부서별로 가장 급여를 많이 받는 사원의 정보를 결과와 같이 출력하시오 
SELECT * FROM emp; 
SELECT deptno, max(sal) FROM emp group by deptno;
-- (1) 서브쿼리에서 그룹핑해서 최대급여 레이블 SELECT  
-- (2) 출력 조건: 해당 최대급여에 해당하는 사람들 출력
SELECT empno, ename, sal, deptno FROM emp
WHERE sal IN (SELECT max(sal) FROM emp group by deptno );  --서브쿼리 [그룹별 최고급여들]을 메인쿼리 sal로 넘김 
-- 서브쿼리의 max(sal)에 해당하는 칼럼들만 메인쿼리를 통해 출력

-- 2개 이상의 칼럼으로 그룹화 가능 ★★★
SELECT deptno, job, AVG(sal), SUM(sal) 
FROM emp 
GROUP BY deptno, job  -- 1차: 부서별, 2차: 직급별 
ORDER BY deptno; -- 이때 avg 집계는 같은 직급(뒤에 오는 그룹칼럼)이 대상 ★★★
-- 확인
SELECT AVG(sal) FROM EMP WHERE JOB = 'CLERK' AND deptno=10 ;

-- 3. HAVING 조건
/* 일반 SQL 문: WHERE 조건 
GROUP BY 문: HAVING 조건 
*/
SELECT deptno, AVG(SAL) 
FROM emp 
GROUP BY deptno 
HAVING AVG(sal) >= 2000;  

-- WHERE절과 HAVING절 함께 올 수 있는가? 
SELECT deptno , AVG(sal) FROM emp 
WHERE deptno IN  (10,20) 
GROUP BY deptno;  -- 앞의 deptno in (10, 20)에 대해서 그룹핑 
-- ★★★ Algorithm :  FROM > WHERE > GROUP BY  > SELECT 

SELECT deptno , AVG(sal) FROM emp 
WHERE deptno IN  (10,20) 
GROUP BY deptno
HAVING AVG(sal) > 2500 ; 

-- ★★★ HAVING 뒤에 일반칼럼이 오면 오류 ★★★
SELECT deptno , AVG(sal) FROM emp 
WHERE deptno IN  (10,20) 
GROUP BY deptno
HAVING sal > 2500 ; --[오류]

-- 각 부서별 최대 최소 급여 (단, 최대급여 2900 초과) 
SELECT deptno, MAX(sal), MIN(sal) FROM emp 
GROUP BY deptno ;  -- MAX(sal) 에 2850 도 포함 

SELECT deptno, MAX(sal), MIN(sal) FROM emp 
GROUP BY deptno  HAVING MAX(sal) > 2900; -- 2900 미만은 제외되어 출력

SELECT deptno, MAX(sal), MIN(sal) FROM emp 
GROUP BY deptno  HAVING deptno !=10;   
-- deptno: 그룹칼럼에 해당한다.

-- 예제 7. 문제 6의 결과에서 'SCOTT'사원을 제외하고 급여를 내림차순으로 정렬하시오 
SELECT empno, ename, sal, deptno FROM emp
WHERE sal IN (SELECT MAX(sal) FROM emp group by deptno) 
AND ename !='SCOTT'  
ORDER BY deptno ASC ; 
-- 메인쿼리 입장: FROM > WHERE > SELECT > ORDER BY 
  
-- SELECT 문 실행 우선순위 
-- FROM > WHERE > GROUP BY > HAVING > SELECT > ORDER BY 

-- [추가] 중복제거 2가지 방법

-- 1) 칼럼 기준으로 중복 제거 
SELECT DISTINCT job  FROM emp ; 
-- 2) 그룹 기준 중복제거 
SELECT job FROM emp GROUP BY job;

-- Q11. 어느 회사의 직원 테이블(employee)은 직급(position)별로 사원 100명, 대리 50명, 
-- 과장 10명, 부장 5명 그리고 직급이 없는(null) 10명으로 구성되어 있을 때 
-- 다음 SQL문 3개를 순서대로 실행한 결과는? 

--SQL1) SELECT COUNT(position) FROM employee;  -- 165
--SQL2) SELECT COUNT(position) FROM employee WHERE position IN ('대리','부장','없음');  -- 55
--SQL3) SELECT COUNT(*) FROM employee GROUP BY position; -- 100, 40, 10, 5 , 10 (null까지 COUNT 집계)
--SQL4) SELECT COUNT(DISTINCT position ) FROM employee ; --4개 (null은 제외 )
--SQL5) SELECT COUNT(COUNT(*)) FROM employee GROUP BY position ; -- 5개  

SELECT * FROM emp;

INSERT INTO emp(empno, ename) VALUES(1111, '김땡땡') ;
rollback;
SELECT COUNT(*) FROM emp  GROUP BY deptno; 
SELECT COUNT(DISTINCT deptno) FROM emp ; 
SELECT COUNT(COUNT(*)) FROM emp  GROUP BY deptno;  