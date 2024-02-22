-- Transaction_exam.sql

-- 문제1) 다음과 같은 조건으로 ATM 테이블을 만드시오.
/*
 테이블명 : ATM
 계좌번호 칼럼 : accNO, INT형, 기본키 
 예금주 칼럼 : accName, 가변길이문자형(20), 중복불가, 생략불가 
 잔액 칼럼   : balance, INT형, 생략불가 
 발급날짜 칼럼 : reg_date, 날짜형, 생략불가 
*/
CREATE TABLE ATM (
accNO INT PRIMARY KEY , 
accName VARCHAR2(20) UNIQUE NOT NULL , 
balance INT NOT NULL, 
reg_date DATE NOT NULL 
);


-- 문제2) 계좌번호(accNo)에 삽입될 시퀀스 객체를 다음 조건에 맞게 만드시오.
-- 시퀀스 객체 만들기 : chap06_Sequence 참고 
/*
   시퀀스 이름 : accNo_seq
   시작 번호 : 123450001
   증가 번호 : 1씩 증가 
   나머지 옵션은 기본값 적용  
*/
CREATE SEQUENCE accNo_seq 
START WITH 123450001 
INCREMENT BY 1  ;

-- 문제3) 아래와 같이 출력되도록 ATM 테이블에 레코드를 추가하시오.

-- <출력결과>
/*
 ACCNO       ACCNAME   BALANCE    가입일 
 123450001   홍길동        1000    2000-10-01
 123450002   이순신       10000    2001-01-10
 123450003   강호동             0    2010-09-23
 123450004   유관순         100    2020-12-10 
*/
INSERT INTO ATM VALUES(accNo_seq.NEXTVAL, '홍길동', 1000, TO_DATE('2000-10-01' , 'YYYY-MM-DD')) ;
INSERT INTO ATM VALUES(accNo_seq.NEXTVAL, '이순신', 10000, TO_DATE('2001-01-10' , 'YYYY-MM-DD')) ;
INSERT INTO ATM VALUES(accNo_seq.NEXTVAL, '강호동', 0, TO_DATE('2010-09-23' , 'YYYY-MM-DD')) ;
INSERT INTO ATM VALUES(accNo_seq.NEXTVAL, '유관순', 100, TO_DATE('2020-12-10' , 'YYYY-MM-DD')) ;

SELECT * FROM ATM ; 
SELECT accNo, accName, TO_CHAR(balance, '999,999') BALANCE , TO_CHAR(reg_date, 'YY/MM/DD') " DATE"
FROM ATM ; 
-- 문4) 강호동 고객에게 10만원을 입금한 후 DB에 반영하시오.
UPDATE ATM SET balance = balance + 10 WHERE accName ='강호동'  ; 
COMMIT ; 

-- 문5) 유관순 고객에게 50만원을 입금해야하는데, 홍길동 고객에게 잘못 입금되었다.
--  위와 같은 잘못된 작업을 정정하고, 정상적으로 유관순 고객에게 입금되도록 
--  SAVEPOINT, ROLLBACK, COMMIT 명령어를 이용하여 트랜잭션을 수행하시오. 
SAVEPOINT C1 ; 
UPDATE ATM SET balance = balance + 50 WHERE accName = '홍길동' ; --잘못 입금 

ROLLBACK TO C1 ; 

SAVEPOINT C2 ; 
UPDATE ATM SET balance = balance + 50 WHERE accName = '유관순' ;

ROLLBACK ; 

-- [추가] 유관순이 이순신에게 50만원 송금해야 하는데 홍길동에게 잘못 주었다. 
SAVEPOINT C3;
UPDATE ATM SET balance = balance - 50 WHERE accName = '유관순'; 
UPDATE ATM SET balance = balance + 50 WHERE accName ='홍길동'; 

ROLLBACK TO C3 ; 

SAVEPOINT C4;
UPDATE ATM SET balance = balance - 50 WHERE accName = '유관순'; 
UPDATE ATM SET balance = balance + 50 WHERE accName ='이순신'; 

