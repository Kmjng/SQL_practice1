/* 
  문1) 부서테이블(dept01)의 레코드 삭제 시 다음 조건으로 트리거를 만드시오. 
   조건1) 트리거명 : delete_dept_chk
   조건2) 이벤트 메시지 : '부서테이블의 레코드가 삭제되었습니다.'
   조건3) 이벤트 시점 : DML 수행 후 
*/

-- 부서 테이블 조회
select * from dept01;

CREATE OR REPLACE TRIGGER delete_dept_chk 
    AFTER DELETE ON dept01 
    BEGIN 
        DBMS_OUTPUT.PUT_LINE('부서테이블의 레코드가 삭제되었습니다.') ; 
    END ; 

DELETE FROM dept01 WHERE deptno = 40 ; 





/*
 문2) 임의의 날짜를 입력받아서 YYYY-MM-DD 형식으로 바꿔주는 함수를 정의하시오.
       조건1) 함수명 :  transform_date(inputDate date) 
       조건2) 적용할 테이블 : emp 테이블의 hiredate 칼럼 
*/

-- 사원 테이블 조회
select * from emp01 ;

DROP FUNCTION transform_date ; 
-- 단계1 : 함수 작성(미완성)
CREATE OR REPLACE FUNCTION transform_date(inputDate DATE) 
RETURN VARCHAR2 
IS 
changeDate VARCHAR2(20) ; 
BEGIN 
SELECT TO_CHAR( hiredate, 'YYYY-MM-DD' ) INTO changeDate FROM emp01 WHERE hiredate = inputDate  ;  -- hiredate를 문자열로 바꾸는 것이니까 !!
RETURN changeDate ;  -- 빼먹지 말기 !!!
END ;




-- 단계2 :함수 정의 후 함수 호출 SELECT문 : 30번 부서 전체 사원 조회  
SELECT ename, transform_date(hiredate) "입사일", sal 
FROM emp01 WHERE deptno = 30;             -- 사용된 함수 : transform_date(hiredate) 



/*
 문3) 다음과 같은 업무를 처리하기 위한 함수를 작성하시오. 
   조건1) 함수명 & 매개변수 : emp_login(사번, 이름)
   조건2) 사용할 테이블 : emp
   
   <업무 처리 절차>
   단계1 : 사번과 이름을 인증(emp에 해당 사번과 이름이 있으면 인증 성공, 없으면 인증 실패)
   단계2 : 단계1에서 인증에 통과하면 '인증이 성공되었습니다.' 메시지 출력 
   단계3 : 단계1에서 인증 실패시 '등록된 사원이 없습니다.' 메시지 출력 
   
   <출력결과 : 인증 성공 시>
    '인증이 성공되었습니다.'
   
   <출력결과 : 인증 실패 시> 
    '등록된 사원이 없습니다.'
*/
SELECT * FROM emp01;

-- 단계1 : 함수 작성(미완성)

CREATE OR REPLACE FUNCTION emp_login(vno NUMBER, vname VARCHAR2) 
RETURN VARCHAR2 -- 인증결과를 반환할 것이다. 
IS 
cnt NUMBER(2) ; -- 레코드 갯수
result VARCHAR2(100) ;

BEGIN 
SELECT COUNT(*) INTO cnt FROM emp01 WHERE empno = vno AND ename= vname ;  -- 있으면 카운트 하도록
IF  cnt  = 1 THEN 
    result := '인증이 성공되었습니다. ' ; 
ELSE 
    result :='인증이 실패되었습니다. ';
END IF ; 
RETURN result ;
END ;

DROP FUNCTION emp_login ; 

CREATE or REPLACE FUNCTION emp_login(Vno number, Vname VARCHAR2)
  RETURN VARCHAR2 -- 인증결과 반환 자료형 
IS
   /*  여기에 들어갈 내용을 채우시오. */ 
BEGIN
   /*  여기에 들어갈 내용을 채우시오. */ 
END;


-- 단계2 : 함수 정의 후 함수 호출 SELECT문  
SELECT emp_login(7360, 'SMITH') FROM dual; -- 등록된 사원이 없습니다. 
SELECT emp_login(7369, 'SMITH') FROM dual; -- 인증이 성공되었습니다. 


/*
  문4) 판매 테이블(sale_data)의 구매금액(price)이 10만원 이상이면 '10% 할인 고객', 
         10만원 미만이면 '할인 없음'이라는 할인여부 결과를 반환하는 함수를 작성하시오.
      조건1) 사용할 테이블 : sale_data 
      조건2) 함수명 : SaleInfoFunc(price number)
      조건3) 반환(return) 변수 : saleInfo varchar(30)
      
      <출력결과 : SELECT문으로 함수 호출 시 출력내용>
      USER_ID     PRICE     할인여부 
      1001        153000    10% 할인 
      1002        120000    10% 할인 
      1003         79000    할인 없음  
      1004        150000    10% 할인       
*/

-- 판매 테이블 조회 
SELECT * FROM sale_data;


-- 단계1 : 함수 작성(미완성)
CREATE OR REPLACE FUNCTION SaleInfoFunc(price NUMBER) 
RETURN VARCHAR -- 출력할 애 자료형 
IS 
saleInfo VARCHAR(100) ; 
BEGIN 

IF price > 100000 THEN 
    saleInfo := '10%할인 고객' ; 
ELSE 
    saleInfo := '할인 없음' ; 
END IF ; 
RETURN saleInfo ; 
END ; 



--  단계2 : 함수 정의 후 함수 호출 SELECT문   
SELECT user_id, price, SaleInfoFunc(price) "할인여부"
FROM sale_data
WHERE pay_method = '1.현금' OR pay_method = '2.직불카드'
ORDER BY user_id;


