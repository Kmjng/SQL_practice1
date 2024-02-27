-- 문제해결 개별과제 (기한: 2024-02-29) 
/*
테이블 1 : 교수테이블 (연구실 번호 lab_no/ 교수번호profno/ 이름 prof_name / 전공과목 major_s ) 
테이블 2: 학생테이블 (학번 no/ 학년(SYSDATE - SUBSTR(no,1,4) )/, 이름 name, 연구실번호 lab_no, 수강과목들 subject - 학점 scores , 과정 degree )
테이블 3: 과목테이블 (교과목명 , 수강학년 grade, 학점score,  강의실off_no, 수강인원 count(~~)  )
테이블 4: 연구실정보 (연구실번호 office_no/ 교수번호  profno / 연구실이름 lab_name / 학생테이블 연결 / 


*/
-- 대학원생(재학생)이 선호하는 과목 찾기 
-- 초기화 
DROP TABLE prof purge; 
DROP TABLE stud purge; 
DROP TABLE sub purge; 
DROP SEQUENCE sub_seq ; 

-- 테이블 확인 
SELECT * FROM prof ; 
SELECT * FROM stud ; 
SELECT * FROM sub ; 

-- 테이블 생성 
CREATE TABLE prof (
profno NUMBER(4) PRIMARY KEY , -- ★ 기본키 : 교수 번호 
prof_name VARCHAR2(10) NOT NULL,        -- 교수명
lab_no NUMBER(4) ,          -- 연구실번호
major_s VARCHAR2(50)            -- 전공과목명

);

CREATE TABLE stud(
no NUMBER(7)    PRIMARY KEY ,  -- ★ 기본키 : 학번
name VARCHAR(10) NOT NULL,          -- 학생명
profno  NUMBER(4)  NOT NULL , -- 교수번호 (외래키) 
subject VARCHAR2(50) ,          -- 수강과목
scores NUMBER(3),   -- 학점
degree VARCHAR(15) ,         -- 과정
FOREIGN KEY(profno) REFERENCES prof(profno) --외래키 1 지정 (교수번호) 

);

CREATE TABLE sub(
sno NUMBER(4) PRIMARY KEY ,   -- ★기본키 : 과목번호
profno NUMBER(4), --  교수번호 (외래키) 
subject VARCHAR2(50)  ,      -- 과목명
grade NUMBER(1) NOT NULL,       -- 수강학년
score NUMBER(1) NOT NULL,       -- 학점
off_no VARCHAR(5)  ,        -- 강의실번호
FOREIGN KEY(profno) REFERENCES prof(profno) -- 외래키 지정 : 교수번호
);

-- 시퀀스 (과목번호) 
CREATE SEQUENCE sub_seq 
START WITH 5000
INCREMENT BY 1 ;


-- 레코드 삽입 
INSERT INTO prof VALUES(1001, '정현종',301, '배리스터 소자 및 물리학') ;
INSERT INTO prof VALUES(1002, '장성호',302, '양자 소재 및 소자') ;
INSERT INTO prof VALUES(1003, '송정현',303, '입자물리학') ;
INSERT INTO prof VALUES(1004, '여준현',304, '열 및 통계물리학') ;
INSERT INTO prof VALUES(1005, '이훈경',305, '양자물리학') ;

INSERT INTO stud VALUES(2021001, '김민정',1001, '입자물리학', 3, '석사과정') ; 
INSERT INTO stud VALUES(2021002, '박창연',1002, '열 및 통계물리학', 2.5, '석사과정') ; 
INSERT INTO stud VALUES(2024003, '이화용',1002, '양자물리학', 2, '석사과정') ; 
INSERT INTO stud VALUES(2022003, '신동호',1002, '입자물리학', 3, '박사과정') ; 
INSERT INTO stud VALUES(2023001, '이창회',1002, '배리스터 소자 및 물리학', 3, '석사과정') ; 
INSERT INTO stud VALUES(2021003, '김주희',1005, '입자물리학', 3, '박사과정') ; 

INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1005, '양자물리학',1, 3, '401-1' ) ; 
INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1003, '입자물리학',2, 3, '402' ) ; 
INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1004, '열 및 통계물리학',1, 3, '403' ) ; 
INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1002, '양자 소재 및 소자',1, 3, '404' ) ; 
INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1001, '배리스터 소자 및 물리학',2, 3, '505' ) ; 



-- 테이블 확인 
SELECT * FROM prof ; 
SELECT * FROM stud ; 
SELECT * FROM sub ; 


-- 개설된 과목에 대한 교수정보와 조교정보 출력하기 
-- 단, 조교는 담당교수 랩실의 학생이 맡는다. 
-- 개설된 과목에 담당교수는 지정되어 있으나, 연구실 내 학생이 없을 경우 조교가 배정되지 않는다. 
-- 연구실 내 학생이 많을 경우 박사과정 학생으로 조교가 배정된다. 
SELECT DISTINCT (sno) 과목번호, sub.subject 과목명,  prof.prof_name 담당교수명, stud.name 조교명
FROM sub LEFT OUTER JOIN prof        -- 과목테이블과 교수테이블 조인 
ON sub.profno = prof.profno LEFT OUTER JOIN stud     -- 교수테이블과 학생테이블 조인 
ON prof.profno = stud.profno 
ORDER BY sno
;

-- 학생들에 들어간 순서 넘버링 해서 넘버 1인 학생이 조교하도록 하기 
