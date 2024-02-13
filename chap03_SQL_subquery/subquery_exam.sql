select * from student; -- 학생 테이블 : 교수번호(profno), 주전공(deptno01)
select * from professor; -- 교수 테이블 : 교수번호(profno)


-- [문1] 교수번호(profno)가 2001인 지도교수를 모시는 전체 학생 명단 출력하기 
-- 서브쿼리 : professor, 메인쿼리 : student 
SELECT * FROM student WHERE profno = (SELECT profno FROM professor WHERE profno = 2001);

SELECT * FROM student WHERE profno = 2001;

-- [문2] professor 테이블에서 보너스(bonus)를 받는 교수들의 이름, 직위, 급여, 보너스 출력하기
-- 사용할 칼럼명 : 이름(name), 직위(position), 급여(pay), 보너스(bonus)
-- 힌트) IN()함수 이용 : 다중 행 처리  
SELECT name, position, pay, bonus FROM professor WHERE bonus !=0;
SELECT name, position, pay, bonus FROM professor WHERE profno IN (SELECT profno FROM professor WHERE bonus !=0); 

-- [문3] professor 테이블에서  301 학과(DEPTNO) 교수들 보다 더 많은 급여를 받는 교수들의 이름, 직위, 급여, 학과 출력하기 
-- 힌트) ALL()함수 이용 : 다중 행 처리 
SELECT name, position, pay, bonus FROM professor WHERE pay >ALL (SELECT pay FROM professor WHERE deptno =301);

--[문4] 'RESEARCH' 부서에서 근무하는 모든 사원을 대상으로 급여가 2,000 이상 수령받는 사원명, 직급, 급여, 부서번호 출력하기
-- 서브쿼리 : dept, 메인쿼리 : emp   
SELECT * FROM dept;
SELECT ename, job, sal, deptno FROM emp 
            WHERE deptno = (SELECT deptno 
            FROM dept 
            WHERE dname = 'RESEARCH') 
AND sal>=2000;

--[문5] cart_products 테이블에서 구매상품(name)에 '과자'와 '빵'를 동시에 구입한 장바구니 ID 출력하기(subQuery 이용) 
select * from cart_products;
SELECT cart_id FROM cart_products WHERE cart_id IN(SELECT cart_id FROM cart_products WHERE name = '빵') AND name = '과자';


/* 
 <출력 예시> 
 CART_ID
    1002
*/

       
-- [문6] 101학과(deptno1)와 102학과(deptno1)에 소속된 학생을 담당하는 지도교수(profno)를 
--   <출력 예시>와 같이 출력하기(단 홈페이지(hpage)가 없는 교수는 출력에서 제외)  
-- 서브쿼리 : student, 메인쿼리 : professor
SELECT profno, name, hpage FROM professor 
WHERE profno IN (SELECT profno FROM student WHERE deptno1 IN(101,102)) 
AND hpage IS NOT NULL;

SELECT * FROM student;
SELECT * FROM professor;
/* 
 <출력 예시> 
 PROFNO  NAME   HPAGE
   1001  조인형  http://www.abc.net
   1002  박승곤  http://www.abc.net
   2002  김영조  http://num1.naver.com   
*/
       

-- [문7] 학생(student) 테이블을 대상으로 평균 신장 보다는 작은 전체 학생 명단 출력하기
-- 힌트) AVG()함수 이용 
SELECT * FROM student WHERE height < (SELECT AVG(height) FROM student);
     
-- [문8] 교수(professor) 테이블을 대상으로 직책(position)이 '조교수' 중에서 
-- 가장 작은 급여(pay) 보다 더 많은 급여 수령자를  <출력 예시>와 같이 출력하기 
-- (단 보너스(bonus)가 100 미만인 교수들은 출력에서 제외한다.)
SELECT profno, name, position, pay, bonus FROM professor WHERE pay > ANY (SELECT pay FROM professor WHERE position='조교수'); 
/* 
 <출력 예시> 
 PROFNO  NAME   POSITION  PAY  BONUS
   1001  조인형  정교수     550   100 
   3001  김도형  정교수     530   110
   4001  심슨   정교수      570   130   
*/   
       
       