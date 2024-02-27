DROP TABLE student;

/*
  MariaDB 주요 자료형 
  INT : 4바이트
  TINYINT : 0~255 ★★
  FLOAT (길이,소수) : 4바이트 ★★
  DOUBLE (길이,소수) : 8바이트 ★★
  CHAR(n)
  VARCHAR(n)
  DATE
*/

CREATE TABLE student( 
  studno INT primary KEY,                     -- 학번
  name VARCHAR(20) not null,
  id VARCHAR(20) not null unique,           -- NULL/중복불가 
  grade TINYINT check(grade between 1 and 6), -- 등급(1~6)
  jumin char(13) not null,          
  birthday  DATE,     -- ★★'년-월-일' 로 직접입력하면 알아서 들어감              
  tel varchar(15),
  height  INT,                
  weight  INT,                
  deptno1 INT,    -- 주전공            
  deptno2 INT,    -- 부전공            
  profno  INT     -- 지도교수            
);  

insert into student values (9411,'서진수','75true',4,'7510231901813','1975-10-23','055)381-2158',180,72,101,201,1001);
insert into student values (9412,'서재수','pooh94',4,'7502241128467','1975-02-24','051)426-1700',172,64,102,null,2001);
insert into student values (9413,'이미경','angel000',4,'7506152123648','1975-06-15','053)266-8947',168,52,103,203,3002);
insert into student values (9414,'김재수','gunmandu',4,'7512251063421','1975-12-25','02)6255-9875',177,83,201,null,4001);
insert into student values (9415,'박동호','pincle1',4,'7503031639826','1975-03-03','031)740-6388',182,70,202,null,4003);
insert into student values (9511,'김신영','bingo',3,'7601232186327','1976-01-23','055)333-6328',164,48,101,null,1002);
insert into student values (9512,'신은경','jjang1',3,'7604122298371','1976-04-12','051)418-9627',161,42,102,201,2002);
insert into student values (9513,'오나라','nara5',3,'7609112118379','1976-09-11','051)724-9618',177,55,202,null,4003);
insert into student values (9514,'구유미','guyume',3,'7601202378641','1976-01-20','055)296-3784',160,58,301,101,4007);
insert into student values (9515,'임세현','shyun1',3,'7610122196482','1976-10-12','02)312-9838',171,54,201,null,4001);
insert into student values (9611,'일지매','onejimae',2,'7711291186223','1977-11-29','02)6788-4861',182,72,101,null,1002);
insert into student values (9612,'김진욱','samjang7',2,'7704021358674','1977-04-02','055)488-2998',171,70,102,null,2001);
insert into student values (9613,'안광훈','nonnon1',2,'7709131276431','1977-09-13','053)736-4981',175,82,201,null,4002);
insert into student values (9614,'김문호','munho',2,'7702261196365','1977-02-26','02)6175-3945',166,51,201,null,4003);
insert into student values (9615,'노정호','star123',2,'7712141254963','1977-12-14','051)785-6984',184,62,301,null,4007);
insert into student values (9711,'이윤나','prettygirl',1,'7808192157498','1978-08-19','055)278-3649',162,48,101,null,null);
insert into student values (9712,'안은수','silverwt',1,'7801051776346','1978-01-05','02)381-5440',175,63,201,null,null);
insert into student values (9713,'인영민','youngmin',1,'7808091786954','1978-08-09','031)345-5677',173,69,201,null,null);
insert into student values (9714,'김주현','kimjh',1,'7803241981987','1978-03-24','055)423-9870',179,81,102,null,null);
insert into student values (9715,'허우','wooya2702',1,'7802232116784','1978-02-23','02)6122-2345',163,51,103,null,null);

select * from student; -- 레코드 20개

COMMIT;
