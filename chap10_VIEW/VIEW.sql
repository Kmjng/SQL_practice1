/*
    뷰(VIEW) : 기본테이블에하나의 쿼리문을 갖는 가상 테이블 
    << 뷰는 문자열(TEXT)로 이루어져 있다. >>
    - 최대목적: 각각의 사용자에 대해 접근권한을 다르게 하기 위해 
    - 읽기전용 뷰 :  기본 테이블 내용만 조회 가능 
    - 수정가능 뷰 : 제한적으로 기본테이블 수정, 삽입, 삭제 가능
    
    형식은 다음과 같다. ( 대괄호 생략가능) 
    CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW view_name   
    [ (alias1, alias2,...) ] -- 뷰의 별칭 
    AS {subquery} 
    [WITH CHECK OPTION]
    [WITH READ ONLY] ;
*/

-- 1. 뷰의 개념: View Life Cycle 

-- (1) 기본테이블 생성 
CREATE TABLE dept_copy  AS SELECT * FROM dept; 
CREATE TABLE emp_copy  AS SELECT * FROM emp;  

-- ★ 구조를 확인해보면, 테이블 복제할 때 제약조건 NOT NULL은 복제되지 않는 것을 알 수 있음. 
DESC EMP; -- EMPNO    NOT NULL NUMBER(38)  
DESC emp_copy ;  --EMPNO       NUMBER(38) 

-- (2) 뷰 만들기 
-- 일단, 뷰를 사용하지 않으면, 아래의 테이블을 조회하기 위해 SELECT 문을 여러번 입력해야 한다. 
SELECT empno, ename, deptno 
FROM emp_copy 
WHERE deptno= 30 ;  

-- 뷰를 생성해보자 
CREATE VIEW emp_view30 
AS SELECT empno, ename, deptno 
FROM emp_copy
WHERE deptno = 30 ; 
-- 읽기 전용으로 할 경우, WITH READ ONLY 를 마지막에 붙여준다. (레코드 읽기전용) 

-- 뷰의 내용 확인 
SELECT * FROM emp_view30; 



-- (3) 뷰를 생성할 권한이 불충분하다면 (ORA-01031: 권한이 불충분합니다. ) 
CONN system/manager 
GRANT CREATE VIEW TO scott ; -- DBA인 SYSTEM 계정으로 로그인해 뷰를 생성할 권한을  부여한다. 

-- (4) 뷰의 구조를 확인해보자
DESC emp_view30 ; -- 뷰의 구조가 아닌, ★★ 물리적인 기본테이블의 구조★★ 를 보여준다. 

CREATE VIEW view_emp
AS SELECT * FROM emp ; 
DESC view_emp ;   

-- (5) 데이터 사전 뷰를 통해 뷰 목록 확인하기 
-- 뷰를 정의할 적 기술한 쿼리문이 궁금하다면 데이터사전 뷰 USER_VIEWS 의 TEXT 칼럼값을 확인하면 된다. 
SELECT * FROM user_tables;  -- 테이블 목록
SELECT VIEW_NAME, TEXT  FROM user_views;  -- 뷰 목록 
-- 뷰가 실질적인 내용이 아닌 TEXT 로 이루어져 있음을 알 수 있다. ( TEXT 내용이 동작되는 것) 

-- (6) 뷰 삭제하기  - PURGE는 사용하지 않는다. 
DROP VIEW emp_view30; 

-- 2. "구조를" 건들 수 있는 뷰 만들기 : CREATE OR REPLACE VIEW ~ 
-- 반복수정이 가능하다.  (해당 뷰 이름으로 덮어쓰기가 가능하다.) 

-- 3. 뷰의 별칭 : 실제 테이블에 없는 칼럼을 뷰로 가져올 경우는 필수로 별칭을 부여한다. 
-- 방법 1. 뷰 이름 뒤에 칼럼들의 별칭들 나열 
-- 방법 2. SELECT 각 칼럼 뒤에 별칭 부여  

-- 3.1. 함수 이용시, 별칭 필수 

CREATE OR REPLACE VIEW emp_view_alias (deptno, 합계, 평균) 
AS SELECT deptno , SUM(sal), AVG(sal)
FROM emp_copy 
GROUP BY deptno ; 

-- 3.2. 일반칼럼 : 별칭 선택사항 
CREATE OR REPLACE VIEW emp_view_alias(부서번호, 급여합계, 급여평균)
AS SELECT deptno, dname, loc 
FROM dept_copy ; 

-- 3.3. 수식 이용시, 별칭 필수 
CREATE OR REPLACE VIEW emp_sale_alias (사원명, 급여, 수당, 연봉) 
AS SELECT ename, sal, comm, sal*12 + NVL(comm, 0) 
FROM emp 
WHERE deptno = 30 ; 
SELECT * FROM emp_sale_alias; 

-- 4. 뷰의 동작원리 

-- (1) 뷰 생성 
CREATE OR REPLACE VIEW emp_view10
AS SELECT empno, ename, deptno 
FROM emp_copy 
WHERE deptno = 10; 
-- 읽기 전용으로 할 경우, WITH READ ONLY 를 마지막에 붙여준다. (레코드 읽기전용)



SELECT * FROM emp_view10; 

-- (2) 뷰를 이용한 레코드 삽입 (INSERT문) 
INSERT INTO emp_view10 VALUES(1111, 'AAAA'  , 30);  -- 단, 원본테이블 8개 칼럼 중, 3개의 칼럼만 접근 가능 ★★★
-- INSERT 하면 원본테이블 emp_copy 에 삽입된다. (3개의 칼럼만) 
SELECT * FROM emp_copy; 
-- 조회해보면, 해당 뷰가 10번사원만 보여지므로 안보임. 

-- 맨 위에서 만든 (구조는 못건드는) 뷰에 레코드 삽입 (가능한듯) 
INSERT INTO emp_view30 VALUES(1111, 'AAAA'  , 30);
SELECT * FROM emp_copy; -- 원본테이블에 추가돼있는 것 확인 가능  

-- (3) 뷰를 이용한 수정 ( 뷰를 통해 보이는 레코드만 수정가능하다. ) 
UPDATE emp_view10 SET ename = 'CLARK_COPY' WHERE empno = 7782 ; -- 10번 부서만 수정 가능하다. 

-- (4) 뷰를 이용한 레코드 삭제 (뷰를 통해 보이는 레코드만 수정가능하다. ) 
-- 원본테이블의 레코드가 삭제된다. 
DELETE FROM emp_view10 
WHERE empno = 7782 ; 



-- 5. 뷰의 사용목적 

-- (1) 복잡하고 긴 SQL 문을 뷰로 정의하여 접근을 단순화한다. 
CREATE OR REPLACE VIEW customer_usage 
AS
SELECT c.cid, c.cname, SUM(u.usage * s.price) as "최종 전기 요금" 
FROM customer c INNER JOIN usage_tab u 
ON ( c.cid = u.cid)
 INNER JOIN slot_tab s 
ON (SUBSTR(TO_CHAR(u.use_time, 'YY-MM-DD HH24'), -2, 2)
BETWEEN SUBSTR(TO_CHAR(s.start_time, 'YY-MM-DD HH24'), -2, 2) AND 
 SUBSTR(TO_CHAR(s.end_time, 'YY-MM-DD HH24'), -2, 2))
GROUP BY c.cid, c.cname 
WITH READ ONLY  ; --  View Option

SELECT * FROM customer_usage; 

-- (2) 보안을 목적으로 테이블 접근을 제한한다. 
SELECT * FROM emp; 

-- <영업부의 VIEW> ename, mgr, comm 
CREATE OR REPLACE VIEW salesman_view 
AS SELECT ename, mgr, comm
FROM emp 
WHERE deptno = 30 
WITH READ ONLY ; 

SELECT * FROM salesman_view ; -- 영업부에게 이 뷰를 준다. 

-- <인사과의 VIEW> 급여, 수당 정보 제외 / 읽기전용 / 대상: 대표를 제외한 모든 인원 
CREATE OR REPLACE VIEW hr_view
AS SELECT empno, ename, job, mgr, hiredate, deptno 
FROM emp WHERE job !='PRESIDENT'
WITH READ ONLY ; 

SELECT * FROM hr_view ; 

-- 6. 뷰의 옵션들 (2024-02-22) 
/*
    옵션없는 view : ★★★ 조건에 사용되지 않은 내용도 수정(삽입O, 수정O, 제거O) 가능 (단, 당연히 SELECT 된 칼럼에 해당되어야 한다.) 
    WITH READ ONLY : 읽기 전용 
    WITH CHECK OPTION : 옵션없는 뷰와 비슷할 수 있으나, 해당 명령어가 있으면 
        추가적으로 점검사항이 존재. (조건 하에 수정 가능)
        뷰 생성 시 적용된 'WHERE 절에서의 칼럼'을 보호하는 목적. 
        ★★★조건에 해당하는 레코드만 수정(삽입O, 수정O, 제거O)이 가능하다.  
        ★★★근데 조건에 쓰인 칼럼의 내용은 변경 불가 
        그리고 WHERE 절 이외의 레코드는 건들 수 없다. 
*/
-- 6.1. WITH READ ONLY 

DROP TABLE emp_copy purge; 
CREATE TABLE emp_copy AS SELECT * FROM emp; 
select * from emp_copy ; 

CREATE OR REPLACE VIEW VIEW_READ30
AS 
SELECT EMPNO, ENAME, SAL, COMM, DEPTNO 
FROM EMP_COPY WHERE DEPTNO=30
WITH READ ONLY;
SELECT * FROM view_read30;

INSERT INTO view_read30 VALUES (1111, 'TEST', 2500, 100, 30); -- [불가능] 

-- 6.2. WITH CHECK OPTION 

CREATE OR REPLACE VIEW VIEW_CHK30
AS 
SELECT EMPNO, ENAME, SAL, COMM, DEPTNO 
FROM EMP_COPY
WHERE DEPTNO=30 -- 해당 칼럼이 with check option 에 해당된다. 
WITH CHECK OPTION;

SELECT * FROM view_chk30;

-- 기능 1. 
-- 부서번호 detpno 칼럼의 내용을 건들 수 없다. ( 30 -> 20 X)

UPDATE view_chk30 SET comm = 1000 ; -- [가능] 
-- ★★★ WHERE절 없이, 부서번호 30번인 레코드의 칼럼만 수정 가능
SELECT * FROM emp_copy ;  -- 원본테이블에서 보면 부서번호30번만 변경되어 있다. 

-- WITH CHECK OPTION 의 기능 확인 
UPDATE view_chk30 SET deptno = 20 
WHERE sal >= 1200; -- [오류] WITH CHECK OPTION의 조건에 위배됨 
-- 만약 옵션이 없었으면 수정 가능했음. 

-- 기능 2. 
-- 수정 가능한 칼럼: empno, ename, sal, comm, deptno (이거는 옵션없어도 해당되는 내용임! ) 
INSERT INTO view_chk30 VALUES(2222,'TEST', 200, 100 , 30 ) ; -- ★부서번호 30번만 수정가능  
INSERT INTO view_chk30 VALUES(2222,'TEST', 200, 100 , 10 ) ; -- [오류] 이것도 옵션없었으면 수정가능


commit;


-- 제한적으로 뷰의 삭제 가능 : 부서번호 30에 해당하는 레코드 삭제는 가능 
DELETE FROM view_chk30 
WHERE empno = 2222 ; -- [가능]
-- 30번만 보이는 VIEW인데 20번을 수정한다? CHECK OPTION에 의해 안됨 
DELETE FROM view_chk20 
WHERE deptno = 20  ; -- [가능]


SELECT * FROM view_chk20;


-- 7. 뷰와 의사칼럼 (ROWNUM) 

-- 입사일 기준으로 내림차순 정렬 뷰 생성 
-- [방법 1]
CREATE OR REPLACE VIEW hiredate_view 
AS SELECT empno, ename, hiredate 
FROM emp_copy 
ORDER BY hiredate DESC nulls last; 
-- 참고로, 원본테이블은 레코드 추가 순서로 구성되어 있음. 

SELECT * FROM hiredate_view ; 

-- 최근 입사자 TOP5 를 뽑아보자 (1) 
SELECT * FROM hiredate_view 
WHERE ROWNUM <= 5; 

-- 최근 입사자 TOP5 를 뽑아보자 (2) 
SELECT * FROM hiredate_view 
FETCH FIRST 5 ROWS ONLY ; 

-- [방법 2] 최초 입사자 TOP 5을 선정한 뷰를 생성한다고 한다고 하자.   
CREATE OR REPLACE VIEW top5_view1 
AS SELECT empno, ename, hiredate, job 
FROM emp 
WHERE ROWNUM <= 5;  --원본테이블에서 입력됐던 순서를 기반으로 ROWNUM 
SELECT * FROM top5_view1 ;

-- 최근 입사자 TOP 5을 선정한 뷰를 생성한다고 한다고 하자.   
-- <다음은 틀린 예>
CREATE OR REPLACE VIEW top5_view2
AS SELECT empno, ename, hiredate, job 
FROM emp 
WHERE ROWNUM <= 5
ORDER BY hiredate DESC ; -- 우선순위 마지막 실행  
SELECT * FROM top5_view2 ;  -- ROWNUM 안에서 DESCENDING 된 결과가 나와버린다. 


-- 만약 입사일이 같으면? 
-- [CREATE 서브쿼리] 안에서 명령된 TOP5 은 '첫번째 칼럼 기준 오름차순 조회'