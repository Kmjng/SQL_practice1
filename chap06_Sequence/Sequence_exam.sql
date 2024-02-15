-- [1] 시퀀스 생성 문제
-- 시작값이 500이고 5씩 증가하는 시퀀스를 다음 조건에 맞게 만드시오.
-- 조건1> 최댓값 = 20000
-- 조건2> 최댓값을 초과한 경우 처음부터 반복 
-- 조건3> 시퀀스 이름 : my_seq
CREATE SEQUENCE my_seq 
START WITH 500
MAXVALUE 20000
INCREMENT BY 5
CYCLE ; 

-- [2] 시퀀스 값을 활용한 데이터 삽입 문제
-- 다음과 같은 고객 테이블(customer_tab)에 새로운 고객을 추가하려고 합니다. 
-- 주어진 시퀀스를 활용하여 고객 ID(cid)를 자동으로 삽입하는 쿼리를 
-- [추정]하여 작성하세요.
-- 시퀀스 이름 : customer_id
-- 테이블 명 : customer_tab(cid, cname, email) 
CREATE TABLE customer_tab (
cid NUMBER(38) primary key, 
cname VARCHAR2(10), 
email VARCHAR2(30)
);

INSERT INTO customer_tab (cid) VALUES(my_seq.NEXTVAL) ;

SELECT * FROM customer_tab;
INSERT INTO customer_tab VALUES (my_seq.NEXTVAL, '김민정' , 'alswjd@naver.com');

-- [3] 시퀀스 증가값 조정 문제
-- 이미 생성된 시퀀스의 증가값을 5에서 3으로 변경하려면 어떻게 해야 할까요?
-- 시퀀스 이름 : my_seq
ALTER SEQUENCE my_seq 
INCREMENT BY 3 ;

-- [4] 시퀀스 제거 문제
-- 시퀀스의 전체 목록을 확인한 후 연습문제에서 작성한 모든 시퀀스를 제거하시오.
SELECT * FROM USER_SEQUENCES ;

DROP SEQUENCE ; 




