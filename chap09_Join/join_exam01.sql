-- 문1) 아래 <출력결과>와 같이 직책이 '관리자'인 이름, 직책, 부서명, 근무지역을 출력하시오.
-- 사용할 테이블 : emp, dept 
SELECT ename, job, dname, loc
FROM emp, dept 
WHERE emp.deptno = dept.deptno 
AND emp.job = 'MANAGER' ;

/*
  <출력결과>
  ENAME  JOB      DNAME       LOC
  CLARK  MANAGER  ACCOUNTING  NEW YORK
  JONES  MANAGER  RESEARCH    DALLAS
  BLAKE  MANAGER  SALES       CHICAHO 
*/


-- 문2) 아래 <출력결과>와 같이 right Outer join 방식으로 사원 테이블에 없는 부서 정보를 출력하시오.
-- 사용할 테이블 : emp, dept 
 -- 사원 테이블에 정보가 부족하므로 대상테이블(+)이 되겠다. 

 SELECT d.deptno, dname, loc 
 FROM emp e, dept d
 WHERE e.deptno(+) = d.deptno AND e.deptno IS NULL ;
 
 
/*
  <출력결과>
  DEPTNO   DNAME      LOC
      40   OPERTIONS  BOSTON
*/


/* 문3) 관리자의 실수로 일부 동물의 입양일이 잘못 입력되었다. 보호 시작일 보다 
   입양일이 더 빠른 동물의 아이디와 이름을 조회하는 SQL문을 작성하시오.  
   단, 보호 시작일이 빠른 순서로 정렬 : <조회 결과> 참고
   힌트 : Inner join 방식 
 
  사용 테이블 
    - 보호소 테이블 : ANIMAL_INS
    - 입양 테이블 : ANIMAL_OUTS
 */ 
SELECT * FROM ANIMAL_INS ; 
SELECT * FROM ANIMAL_OUTS ORDER BY datetime ASC;

SELECT i.aid AID, i.atype ATYPE ,  i.datetime 입소일, o.datetime 입양일 
FROM animal_ins i, animal_outs o 
WHERE i.aid = o.aid AND i.datetime >= o.datetime
ORDER BY i.datetime ASC ; 

/*
  <출력결과>   
  AID  NAME     입소일     입양일 
  1001 푸들     23/08/08  20/10/03 
  1004 달마티안  23/08/08  20/03/12
  1006 메이쿤    23/08/08  20/06/10
 */
 
 
 
/*
  <준비> 다음 문제를 풀기 전에 아래 3개 테이블(고객, 판매, 반품)을 생성하고, 레코드를 추가하세요.
*/

-- 1. 고객 테이블 
create table user_data(
user_id int primary key,       -- 고객id(기본키) : 고객 식별자 
gender number(1) not null,     -- 성별 : 범주형(남자:1, 여자:2)
age number(3) not null,        -- 나이 : 숫자형(연속형) 
house_type number(1) not null, -- 주택유형 : 범주형(1~4) 
resident varchar(10) not null, -- 거주지역 : 문자형 
job number(1) not null         -- 직업유형 : 범주형(1~6) 
);

-- 시퀀스 생성 
create sequence seq_id increment by 1 start with 1001;

-- 시퀀스 이용 레코드 추가 
insert into user_data values(seq_id.nextval, 1, 35,	1,	'전북', 	6);
insert into user_data values(seq_id.nextval, 2, 45,	3,	'경남', 	2);
insert into user_data values(seq_id.nextval, 1, 55,	3,	'경기', 	6);
insert into user_data values(seq_id.nextval, 1, 43,	3,	'대전', 	1);
insert into user_data values(seq_id.nextval, 2, 55,	4,	'경기', 	2);
insert into user_data values(seq_id.nextval, 1, 45,	1,	'대구', 	1);
insert into user_data values(seq_id.nextval, 2, 39,	4,	'경남', 	1);
insert into user_data values(seq_id.nextval, 1, 55,	2,	'경기', 	6);
insert into user_data values(seq_id.nextval, 1, 33,	4,	'인천', 	3);
insert into user_data values(seq_id.nextval, 2, 55,	3,	'서울', 	6);

-- 레코드 조회 
select * from user_data;


-- 2. 판매 테이블 
create table sale_data(
user_id int not null,            -- 고객id
product_type number(1) not null, -- 상품유형 : 범주형(1~5)
pay_method varchar(20) not null, -- 지불유형 : 범주형(1~4)
price int not null,              -- 구매금액 
foreign key(user_id)             -- 외래키(고객id)
references User_data(user_id)
);

-- 판매 테이블 레코드 추가 
insert into sale_data values(1001, 1, '1.현금', 153000);
insert into sale_data values(1002, 2, '2.직불카드', 120000);
insert into sale_data values(1003, 3, '3.신용카드', 780000);
insert into sale_data values(1003, 4, '3.신용카드', 123000);
insert into sale_data values(1003, 5, '1.현금', 79000);
insert into sale_data values(1003, 1, '3.신용카드', 125000);
insert into sale_data values(1007, 2, '2.직불카드', 150000);
insert into sale_data values(1007, 3, '4.상품권', 78879);


select * from sale_data;


-- 3. 반품 테이블  
create table return_data(
user_id int not null,            -- 고객id
return_code number(1) not null,  -- 반품코드 : 범주형(1~4)
foreign key(user_id) 
references User_data(user_id)    -- 외래키(고객id)
);

-- 반품 테이블 레코드 추가  
insert into return_data values(1003, 1);
insert into return_data values(1003, 4);
insert into return_data values(1007, 1);
insert into return_data values(1009, 2);

select * from return_data;

commit; -- db 반영 


-- 문4) 고객(user_data)테이블과 판매(sale_data)테이블을 inner join하여 조건에 맞게 출력하시오.
/*
 조건1) 고객ID(user_id), 성별(gender), 직업유형(job), 상품유형(product_type), 지불방법(pay_method), 구매금액(price) 칼럼 출력  
 조건2) 조회결과 고객ID(user_id)기준 오름차순 정렬
*/
SELECT * FROM user_data ; 
SELECT * FROM sale_data ;

SELECT u.user_id 고객ID, u.gender 성별, u.job 직업유형, s.product_type 상품유형, s.pay_method 지불방법, s.price 구매금액 
FROM user_data u, sale_data s 
WHERE u.user_id = s.user_id 
ORDER BY u.user_id ASC; 


-- 문5) 문4)의 결과에서 성별이 '여자'이거나 지불방법이 '1.현금'인 경우만 출력하시오.
SELECT u.user_id 고객ID, u.gender 성별, u.job 직업유형, s.product_type 상품유형, s.pay_method 지불방법, s.price 구매금액 
FROM user_data u, sale_data s 
WHERE u.user_id = s.user_id  AND (u.gender = 2 OR s.pay_method = '1.현금') 
ORDER BY u.user_id ASC; 



-- 문6) 고객 테이블(user_data)과 판매 테이블(sale_data)을 대상으로 상품을 구매하지 않은 고객까지 출력하시오.
/*
  <조건> 고객ID(user_id), 성별(gender), 나이(age), 상품유형(product_type), 지불방법(pay_method) 칼럼 출력   
  힌트) left outer join 이용 
*/ 
SELECT u.user_id 고객ID, u.gender 성별, u.age 나이 , s.product_type 상품유형, s.pay_method 지불방법 
FROM user_data u, sale_data s 
WHERE u.user_id = s.user_id(+)  -- 상품목록이 부족한쪽이니까 대상테이블(+)  



 
     