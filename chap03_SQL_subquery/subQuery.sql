/* 
SELECT 문 안에 포함된 또 다른 SELECT문 (서브쿼리) 
하나의 select문으로는 조회가 불가능한 경우 이용

예 1) 하나의 테이블 대상: 사원 [부서번호] -> 같은 [부서] 직원 조회 
예 2) 두개의 테이블 대상: [사원정보] -> [부서정보] 조회 - 예제 4)

단일 행 서브쿼리 (하나의 행만을 반환하는 서브쿼리) - 예제 1)~6) 
다중 행 서브쿼리 (두 개 이상의 행을 반환하는 서브쿼리) 
*/ 

-- 사원 정보(emp), 부서 정보(dept) 테이블 
SELECT * FROM dept;
SELECT * FROM emp; 
SELECT dname FROM dept 
WHERE deptno = (SELECT deptno FROM emp WHERE ename = 'SCOTT');

-- 1. 단일행 서브쿼리 - 앞에는 [비교연산자]가 온다. (하나의 레코드) 
-- 예제 1) SCOTT과 같은 부서에서 근무하는 사원의 이름과 부서번호를 출력해라 (emp테이블) 
SELECT ename, deptno FROM emp 
WHERE deptno = (SELECT deptno FROM emp WHERE ename = 'SCOTT'); 

-- 예제 2) SCOTT과 동일한 직속상관을 가진 사원을 출력해라 (emp 테이블) 
SELECT * FROM emp 
WHERE mgr = (SELECT mgr FROM emp WHERE ename = 'SCOTT');

-- 예제 3) SCOTT의 급여와 동일하거나 더 많이 받는 사원명과 급여를 출력해라 (emp 테이블)
SELECT ename,sal FROM emp
WHERE sal >= (SELECT sal FROM emp WHERE ename = 'SCOTT');

-- 예제 4) DALLAS에서 근무하는 사원의 이름, 부서 번호를 출력해라 (dept01, emp 테이블) 
CREATE TABLE dept01 AS SELECT * FROM dept; 
-- [CTAS] CREATE TABLE 메인쿼리(복제) AS 서브쿼리(원본)
-- 원본의 자료를 유지하기 위해 

SELECT ename, deptno FROM emp 
WHERE deptno = (SELECT deptno FROM dept01 WHERE loc = 'DALLAS');
-- ★★★ 공통칼럼(deptno)이 반드시 있어야 한다. ★★★

--예제 5) sales(영업부) 부서에서 근무하는 모든 사원의 이름과 급여를 출력하시오(dept01, emp테이블) 
SELECT ename, sal FROM emp 
WHERE deptno = ( SELECT deptno FROM dept01 WHERE dname ='SALES');

-- 서브쿼리의 칼럼을 출력하고 싶을 때는??????????

-- 그룹(집계) 함수 사용 시 (이 또한 하나의 레코드) 
/* AVG(), SUM(), MAX(), MIN() */

-- 평균 급여 이상 수령자 조회 
SELECT ename, sal FROM emp WHERE sal > (SELECT AVG(sal) FROM emp);

-- 예제6) 부서번호 10번에 근무하는 사원 중에서 가장 적은 급여 보다 더 많은 급여 수령자의 사원명, 급여, 부서번호를 출력하시오(emp테이블) 
SELECT ename, sal, deptn o FROM emp 
WHERE sal > (SELECT MIN(sal) FROM emp WHERE deptno =10); 

-- 2. 다중 행 서브쿼리 
-- 형식:[메인쿼리] 비교연산자 IN/ANY/ALL [서브쿼리]; -조회되는 레코드가 2개 이상

--2.1. IN 연산자 
-- 예제 1) 급여가 3000이상인 사원이 소속된 부서가 10,20번이다. 여기서 서브쿼리 결과 중 ★하나라도 일치하면★ 참인 결과를 구해라 
SELECT ename, sal, deptno FROM emp 
WHERE deptno IN(SELECT DISTINCT deptno FROM emp WHERE sal >=3000);

-- 예제 2) 직급(JOB)이 MANAGER인 사람이 속한 부서의 부서번호와 부서명과 지역을 출력하시오(dept01, emp테이블) 
SELECT * FROM emp;
SELECT * FROM dept01;
SELECT * FROM dept01 WHERE deptno IN (SELECT deptno FROM emp WHERE job = 'MANAGER')
ORDER BY deptno;

--2.2. ANY 연산자 (OR)
-- >ANY: 어떠한 값들 보다는 크다. (최솟값보다 커야함)
-- <ANY: 어떠한 값들 보다는 작다. (최대값보다 작아야함) 
-- >ALL: 모든 값들 보다 크다. (최댓값보다 커야함) 
-- <ALL: 모든 값들 보다 작다. (최솟값보다 작야아함)
SELECT ename, sal FROM emp 
WHERE sal > ANY(SELECT sal FROM emp WHERE deptno = 30 ); 

-- 예제 3) 영업 사원들의 최소급여보다 더 많이 받는 사원들의 이름, 급여, 직급을 출력하되 영업사원은 출력하지 않습니다. 
SELECT ename, sal, job FROM emp 
WHERE sal > ANY(SELECT sal FROM emp WHERE job = 'SALESMAN') AND job !='SALESMAN';

--2.3. ALL 연산자 (AND) 
SELECT ename, sal FROM emp WHERE sal > ALL (SELECT sal FROM emp WHERE deptno = 30);

-- 예제 4) 전체 영업 사원 중에서 급여를 가장 많이 받는 사원보다 더 많은 급여 수령자의 이름과 급여를 출력해라 
SELECT ename, sal, job FROM emp WHERE sal > ALL (SELECT sal FROM emp WHERE job = 'SALESMAN');

SELECT ename, sal, job FROM emp WHERE sal > (SELECT MAX(sal) FROM emp WHERE job = 'SALESMAN');
-- 얘랑 무슨 차이?????????? 없음


-- 추가내용: 분석가 제외  
SELECT ename, sal, job FROM emp WHERE sal > ALL (SELECT sal FROM emp WHERE job = 'SALESMAN') AND job !='ANALYST';

-- 3. 커서(Cursor)를 고려한 서브쿼리 활용 
-- 커서란? SELECT문에서 레코드 작업 위치 
-- 연관 분석에서도 적용되는 원리
-- '우유'와 '빵' 동시 구매자 cart_id 조회 (★교집합★ 선행사건과 후행사건)
SELECT * FROM cart_products; -- 1001번 고객의 상품들, 1002번 고객의 상품들 ... Transaction이라 함

SELECT DISTINCT cart_id FROM cart_products 
WHERE cart_id IN (SELECT cart_id FROM cart_products WHERE name = '우유') --선행사건 
AND name ='빵'; -- 후행사건

/* 
조건부 확률 
서브쿼리(선행사건): 사건A
메인쿼리(후행사건): 사건A 교집합 사건B
*/
