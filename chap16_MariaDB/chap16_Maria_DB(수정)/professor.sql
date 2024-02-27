-- 교수 테이블 
create table professor(
 profno INT primary key,    -- 교수번호(기본키)
 name  varchar(10) not null, 
 id  varchar(15) not null,
 position varchar (15) not null, -- 직위(전임강사,조/부/정교수) 
 pay INT not null,
 hiredate  date not null,       
 bonus INT ,             
 deptno  INT,               -- 학과번호          
 email  varchar(50),
 hpage  varchar(50)              -- 홈페이지 주소          
);

insert into professor values(1001,'조인형','captain','정교수',550,'1980-06-23',100,101,'captain@abc.net','http://www.abc.net');
insert into professor values(1002,'박승곤','sweety','조교수',380,'1987-01-30',60,101,'sweety@abc.net','http://www.abc.net');
insert into professor values (1003,'송도권','powerman','전임강사',270,'1998-03-22',null,101,'pman@power.com','http://www.power.com');
insert into professor values (2001,'양선희','lamb1','전임강사',250,'2001-09-01',null,102,'lamb1@hamail.net',null);
insert into professor values (2002,'김영조','number1','조교수',350,'1985-11-30',80,102,'number1@naver.com','http://num1.naver.com');
insert into professor values (2003,'주승재','bluedragon','정교수',490,'1982-04-29',90,102,'bdragon@naver.com',null);
insert into professor values (3001,'김도형','angel1004','정교수',530,'1981-10-23',110,103,'angel1004@hanmir.com',null);
insert into professor values (3002,'나한열','naone10','조교수',330,'1997-07-01',50,103,'naone10@empal.com',null);
insert into professor values (3003,'김현정','only-u','전임강사',290,'2002-02-24',null,103,'only_u@abc.com',null);
insert into professor values (4001,'심슨','simson','정교수',570,'1981-10-23',130,201,'chebin@daum.net',null);
insert into professor values (4002,'최슬기','gogogo','조교수',330,'2009-08-30',null,201,'gogogo@def.com',null);
insert into professor values (4003,'박원범','mypride','조교수',310,'1999-12-01',50,202,'mypride@hanmail.net',null);
insert into professor values (4004,'차범철','ironman','전임강사',260,'2009-01-28',null,202,'ironman@naver.com',null);
insert into professor values (4005,'바비','standkang','정교수',500,'1985-09-18',80,203,'standkang@naver.com',null);
insert into professor values (4006,'전민','napeople','전임강사',220,'2010-06-28',null,301,'napeople@jass.com',null);
insert into professor values (4007,'허은','silver-her','조교수',290,'2001-05-23',30,301,'silver-her@daum.net',null);

select * from professor; -- 16개 레코드

commit;

-- function
select count(*) from professor; -- 16
select count(bonus) from professor; -- 10
select sum(pay), avg(bonus) from professor;


-- 직급별 급여 평균  
select position, avg(pay) 
from professor 
group by position;

-- 학과별 급여, 보너서 평균 
select deptno, avg(pay), avg(bonus) , COUNT(*)
from professor 
group by deptno
HAVING COUNT(*) > 1 
;

