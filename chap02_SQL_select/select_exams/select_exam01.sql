-- <연습문제1>

-- [문1] 다음 문장에서 에러를 올바르게 수정하기(년봉은 별칭)
SELECT empno,ename,sal * 12 년봉 FROM emp;


-- [문2] EMP 테이블을 대상으로 사번, 이름, 입사년도, 직속상관의 칼럼을 출력하기
-- 사용 컬럼명 : 사번(empno), 이름(ename), 입사년도(hiredate), 직속상관(mgr)
SELECT empno, ename, hiredate, mgr, deptno FROM emp; -- mgr은 직속상관의 사번

-- [문3] EMP 테이블에서 중복되지 않는 부서번호(deptno) 출력하기(힌트 : distinct)
SELECT DISTINCT deptno FROM emp;

-- [문4] DEPT 테이블의 dname과 loc를 연결하여 <출력 형식>과 같이 출력하기
SELECT dname ||' -> '|| loc AS "부서명과 부서위치" FROM dept;


/* <출력 형식>
   부서명과 부서위치 
   ACCOUNTING -> NEW YORK
   RESEARCH -> DALLAS
   SALES -> CHICAGO
   OPERATIONS -> BOSTON     
*/   

-- [문5] EMP 테이블의 ename, job, deptno를 연결하여 <출력 형식>과 같이 출력하기
SELECT ename ||''||' 사원의 직책은 '|| job ||''||' 이고, 부서번호는'|| deptno AS "사원 정보" FROM emp; 

/* <출력 형식>
     사원 정보   
     SMITH 사원의 직책은 CLERK 이고, 부서번호는 20
        :
     MILLEER 사원의 직책은 CLERK 이고, 부서번호는 10   
*/

-- [문6] gift 테이블을 대상으로 별칭을 사용하여 <출력 형식>과 같이 출력하기 
select * from gift; -- gift 테이블 전체 조회 

SELECT gno AS "선물번호" , gname AS "선물이름" FROM gift;
/* <출력 형식>
    선물번호 선물이름 
         1  참치세트
         2  샴푸세트   
         :
        10 양쪽문냉장고   
*/ 

-- [문7] professor 테이블을 대상으로 각 학과에 소속된 유일한 직위 출력하기(힌트 : distinct) 
-- 사용 컬럼명 : 학과(deptno), 직위(position)
SELECT DISTINCT deptno, position FROM professor;
/* <출력형식>
   DEPTNO  POSITION 
      101   정교수 
      101   조교수
      101   전임강사 
      102   전임강사 
      102   조교수
      102   정교수
        :
      301   전임강사 
      301   조교수
*/


-- [문8] professor 테이블을 대상으로 NVL() 함수를 이용하여 <출력 형식>과 같이 출력하기 

SELECT profno, name, pay, bonus, pay+NVL(bonus,0) AS 지급액 FROM professor;

/* <출력 형식>
     PROFNO NAME  PAY  BONUS  지급액 
      1001  조인형  550  100    650
      1002  박승곤  380   60    440
      1003  송도권  270  (null) 270 
         :
      4007  허은   290    30    320   
*/
