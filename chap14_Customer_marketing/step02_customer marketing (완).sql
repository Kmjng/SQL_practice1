-- step02_customer marketing.sql
/*
  고객행동분석 : 고객의 구매행동을 분석하여 마케팅에 활용  
*/

-- 3. 고객행동분석

-- 고객구매행동 테이블 생성 : 고객(customers) 테이블 참조 
drop table customer_activities;

CREATE TABLE customer_activities(
    activity_id INT PRIMARY KEY, -- 기본키 : 구분자   
    customer_id INT NOT NULL, -- 외래키 : 고객id
    activity_date DATE, -- 구매일
    amount NUMBER(10, 2), -- 구매수량 
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- 레코드 추가
INSERT INTO customer_activities
VALUES(1, 10, TO_DATE('2023-12-01', 'YYYY-MM-DD'), 50.00);
INSERT INTO customer_activities
VALUES(2, 10, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 20.00);
INSERT INTO customer_activities
VALUES(3, 20, TO_DATE('2023-12-10', 'YYYY-MM-DD'), 80.00);
INSERT INTO customer_activities
VALUES(4, 13, TO_DATE('2023-12-05', 'YYYY-MM-DD'), 15.00); 
INSERT INTO customer_activities
VALUES(5, 10, TO_DATE('2024-02-02', 'YYYY-MM-DD'), 20.00);
INSERT INTO customer_activities
VALUES(6, 20, TO_DATE('2024-01-25', 'YYYY-MM-DD'), 25.00);
INSERT INTO customer_activities
VALUES(7, 13, TO_DATE('2024-01-10', 'YYYY-MM-DD'), 50.00);
INSERT INTO customer_activities
VALUES(8, 1, TO_DATE('2024-01-10', 'YYYY-MM-DD'), 30.00);  


-- 고객구매행동 테이블 조회  
SELECT * FROM customers; -- 원장 테이블 : 고객 정보 
SELECT * FROM customer_activities; -- 거래 테이블 : 고객구매행동 정보 
COMMIT;


-- 1) 구매가 활발한 고객 분석 : 최근 6개월 간 구매활동 횟수가 2회 이상인 고객
SELECT customer_id, COUNT(*) 구매횟수, SUM(amount) 총구매량, AVG(amount) 평균구매량  
FROM customer_activities -- 1차 
WHERE MONTHS_BETWEEN(SYSDATE, activity_date) <= 6 -- 2차 : 최근 6개월 이내      
GROUP BY customer_id -- 3차 : 같은 고객끼리 묶음   
HAVING COUNT(*) > 1 -- 4차 : 구매활동 횟수가 2회 이상
ORDER BY customer_id; -- 6차 


/*
  문4) 구매가 활발한 고객을 분석하기 위해서 최근 3개월 간 평균구매량이 30을 초과한 고객을 
      <출력결과>와 같이 조회하시오.(고객구매행동(customer_activities) 테이블 이용) 

   <출력결과>
   고객ID   구매횟수   총구매량   평균구매량
      13        2        65       32.5
      20        2       105       52.5  
*/
SELECT customer_id 고객ID, COUNT(*) 구매횟수, SUM(amount) 총구매량, AVG(amount) 평균구매량  
FROM customer_activities -- 1차 
WHERE MONTHS_BETWEEN(SYSDATE, activity_date) <= 6 -- 2차 : 최근 6개월 이내      
GROUP BY customer_id -- 3차 : 같은 고객끼리 묶음   
HAVING AVG(amount) > 30 -- 4차 : 구매활동 횟수가 2회 이상
ORDER BY customer_id; -- 6차 



-- 2) 최근 3개월 간 구매 패턴 분석 : ANSI 표준 INNER JOIN 방식 
SELECT c.customer_id, c.cname, c.total_price, c.last_date, ca.activity_date, ca.amount,
    CASE
        WHEN c.total_price > 1500 THEN '고액 구매'
        WHEN c.total_price > 0 THEN '저액 구매' -- 1~1500 
        ELSE '구매 없음' -- NULL
    END AS 구매패턴 -- 7번 칼럼 
FROM customers c INNER JOIN customer_activities ca
ON (c.customer_id = ca.customer_id -- 8개 레코드
      AND MONTHS_BETWEEN(SYSDATE, last_date) <= 3 -- 7개 레코드 
      AND c.total_price IS NOT NULL); -- 5개 레코드  

-- ON절 + WHERE절  
SELECT c.customer_id, c.cname, c.total_price, c.last_date, ca.activity_date, ca.amount,
    CASE
        WHEN c.total_price > 1500 THEN '고액 구매'
        WHEN c.total_price > 0 THEN '저액 구매' -- 1~1500 
        ELSE '구매 없음' -- NULL
    END AS 구매패턴 -- 7번 칼럼 
FROM customers c INNER JOIN customer_activities ca
ON (c.customer_id = ca.customer_id) -- 8개 레코드
WHERE MONTHS_BETWEEN(SYSDATE, last_date) <= 3 -- 7개 레코드
      AND c.total_price IS NOT NULL; -- 5개 레코드
      
      
-- 3) 고객 정보와 고객구매활동 정보 조인 : ANSI 표준 LEFT OUTER JOIN 방식
SELECT c.customer_id, c.cname, c.email, ca.activity_date, ca.amount
FROM customers c LEFT OUTER JOIN customer_activities ca
ON (c.customer_id = ca.customer_id) -- 조인조건 
ORDER BY ca.amount;   
-- [해설] 왼쪽의 고객 정보는 모두 표시되고, 오른쪽 고객구매행동 정보를 가져오고, 없으면 NULL 채움 


-- 4) 구매가 활발한 고객 분석 : ANSI 표준 LEFT OUTER JOIN + GROUP BY
SELECT c.customer_id, c.cname, COUNT(ca.activity_id) AS 활동횟수,
       SUM(ca.amount) AS 총구매수량, AVG(ca.amount) AS 평균구매수량
FROM customers c LEFT OUTER JOIN customer_activities ca
ON (c.customer_id = ca.customer_id) -- 조인조건 
GROUP BY c.customer_id, c.cname; -- 같은 고객은 묶음 

/*
 문5) 구매가 활발한 고객을 분석하기 위해서 최근 3개월 간 구매활동 횟수가 2회 이상인 고객의 
      정보를 다음 <출력결과>와 같이 출력되는 조회문을 작성하시오.(총구매량 내림차순 정렬)
      힌트) ANSI 표준 INNER JOIN 이용
      
    <출력결과>
    고객ID  이름           성별  구매횟수  총구매량  평균구매량 
       20	Noah Martin	 Male      2	105 	52.5
       10	Jack Taylor	 Male	   3	90	      30
       13	Sophia Brown Female	   2	65	    32.5
*/
SELECT c.customer_id 고객ID, c.cname 이름, c.gender 성별, 
       COUNT(ca.activity_id) AS 구매횟수, SUM(ca.amount) AS 총구매량, 
       AVG(ca.amount) AS 평균구매량    
FROM customers c INNER JOIN customer_activities ca
ON (c.customer_id = ca.customer_id
     AND MONTHS_BETWEEN(SYSDATE, last_date) <= 3) -- 조인 조건  
GROUP BY c.customer_id, c.cname, c.gender -- 동일 고객 묶음 
HAVING COUNT(ca.activity_id) > 1 -- GROUP BY 조건 
ORDER BY 총구매량 DESC;

-- 오류 발생 : 그룹함수를 이용하여 조건 사용 
-- ON (c.customer_id = ca.customer_id AND COUNT(ca.activity_id) > 1)


-- 고객구매활동을 기준으로 고객 정보 조인 : ANSI 표준 RIGHT OUTER JOIN 
SELECT c.customer_id, c.cname, c.email, ca.activity_date, ca.amount
FROM customers c RIGHT OUTER JOIN customer_activities ca
ON (c.customer_id = ca.customer_id) -- 조인조건 
ORDER BY ca.amount; 
-- INNER JOIN 결과와 동일 : 8개 

SELECT c.customer_id, c.cname, c.email, ca.activity_date, ca.amount
FROM customers c RIGHT OUTER JOIN customer_activities ca
ON (c.customer_id = ca.customer_id AND c.customer_id=10) -- 조인조건 
ORDER BY ca.amount; 
-- 오른쪽 고객구매활동 정보는 모두 가져오고, 왼쪽은 10번 고객 정보만 표시되고, 나머지는 NULL 채움
