/*
두 테이블의 NULL이 엇갈려 있는 경우, FULL JOIN 으로 OUTER JOIN 을 걸 수 있다. 
단, 오라클 SQL로는 제공되지 않아서 ANSI 표준의 OUTER JOIN을 사용해야 한다. 
*/

-- 3. 3. ANSI Outer Join 
-- 논리적 조인할 두 테이블 각각 빵꾸 있을 때 용이 
DROP TABLE dept02 purge;
CREATE TABLE dept01 (
deptno NUMBER(2), 
dname VARCHAR2(14)
);
INSERT INTO dept01 VALUES(10, 'ACCOUNTING');
INSERT INTO dept01 VALUES(20,  'RESEARCH');

CREATE TABLE dept02 (
deptno NUMBER(2), 
dname VARCHAR2(14)
);
INSERT INTO dept02 VALUES(10, 'ACCOUNTING');
INSERT INTO dept02 VALUES(30,  'SALES');

SELECT * FROM dept01;
SELECT * FROM dept02; 

commit;

SELECT * FROM dept01 LEFT OUTER JOIN dept02 -- 왼쪽 테이블은 모두 가져오고, 오른쪽 해당 자료가 없으면 NULL로 가져옴 
ON (dept01.deptno = dept02.deptno) ;

SELECT * FROM dept02 RIGHT OUTER JOIN dept01 --오른쪽 테이블은 모두 가져오고, 왼쪽에 없으면 NULL로 불러옴  
USING (deptno);

-- LEFT OUTER JOIN 은 왼쪽에 적힌 테이블을 가져오고 나머지 테이블은 맞는 칼럼이 없을 경우 NULL
-- RIGHT OUTER JOIN 은 오른쪽에 적힌 테이블을 가져오고 나머지 테이블에서 맞는 칼럼이 없을 경우 NULL  

SELECT  *
FROM student s, professor p
WHERE s.profno = p.profno(+) ;  

SELECT *
FROM student s, professor p
WHERE s.profno(+) = p.profno;  -- 기준테이블: 지도교수 


-- 3. 4. ANSI FULL Outer Join  
SELECT * 
FROM dept01 FULL OUTER JOIN dept02
USING (deptno);

/*
ON 절 VS USING 절 

ON 절: WHERE 절 추가로 사용 가능, SELECT 절에서 중복해서 공통칼럼 표시 
USING 절: WHERE절 추가 사용 불가능 , SELECT 절에서 공통칼럼은 1개 표시 

*/

SELECT * FROM student ;-- [20 x12]:: profno, deptno1
SELECT * FROM professor ;-- [16 x 10] : profno, deptno

SELECT s.studno, s.name, p.profno, p.name
FROM student s FULL OUTER JOIN professor p
ON (s.profno=p.profno);
/*
 27개 레코드: Student 기준 20개 레코드(15 + 5)  + Professor 기준 7개 레코드 (9 + 7)
*/

-- 3.5. ERD (Entity Relationship Diagram) 

-- 스키마 = 구조 

-- 시간대별 전기 사용량에 따른 요금 계산 (PDF) 
-- EDA로 설계를 먼저 하고, SQL로 DB를 구현한다. 

-- 1차: 고객 전기사용량 -> 물리적 조인 (PK/FK) 
-- 2차: 시간대별 사용요금 -> 논리적 조인 (사용시간/사용량) 


-- (1). 고객테이블(고객ID(PK), 고객명, 생년월일)
CREATE TABLE customer(
cid NUMBER(3) PRIMARY KEY,
cname VARCHAR(20),
birth DATE
);
INSERT INTO customer VALUES(101, '홍길동', SYSDATE);
INSERT INTO customer VALUES(102, '강호동', SYSDATE);
INSERT INTO customer VALUES(103, '이순신', SYSDATE);

-- (2). 고객 전기 사용량(고객ID(FK), 사용시간, 사용량(kw단위)
CREATE TABLE usage_tab(
cid NUMBER(3) NOT NULL, -- 외래키
use_time DATE,
usage number(2),
FOREIGN KEY(cid) REFERENCES customer(cid) 
);

INSERT INTO usage_tab
VALUES(101, TO_DATE('24-02-19 13:10', 'YY-MM-DD HH24:MI'), 50);
INSERT INTO usage_tab
VALUES(102, TO_DATE('24-02-19 06:10', 'YY-MM-DD HH24:MI'), 30);
INSERT INTO usage_tab
VALUES(103, TO_DATE('24-02-19 19:10', 'YY-MM-DD HH24:MI'), 40);
INSERT INTO usage_tab
VALUES(101, TO_DATE('24-01-19 01:10', 'YY-MM-DD HH24:MI'), 40);
INSERT INTO usage_tab
VALUES(103, TO_DATE('24-01-19 20:10', 'YY-MM-DD HH24:MI'), 20); 

-- (3). 시간대별 요금(시작시간대, 종료시간대, 단가)
CREATE TABLE slot_tab(
start_time DATE,
end_time DATE,
price int 
);
INSERT INTO slot_tab VALUES(TO_DATE('24-01-01 00', 'YY-MM-DD HH24'), 
TO_DATE('24-01-01 08', 'YY-MM-DD HH24'), 1000); 
 
INSERT INTO slot_tab VALUES(TO_DATE('24-01-01 09', 'YY-MM-DD HH24'), 
TO_DATE('24-01-01 18', 'YY-MM-DD HH24:MI'), 2000);
 
INSERT INTO slot_tab VALUES(TO_DATE('24-01-01 19', 'YY-MM-DD HH24'), 
TO_DATE('24-01-01 23', 'YY-MM-DD HH24:MI'), 500);

DROP TABLE slot_tab purge;

-- 작성한 테이블 확인 
SELECT * FROM customer;
SELECT cid, TO_CHAR(use_time, 'YYYY-MM-DD HH24:MI:SS') 사용시간대, usage FROM usage_tab; 

SELECT TO_CHAR(start_time,'YYYY-MM-DD HH24:MI:SS') 사용시작,  TO_CHAR(end_time,'YYYY-MM-DD HH24:MI:SS') 사용종료, price  
FROM slot_tab;

-- 물리적 조인 (방식이 INNER JOIN 이랑 똑같네 ) 
SELECT  c.cid, c.cname, TO_CHAR(u.use_time, 'YY-MM-DD HH24:MI:SS') 
FROM customer c, usage_tab u 
WHERE c.cid = u.cid
ORDER BY c.cid;



-- 논리적 조인 (INNER JOIN) 
SELECT c.cid, c.cname, TO_CHAR(u.use_time, 'YY-MM-DD HH24:MI:SS') 사용시간대 , u.usage  사용량
FROM customer c INNER JOIN usage_tab u 
ON ( c.cid = u.cid) ;
-- USING 대신 ON 사용하는 이유는 USING 뒤에 공통칼럼밖에 못오기 때문이다. 

-- ★★★ 2차 ON 절 ( 2차 논리적 조인. 세 개의 테이블 조인) ★★★★★★★
SELECT c.cid, c.cname, TO_CHAR(u.use_time, 'YY-MM-DD HH24:MI:SS') 사용시간대 , u.usage  사용량,
s.price 단가
FROM customer c INNER JOIN usage_tab u 
ON ( c.cid = u.cid) -- 여기까지가 1차 ON 절  -- > 내부조인1: 고객별 전기사용량 
 INNER JOIN slot_tab s -- 내부조인2 : s 조인
ON (SUBSTR(TO_CHAR(u.use_time, 'YY-MM-DD HH24'), -2, 2)
BETWEEN SUBSTR(TO_CHAR(s.start_time, 'YY-MM-DD HH24'), -2, 2) AND 
 SUBSTR(TO_CHAR(s.end_time, 'YY-MM-DD HH24'), -2, 2));  -- 내부조인2: 고객별 전기사용량 + 단가
 -- 두번째 조인조건은 등호 대신 [s 테이블 '범위'에 u 테이블 지정] ★★★

-- 고객별 사용량 합산 (GROUPING)  
SELECT c.cid, c.cname, SUM(u.usage * s.price) as "최종 전기 요금" 
FROM customer c INNER JOIN usage_tab u 
ON ( c.cid = u.cid) -- 여기까지가 1차 ON 절  -- > 내부조인1: 고객별 전기사용량 
 INNER JOIN slot_tab s -- 내부조인2 : s 조인
ON (SUBSTR(TO_CHAR(u.use_time, 'YY-MM-DD HH24'), -2, 2)
BETWEEN SUBSTR(TO_CHAR(s.start_time, 'YY-MM-DD HH24'), -2, 2) AND 
 SUBSTR(TO_CHAR(s.end_time, 'YY-MM-DD HH24'), -2, 2))
GROUP BY c.cid, c.cname -- 이름도 SELECT하기 위해서 함께 GROUP 해준다.  
 ;

