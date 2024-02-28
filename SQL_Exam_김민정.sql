-- 문제해결 개별과제 (기한: 2024-02-29) 
/*
테이블 1 : 교수테이블 (교수번호 profno / 교수이름 pname/ 연구실번호 lab_no / 전공과목 major ) 
테이블 2: 대학원생테이블 (학번 gno / 이름 gname / 지도교수번호 profno / 과정 degree )
테이블 3 : 학생테이블 (학번 sno / 이름 sname / 수강과목번호 no  / 재적상태 status  )
테이블 4 : 과목테이블 (과목번호 no / 교수번호 profno / 과목명 subject / 수강학년 grade / 학점 score / 강의실번호 off_no  )

<< 최종 쿼리문 >>
개설된 과목에 대한 교수, 조교명과 수강생수, 개설여부(개설/폐강) 출력하기 

*/

/*
삭제 
DROP TABLE prof   CASCADE CONSTRAINTS;
DROP TABLE grad PURGE ;
DROP TABLE std PURGE ;
DROP TABLE sub PURGE ;
DROP SEQUENCE sub_seq  ;
*/

-- 테이블 생성 
CREATE TABLE prof (
profno NUMBER(4) PRIMARY KEY , -- ★ 기본키 : 교수 번호 
pname VARCHAR2(10) NOT NULL,        -- 교수명
lab_no NUMBER(4) ,          -- 연구실번호
major VARCHAR2(50)            -- 전공과목명
);

CREATE TABLE grad(
gno NUMBER(7)    PRIMARY KEY ,  -- ★ 기본키 : 학번
gname VARCHAR(10) NOT NULL,          -- 학생명
profno  NUMBER(4)  NOT NULL , -- 교수번호 (외래키) 
degree VARCHAR(15) ,         -- 과정
FOREIGN KEY(profno) REFERENCES prof(profno) --외래키 지정 
);

CREATE TABLE sub(
no NUMBER(4) PRIMARY KEY ,   -- ★기본키 : 과목번호
profno NUMBER(4), --  교수번호 (외래키) 
subject VARCHAR2(50)  ,      -- 과목명
grade VARCHAR(10) NOT NULL,       -- 수강학년
score NUMBER(1) NOT NULL,       -- 학점
off_no VARCHAR(5)  ,        -- 강의실번호
FOREIGN KEY(profno) REFERENCES prof(profno) -- 외래키 지정
);

CREATE TABLE std(
sno NUMBER(7)    PRIMARY KEY ,  -- ★ 기본키 : 학번
sname VARCHAR(10) NOT NULL,          -- 학생명
no  NUMBER(4)  , -- 과목번호 (외래키, 휴학생은 null 가능해야 함) 
status VARCHAR(15) ,         -- 재적상태
FOREIGN KEY(no) REFERENCES sub(no) --외래키 지정 
);


-- 시퀀스 (과목번호) : 개설 과목에 할당된다. 
CREATE SEQUENCE sub_seq 
START WITH 5000
INCREMENT BY 1 ;

-- 교수 테이블 레코드 삽입 
INSERT INTO prof VALUES(1001, '정현종',301, '전산물리학') ;
INSERT INTO prof VALUES(1002, '장성호',302, '양자 소재 및 소자') ;
INSERT INTO prof VALUES(1003, '송정현',303, '입자물리학') ;
INSERT INTO prof VALUES(1004, '여준현',304, '열 및 통계물리학') ;
INSERT INTO prof VALUES(1005, '이훈경',305, '양자물리학') ;

-- 대학원생 테이블 레코드 삽입
INSERT INTO grad VALUES(2023011, '김민땡',1001, '석사과정') ; 
INSERT INTO grad VALUES(2023021, '박창연',1002, '석사과정') ; 
INSERT INTO grad VALUES(2023024, '이화용',1002, '석사과정') ; 
INSERT INTO grad VALUES(2022022, '신동호',1002, '박사과정') ; 
INSERT INTO grad VALUES(2023023, '이창회',1002, '석사과정') ; 
INSERT INTO grad VALUES(2021031, '김주희',1005, '박사과정') ; 

-- 교과목 테이블 레코드 삽입
INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1005, '양자물리학','3학년', 3, '401-1' ) ; 
INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1003, '입자물리학','3학년', 3, '402' ) ; 
INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1004, '열 및 통계물리학','4학년', 3, '403' ) ; 
INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1002, '양자 소재 및 소자','4학년', 3, '404' ) ; 
INSERT INTO sub VALUES(sub_seq.NEXTVAL, 1001, '전산물리학','3학년', 3, '505' ) ; 

-- 학생 테이블 레코드 삽입
INSERT INTO std VALUES(2022911, '황성웅',5001, '재학생') ; 
INSERT INTO std VALUES(2021912, '최지혜',5001, '재학생') ; 
INSERT INTO std VALUES(2021913, '유현종',5002, '재학생') ; 
INSERT INTO std VALUES(2022914, '구광림',5004, '재학생') ; 
INSERT INTO std VALUES(2021915, '김대원',5004, '재학생') ; 
INSERT INTO std VALUES(2021916, '김민정',NULL, '휴학생') ; 





-- 테이블 확인 
SELECT * FROM prof ; 
SELECT * FROM grad ;
SELECT * FROM sub ; 
SELECT * FROM std ; 

-- 개설된 과목에 대한 교수, 조교명과 수강생수 출력하기 
-- 단, 조교는 담당교수 랩실의 학생이 맡는다. 
-- 개설된 과목에 담당교수는 지정되어 있으나, 연구실 내 학생이 없을 경우 조교가 배정되지 않는다. 
-- 연구실 내 학생이 많을 경우 [학번 끝자리가 1]인 학생으로 조교가 배정된다. 
-- 수강생이 없을 경우 폐강이다. 

SELECT sub.no 과목번호, sub.subject 과목명, grade 수강학년, score 학점, prof.pname 담당교수명, ass.gname 조교명,COUNT(std.sno) 수강생수 ,
CASE 
WHEN COUNT(std.sno) = 0 THEN '폐강'
ELSE '개설됨'
END 개설여부 
FROM sub LEFT OUTER JOIN prof        -- 과목테이블과 교수테이블 조인 
ON sub.profno = prof.profno LEFT OUTER JOIN (SELECT *
FROM grad 
WHERE gno LIKE '%1') ass      -- 교수테이블과 학생(조교)테이블 조인 
ON prof.profno = ass.profno LEFT OUTER JOIN std
ON sub.no = std.no 
GROUP BY sub.no , sub.subject, grade, score, prof.pname, ass.gname
ORDER BY sub.no
;
COMMIT;
