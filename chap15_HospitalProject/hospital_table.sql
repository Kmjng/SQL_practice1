-- hostpital_table.sql


-- 1. 의사 테이블 
create table doctors(  
doc_id number(10) primary key,  -- 기본키 (구분자) 
major_treat varchar(25) not null, 
doc_name varchar(20) not null,
doc_gen char(1) not null,       -- M or F 
doc_phone varchar(15) not null,
doc_email varchar(20) not null,
doc_position varchar(20) not null
);

insert into DOCTORS values(980312, '소아과', '이태정', 'M', '010-333-1330', 'itj@naver.com','과정');
insert into DOCTORS values(000601, '내과', '안성기', 'M', '010-444-1440', 'ask@naver.com','과정');
insert into DOCTORS values(001208, '외과', '김민종', 'M', '010-222-1220', 'kmj@naver.com','과정');
insert into DOCTORS values(020403, '피부과', '이태서', 'M', '010-111-1110', 'lts@naver.com','전문의');
insert into DOCTORS values(050900, '소아과', '김연아', 'F', '010-555-1550', 'itj@naver.com','전문의');

select * from DOCTORS;


-- 2. 간호사 테이블 : 부모 테이블(마스터) 
create table nurses(
nur_id number(10) primary key,      -- 구분자 
major_job varchar(25) not null,
nur_name varchar(20) not null,
nur_gen char(1) not null,
nur_phone varchar(15) null,
nur_email varchar(50) unique,
nur_position varchar(20) not null       -- 직급(수간호사, 주임, 간호사) 
);

insert into nurses values(050302, '소아과', '김은영', 'F', '010-555-8751', 'kim@naver.com', '수간호사');
insert into nurses values(050021, '내과', '윤성애', 'F', '010-444-8751', 'ysa@naver.com', '수간호사');
insert into nurses values(040089, '방사선과', '신지원', 'M', '010-666-8661', 'sjw@naver.com', '주임');
insert into nurses values(100356, '피부과', '유정화', 'F', '010-333-7551', 'yjw@naver.com', '간호사');
insert into nurses values(102101, '외과', '리히나', 'F', '010-222-1234', 'nnn@naver.com', '간호사');

select * from nurses;

-- 3. 환자 테이블
create table patients(
pat_id number(10) primary key,  -- 구분자 
nur_id number(10) not null,     -- 간호사 id : 외래키 1
doc_id number(10) not null,     -- 의사 id : 외래키 2
pat_name varchar(20) not null,
pat_gen char(1) not null,
pat_jumin varchar(14) not null,
pat_addr varchar(100) not null,
pat_phone varchar(15) null,
pat_email varchar(50) unique,
pat_job varchar(20) not null,
foreign key(nur_id) references nurses(nur_id),
foreign key(doc_id) references doctors(doc_id)
);

insert into patients values(1234, 050021, 000601, '안상건', 'M', 232345, '서울', '010-555-4578', 'ask@naver.com', '회사원');
insert into patients values(3456, 100356, 020403, '김성룡', 'M', 543545, '서울', '010-333-7842', 'ksr@naver.com', '자영업');
insert into patients values(2541, 050021, 000601, '이종진', 'M', 433424, '부산', '010-222-2278', 'lss@naver.com', '회사원');
insert into patients values(4522, 102101, 001208, '이진희', 'F', 119768, '서울', '010-888-4578', 'ljh@naver.com', '교수');
insert into patients values(9785, 050302, 050900, '오나미', 'F', 987645, '서울', '010-555-4578', 'onm@naver.com', '학생');

select * from patients;

-- 4. 진료 테이블
create table treatments(
treat_id number(15) primary key,        -- 구분자 
pat_id number(10) not null,         -- 환자 id : 외래키 1 
doc_id number(10) not null,         -- 의사 id: 외래키 2
treat_contents varchar(1000) not null,      -- 진료내용 
tread_date date null,       -- 진료일 
foreign key(pat_id) references patients(pat_id),
foreign key(doc_id) references doctors(doc_id)
);

insert into treatments values(130516023, 1234, 000601, '감기,몸살', '2013-05-16');
insert into treatments values(134121420, 3456, 020403, '피부 트러블 치료', '2013-06-28');
insert into treatments values(131205056, 2541, 000601, '배탈, 설사', '2013-12-10');
insert into treatments values(131224012, 4522, 001208, '위궤양', '2014-05-10');
insert into treatments values(140109026, 9785, 050900, '중이염', '2015-03-12');

commit; -- db 반영 

SELECT * FROM USER_TABLES; 

SELECT * FROM doctors;
SELECT * FROM nurses;
SELECT * FROM doctors;
SELECT * FROM patients;
SELECT * FROM treatments;

-- 1. 담당 의사진료 정보 확인 
/*  의사 VS 진료(doc_id),  의사 VS 환자(doc_id) */

SELECT *
FROM doctors d, treatments t
WHERE d.doc_id = t.doc_id;


-- 문1) 601의사 진료 정보 조회하기
-- 조회할 칼럼 : 의사id, 진료과, 환자id, 진료내용, 진료일 
SELECT d.doc_id 의사ID, major_treat 진료과, t.pat_id 환자ID, treat_contents 진료내용, tread_date 진료일
FROM doctors d, treatments t 
WHERE d.doc_id = t.doc_id ; 

-- 문2) 진료과가 '피부과'인 진료 정보 조회하기 
-- 조회할 칼럼 : 의사id, 진료과, 환자id, 진료내용
SELECT d.doc_id 의사ID, major_treat 진료과, t.pat_id 환자ID, treat_contents 진료내용 
FROM doctors d, treatments t
WHERE d.doc_id = t.doc_id 
AND major_treat = '피부과';

-- 2. 담당 간호사의 환자 정보
SELECT *
FROM nurses n, patients p
WHERE n.nur_id = p.nur_id;


-- 문3) 50021간호사 환자 정보 조회하기
-- 조회할 칼럼 : 간호사id, 간호사명, 환자명, 환자주소  
SELECT n.nur_id 간호사id, nur_name 간호사명, pat_name 환자명, pat_addr 환자주소
FROM nurses n , patients p 
WHERE n.nur_id = p.nur_id       -- ★★★
AND
n.nur_id = 50021;

-- 문4) 50021간호사와 601의사가 함께 진료하는 환자 정보 조회하기
-- 조회할 칼럼 : 간호사id, 간호사명, 의사id,  환자명 + 의사명 ★★★
SELECT n.nur_id 간호사id, nur_name 간호사명, p.doc_id 의사id, p.pat_name 환자명 , d.doc_name 의사명
FROM nurses n, patients p , doctors d-- patients가 doc_id, nur_id 다 갖고 있음 ★★★
WHERE n.nur_id = p.nur_id AND (n.nur_id = 50021 AND p.doc_id = 601 )
AND (d.doc_id = p.doc_id);

-- 문5) '수간호사'의 환자 정보 조회하기
-- 조회할 칼럼 : 간호사id, 간호사명, 간호사 직위, 환자명, 환자전화번호
SELECT n.nur_id 간호사id, nur_name 간호사명, nur_position "간호사 직위", pat_name 환자명, pat_phone 환자전화번호
FROM nurses n, patients p 
WHERE n.nur_id = p.nur_id
AND nur_position ='수간호사';

-- 3. 진료 내용의 환자 정보 확인 
SELECT *
FROM treatments t, patients p
WHERE t.pat_id = p.pat_id;


-- 문6) 601의사가 진료한 내용과 환자정보 조회하기
-- 조회할 칼럼 : 의사id, 진료내용, 환자id, 환자명 


-- 문7) 진료일이 2013년 6월 이후 환자정보 조회하기 
-- 조회할 칼럼 : 의사id, 환자id, 진료내용, 진료일, 환자명 



-- 문8) 진료명 중에서 '몸살'이나 '트러블'의 내용이 포함된 환자만 조회하기
-- 조회할 칼럼 : 환자id, 환자명, 진료내용, 진료일  
