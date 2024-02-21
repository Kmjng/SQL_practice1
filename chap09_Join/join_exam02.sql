-- 문1) 아래 <출력결과>와 같이 직책이 '관리자'인 이름, 직책, 부서명, 근무지역을 출력하시오.
-- 사용할 테이블 : emp, dept 
     
/*
  <출력결과>
  ENAME  JOB      DNAME       LOC
  CLARK  MANAGER  ACCOUNTING  NEW YORK
  JONES  MANAGER  RESEARCH    DALLAS
  BLAKE  MANAGER  SALES       CHICAHO 
*/

SELECT ename, job, dname, loc -- 유일한 칼럼 : 출처 생략 
FROM emp, dept
WHERE emp.deptno = dept.deptno
      AND emp.job = 'MANAGER';

-- 문2) 아래 <출력결과>와 같이 right Outer join 방식으로 사원 테이블에 없는 부서 정보를 출력하시오.
-- 사용할 테이블 : emp, dept 
 
/*
  <출력결과>
  DEPTNO   DNAME      LOC
      40   OPERTIONS  BOSTON
*/

-- right Outer join 방식 : 오른쪽 테이블 기준 
SELECT dept.deptno, dname, loc  -- 부서번호 출처표시 
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno -- 외부조인 조건 
      AND emp.deptno IS NULL; -- 추가 조건 



/* 문3) 관리자의 실수로 일부 동물의 입양일이 잘못 입력되었다. 보호 시작일 보다 
   입양일이 더 빠른 동물의 아이디와 이름을 조회하는 SQL문을 작성하시오.  
   단, 보호 시작일이 빠른 순서로 정렬 : <조회 결과> 참고
   힌트 : Inner join 방식 
 
  사용 테이블 
    - 보호소 테이블 : ANIMAL_INS
    - 입양 테이블 : ANIMAL_OUTS
 */ 

SELECT * FROM ANIMAL_INS; -- 보호소 : 9마리 
SELECT * FROM ANIMAL_OUTS; -- 입양 : 5마리 

/*
  <출력결과>   
  AID  NAME     입소일     입양일 
  1001 푸들     23/08/08  20/10/03 
  1004 달마티안  23/08/08  20/03/12
  1006 메이쿤    23/08/08  20/06/10
 */
 
SELECT ins.aid, ins.name, ins.datetime 입소일, outs.datetime 입양일 
FROM ANIMAL_INS ins, ANIMAL_OUTS outs
WHERE ins.aid = outs.aid -- 조인조건 : 5마리 
      AND ins.datetime > outs.datetime -- 추가조건 : 3마리(2마리 제외)
ORDER BY ins.datetime; -- 보호시작일 오름차순  
 
 
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
select * from user_data; -- 전체 고객 : 10명 


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


select * from sale_data; -- 판매건수 : 8개 


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

select * from return_data; -- 반품건수 : 4개 

commit; -- db 반영 

-- 위 테이블 3개는 고객 ID(user_id) 칼럼으로 물리적 조인되었다.


-- 문4) 고객(user_data)테이블과 판매(sale_data)테이블을 inner join하여 조건에 맞게 출력하시오.
/*
 조건1) 고객ID(user_id), 성별(gender), 직업유형(job), 상품유형(product_type), 지불방법(pay_method), 구매금액(price) 칼럼 출력  
 조건2) 조회결과 고객ID(user_id)기준 오름차순 정렬
*/
SELECT u.user_id,gender,job, product_type, pay_method, price 
FROM user_data u, sale_data s
WHERE u.user_id = s.user_id -- 내부 조인 : 8개 레코드(판매 정보 제공)   
ORDER BY u.user_id; -- 오름차순 정렬

-- 문5) 문4)의 결과에서 성별이 '여자'이거나 지불방법이 '1.현금'인 경우만 출력하시오.
SELECT u.user_id,gender,job, product_type, pay_method, price 
FROM user_data u, sale_data s
WHERE u.user_id = s.user_id -- 내부 조인 : 8개 레코드 
      AND (gender = 2 OR pay_method = '1.현금') -- 추가 조건 : 5개 레코드(3개 제외) 
ORDER BY u.user_id; -- 오름차순 정렬

-- 문6) 고객 테이블(user_data)과 판매 테이블(sale_data)을 대상으로 상품을 구매하지 않은 고객까지 출력하시오.
/*
  <조건> 고객ID(user_id), 성별(gender), 나이(age), 상품유형(product_type), 지불방법(pay_method) 칼럼 출력   
  힌트) left outer join 이용 
*/ 
SELECT u.user_id,gender,age, product_type, pay_method 
FROM user_data u, sale_data s
WHERE u.user_id = s.user_id(+); -- 왼쪽 외부 조인(left outer join) 
-- 내부 조인 : 8개 레코드 -> 외부 조인 : 14개 레코드 
-- 상품을 구매하지 않은 고객 : 6명 


-- 문7) 문6)의 SQL문으로 ANSI Outer Join으로 작성하시오.
SELECT u.user_id, gender, age, product_type, pay_method
FROM user_data u FULL OUTER JOIN sale_data s
ON u.user_id = s.user_id 
;

-- 문8) 고객 테이블(user_data)과 반품 테이블(return_data)을 대상으로 상품을 '반품한 고객'만 출력하시오.
-- <조건1> 고객ID, 성별, 거주지역, 반품코드 칼럼 출력
-- <조건2> ANSI Outer Join 이용
SELECT * FROM return_data; -- 반품 목록 확인 

SELECT r.user_id 반품한고객, gender, age, house_type, resident, job, r.return_code 
FROM user_data u FULL OUTER JOIN return_data R
ON u.user_id = r.user_id
WHERE r.user_id IS NOT NULL ;


-- 문9) 반품 고객을 대상으로 반품 수량을 출력하시오.(반품 수량이 가장 많은 순으로 정렬)
SELECT r.user_id 반품한고객, COUNT(r.user_id) 반품갯수 
FROM user_data u FULL OUTER JOIN return_data R
ON u.user_id = r.user_id
WHERE r.user_id IS NOT NULL 
GROUP BY r.user_id
ORDER BY COUNT(r.user_id) DESC;


/*
  <출력 결과>
  USER_ID  반품수 
   1003      2 
   1007      1
   1009      1
*/

-- 문10) 위 3개 테이블(고객, 판매, 반품)의 관계를 ERD로 나타내시오. 

-- 네 



