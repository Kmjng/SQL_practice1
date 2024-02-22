/*
    트랜잭션(Transaction) : DML 명령어의 일련의 작업 (ATM 현금인출)
    - COMMIT 또는 ROLLBACK에 의해 하나의 트랜잭션이 종료된다. 
    - 커밋과 커밋 사이를 하나의 트랜잭션이라고 한다. 
    - 하나의 트랜잭션은 ALL- OR- NOTHING 방식으로 처리된다. 
    - SAVEPOINT를 이용하면, 
    <특정 위치 ROLLBACK>  또는 <특정 위치까지 COMMIT> 이 가능함. 
    
    - COMMIT : 트랜잭션 DB반영 
    - ROLLBACK : 트랜잭션 작업 취소 
    - SAVEPOINT : 작업의 위치 지정 
*/

-- 1. COMMIT / ROLLBACK 

SELECT * FROM dept02; 
DROP TABLE dept02 purge; 

CREATE TABLE dept02 AS SELECT * FROM dept;

-- DML 시행 (1)
DELETE FROM dept02 WHERE deptno = 30 ; 

-- 작업 취소 : ROLLBACK  
ROLLBACK ;
SELECT * FROM dept02; 

-- DML 시행 (2) 
UPDATE dept02 SET loc = 'SEOUL' WHERE deptno = 30;

-- DB 반영하기 : COMMIT 
COMMIT ; 

-- 2. AUTO COMMIT 
-- DDL 명령문은 자동으로 커밋된다.

-- 1) 레코드 삽입을 했으면 커밋을 합시다. 
INSERT INTO dept02 VALUES(50, 'TEST','TEST'); 
COMMIT ; 

-- 2) 레코드 삭제 후 롤백하기 
DELETE FROM dept02 WHERE deptno = 50 ; 
ROLLBACK ; 

-- 3) 레코드 삭제 & DDL 후 롤백하면? 
DELETE FROM dept02 WHERE deptno = 30 ; 
SELECT * FROM dept02 ; 
TRUNCATE TABLE dept02 ; 
ROLLBACK ; 

DROP TABLE dept02 PURGE ; 
CREATE TABLE dept02 AS SELECT * FROM dept; 
-- DML  뒤에 DDL 오면 자동 커밋이 돼버림 
DELETE FROM dept02 WHERE deptno = 30 ; 
ALTER TABLE dept02  RENAME COLUMN deptno TO dno ; 
SELECT * FROM dept02 ; 
ROLLBACK ; 

-- 3. SAVEPOINT  
-- 트랜잭션의 수행 지점을 저장하는 역할 
/*
    SAVEPOINT label : 트랜잭션 수행 지점을 저장하는 역할
    ROLLBACK TO label : 복원 시점을 이용해 명령어 복원 
    COMMIT은 SAVEPOINT 사용 불가 
    
    DML 중간중간에 SAVEPOINT label 심어놓으면 그 위치로 복원(ROLLBACK) 가능하다. 
*/
    
SELECT * FROM dept01 ;
DROP TABLE dept01 purge; 

CREATE TABLE dept01 AS SELECT * FROM dept ; 

DELETE FROM dept01 WHERE deptno = 40 ; 
COMMIT ;  -----------------여기부터 
SELECT * FROM dept01 ; 

DELETE FROM dept01 WHERE deptno = 30 ;
SAVEPOINT C1 ; -- 이 앞까지 살린다. 
DELETE FROM dept01 WHERE deptno = 20 ;
SAVEPOINT C2 ; 
DELETE FROM dept01 WHERE deptno = 10 ;

SELECT * FROM dept01 ;  -- 전체 레코드 없어진 상태 

ROLLBACK TO C2 ;
ROLLBACK TO C1 ; 
ROLLBACK ; 
