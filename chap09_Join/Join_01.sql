/* 


공통 칼럼을 공유하는 테이블을 Join을 통해 연결한다. 
부모 테이블 = 원장테이블 (★★★ 주로 내용이 변하지 않는 데이터가 들어간다. ★★★) 
자식테이블 = 거래테이블 
조인테이블을 지우려면 ? 자식테이블 삭제 -> 부모테이블 삭제 
또는 DROP TABLE 테이블명 cascade constraint; 으로 테이블을 강제 삭제한다. 
*/

/*
CREATE TABLE dept_copy(
deptno NUMBER(2) PRIMARY KEY,  -- ★★★ 원장테이블의 기본키 
dname CHAR(14),
loc CHAR(13)
);

CREATE TABLE emp_copy( 
empno NUMBER(4) PRIMARY KEY, -- ★★★ 거래테이블의 기본키 
ename VARCHAR2(10),
job VARCHAR2(9),
mgr NUMBER(4) REFERENCES emp_tab(empno),  -- 동일테이블 조인 
deptno NUMBER(2) NOT NULL,    -- 외래키로 할 것임. 외래키로 들어갈 칼럼에 not null 전제조건을 넣어줘야 이후 데이터의 무결성을 유지할 수 있다. 
FOREIGN KEY(deptno) REFERENCES dept_tab(deptno)  -- ★★★ 연결시킬 키는 외래키로 들어간다. 
);

deptno NUMBER(2) NOT NULL REFERENCES dept_tab(deptno) 라고 작성하면 NOT NULL & 외래키 동시에 지정해줄 수 있음 
*/

-- 1. 물리적 조인 

-- 예제 
--1단계 : 상품(goods) 테이블 - 원장테이블 
CREATE TABLE goods(
gcode NUMBER(2) PRIMARY KEY, -- 기본키로 상품코드 
gname VARCHAR(20), 
price INT 
);
-- 2단계: 상품 테이블에 레코드 추가 
INSERT INTO goods VALUES(10,'사과', 5000);
INSERT INTO goods VALUES(20,'복숭아', 8000);
INSERT INTO goods VALUES(30,'포도', 3000);

DESC goods; 

-- 3단계: 판매(sale) 테이블 - 거래테이블 
CREATE TABLE sale(
sale_num NUMBER(8) PRIMARY KEY,  -- 거래테이블의 기본키 
gcode NUMBER(4) NOT NULL, --외래키로 할 것임 
sale_date date, 
su NUMBER(3) , 
FOREIGN KEY(gcode) REFERENCES goods(gcode) --외래키 지정 

);
ALTER TABLE sale RENAME COLUMN sal_num TO  sale_num ;

-- 4 단계: 판매테이블에 레코드 추가 
-- 주의: 주테이블의 기본키에 없는 데이터를 외래키에 넣을 경우 참조 무결성 제약조건에 위배된다. 
INSERT INTO sale VALUES(1,10, sysdate-2, 5);
INSERT INTO sale VALUES(2,20, sysdate-1, 10);
INSERT INTO sale VALUES(3,30, sysdate, 8);
INSERT INTO sale VALUES(4,30, sysdate-3, 5);

SELECT * FROM sale; 
SELECT * FROM goods;

-- 5단계: 외래키(gcode; 공통칼럼) 를 이용한 테이블 조인 
-- FROM 절에서 조인대상들을 나열한다. -- FROM goods g, sale s
-- 그리고 WHERE절에서 공통칼럼으로 조인 조건을 건다. -- WHERE g.gcode = s.gcode 
SELECT sale_num, g.gcode, g.gname, price, su, sale_date  -- ★★★ 한 테이블에만 있는 칼럼은 출처생략 가능 
FROM goods g, sale s
WHERE g.gcode = s.gcode ; 

-- WHERE에 조인조건 & 동시에 추가조건을 걸 수 있다. 
SELECT sale_num, g.gcode, g.gname, price, su, sale_date  
FROM goods g, sale s
WHERE g.gcode = s.gcode 
AND s.su >=8 ; -- 추가조건 
 
 -- ANSI JOIN (Oracle, MySQL 등 다른 RDBMS에서도 사용가능한 국제표준 SQL) 
 SELECT sale_num, g.gcode, g.gname, price, su, sale_date  
FROM goods g INNER JOIN sale s   -- ★★★ 컴마(,) 대신에 INNER JOIN 이라는 명령어가 들어간다.  -- ON절이 추가로 들어간다. 
ON (g.gcode = s.gcode) ; 
-- 오라클 전용에서는 FROM 및 WHERE절을 통해 조인을 걸게 되는데, ANSI 조인은 FROM 및 ON 절 
SELECT sale_num, g.gcode, g.gname, price, su, sale_date  
FROM goods g INNER JOIN sale s  
ON (g.gcode = s.gcode) 
WHERE s.su >= 8 ;  -- Of caurse, WHERE절로 추가조건 걸 수 있다. 
-- ★★★ Algorithm : FROM > ON > WHERE > SELECT >... 


