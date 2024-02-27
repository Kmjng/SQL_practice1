-- 부서 정보 
create or replace table dept(
dno int auto_increment primary key, -- 자동번호생성기  
dname varchar(50) not null,
loc varchar(100) 
);

insert into dept values(null,'영업부', '뉴욕시');
insert into dept values(null,'기획실', '서울시');
insert into dept values(null,'연구실', '대전시');

select * from dept;

















