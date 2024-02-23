/* 
PL_SQL 
Procedure, Trigger, Function 세가지로 이루어져 있다. 

    1. PROCEDURE (프로시저) 
    
    CREATE OR REPLACE PROCEDURE 프로시저명(param) -- para 에는 변수와 자료형이 들어가고 사이에 in 기입은 선택사항
    IS 
        변수선언 ;   -- 필요 시 사용 
    BEGIN  --여기부터의 내용이 실행됨 
        처리내용(로직) ; 
        EXCEPTION WHEN OTHERS THEN  -- 로직수행 중 오류발생했을 시 (또는 해당하지 않을 때?) 수행할 내용이 온다.
            예외처리 내용 ; 
        END ;  -- 프로시저 실행은 드래그로 블록지정이 필요하다. 

    -- ★★★ 프로시저 특 : 블록지정 안하고 실행하면 프로시저 만든거 다 날라감 ;;;;; 다시 컴파일해줘야함
    

*/

--   예 ) 1001 번 교수에 대해 급여인상해주는 프로그램 : sal_inc( 1001 ) ;

CREATE TABLE professor01 AS SELECT * FROM professor ;  --프로시저도 VIEW처럼 REPLACE가 가능하다. .
SELECT * FROM professor01 ;

CREATE OR REPLACE PROCEDURE sal_inc(pno in NUMBER) --pro : 매개변수 , 매개변수의 자료형에 자릿수필요없음
IS 
BEGIN
 update professor01 set pay = pay * 1.1  -- 수행 순서 : 1번
 where profno = pno;  
 COMMIT;        -- 2-1번
 DBMS_OUTPUT.PUT_LINE( pno || '의 교수테이블의 급여 인상 프로시저 실행 성공');    -- 어떤교수 급여 변경됐는지 알림 (결합연산자)
  -- 나왜안됨 ????????????
 EXCEPTION WHEN OTHERS THEN --예외처리 (정전, 네트워크 문제 등 ) 
 DBMS_OUTPUT.PUT_LINE('교수테이블의 급여 인상 프로시저 실행 실패'); -- 이거 수정하려면 프로시저 삭제하고 다시만들어야 하는 듯;;
 ROLLBACK;  -- 2-2 번 
END;

DROP PROCEDURE sal_inc ; 
DESC professor01 ; 

-- 프로시저 내용이 DML 이지만 안에 COMMIT이 있으므로 함수사용할때 취소(롤백)이 불가능하겠네 

-- 프로시저 실행 
EXECUTE sal_inc(1001) ;
SELECT * FROM professor01 ;

EXECUTE sal_inc(1002) ;
SELECT * FROM professor01 ;
/*
    1001 조인형 550
    1002 박승곤 380 
*/

-- ★★★ 프로시저가 잘 수행됐는지, 예외처리 됐는지 메세지를 알려주는 기능 추가 ★★★
-- DBMS_OUTPUT.PUT_LINE('교수테이블의 급여 인상 프로시저 실행 실패');

-- 1.2. 데이터 사전 뷰를 통해 프로시저 목록 보기 

SELECT * FROM USER_PROCEDURES ; 

-- 1.3. 프로시저 삭제 
DROP PROCEDURE sal_inc ; 


-- 1.4. [변수 선언]이 들어간 프로시저

DROP TABLE emp01 PURGE ; 
CREATE TABLE emp01 AS SELECT * FROM emp ; 

-- 특정사원 급여 인상 프로시저 
CREATE OR REPLACE PROCEDURE emp_sal_inc(Vempno NUMBER) 
IS 
-- 변수 선언
ename_val VARCHAR2(30); 
sal_val INT;   -- SELECT의 INTO절에 사용된다. 
BEGIN
UPDATE emp01 SET sal = sal * 1.1 WHERE empno = Vempno; -- 함수 변수와 empno가 같을 때
SELECT ename, sal INTO ename_val, sal_val FROM emp01  -- SELECT된 사원이름과 인상된 급여를 앞에 생성한 변수에 넣어준다. (INTO 선언된변수) 
WHERE empno = Vempno; 
DBMS_OUTPUT.PUT_LINE(Vempno || '급여 인상 성공'); 
DBMS_OUTPUT.PUT_LINE(  '사원명 : ' || ename_val); 
DBMS_OUTPUT.PUT_LINE( '인상된 급여: '|| sal_val ); 
COMMIT; 
EXCEPTION WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE( '급여 인상 실패'); 
ROLLBACK; 
END;

/* 
    7369 SMITH 800 
    7499 ALLEN 1600 
*/

EXECUTE emp_sal_inc(7369) ;

-- 프로시저에서 선언된 변수들의 역할 : (임시로 값을 갖고 있는 것임) DBMS 메세지에 사용된다. & 밑의 명령문에 사용 가능 


-- 1. 5. [로직]을 추가한 프로시저 & 여러개의 매개변수 사용
-- Algorithm : IS 선언부 > BEGIN 실행부(셀렉~~) > IF 프로시저 조건문 ..... ->EXCEPTION 예외처리부 
-- IF / ELSE / END IF 

DROP TABLE dept01 ;
CREATE TABLE dept01 AS SELECT * FROM dept ;

CREATE OR REPLACE PROCEDURE update_insertDEPT(vdno NUMBER, vdname 
VARCHAR, vloc VARCHAR)
IS
cnt_var NUMBER;  --순서 1. 레코드 갯수 저장
BEGIN
     SELECT COUNT(*) INTO cnt_var FROM dept01 WHERE deptno=vdno;  -- 순서2. 입력한 vdno가 deptno에 있으면 그 갯수를 세서 cnt_var에 넣어준다. 
        IF cnt_var = 0 THEN  -- 순서 3-1
             INSERT INTO dept01 VALUES(vdno, vdname, vloc);
            DBMS_OUTPUT.PUT_LINE('부서테이블 레코드 삽입 성공!!');
            COMMIT;
        ELSE 
            UPDATE dept01 SET dname=vdname, loc=vloc WHERE deptno=vdno; -- 순서 3-2
             DBMS_OUTPUT.PUT_LINE('부서테이블 레코드 수정 성공!!');
             COMMIT;
     END IF;
    EXCEPTION WHEN OTHERS THEN  -- 순서 3-3 
    DBMS_OUTPUT.PUT_LINE( '작업 실패!!'  ); 
    ROLLBACK; 
END;  -- 프로시저 끝 

SELECT * FROM dept01 ; -- 테이블 상태 확인 -- 10번~40번 부서 있음. 

EXECUTE update_insertDEPT(50 , '영업부', '서울시') ;  -- INSERT 대상 (IF에 해당) 
EXECUTE update_insertDEPT(30 , '영업부', '서울시') ; -- UPDATE 대상 (ELSE에 해당) 
-- 참고로 실행문에 들어가는 실인수의 순서, 개수, 자료형은 일치해야 한다. 


-- 2. TRIGGER (트리거) 
/*
    DML명령어 이전에 ? 혹은 이후에 발생시킬 것인지 
    
    CREATE OR REPLACE TRIGGER 트리거명
    {BEFORE | AFTER}  {INSERT | DELETE | UPDATE} (OF 칼럼명) 
    ON 테이블명
    BEGIN       -- 어떤 트리거(이벤트)를 실행할 것인지 밑에 기술 
    트리거 내용
    END;
*/
    -- 예 1 ) Professor 테이블이 수정되면 메세지로 알려주는 트리거 
SELECT * FROM professor01;

CREATE OR REPLACE TRIGGER sal_chk 
BEFORE UPDATE ON professor01  -- ★★★ 트리거 발생할 시점(BEFORE or AFTER)  ★★★
BEGIN       --★★★ 트리거 발생 시 수행되는 명령어 ★★★
    DBMS_OUTPUT.PUT_LINE('교수테이블이 수정되었습니다.');
END ; 
-- sal_chk가 동작되면,  UPDATE ON professor01 되기 전에 명령어 띄움 
-- ★★★ 순서 : BEGIN > BEFORE / AFTER > BEGIN ★★★

-- 해봅시다. 
UPDATE professor01 SET position = '정교수' WHERE profno = 1002 ; 

-- 2.1. 데이터사전뷰를 이용해 트리거 목록 보기 
SELECT * FROM USER_TRIGGERS ; 

-- 2.2. 트리거 제거하기 
DROP TRIGGER sal_chk ; 

-- 예 2 ) 트리거 시점이 중요한 사례 
-- sale_date 을 먼저 수정하고 수정된 것에 대해서 나머지 명령 시행하기 
SELECT * FROM sale ; 
CREATE TABLE sale01 AS SELECT * FROM sale ; 

-- 트리거 실행으로 레코드 삽입하기 
CREATE OR REPLACE TRIGGER update_sale_date 
BEFORE INSERT ON sale01  
FOR EACH ROW -- 각 행에 트리거 실행             -- ★★★ 트리거 전용 명령어 ★★★★
BEGIN 
    :NEW.sale_date := SYSDATE ;  
END; 
-- 참고로 :NEW.칼럼명은 새로 추가될 레코드를 의미하고  := 값 은 우변의 값을 좌변에 대입해라 라는 뜻 
-- :OLD.칼럼명은 주로 UPDATE할 때 기존 칼럼 수정 시 사용된다. 

-- sale01 레코드 추가 
INSERT INTO sale01 VALUES(5, 20, '23-10-20', 3 ) ;   -- 트리거에 의해 23-10-20 대신 SYSDATE로 들어감.


SELECT * FROM sale01 ; 



-- 3. 사용자 함수 
/* 
    프로시저와 공통점: DML 명령어를 이용한 프로그램 
    프로시점 특 : 단위 프로그램 작성/ 반환은 선택사항/ 단독실행(EXECUTE) /매개변수 - 입력, 출력, 입출력
    사용자 함수 특 : 기능 작성/ ★반환(RETURN)이 필수 / 호출 실행  /매개변수 - 입력 
    
*/

-- 예 ) emp 테이블에서 사번으로 특정 사원의 급여 조회 사용자 함수 
CREATE OR REPLACE FUNCTION EMP_SAL(ENO NUMBER)  -- 사번이 매개변수가 된다. 
RETURN NUMBER -- 리턴값의 자료형 (★★★ 바꿔줄 자료형!!) 
IS
 SAL_VAL NUMBER(6); -- 리턴 변수 선언
BEGIN 
 SELECT SAL  INTO SAL_VAL -- SAL 칼럼 조회 결과를 변수에 저장
 FROM EMP WHERE EMPNO = ENO;    -- 순서 2. 처리
 RETURN SAL_VAL; -- 급여 결과 리턴(출력)    -- 순서 3. 출력
END;

SELECT emp_sal(7369) FROM dual ; -- 함수를 호출 


-- 3.1. 함수 목록은 데이터 사전뷰가 제공하지 않는다. 

-- 3.2. 사용자함수 제거하기 
DROP FUNCTION emp_sal ; 