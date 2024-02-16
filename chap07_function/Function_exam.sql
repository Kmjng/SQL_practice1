/*
 * 주요 함수 
 * 작업 대상 테이블 : Student, EMP, Professor 
 */

--Q1. STUDENT 테이블에서 JUMIN 칼럼을 사용하여 
-- 태어난 달이 8월인 학생의 이름과 생년월일을 출력하시오.
-- 힌트 : SUBSTR 함수 이용
SELECT * FROM student ; 
SELECT name, birthday FROM student WHERE SUBSTR(JUMIN, 3,2) = 08;


--Q2. EMP 테이블에서 입사일이 짝수인 사원을 모두 출력하시오.
-- 힌트 : MOD 함수 이용
SELECT * FROM emp ; 

SELECT * FROM emp WHERE MOD(SUBSTR(hiredate, -2,2),2) = 0;
SELECT * FROM emp WHERE MOD(TO_NUMBER(hiredate),2) = 0;

--Q3. Professor 테이블에서 교수명, 급여, 보너스, 연봉을 출력하시오. 
-- 단 연봉 출력 시 다음 <조건>을 적용한다.  
-- 조건) 연봉 = pay*12+bonus 으로 계산, bonus가 없으면 pay*12 처리
-- 힌트 : NVL 함수 또는 NVL2 함수 이용  
DESC professor; 
SELECT name, pay, bonus, NVL2(bonus,pay*12+bonus, pay*12) 연봉 FROM professor;

--Q4. STUDENT01 테이블에서 '안'씨 성을 갖는 학생이름을 모두 '양'씨로 교체하여 
-- 학번, 학생명을 출력하시오.
-- 단, STUDENT01 테이블이 없는 경우 STUDENT을 이용하여 테이블을 만든다.
-- 힌트 : REPLACE 함수 이용 
CREATE TABLE student01 AS SELECT * FROM  student ; 
DESC student01;
SELECT id, name FROM student;
SELECT id, REPLACE(name,'안','양') FROM student01 ;

SELECT studno, REPLACE(name,'안','양') FROM student01 
WHERE name LIKE '안%';

/*
  <출력 결과>
  STUDNO NAME   RNAME
  9613   안광운  양광운  
  9712   안은주  양은주 
*/ 


--Q5. Professor 테이블에서 교수명, 학과명을 출력하되 
--  deptno가 101번이면 ‘컴퓨터 공학과’, 102번이면 
-- ‘멀티미디어 공학과’, 103번이면 ‘소프트웨어 공학과’, 
-- 나머지는 ‘기타학과’로 출력하시오.
-- 힌트 : DECODE 함수 이용
SELECt * FROM professor; 
SELECT name, DECODE(deptno, 101, '멀티미디어 공학과',103, '소프트웨어공학과','기타학과') FROM professor; 
 /*
  <출력 결과>
  NAME    DEPTNO     학과명
  조인형   101     컴퓨터 공학과
  박승곤   101     컴퓨터 공학과 
  양선희   102     멀티미디어 공학과      
          :
  허은    301      기타학과 
*/  


--Q6. 'EMP' 테이블을 대상으로 다음과 같은 <출력결과>와 같이 
-- 10번 부서 사원의 직책을 출력하시오.
-- 조건> PRESIDENT : 경영자, MANAGER : 관리자, 그외 나머지 직책 : 사원 
SELECT ename, job, DECODE(job, 'PRESIDENT','경영자','MANAGER','관리자','사원') 직책 
FROM emp
WHERE deptno = 10 ;

/*
  <출력 결과>
  ENAME    JOB      직책명
  CLARK   MANAGER   관리자
  KING    PRESIDENT 경영자
  MILLER  CLERK     사원 
*/       


--Q7. Professor 테이블을 대상으로 각 교수들의 홈페이지 유무를 조사하여 
-- 다음 <출력 결과> 같이 출력하시오.
-- 힌트 : NVL2 함수 이용
SELECT name, position, NVL2(hpage, '홈페이지 있음','홈페이지 없음') "홈페이지 유무"
FROM professor; 

/*
  <출력 결과>
  NAME    POSITION   홈페이지유무
  조인형   정교수      홈페이지 있음
  박승곤   조교수      홈페이지 있음
           :
  허은     조교수     홈페이지 없음 
*/

--Q8. cart_products 테이블의 전체 내용과 구조를 복제하여 새 테이블 products를 만들고,
-- products 테이블의 구매상품(name) 칼럼의 값이 '우유' 이면 '산양유'로 모두 수정하시오.
-- 힌트 : UPDATE문과 REPLACE 함수 이용

-- 1) 서브쿼리 방식으로 products 만들기 
CREATE TABLE products AS SELECT * FROM cart_products ;
-- 2) products 테이블의 구매상품(name) 내용 수정('우유' -> '산양유')
SELECT * FROM products;
UPDATE products SET name = REPLACE(name,'우유','산양유')
WHERE cart_id IN (SELECT cart_id FROM products WHERE name = '우유')
;

commit;