/*
  집합 함수(COUNT,MAX,MIN,SUM,AVG) 
  작업 대상 테이블 : EMP, STUDENT, PROFESSOR
*/


--Q1. PROFESSOR 테이블에서 POSITION의 수를 출력하시오.
-- 정답
SELECT COUNT(DISTINCT POSITION) FROM professor;

-- 이거는 position 내의 레코드 수 
SELECT COUNT(*) FROM professor GROUP BY position; 



--Q2. EMP 테이블에서 소속 부서별 최대 급여와 최소 급여를 구하시오.
SELECT MAX(sal), MIN(sal) FROM emp GROUP BY deptno ; 

--Q3. EMP 테이블에서 전체 사원의 급여에 대한 분산과 표준편차를 구하시오.
SELECT VARIANCE(sal) , STDDEV(sal) FROM emp ;

-- Q4-1. EMP 테이블에서 각 부서별 사원수와 수당(comm)이 null이 아닌 사원수를 카운트 하시오.
-- 힌트) COUNT 함수 이용 
SELECT deptno, COUNT(empno) 전체사원수, COUNT(comm) 수당사원수  FROM emp 
GROUP BY deptno
ORDER BY deptno DESC;  -- deptno 의 사원(empno) 집계, deptno의 수당(comm) 집계 
/*
<출력 결과>
부서번호   전체사원수   수당사원수
     30          6         4  
     20          5         0
     10          3         0 
*/

-- Q4-2. EMP 테이블에서 실직적인 수당(comm)을 받는 사원수를 카운트 하시오.
-- 힌트) REPLACE 함수 이용 ★★★★
SELECT deptno, comm from emp ; 
SELECT deptno,  COUNT(*) , COUNT(REPLACE(comm,0,NULL)) FROM emp GROUP BY deptno
ORDER BY deptno DESC; 
/*
<출력 결과>
부서번호    전체사원수     수당사원수
    30          6             3    -> 실직적인 수당받는 사원수 
    20          5             0
    10          3             0 
*/      


-- Q5. PROFESSOR 테이블을 대상으로 교수 직위(position)별로 인원수를 출력하시오.
SELECT position 직위, COUNT(position) FROM professor GROUP BY position ;

/*
<출력 결과>
 직위    인원수 
 정교수      5
 조교수      6
 전임강사    5
*/   
SELECT * FROM professor; 
SELECT  deptno, AVG(pay) FROM PROFESSOR GROUP BY deptno;
--Q6. PROFESSOR 테이블에서 학과별 급여(pay)의 평균이 400 이상인 레코드를 출력하시오.
SELECT * FROM (SELECT deptno, AVG(pay) FROM professor GROUP BY deptno
HAVING AVG(pay) >= 400);

-- 답 
SELECT deptno, AVG(pay)  FROM professor GROUP BY deptno
HAVING AVG(pay) >= 400;

--Q7. PROFESSOR 테이블에서 학과별,직위별 급여(pay)의 평균을 구하시오. ★
SELECT deptno, position, AVG(pay)  FROM professor GROUP BY deptno, position;



--Q8. STUDENT 테이블에서 grade별로 weight의 평균과 최댓값, height의 평균과 최댓값을 
-- 구한 결과에서 키의 평균이 170 이하인 레코드를 출력하시오.
-- 힌트) HAVING 절과 AVG, MAX 함수 활용 
SELECT  grade, AVG(weight), MAX(weight), AVG(height), MAX(height)  FROM student 
GROUP BY grade 
HAVING AVG(height) <= 170 ;

--Q9. cart_products 테이블에서 구매자(cart_id)별로 구매액(price)의 총합을  
-- <출력 결과> 같이 출력하시오.
-- 힌트) HAVING 절과 SUM 함수 활용 
SELECT * FROM cart_products;
SELECT cart_id 구매자 ,  SUM(price) 총구매액 , COUNT(*) 구매건수 FROM cart_products  GROUP BY  cart_id;
/*
<출력 결과>
구매자  총구매액
  1001  5500
  1002  3000
  1003  4000
*/      

--Q10. EMP 테이블에서 급여 평균이 2000 이상인 부서 중에서 직원 수를 
-- <출력 결과> 같이 출력하시오.
-- 힌트) HAVING 절과 AVG 함수 활용 
SELECT deptno, COUNT(empno), AVG(sal) FROM emp 
GROUP BY deptno 
HAVING AVG(sal) >= 2000
ORDER BY deptno ASC;
/*
<출력 결과>
부서번호  직원수  평균급여 
      10        3        2917
      20        5        2175
*/ 


-- Q11. 어느 회사의 직원 테이블(employee)은 직급(position)별로 사원 100명, 대리 50명, 
-- 과장 10명, 부장 5명 그리고 직급이 없는(null) 10명으로 구성되어 있을 때 
-- 다음 SQL문 3개를 순서대로 실행한 결과를 답항에서 고르시오. 

--SQL1) SELECT COUNT(position) FROM employee;  -- 165
--SQL2) SELECT COUNT(position) FROM employee WHERE position IN ('대리','부장','없음');  -- 55
--SQL3) SELECT COUNT(*) FROM employee GROUP BY position; -- 100, 40, 10, 5 , 10
--SQL4) SELECT COUNT(DISTINCT position ) FROM employee ; -- 4개 
--SQL5) SELECT COUNT(COUNT(*)) FROM employee GROUP BY position ; -- 5개 


--Q12. 주어진 표본(x)의 표본분산과 표본표준편차를 구하시오.(ppt18. 참고)
/*
  표본(x) = [2, 4, 6, 8, 10]
  산술평균 = ? 6
  표본분산 = ? 10
  표본표준편차 =  ? 3.162277
*/
CREATE TABLE NUMB (
NUM NUMBER(3) 
);
INSERT INTO numb VALUES(2);
INSERT INTO numb VALUES(4);
INSERT INTO numb VALUES(6);
INSERT INTO numb VALUES(8);
INSERT INTO numb VALUES(10);

SELECT AVG(num) FROM numb; 
SELECT VARIANCE(num) FROM numb; 
SELECT STDDEV(num) FROM numb; 


