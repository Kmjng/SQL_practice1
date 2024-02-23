/*
 문1) 부서번호를 매개변수로 입력받아서 해당 레코드를 삭제하는 프로시저를 생성하시오.
   조건1) 프로시저이름 : deleteDept(부서번호)
   조건2) 사용할 테이블 : dept01
   조건3) 부서번호가 없는 경우 :  '해당 부서가 없습니다.' 메시지 출력 
   조건4) 부서번호가 있는 경우 :  '해당 부서가 삭제되었습니다.' 메시지 출력
*/

-- 부서 테이블 조회
select * from dept01;

DROP TABLE dept01 purge ; 
CREATE TABLE dept01 AS SELECT * FROM dept;


-- 틀린 예 
CREATE OR REPLACE PROCEDURE delteDept (vno NUMBER) 
IS 
 dno NUMBER ;  -- INTO 뒤에 들어갈 변수 
BEGIN 
    SELECT deptno  INTO dno  FROM dept01 WHERE deptno = vno ; -- 밑에 프로시저 조건문에서 사용하려면 into 가 필수인듯?????????
    IF  dno = vno THEN 
    DELETE FROM dept01 WHERE deptno = VNO ;  -- where 뒤에 변수 주의 
    DBMS_OUTPUT.PUT_LINE(' 해당 부서가 삭제 되었습니다. ');
    COMMIT ; 
    ELSE 
     DBMS_OUTPUT.PUT_LINE('해당부서가 없습니다. '); 
     END IF;
    EXCEPTION WHEN OTHERS THEN  -- 순서 3-3 
    DBMS_OUTPUT.PUT_LINE( '작업 실패!!'  ); 
    ROLLBACK; 
    END ; 

EXECUTE delteDept (30) ; 
SELECT * FROM dept01 ; 

DROP PROCEDURE delteDept ;
EXECUTE delteDept (60) ;  -- 이렇게 하면 vno= 60 이 deptno에 없기 때문에 select문에서 걸러져서 EXCEPTION  예외처리됨 . 
SELECT * FROM dept01 ; 

/* 
문2) 다음과 같이 계좌 이체를 처리하는 프로시저를 생성하시오.
  조건1) 프로시저이름(매개변수) : transfer_amount(transfer_amt, accNO_from, accNO_to)
           매개변수 : transfer_amt(이체금액), accNO_from(출금계좌), accNO_to(입금계좌) 
  조건2) 사용할 테이블 : ATM 
  조건3) 처리 내용 : 출금계좌에서 이체금액을 출금하여 입금계좌에 넣기
              예) 유관순 계좌에서 20,000원 인출하여 이순신 계좌로 이체한다. 
  조건4) 만약 '이체금액 > 출금계좌 잔액' 이면 '잔액이 부족합니다.' 메시지 출력       
*/

-- ATM 테이블 조회 : chap11_Transaction의 연습문제에서 작성함 
select * from ATM;
CREATE TABLE ATM01 AS SELECT * FROM ATM ; 
select * FROM ATM01 ; 

CREATE OR REPLACE PROCEDURE transfer_amount(transfer_amt NUMBER, accNO_from VARCHAR2 , accNO_to VARCHAR)
IS 
    no NUMBER ;
    name VARCHAR2(10);
    bal NUMBER; -- transfer_amt 관련 
    reg DATE ;
BEGIN 
    SELECT  balance INTO bal FROM ATM01 WHERE accno = accNO_from ; 
    IF bal >= transfer_amt  THEN 
    UPDATE ATM01 SET balance = balance - transfer_amt WHERE accno = accNO_from ;  -- balance 주의 . 원본테이블의 칼럼에 넣어야 하니까 !!
    UPDATE ATM01 SET balance = balance + transfer_amt WHERE accno = accNO_to ; -- name 이 accNO_to에 해당하면 업뎃해라 
    DBMS_OUTPUT.PUT_LINE( TO_CHAR(transfer_amt, 'L999,999') ||'원 이체완료');
    COMMIT;
    ELSE
    DBMS_OUTPUT.PUT_LINE( '잔액이 부족합니다.');
    
    END IF ; 
    EXCEPTION WHEN OTHERS THEN 
    ROLLBACK ; 
END ; 



EXECUTE transfer_amount(1000, 123450001, 123450002) ;  
select * FROM ATM01 ;
EXECUTE transfer_amount(48, '123450004', '123450003') ; 
select * FROM ATM01 ; 

-- 다시만들기 
DROP TABLE ATM01 ; 
CREATE TABLE ATM01 AS SELECT * FROM ATM ; 

DROP PROCEDURE  transfer_amount ;