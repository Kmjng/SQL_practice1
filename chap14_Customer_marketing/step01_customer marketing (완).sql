-- step01_customer marketing.sql
/*
  고객세분화 분석과 이탈고객 분석으로 마케팅에 활용 
*/

-- join 테이블 삭제 
DROP TABLE customers CASCADE CONSTRAINTS;


-- 고객(customers) 테이블 생성 
CREATE TABLE customers(
    customer_id NUMBER PRIMARY KEY, -- 고객id : 구분자 
    cname VARCHAR2(50) NOT NULL, 
    email VARCHAR2(100) UNIQUE,
    phone_number VARCHAR2(20),
    birthdate DATE, -- 생년월일 
    reg_date DATE, -- 가입일
    gender VARCHAR2(10), -- 성별(Male or Female) 
    address VARCHAR2(200), -- 주소 
    total_price NUMBER, -- 총구매금액 
    last_date DATE, -- 마지막 구매 날짜
    churn_status VARCHAR2(20) -- 이탈 여부('활동' or '이탈')
);


-- 레코드 삽입 
INSERT INTO customers
VALUES(1, 'Alice Johnson', 'alice@example.com', '555-111-2222', TO_DATE('1988-05-10', 'YYYY-MM-DD'),'21/08/20', 'Female', '123 Maple St, City', 1200, SYSDATE - 95, '활동');
INSERT INTO customers 
VALUES(2, 'Bob Smith', 'bob@example.com', '555-333-4444', TO_DATE('1985-09-20', 'YYYY-MM-DD'), '21/08/20', 'Male', '456 Oak St, Town', 900, SYSDATE - 40, '활동');
INSERT INTO customers
VALUES(3, 'Carol Williams', 'carol@example.com', '555-555-6666', TO_DATE('1992-02-15', 'YYYY-MM-DD'), '22/08/20', 'Female', '789 Elm St, Village', 1500, SYSDATE - 15, '활동');
INSERT INTO customers
VALUES(4, 'David Brown', 'david@example.com', '555-777-8888', TO_DATE('1990-07-05', 'YYYY-MM-DD'), '21/08/20', 'Male', '101 Pine St, Town', 800, SYSDATE - 35, '활동');
INSERT INTO customers
VALUES(5, 'Emily Lee', 'emily@example.com', '555-999-0000', TO_DATE('1994-11-30', 'YYYY-MM-DD'),'22/08/20', 'Female', '222 Cedar St, City', 1100, SYSDATE - 20, '활동');
INSERT INTO customers
VALUES(6, 'Frank Miller', 'frank@example.com', '555-222-3333', TO_DATE('1983-08-22', 'YYYY-MM-DD'), '21/08/20', 'Male', '333 Birch St, Village', 1400, SYSDATE - 10, '활동');
INSERT INTO customers
VALUES(7, 'Grace Davis', 'grace@example.com', '555-444-5555', TO_DATE('1987-01-18', 'YYYY-MM-DD'), '21/08/20', 'Female', '444 Oak St, Town', NULL, SYSDATE - 30, '활동');
INSERT INTO customers
VALUES(8, 'Henry Wilson', 'henry@example.com', '555-666-7777', TO_DATE('1989-03-25', 'YYYY-MM-DD'), '22/08/20', 'Male', '555 Maple St, City', 1300, SYSDATE - 5, '활동');
INSERT INTO customers
VALUES(9, 'Isabella Moore', 'isabella@example.com', '555-888-9999', TO_DATE('1991-06-12', 'YYYY-MM-DD'), '21/08/20', 'Female', '666 Elm St, Village', 1600, SYSDATE - 50, '활동');
INSERT INTO customers
VALUES(10, 'Jack Taylor', 'jack@example.com', '555-000-1111', TO_DATE('1986-04-28', 'YYYY-MM-DD'), '22/08/20', 'Male', '777 Cedar St, City', 1800, SYSDATE - 18, '활동');
INSERT INTO customers
VALUES(11, 'Emily Johnson', 'emilyson@example.com', '555-111-2222', TO_DATE('1992-08-18', 'YYYY-MM-DD'), '23/08/20', 'Female', '123 Elm St, City', 750, SYSDATE - 620, '탈퇴');
INSERT INTO customers
VALUES(12, 'David Williams', 'davidwill@example.com', '555-333-4444', TO_DATE('1988-03-12', 'YYYY-MM-DD'), '23/08/20', 'Male', '456 Oak St, Town', 1200, SYSDATE - 30, '활동');
INSERT INTO customers
VALUES(13, 'Sophia Brown', 'sophia@example.com', '555-555-3333', TO_DATE('1995-11-25', 'YYYY-MM-DD'), '22/08/20', 'Female', '789 Maple St, Village', NULL, SYSDATE - 40, '활동');
INSERT INTO customers
VALUES(14, 'Michael Davis', 'michael@example.com', '555-777-8888', TO_DATE('1987-02-05', 'YYYY-MM-DD'), '22/08/20', 'Male', '234 Pine St, City', 1800, SYSDATE - 10, '활동');
INSERT INTO customers
VALUES(15, 'Olivia Wilson', 'olivia@example.com', '555-999-0000', TO_DATE('1990-07-30', 'YYYY-MM-DD'),'21/08/20', 'Female', '567 Elm St, Town', 800, SYSDATE - 15, '활동');
INSERT INTO customers
VALUES(16, 'William Smith', 'william@example.com', '555-222-3333', TO_DATE('1993-04-22', 'YYYY-MM-DD'), '21/08/20', 'Male', '890 Oak St, Village', 300, SYSDATE - 50, '활동');
INSERT INTO customers
VALUES(17, 'Emma Jones', 'emma@example.com', '555-444-5555', TO_DATE('1989-10-10', 'YYYY-MM-DD'), '21/08/20', 'Female', '123 Maple St, City', 600, SYSDATE - 25, '활동');
INSERT INTO customers
VALUES(18, 'Liam Miller', 'liam@example.com', '555-666-7777', TO_DATE('1991-01-28', 'YYYY-MM-DD'), '21/08/20', 'Male', '456 Pine St, Town', 1400, SYSDATE - 18, '활동');
INSERT INTO customers
VALUES(19, 'Ava Taylor', 'ava@example.com', '555-888-9999', TO_DATE('1994-09-15', 'YYYY-MM-DD'), '21/08/20', 'Female', '789 Elm St, Village', 400, SYSDATE - 450, '탈퇴');
INSERT INTO customers
VALUES(20, 'Noah Martin', 'noah@example.com', '555-000-1111', TO_DATE('1996-06-02', 'YYYY-MM-DD'), '21/08/20', 'Male', '234 Oak St, City', 1100, SYSDATE - 22, '활동');
    
SELECT * FROM customers;    

COMMIT;


-- 1. 고객 세분화

-- 1) 구매금액과 지역에 따른 고객 세분화 : 총구매금액 1000이상 & 대도시 거주자  
SELECT customer_id, cname, total_price, address     
FROM customers
WHERE total_price >= 1000 AND address LIKE '%City%';

/*
City (시): "City"는 보통 인구가 많고 상업 및 문화 중심지로서 발전한 지역(대규모 도시)
Town (타운): 시 보다는 작지만 마을보다는 큰 지역.(소규모 도시)
Village (빌리지): 가장 작은 지역 단위(인구가 상대적으로 적고, 주로 농촌지역)
*/

-- 2) 총구매금액을 "고가", "중가", "저가" 카테고리로 분류
SELECT customer_id, cname, total_price,
    CASE
        WHEN total_price >= 1000 THEN '고가'
        WHEN total_price >= 500 AND total_price < 1000 THEN '중가'
        ELSE '저가'
    END 구매카테고리 -- 3 
FROM customers -- 1 
WHERE total_price IS NOT NULL -- 2: 구매이력이 없는 고객 제외 
ORDER BY total_price DESC; -- 4: 총구매금액 내림차순 정렬     


-- 3) 거주지역에 따라 "City", "Town", "Village" 카테고리로 분류
SELECT customer_id, cname, total_price, address,
    CASE
      WHEN address LIKE '%City%' THEN 'City'
      WHEN address LIKE '%Town%' THEN 'Town'
      ELSE 'Village'
    END 거주지역카테고리 
FROM customers   
ORDER BY 거주지역카테고리; -- 거주지역세그먼트 기준 정렬

/*
 문1) 거주지역이 Town 또는 Village이고, 총구매금액의 구매카테고리가 중가와 저가인 고객을 대상으로 
     마케팅을 수행하기 위해서 고객 '이름','이메일','주소','총구매금액','구매카테고리'를 
     출력하는 조회문을 작성하시오. (단 총구매금액 순으로 내림차순 정렬)
     힌트) CASE문 이용
     
     <출력결과>
     CNAME          EMAIL               ADDRESS      TOTAL_PRICE  구매카테고리       
    Bob Smith	   bob@example.com	    456 Oak St, Town	900	   중가
    David Brown	   david@example.com	101 Pine St, Town	800	   중가
    Olivia Wilson  olivia@example.com	567 Elm St, Town	800	   중가
    Ava Taylor	   ava@example.com	    789 Elm St, Village	400	   저가
    William Smith  william@example.com	890 Oak St, Village	300	   저가
*/

SELECT cname, email, address, total_price,
    CASE
        WHEN total_price >= 1000 THEN '고가'
        WHEN total_price >= 500 AND total_price < 1000 THEN '중가'
        ELSE '저가'
     END 구매카테고리
FROM customers
WHERE total_price < 1000 AND (address LIKE '%Town%' OR address LIKE '%Village%')
ORDER BY total_price DESC; 


/*
  문2) 봄과 초여름 신상품을 판매하기 위해서 계절 세그먼트가 '봄'과 '여름'에 해당하는
       고객정보만 조회하시오.
       계절 세그먼트는 고객의 생년월일에 따라서 아래와 같이 분류한다.  
       계절 세그먼트 : 봄 : 3~5월, 여름 : 6~8월, 가을 : 9~11월, 겨울 : 12~2월      
       힌트) CASE문 이용
       
    <출력결과>
      CNAME        BIRTHDATE     ADDRESS         TOTAL_PRICE  계절카테고리 
    Alice Johnson	88/05/10  123 Maple St, City	1200	  봄
    Jack Taylor	    86/04/28  777 Cedar St, City	1800	  봄
    William Smith	93/04/22  890 Oak St, Village	 300	  봄
    David Williams	88/03/12  456 Oak St, Town	    1200	  봄
    Henry Wilson	89/03/25  555 Maple St, City	1300	  봄
    Noah Martin  	96/06/02  234 Oak St, City	    1100	여름
    Emily Johnson	92/08/1   123 Elm St, City	     750	여름
    Isabella Moore	91/06/12  666 Elm St, Village	1600	여름
    Olivia Wilson	90/07/30  567 Elm St, Town	     800	여름
    Frank Miller	83/08/22  333 Birch St, Village	1400	여름
    David Brown	    90/07/05  101 Pine St, Town	     800	여름
*/ 

SELECT cname, birthdate, address, total_price,
    CASE
      WHEN SUBSTR(birthdate, 4,2) >= '03' AND  SUBSTR(birthdate, 4,2) <= '05' THEN '봄'
      WHEN SUBSTR(birthdate, 4,2) >= '06' AND  SUBSTR(birthdate, 4,2) <= '08' THEN '여름'
      WHEN SUBSTR(birthdate, 4,2) >= '09' AND  SUBSTR(birthdate, 4,2) <= '11' THEN '가을'
      ELSE '겨울'
    END 계절카테고리 
FROM customers
WHERE SUBSTR(birthdate, 4,2) >= '03' AND  SUBSTR(birthdate, 4,2) <= '08'
ORDER BY 계절카테고리; -- 정렬 : 별칭 사용 



-- 2. 이탈고객분석 : 최근 구매일짜가 오래된 고객 중심으로 이탈고객 찾기 

-- 1) '탈퇴' 고객과 '활동' 고객 조회 
SELECT customer_id, cname, email, total_price, last_date    
FROM customers
WHERE churn_status != '탈퇴'; -- 2명 : 탈퇴, 18명 : 활동  


-- 2) 이탈가능고객 조회 : 1개월 이상 구매이력 없는 고객 
-- MONTHS_BETWEEN(시작일, 종료일) : 개월 반환 
SELECT customer_id, cname, email, total_price, last_date,
    CASE
        WHEN MONTHS_BETWEEN(SYSDATE, last_date) >= 1 THEN '이탈가능'
        ELSE '지속가능'
    END 이탈여부
FROM customers
ORDER BY 이탈여부; 


-- 3) '활동' 고객 중에서 가입일이 2년 이하인 고객 조회       
SELECT cname, reg_date, phone_number, last_date
FROM customers
WHERE MONTHS_BETWEEN(SYSDATE, reg_date) <= 24
      AND churn_status='활동';  
      
-- 4) 마지막 구매일이 20일 이상인 고객 조회          
SELECT cname, reg_date, phone_number, last_date
FROM customers
WHERE sysdate-last_date >= 20; 

/*
 문3) 고객이탈방지를 위해서 관련 고객에게 이벤트를 진행하기 위해서 가입일(reg_date)이 2년 이내
      이면서 오늘일짜를 기준으로 30일 이상 구매이력이 없는 고객 정보를 출력하는 조회문을
      작성하시오. (단 이탈여부(churn_status)가 '탈퇴'한 고객은 제외)
     
     힌트) MONTHS_BETWEEN과 SYSDATE 함수 이용 
     
    <출력결과>
    CNAME            REG_DATE  PHONE_NUMBER    LAST_DATE
    David Williams	23/08/20	555-333-4444	24/01/25
    Sophia Brown	22/08/20	555-555-3333	24/01/15
*/
SELECT cname, reg_date, phone_number, last_date
FROM customers
WHERE MONTHS_BETWEEN(SYSDATE, reg_date) < 24 -- 8명 
      AND SYSDATE-last_date >= 30 -- 3명
      AND churn_status != '탈퇴'; -- 2명 
      
      