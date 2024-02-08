/* 연결된 테이블도 모두 제거할 경우 */
drop table DEPT cascade constraint;  
-- cascade constraint : 조인 테이블 강제 삭제 옵션 

-- 1. 부서 테이블 
create table DEPT(
deptno int           -- 부서번호
,dname varchar(14)   -- 부서명
,loc varchar(13)     -- 지역
,primary key(deptno) 
);

select * from DEPT;

insert into dept(deptno, dname,loc) values(10,'ACCOUNTING','NEW YORK');
insert into dept(deptno, dname,loc) values(20,'RESEARCH','DALLAS');
insert into dept(deptno, dname,loc) values(30,'SALES','CHICAGO');
insert into dept(deptno, dname,loc) values(40,'OPERATIONS','BOSTON');

drop table dept01;

create table dept01
as
select * from dept;


drop table EMP cascade constraint;

-- 2. 사원 테이블 
create table EMP(
    empno int primary key, -- 사번
    ename    VARCHAR(20),  -- 이름
    job      VARCHAR(20),  -- 직책(담당업무) 
    mgr      INT,          -- 직속상관
    hiredate DATE,         -- 입사일
    sal      INT,          -- 급여
    comm     INT,          -- 상여금
    deptno   INT           -- 부서번호
);

insert into emp(empno,ename,job,mgr,hiredate,sal,deptno) values(7369,'SMITH','CLERK',7902,TO_DATE('19801217','YYMMDD'),800,20);
insert into emp(empno,ename,job,mgr,hiredate,sal,comm,deptno) values(7499,'ALLEN','SALESMAN',7698,TO_DATE('19810220','YYMMDD'),1600,300,30);
insert into emp(empno,ename,job,mgr,hiredate,sal,comm,deptno) values(7521,'WARD','SALESMAN',7698,TO_DATE('19810222','YYYYMMDD'),1250,500,30);
insert into emp(empno,ename,job,mgr,hiredate,sal,deptno) values(7566,'JONES','MANAGER',7839,TO_DATE('19810402','YYYYMMDD'),2975,20);
insert into emp(empno,ename,job,mgr,hiredate,sal,comm,deptno) values(7654,'MARTIN','SALESMAN',7698,TO_DATE('19810928','YYYYMMDD'),1250,1400,30);
insert into emp(empno,ename,job,mgr,hiredate,sal,deptno) values(7698,'BLAKE','MANAGER',7839,TO_DATE('19810501','YYYYMMDD'),2850,30);
insert into emp(empno,ename,job,mgr,hiredate,sal,deptno) values(7782,'CLARK','MANAGER',7839,TO_DATE('19810609','YYYYMMDD'),2450,10);
insert into emp(empno,ename,job,mgr,hiredate,sal,deptno) values(7788,'SCOTT','ANALYST',7566,TO_DATE('19870419','YYYYMMDD'),3000,20);
insert into emp(empno,ename,job,hiredate,sal,deptno) values(7839,'KING','PRESIDENT',TO_DATE('19811117','YYYYMMDD'),5000,10);
insert into emp(empno,ename,job,mgr,hiredate,sal,comm,deptno) values(7844,'TURNER','SALESMAN',7698,TO_DATE('19810908','YYYYMMDD'),1500,0,30);
insert into emp(empno,ename,job,mgr,hiredate,sal,deptno) values(7876,'ADAMS','CLERK',7788,TO_DATE('19870523','YYYYMMDD'),1100,20);
insert into emp(empno,ename,job,mgr,hiredate,sal,deptno) values(7900,'JAMES','CLERK',7698,TO_DATE('19811203','YYYYMMDD'),950,30);
insert into emp(empno,ename,job,mgr,hiredate,sal,deptno) values(7902,'FORD','ANALYST',7566,TO_DATE('19811203','YYYYMMDD'),3000,20);
insert into emp(empno,ename,job,mgr,hiredate,sal,deptno) values(7934,'MILLER','CLERK',7782,TO_DATE('19820123','YYYYMMDD'),1300,10);

select * from emp; -- 레코드 전체 조회(14개)


drop table emp01;

create table emp01
as
select * from emp;


drop table professor ;

-- 3. 교수 테이블 
create table professor(
 profno number(4) primary key,    -- 교수번호(기본키)
 name  varchar2(10) not null, 
 id  varchar2(15) not null,
 position varchar2 (15) not null, -- 직위(전임강사,조/부/정교수) 
 pay number(3) not null,
 hiredate  date not null,       
 bonus number(4) ,             
 deptno  number(3),               -- 학과번호          
 email  varchar2(50),
 hpage  varchar2(50)              -- 홈페이지 주소          
);

insert into professor values(1001,'조인형','captain','정교수',550,to_date('1980-06-23','YYYY-MM-DD'),100,101,'captain@abc.net','http://www.abc.net');
insert into professor values(1002,'박승곤','sweety','조교수',380,to_date('1987-01-30','YYYY-MM-DD'),60,101,'sweety@abc.net','http://www.abc.net');
insert into professor values (1003,'송도권','powerman','전임강사',270,to_date('1998-03-22','YYYY-MM-DD'),null,101,'pman@power.com','http://www.power.com');
insert into professor values (2001,'양선희','lamb1','전임강사',250,to_date('2001-09-01','YYYY-MM-DD'),null,102,'lamb1@hamail.net',null);
insert into professor values (2002,'김영조','number1','조교수',350,to_date('1985-11-30','YYYY-MM-DD'),80,102,'number1@naver.com','http://num1.naver.com');
insert into professor values (2003,'주승재','bluedragon','정교수',490,to_date('1982-04-29','YYYY-MM-DD'),90,102,'bdragon@naver.com',null);
insert into professor values (3001,'김도형','angel1004','정교수',530,to_date('1981-10-23','YYYY-MM-DD'),110,103,'angel1004@hanmir.com',null);
insert into professor values (3002,'나한열','naone10','조교수',330,to_date('1997-07-01','YYYY-MM-DD'),50,103,'naone10@empal.com',null);
insert into professor values (3003,'김현정','only-u','전임강사',290,to_date('2002-02-24','YYYY-MM-DD'),null,103,'only_u@abc.com',null);
insert into professor values (4001,'심슨','simson','정교수',570,to_date('1981-10-23','YYYY-MM-DD'),130,201,'chebin@daum.net',null);
insert into professor values (4002,'최슬기','gogogo','조교수',330,to_date('2009-08-30','YYYY-MM-DD'),null,201,'gogogo@def.com',null);
insert into professor values (4003,'박원범','mypride','조교수',310,to_date('1999-12-01','YYYY-MM-DD'),50,202,'mypride@hanmail.net',null);
insert into professor values (4004,'차범철','ironman','전임강사',260,to_date('2009-01-28','YYYY-MM-DD'),null,202,'ironman@naver.com',null);
insert into professor values (4005,'바비','standkang','정교수',500,to_date('1985-09-18','YYYY-MM-DD'),80,203,'standkang@naver.com',null);
insert into professor values (4006,'전민','napeople','전임강사',220,to_date('2010-06-28','YYYY-MM-DD'),null,301,'napeople@jass.com',null);
insert into professor values (4007,'허은','silver-her','조교수',290,to_date('2001-05-23','YYYY-MM-DD'),30,301,'silver-her@daum.net',null);

select * from professor; -- 16개 레코드

drop table student purge; -- 테이블 제거(임시파일 삭제)

-- 4. 학생 테이블 
create table student( 
  studno number(4) primary key,              -- 학번
  name   varchar2(10) not null,
  id varchar2(20) not null unique,           -- NULL/중복불가 
  grade number check(grade between 1 and 6), -- 등급(1~6)
  jumin char(13) not null,          
  birthday  date,                   
  tel varchar2(15),
  height  number(4),                
  weight  number(3),                
  deptno1 number(3),    -- 주전공            
  deptno2 number(3),    -- 부전공            
  profno  number(4)     -- 지도교수            
);  

insert into student values (9411,'서진수','75true',4,'7510231901813',to_date('1975-10-23','YYYY-MM-DD'),'055)381-2158',180,72,101,201,1001);
insert into student values (9412,'서재수','pooh94',4,'7502241128467',to_date('1975-02-24','YYYY-MM-DD'),'051)426-1700',172,64,102,null,2001);
insert into student values (9413,'이미경','angel000',4,'7506152123648',to_date('1975-06-15','YYYY-MM-DD'),'053)266-8947',168,52,103,203,3002);
insert into student values (9414,'김재수','gunmandu',4,'7512251063421',to_date('1975-12-25','YYYY-MM-DD'),'02)6255-9875',177,83,201,null,4001);
insert into student values (9415,'박동호','pincle1',4,'7503031639826',to_date('1975-03-03','YYYY-MM-DD'),'031)740-6388',182,70,202,null,4003);
insert into student values (9511,'김신영','bingo',3,'7601232186327',to_date('1976-01-23','YYYY-MM-DD'),'055)333-6328',164,48,101,null,1002);
insert into student values (9512,'신은경','jjang1',3,'7604122298371',to_date('1976-04-12','YYYY-MM-DD'),'051)418-9627',161,42,102,201,2002);
insert into student values (9513,'오나라','nara5',3,'7609112118379',to_date('1976-09-11','YYYY-MM-DD'),'051)724-9618',177,55,202,null,4003);
insert into student values (9514,'구유미','guyume',3,'7601202378641',to_date('1976-01-20','YYYY-MM-DD'),'055)296-3784',160,58,301,101,4007);
insert into student values (9515,'임세현','shyun1',3,'7610122196482',to_date('1976-10-12','YYYY-MM-DD'),'02)312-9838',171,54,201,null,4001);
insert into student values (9611,'일지매','onejimae',2,'7711291186223',to_date('1977-11-29','YYYY-MM-DD'),'02)6788-4861',182,72,101,null,1002);
insert into student values (9612,'김진욱','samjang7',2,'7704021358674',to_date('1977-04-02','YYYY-MM-DD'),'055)488-2998',171,70,102,null,2001);
insert into student values (9613,'안광훈','nonnon1',2,'7709131276431',to_date('1977-09-13','YYYY-MM-DD'),'053)736-4981',175,82,201,null,4002);
insert into student values (9614,'김문호','munho',2,'7702261196365',to_date('1977-02-26','YYYY-MM-DD'),'02)6175-3945',166,51,201,null,4003);
insert into student values (9615,'노정호','star123',2,'7712141254963',to_date('1977-12-14','YYYY-MM-DD'),'051)785-6984',184,62,301,null,4007);
insert into student values (9711,'이윤나','prettygirl',1,'7808192157498',to_date('1978-08-19','YYYY-MM-DD'),'055)278-3649',162,48,101,null,null);
insert into student values (9712,'안은수','silverwt',1,'7801051776346',to_date('1978-01-05','YYYY-MM-DD'),'02)381-5440',175,63,201,null,null);
insert into student values (9713,'인영민','youngmin',1,'7808091786954',to_date('1978-08-09','YYYY-MM-DD'),'031)345-5677',173,69,201,null,null);
insert into student values (9714,'김주현','kimjh',1,'7803241981987',to_date('1978-03-24','YYYY-MM-DD'),'055)423-9870',179,81,102,null,null);
insert into student values (9715,'허우','wooya2702',1,'7802232116784',to_date('1978-02-23','YYYY-MM-DD'),'02)6122-2345',163,51,103,null,null);

select * from student; -- 레코드 20개

-- 5. 학과 테이블 
create table department( 
deptno number(3) primary key , 
  dname varchar2(30) not null,   
  part number(3),                 
  build  varchar2(20)           -- 건물명          
);

insert into department values (101,'컴퓨터공학과',100,'정보관');
insert into department values (102,'멀티미디어공학과',100,'멀티미디어관');
insert into department values (103,'소프트웨어공학과',100,'소프트웨어관');
insert into department values (201,'전자공학과',200,'전자제어관');
insert into department values (202,'기계공학과',200,'기계실험관');
insert into department values (203,'화학공학과',200,'화학실습관');
insert into department values (301,'문헌정보학과',300,'인문관');
insert into department values (100,'컴퓨터정보학부',10,null);
insert into department values (200,'메카트로닉스학부',10,null);
insert into department values (300,'인문사회학부',20,null);
insert into department values (10,'공과대학',null,null);
insert into department values (20,'인문대학',null,null);

select * from department; -- 레코드 12개

-- 6. 장바구니 테이블
create table CART_PRODUCTS(
CART_ID	INT, 
NAME	VARCHAR(20),
PRICE	INT
);

insert into CART_PRODUCTS values(1001, '우유', 2500);
insert into CART_PRODUCTS values(1002, '빵', 1500);
insert into CART_PRODUCTS values(1001, '빵', 1500);
insert into CART_PRODUCTS values(1003, '우유', 2500);
insert into CART_PRODUCTS values(1001, '빵', 1500);
insert into CART_PRODUCTS values(1002, '과자', 1500);
insert into CART_PRODUCTS values(1003, '빵', 1500);


-- 7. 선물 테이블
create table gift( 
  gno  number,           -- 상품번호
  gname varchar2(20) ,   -- 상품명
  g_start  number ,      -- 시작 번호
  g_end  number          -- 끝 번호 
);


insert into gift values(1,'참치세트',1,100000);
insert into gift values(2,'샴푸세트',100001,200000);
insert into gift values(3,'세차용품세트',200001,300000);
insert into gift values(4,'주방용품세트',300001,400000);
insert into gift values(5,'산악용자전거',400001,500000);
insert into gift values(6,'LCD모니터',500001,600000);
insert into gift values(7,'노트북',600001,700000);
insert into gift values(8,'벽걸이TV',700001,800000);
insert into gift values(9,'드럼세탁기',800001,900000);
insert into gift values(10,'양쪽문냉장고',900001,1000000);

select * from gift; -- 레코드 10개
SELECT * FROM tab; 

-- DB 반영
commit work;

-- table 목록 조회
select * from tab;

