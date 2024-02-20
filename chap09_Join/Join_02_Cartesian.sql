-- 2. 논리적 조인 (Cartesian Join)  
-- 물리적조인과 차이점: 외래키를 지정하지 않는다. 
-- 공통칼럼만 가지고 연결해 사용한다. 

-- 논리적테이블을 사용하면 하나의 테이블을 다각도에서 활용 가능 

/*
    예) 
    SELECT 테이블1.칼럼, 테이블2.칼럼 ... 
    FROM 테이블1, 테이블2 
    WHERE 조인조건 ;  -- 2,3,4에 해당 


1. Cross Join: 조인 조건 없이 테이블 연결 - 실질적으로 쓰이진 않음 - 동일테이블 사용 
2. Self Join: 조인 조건을 이용해 한 테이블 내에서 연결 (조건 유무) - 동일테이블 사용 
3. Inner Join: 조인 조건을 이용해 일치하는 행만 테이블 연결 - 다른 테이블 사용 
4. Outer Join: 조인 조건을 이용해 일치하지 않은 행도 테이블 연결  - 상관무 



*/

-- 2.1. Cross Join 
--★★★  조인 결과가 의미를 가지려면 조인조건을 지정해야하는데, 조인조건이 없으므로 이런식의 조인은 별 의미가 없다. 
-- 조인 연산을 이해하는 지름길
SELECT * FROM emp, dept;  -- 행 56개(14*4) , 열 11개 (8+3) : emp(1) 에 대해 dept(4) 연결돼서
SELECT * FROM emp;  --  [14x8]
SELECT * FROM dept; --  [4x3]
-- 참고로, 중복된 칼럼은 _1으로 추가됨

-- 2.2. Self Join 
-- 동일한 테이블 끼리 조인하는 방식 
-- 별칭을 사용해 논리적으로 동일한 테이블 끼리 연결 ( ★★★ 그래야 구분이 가기 때문이다 ★★★) 
-- 같은 속성칼럼   (ex. empno, mgr  둘다 사원번호임) - 공통칼럼이라고 칭할 수 있다. 

-- 예1) 사원과 직속상사를 같은 행으로 출력할 경우 사용
-- 사원테이블 하나로 Self Join 
SELECT e1.*, e2.* FROM emp e1, emp e2 ; -- 여기까지는 조인조건 없으므로 Cross Join 에 해당함.  완전 의미 없네

SELECT e1.ename 사원명 , e2.ename 상사명 FROM emp e1, emp e2 
WHERE e1.mgr = e2.empno ;  -- e1의 mgr에 해당하는 e2의 empno를 갖다 붙인다. (참고: null이어서 대응값이 없는 경우 제외되어 출력됨) 

SELECT e1.ename 사원명 , e2.ename 상사명 FROM emp e1, emp e2 
WHERE e1.mgr = e2.empno AND e1.ename = 'SMITH' ;  -- 조건절 추가

-- 문제) 
SELECT e1.empno "사원 사번", e1.ename "사원명", e2.empno "직속상사 사번" , e2.ename "직속상사명" 
FROM emp e1, emp e2 
WHERE e1.mgr = e2.empno 
ORDER BY e1.ename DESC ;
-- 문제2) 직속상사가 KING인 부하직원 이름과 직책 출력해라 
SELECT e1.ename "직원 이름", e1.job "직책"
FROM emp e1, emp e2 
WHERE e1.mgr = e2.empno 
AND e2.ename = 'KING';

-- 예2) 빵과 우유 동시 구매자 조회 
SELECT * FROM cart_products;

SELECT c1.*  , c2.*
FROM cart_products c1, cart_products c2
WHERE c1.cart_id = c2.cart_id
AND c1.name = '빵' AND c2.name ='우유' ; -- Self Join 을 사용해서 서브쿼리 없이 교집합 출력했음 

-- 변형)))  빵과 우유 동시 구매자의 총 지불금액 출력하기 
 SELECT c1.cart_id  ,SUM(c1.price+ c2.price) AS "total price"  -- 해당 summation을 c1.cart_id 행 하나에 대해 표현 가능하기 때문에 가능한듯 
FROM cart_products c1, cart_products c2
WHERE c1.cart_id = c2.cart_id
AND c1.name = '빵' AND c2.name ='우유'
GROUP BY c1.cart_id ;  

-- 2.3. Inner Join  -- ★★★ 약간 서브쿼리 대신하는 느낌. 서브쿼리보다 효율적임
-- 별칭 생략 가능 
-- 가장 많이 사용됨 (★★★ 매우 그럴거 같다)
-- 조인 대상이 되는 테이블에서 칼럼의 값이 모두 존재하는 행을 연결해 결과를 생성하는 조인 방법 
-- 대응되지 않으면 생략하여 출력된다.

SELECT DISTINCT deptno FROM emp ; -- 10, 20 , 30  
SELECT DISTINCT deptno FROM dept ;  -- 10, 20, 30, 40  ★★★ 이 경우, Inner Join 시, 10, 20, 30 만 조인되어 출력됨 

SELECT * FROM emp, dept  -- 테이블이 다르기 때문에 Inner 또는 Outer 조인 둘 중 하나임
WHERE emp.deptno = dept.deptno ; -- 조인조건을 어떻게 하느냐에 따라 

SELECT emp.* , dname, loc  FROM emp, dept  
WHERE emp.deptno = dept.deptno ; 

-- WHERE 조건절 추가 
SELECT emp.* , dname, loc  FROM emp, dept  
WHERE emp.deptno = dept.deptno AND ename = 'SCOTT'; -- dept에 ename칼럼 없으므로 출처 생략 가능 

-- 테이블 별칭: AS 명령어 또는 " " 사용 불가 
-- 별칭 사용 가능 절: SELECT, WHERE, ORDER BY 절 


-- 문제 3. 뉴욕에서 근무하는 사원의 이름과 급여를 출력해라 (emp, dept사용) 
SELECT  ename, sal 
FROM emp , dept 
WHERE emp.deptno = dept.deptno
AND loc = 'NEW YORK' ;

SELECT * FROM emp, dept;
-- 추가) SCOTT과 동일한 부서에 소속된 사원의 이름과 직책 출력하기 
SELECT ename, job 
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND emp.deptno =( SELECT deptno FROM emp WHERE emp.ename='SCOTT');

-- 문제 4. ACCOUNTING 부서 소속 사원의 이름, 입사일, 근무지역, 부서명 을 출력하시오 
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') HIREDATE, loc, dname
FROM  emp , dept 
WHERE emp.deptno = dept.deptno 
AND dept.dname = 'ACCOUNTING' ;

-- 문제 5. 직급이 MANAGER인 사원의이름, 부서명을 출력하시오 
SELECT ename, dname 
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND job = 'MANAGER' ;

-- 문제 6. 학생테이블(student)와 교수테이블(professor) 조인하기 
-- 교수번호(profno) 칼럼을 기준 조인하여 그림과 같이 학생명, 학과(deptno1), 교수명, 교수번호 칼럼을 조회하시오 
SELECT * FROM student, professor;
SELECT st.name 학생명, st.deptno1 학과 , pr.name 교수명, pr.profno 교수번호   
FROM student st, professor pr
WHERE st.profno = pr.profno ;  
-- 여기에 출력되지 않은 학생들은 교수가 배정되지 않은 학생들이라고 해석가능하다. 
-- ★★★ 학생: 교수 = 1: n 

-- 문제 7. 문제6의 결과에서 101 학과만 검색되도록 하시오 
-- AND st.deptno1=101;



-- 2.4. Outer Join 
-- Inner Join과 다르게, 대응되지 않는 값도 출력해줌 (대신 NULL 로 출력됨)  
/*
두가지로 나뉜다. 
    Left Outer Join : 기준테이블(다있는놈) 이 왼쪽 / 대상 테이블 (부족한놈)(+) 이 오른쪽
    Right Outer Join  : 기준테이블이 오른쪽 / 대상테이블 (+)이 왼쪽
    (+) : 부족한 칼럼을 갖는 테이블에 붙는다. 
    
    남는 녀석이 추가사항이 된다. 
    
*/

-- 외부조인과 내부조인을 비교해봅시다. 
SELECT e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno ;-- 내부조인 

SELECT e.ename, d.deptno, d.dname
FROM emp e, dept d  -- 여기서 테이블 순서는 무관함
WHERE e.deptno (+) = d.deptno ;-- 외부조인 (중에서 기준테이블이 오른쪽이므로 Right Outer Join 이다. ) 

-- 문제 8 . KING은 이회사의 대표로 상사가 존재하지 않으므로 상사명이 NULL로 출력되도록 작성하시오 
SELECT e1.ename 사원명, e2.ename 상사명 
FROM emp e1, emp e2 
WHERE e1.mgr = e2.empno (+) ; 

-- (1) LEFT OUTER JOIN 에 대한 예문 
-- 전체 20명 학생 중에서 지도교수가 배정된 15명의 학생에 더불어, 배정되지 않은 5명도 출력해라 
SELECT s.name, s.deptno1, p.name 
FROM student s, professor p
WHERE s.profno = p.profno(+) ;  

-- (2) RIGHT OUTER JOIN 에 대한 예문 
-- 기준테이블을 지도교수로 지정한다면, 모든 교수가 학생을 한명 이상 담당한다고 출력될 것.  
-- 전체 16명 교수 중에서 9명은 학생이 한명 이상 배정됨 , 7명은 학생배정이 되지 않음 
SELECT s.name, s.deptno1, p.name 
FROM student s, professor p
WHERE s.profno(+) = p.profno;  -- 기준테이블: 지도교수 

-- ANSI JOIN에서 FULL JOIN이 있지만, 오라클에서는 지원하지 않는다. 

-- 3. ANSI JOIN  : 국제 표준 JOIN 문법 
-- 오라클 JOIN 문 보다 명시적이다.  

-- 3. 1. ANSI Cross Join 
SELECT * 
FROM emp CROSS JOIN dept ;  -- [56(14x4), 11(8+3)]  

-- 3. 2. ANSI Inner Join 
/*  
두가지 방법이 있다. 
-- USING 절 
SELECT * FROM 테이블1 INNER JOIN 테이블2 
   USING (공통칼럼명)  -- ★★★★★ USING 뒤에 꼭 소괄호 필수 ★★★★★

-- ON 절 
SELECT * FROM 테이블1 INNER JOIN 테이블2 
    ON (테이블1.칼럼1 = 테이블2.칼럼2)  -- ★★★ 얘는 소괄호 유무 상관 없음 ★★★
*/
SELECT emp.ename, dept.dname
FROM emp INNER JOIN dept
USING (deptno) ;  -- 조인 조건 역할 

SELECT emp.ename, dept.dname
FROM emp INNER JOIN dept
ON emp.deptno= dept.deptno ;  -- 조인 조건 역할 

-- INNER JOIN과 GROUP BY 함께 사용하기 
-- INNER JOIN에서 중복되는 값을 칼럼을 그룹핑함으로써 중복제거를 할 수 있다. (SELECT 할 칼럼 선택 주의) 

SELECT e.deptno, job , COUNT(*)
FROM emp e INNER JOIN dept d 
ON e.deptno = d.deptno 
GROUP BY e.deptno, job ; 