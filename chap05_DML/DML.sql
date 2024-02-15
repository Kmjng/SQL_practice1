/* 
데이터 조작어(DML): 레코드 조회, 삽입, 수정, 삭제 
 - COMMIT 또는 ROLLBACK으로 명령어 완성 
 - INSERT/UPDATE/DELETE 
 - COMMIT: DB반영 
 - ROLLBACK: 명령 수행 이전 상태 (복원) 
 - SELECT 는 COMITT 대상이 아님.

    1. 단일 쿼리문 
    
    2. 서브 쿼리문 
    INSERT/UPDATE/DELETE 사용하고 뒤에 SELECT 사용
*/

-- 1. INSERT 문 (레코드를 삽입) - INSERT INTO ~ () VALUES ();

DROP TABLE dept01 PURGE;

CREATE TABLE dept01(
deptno NUMBER(4),
dname VARCHAR2(30), 
loc VARCHAR2(20)
);

INSERT INTO dept01 (deptno, dname, loc) VALUES(10, 'accounting','new york');

SELECT * FROM dept01;

COMMIT;
INSERT INTO dept01 (deptno, dname, loc) VALUES(10, 'accounting','new york');

-- 직전에 똑같은 레코드를 INSERT 실행해버렸을 경우 ROLLBACK 을 한다. 
ROLLBACK; --★★★ COMMIT 이전의 실행 취소 ★★★

-- INSERT INTO 테이블명 (전체칼럼에 대해 입력할 경우 칼럼명 작성 생략가능) 
INSERT INTO dept01 VALUES(10,'ACCOUNTING','NEW YORK');

-- 예제
CREATE TABLE sam01 AS (SELECT empno, ename, job, sal FROM emp WHERE 1=0); -- 구조만 복제함
SELECT * FROM sam01;


DESC sam01;
INSERT INTO sam01 VALUES(1000,'APPLE','POLICE',10000);
INSERT INTO sam01 VALUES(1010,'Banana','nurse',10000);
INSERT INTO sam01 VALUES(1020,'Orange','Doctor',10000);

COMMIT;

-- 2. NULL (데이터 입력 시점에서 해당 칼럼값을 모르거나 확정되지 않았을 경우 입력한다.)
-- 입력방법: 암시적 방법(작성 생략시), 명시적 방법 (VALUES 리스트에 명시적으로 입력) 

-- 암시적방법 
INSERT INTO dept01 (deptno, dname) VALUES(30, 'SALES');
SELECT * FROM dept01;

-- 명시적방법
INSERT INTO dept01 VALUES(40, 'OPERATION',NULL); 

-- 우선순위: DEFAULT < 명시적 NULL 

SELECT * FROM dept01 WHERE loc IS NULL; 

-- 예제 
INSERT INTO sam01 (empno, ename, sal) VALUES (1030, 'VERY', 25000);
INSERT INTO sam01 VALUES( 1040, 'CAT' , NULL, 2000); 
INSERT INTO sam01 VALUES ( 1050, 'CAT2', '', 4000); -- ''도 NULL임 
SELECT * FROM sam01;


-- 3. 서브쿼리로 레코드 삽입하기 

-- 굳이 서브쿼리로 복붙 해야 하는 이유가..? -> 
-- 다른 테이블의 특정 조건에 대한 레코드만 가져오고 싶을 때 !
-- INSERT INTO 다음에 VALUES 절을 사용하는 대신에 서브쿼리를 사용할 수 있다. 
-- 기존의 테이블에 있던 여러행을 복사해서 다른 테이블에 삽입할 수 있다. 

-- ★★★ 주의: INSERT 문에서 지정한 칼럼의 개수, 데이터 타입이 서브쿼리를 수행한 결과와 동일해야 한다.
-- ★★★ Algorithm : INTO 테이블명 > INSERT 문 ★★★
-- ★★★ Algorithm : 서브쿼리(1순위) > 메인쿼(2순위)  

DROP TABLE dept02 PURGE;
CREATE TABLE dept02 AS SELECT * FROM dept WHERE 1=0;

INSERT INTO dept02 SELECT * FROM dept; --CTAS와 다르게 AS 안씀. 

-- 예제 
/* 문제1에서 생성한 sam01 테이블에 서브쿼리문을 사용해서 emp에 저장된 사원 중 
10번 부서 소속 사원의 정보를 추가하시오 */
DESC emp;
DESC sam01;
INSERT INTO sam01 
SELECT empno, ename, job, sal FROM emp WHERE deptno = 10;

SELECT * FROM sam01;


-- 3.2. 다중 테이블에 다중 행 입력하기 (하나의 테이블을 SELECT해서 두개 이상의 테이블에 INSERT )
-- INSERT ALL INTO ~ VALUES(★칼럼이름들★) INTO ~ ... SELECT ~
-- (1) 테이블 생성
DESC emp;
CREATE TABLE emp_hir AS SELECT empno, ename, hiredate FROM emp WHERE 1=0; 
DESC emp_hir;
CREATE TABLE emp_mgr AS SELECT empno, ename, mgr FROM emp WHERE 1=0 ; 
DESC emp_mgr; 

-- (2) 다중 테이블에 레코드 삽입 
INSERT ALL INTO emp_hir VALUES(empno, ename, hiredate) 
INTO emp_mgr VALUES(empno, ename, mgr) 
SELECT empno, ename, hiredate, mgr FROM emp WHERE deptno = 20;

SELECT * FROM emp_hir;
SELECT * FROM emp_mgr;


-- 4. UPDATE 문 (레코드를 수정) WHERE절 필수 (대참사) 
-- UPDATE 테이블명 SET 칼럼명 = 값, 칼럼명 = 값 WHERE 조건 ; 

-- 실습용 테이블 
CREATE TABLE emp01 AS SELECT * FROM emp; 
SELECT * FROM emp01;
--모든 사원 정보 바꾸기 
UPDATE emp01 SET deptno = 30 ; 
-- 전체 사원 급여 10% 인상 
UPDATE emp01 SET sal = sal * 1.1 ; -- 칼럼명 = 수식, 상수, 칼럼명 가능

DROP TABLE emp01 purge; 

-- 테이블의 특정 행만 수정하기 (WHERE절)
SELECT * FROM emp01;
-- 10번 부서 사람들을 30번 부서로 바꿔라 
UPDATE emp01 SET deptno=30 WHERE deptno= 10 ;
-- 3000이상의 급여 수령자의 월급을 10% 인상해라 
UPDATE emp01 SET sal = sal * 1.1 WHERE sal >= 3000;

-- 1987년에 입사한 사원의 입사일을 오늘로 수정한다. 
UPDATE emp01 SET hiredate = sysdate 
WHERE SUBSTR(hiredate, 1,2) = '87'; -- SUBSTR 특정한 문자 부분만 발췌 (날짜형도 사용 가능) 

-- 예제 : sam01 테이블에 저장된 사원 중 급여가 10000이상이 사원들의 급여만 5000원씩 삭감해라 
UPDATE sam01 SET sal = sal -5000 WHERE sal >=10000;
SELECT * FROM sam01;

-- 테이블에서 2개이상의 칼럼 값 변경 
UPDATE emp01 SET deptno = 20, job = 'MANAGER' 
WHERE ename = 'SCOTT';

UPDATE emp01 SET hiredate = sysdate, sal = 50 , comm =4000 
WHERE ename = 'SCOTT';

SELECT * FROM emp01;

-- 5. 서브쿼리로 레코드 수정하기 
-- 굳이 서브쿼리로 수정해야 하는 이유가..? -> 
-- 다른 테이블의 특정 조건에 대한 레코드의 값으로 수정하고 싶을 때 !
UPDATE dept01 
SET loc = (SELECT loc 
        FROM dept01 
        WHERE deptno = 10)
WHERE deptno = 20 ;
SELECT * FROM dept01; 

-- 예제 : 서브쿼리문을 사용해 emp 테이블의 특정 컬럼(ename, sal, hiredate, deptno)만으로 구성된 sam02 테이블을 생성하시오 
CREATE TABLE sam02 AS SELECT ename, sal, hiredate, deptno FROM emp ; 
SELECT * FROM sam02;
SELECT * FROM dept; 

-- 예제 : sam02 테이블을 대상으로 DALLAS에 위치한 부서 소속 사원들의 급여를 1000 인상해라 
UPDATE sam02 SET sal = sal +1000 
WHERE deptno = (SELECT deptno FROM dept WHERE loc = 'DALLAS');

-- 5. 서브쿼리로 레코드 수정하기(2) - 여러개의 서브쿼리
 
/* 
경우1. 두개의 서브쿼리로 각각의 칼럼을 수정
경우2. 하나의 서브쿼리를 참조해 두개의 칼럼을 수정할 수 도 있음 (주로 후자 사용) 
★★★ 이 때, 서브쿼리에서 참조하는 칼럼 수를 신경 쓸 것 ★★★ 
*/

SELECT * FROM dept01;
UPDATE dept01 
SET (dname, loc) = (SELECT dname, loc 
                FROM dept01 
                WHERE deptno = 30)
WHERE deptno = 40;

UPDATE dept01 SET dname = (SELECT dname FROM dept01 WHERE deptno= 30), 
loc = (SELECT loc FROM dept01 WHERE deptno= 30)
WHERE deptno =40 ;

-- 예제 : 서브쿼리문을 사용하여 sam02 테이블의 모든 사원의 급여와 입사일을 이름이 KING인 사원의 급여와 입사일로 변경하시오 
SELECT * FROM sam02;
UPDATE sam02 
SET (sal, hiredate) = 
(SELECT sal, hiredate FROM sam02 WHERE ename = 'KING');

-- 6. DELETE 문 (레코드 삭제) WHERE절 사용하지 않으면 대참사 
-- DML이므로 ROLLBACK으로 복원 가능 
DELETE FROM dept01 
WHERE deptno = 30; 

SELECT * FROM dept01;

DELETE FROM dept01; --행 전체 삭제  

-- 6.1. TRUNCATE 문 (모든 레코드 삭제 - 특정 레코드 삭제는 불가능) 
-- 주의: DDL이므로 자동 COMMIT (ROLLBACK 불가능)  

SELECT * FROM dept02; 
-- 레코드 모두 지울때 
TRUNCATE TABLE dept02; 

-- 예제: SAM01 테이블에서 직책이 정해지지 않은 사원을 삭제해라 
SELECT * FROM sam01; 
COMMIT;
DELETE FROM sam01 WHERE job IS NULL ;

-- 서브쿼리로 특정 레코드만 DELETE 
DELETE FROM emp01 
WHERE deptno = (SELECT deptno FROM dept WHERE dname = 'SALES');

COMMIT;