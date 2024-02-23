/*
 문1) 부서번호를 매개변수로 입력받아서 해당 레코드를 삭제하는 프로시저를 생성하시오.
   조건1) 프로시저이름 : deleteDept(부서번호)
   조건2) 사용할 테이블 : dept01
   조건3) 부서번호가 없는 경우 :  '해당 부서가 없습니다.' 메시지 출력 
   조건4) 부서번호가 있는 경우 :  '해당 부서가 삭제되었습니다.' 메시지 출력
*/

-- 부서 테이블 조회
select * from dept01;

CREATE OR REPLACE PROCEDURE deleteDept(vdno NUMBER) -- 부서번호:매개변수  
IS
  --변수 선언;
  cnt_var NUMBER(2); -- 레코드 수 저장 
BEGIN
  -- 처리 내용(로직);
  SELECT COUNT(*) INTO cnt_var FROM dept01 WHERE deptno = vdno; -- 레코드 조회 
  IF cnt_var > 0 THEN
      -- 부서번호가 있는 경우
      DELETE FROM dept01 WHERE deptno = vdno; 
      COMMIT;
      DBMS_OUTPUT.PUT_LINE(vdno || '번 해당 부서가 삭제되었습니다.');
  ELSE
      -- 부서번호가 없는 경우
      DBMS_OUTPUT.PUT_LINE('해당 부서가 없습니다.');
  END IF;
 EXCEPTION WHEN OTHERS THEN  
  ROLLBACK; -- 예외처리 내용;
END;


-- 프로시저 실행 
EXECUTE deleteDept(50); -- 부서번호 있는 경우 
EXECUTE deleteDept(60); -- 부서번호 없는 경우 

-- 프로시저 실행 결과 확인 
select * from dept01;


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

CREATE OR REPLACE PROCEDURE transfer_amount(transfer_amt NUMBER, 
                                             accNO_from NUMBER, 
                                             accNO_to NUMBER)
IS
  -- 변수 선언;  
  curr_bal INT; -- 출금계좌 잔액 
BEGIN 
     SELECT balance INTO curr_bal FROM ATM WHERE accno = accNO_from; -- 레코드 조회 
     IF transfer_amt > curr_bal THEN 
        -- 송금액 잔액보다 큰 경우 
        DBMS_OUTPUT.PUT_LINE('잔액이 부족합니다.');
     ELSE
        -- 계좌 이체 
        UPDATE ATM SET balance = balance - transfer_amt WHERE accno = accNO_from; -- 출금 
        UPDATE ATM SET balance = balance + transfer_amt WHERE accno = accNO_to; -- 입금
        COMMIT;     
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(transfer_amt, 'L999,999') || '원이 이체되었습니다.');
     END IF;
    EXCEPTION WHEN OTHERS THEN
     ROLLBACK;
END;

-- 강호동 : 5만원 -> 유관순 계좌 이체 
EXECUTE transfer_amount(50000, 123450003, 123450004); -- (이체금액, 출금계좌, 입금계좌)

EXECUTE transfer_amount(500000, 123450003, 123450004); -- 잔액이 부족합니다.

-- 이체 결과 확인 
select * from ATM;

