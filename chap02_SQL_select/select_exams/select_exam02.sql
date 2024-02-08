-- <연습문제2>

-- 사용할 테이블 : emp

-- [문1] sal이 3000이상인 사원의 empno, ename, job, sal 출력하기 
SELECT empno, ename, job, sal 
FROM emp
WHERE sal >= 3000 ;

-- [문2] empno가 7788인 사원의 ename과 deptno 출력하기 
SELECT ename, deptno 
FROM emp 
WHERE empno =7788 ;

-- [문3] sal이 1500이상이고 deptno가 10,30인 사원의 ename과 sal를 출력하기 
SELECT ename, sal
FROM emp
WHERE sal >=1500 AND (deptno = 10 OR deptno =30);

-- ★★★ [문4] hiredate가 1982년 입사한 사원의 모든 정보 출력하기(힌트 : between ~ and ~) 
SELECT * 
FROM emp 
WHERE hiredate LIKE '82%' ;

-- [문5] comm이 NULL이 아닌 사원의 모든 정보를 출력하기(힌트 : is not null)
SELECT * 
FROM emp 
WHERE comm IS NOT NULL;

-- [문6] comm이 sal보다 10%가 많은 모든 사원에 대하여 ename,sal,comm 출력하기 
SELECT ename, sal, comm 
FROM emp 
WHERE comm >= sal*1.1 ;

-- [문7] job이 CLERK이거나 ANALYST이고 sal이 1000,3000,5000이 아닌 모든 사원 출력하기(힌트 : in, not in)
SELECT *
FROM emp 
WHERE (job = 'CLERK' OR job ='ANALYST') AND sal NOT IN (1000,3000,5000);

-- ★★★ [문8] ename에 L이 두 자가 있고, deptno가 30이거나 또는 mgr이 7782인 모든 사원 출력하기(힌트 : like)
SELECT * 
FROM emp 
WHERE ename LIKE '%L%' AND (deptno = 30 OR mgr = 7782) ; 
