-- 물리적 테이블 생성 
create table db_view_tab(
id varchar2(15) primary key,  
name varchar2(25) not null,
price int,
email varchar2(50),
regdate date not null
);

-- 레코드 추가 
insert into db_view_tab values('hong','홍길동',150, 'hong@naver.com',sysdate);
insert into db_view_tab values('lee','이순신',80, 'lee@naver.com',sysdate);
insert into db_view_tab values('admin','관리자',220, 'admin@naver.com',sysdate);
select * from db_view_tab;
commit work; -- DB 반영 


-- 문1) 기본테이블(db_view_tab)을 이용하여 다음 조건에 맞게 일반 사용자만 조회할 수 있는 뷰를 생성하시오.
/*
   조건1> 조건1> 뷰 자체는 수정 가능하고, 기본 테이블은 읽기만 가능한 뷰
   조건2> 뷰 이름 : db_view
*/
SELECT * FROM db_view_tab; 

CREATE OR REPLACE VIEW db_view 
AS SELECT id, name, price, email, regdate FROM db_view_tab
WITH READ ONLY ; 



-- 문2) 생성된 뷰(db_view) 내용을 확인하고, 뷰 데이터 사전으로 뷰 목록을 확인하시오.
SELECT * FROM db_view; 

SELECT * FROM USER_VIEWS; 

-- 문3) 생성된 뷰(db_view)을 삭제한 후 뷰 목록을 확인하시오. 
DROP VIEW db_view ; 

SELECT *  FROM db_view; 

-- 문4) 기본테이블(db_view_tab)을 이용하여 구매금액(price)의 평균, 최대구매액, 최소구매액을 
-- 조회있는 뷰를 생성하시오.
/*
  조건1> 수정 가능한 뷰
  조건2> 뷰 이름 : db_avg_view
  조건3> 읽기전용 뷰
*/
CREATE OR REPLACE VIEW db_avg_view(평균, 최대구매액, 최소구매액)
AS SELECT AVG(price), MAX(price), MIN(price)
FROM db_view_tab 
WITH READ ONLY ; 

SELECT * FROM db_avg_view ; 
/*
  <뷰 조회결과>
   구매액 평균 최대구매액  최소구매액 
        150           220            80
*/



-- 문5) 다음과 같이 관리자용 view를 생성하시오.
/*
 *   조건1> 기본 테이블 : emp_copy
 *   조건2> view 이름 : manager_view
 *   조건3> 대상 칼럼 : 사번, 이름, 직책, 부서번호   
 *   조건4> 대상 레코드 : 직책(영업직, 사원, 분석자)
 *   조건5> 기본테이블에 UPDATE와 INSERT 가능한 뷰 
 */
CREATE VIEW manager_view
AS SELECT empno, ename, job, deptno FROM emp_copy 
WHERE job IN ('SALESMAN','CLERK','ANALYST') ;

SELECT * FROM manager_view;

-- 문6) 다음 조건에 맞게 가장 많은 급여 수령자 순으로 뷰를 정의하고, TOP3를 조회하시오. 
/*  
   조건1> 원본 테이블 : EMP
   조건2> 뷰이름 : sal_top3_view
   조건3> 대상 칼럼 : 사번,이름,급여,직책
   조건4> 읽기전용 뷰

 <출력결과>
EMPNO   ENAME  SAL   JOB  
 7839   KING   5000  PRESIDENT
 7788   SCOTT  3000  ANALYST
 7902   FORD   3000  ANALYST
*/

-- 단계1 : 기본 view 만들기   
CREATE VIEW sal_top3_view 
AS SELECT empno, ename, sal, job 
FROM emp 
WHERE ROWNUM <=3
ORDER BY sal DESC 
WITH READ ONLY ; 

SELECT * FROM sal_top3_view ; 
-- 단계2 : 의사칼럼 이용 TOP3 조회 


-- 문7) 최근에 보호소에 들어온 동물 N마리를 조회하는 뷰를 정의하고, TOP5를 조회하시오. 
/*  
   조건1> 원본 테이블 : animal_ins
   조건2> 뷰이름 : animal_sorted_view
   조건3> 대상 칼럼 : 전체
   조건4> 읽기전용 뷰
*/

-- 동물 보호소 테이블 조회  
SELECT * FROM animal_ins;  -- chap04_DDL의 연습문제 파일 참고 


-- 단계1 : view 만들기   
CREATE VIEW animal_sorted_view 
AS SELECT aid, atype, datetime, condition, name 
FROM animal_ins
WHERE ROWNUM <=5
ORDER BY datetime DESC
WITH READ ONLY ; 

-- 단계2 : view 이용 TOP5 조회 
SELECT * FROM animal_sorted_view ;


/* 문8) "goods"와 "sale"라는 두 개의 테이블이 있습니다. "goods" 테이블은 상품 정보를, 
        "sale" 테이블은 판매 정보를 저장하고 있습니다. 이 두 테이블을 조인하여 
         상품코드, 상품명, 가격, 판매일자, 수량을 포함하는 "SaleView"라는 뷰를 생성하세요.
/*  
   조건1> 기본 테이블 : goods, sale
   조건2> 뷰이름 : SaleView
   조건3> 읽기전용 뷰
   
  <출력결과>
  GCODE  GNAME  PRICE SALE_DATE  SU
    10  사과    5000   23/08/13   5 
    20  복숭아  8000   23/08/13   10  
    30  포도    3000   23/08/13   8 
*/
SELECT * FROM goods;
SELECT * FROM sale; 

CREATE VIEW SaleView 
AS SELECT g.gcode, gname, price, sale_date su 
FROM goods g, sale s 
WHERE g.gcode = s.gcode ;

SELECT * FROM SaleView ; 
