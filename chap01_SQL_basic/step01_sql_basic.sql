-- 주석입니다.
SELECT * FROM test_table;

/*
  SQL(Structured Query Language) : 구조화된 질의 언어 
  - DDL, DML, DCL
  1. DDL : 데이터 정의어 -> DBA, USER(TABLE 생성, 구조변경, 삭제)
  2. DML : 데이터 조작어 -> USER(SELECT, INSERT, DELETE, UPDATE)
  3. DCL : 데이터 제어어 -> DBA(권한설정, 사용자 등록 등) 
*/



-- 1. DDL : 데이터 정의어

-- 1) Table 생성 
/*
 * create table 테이블명(
 *   칼럼명 데이터형 [제약조건],
 *   칼럼명 데이터형
 *   );
 */
create table test2(
id varchar2(20) primary key, -- 키 설정
pwd varchar2(50) not null, -- pwd는 필수입력이다~
name varchar2(25) not null -- name도 필수입력이다~ 
);

-- 2) Table 구조 변경 
-- (1) 테이블 이름 변경 
-- 형식) alter table 구테이블명 rename to 새테이블명;
ALTER TABLE test2 RENAME TO member;
SELECT * FROM tab; -- tab(의사테이블): 사용자가 만든 모든 명령문들을 보겠다.

-- (2) 테이블 칼럼 추가 
-- 형식) alter table 테이블명 add (칼럼명 자료형(n));

ALTER TABLE member ADD(reg_date date);  --date타입 자료형 

DESC member; --테이블 구조 확인 (이 명령어는 드래그해야 실행됨) 

--(3) 테이블 칼럼 수정 : ★★★ 이름변경X(테이블 컬럼명은 수정할 수 없음) , type(O), 제약조건(O) 수정 
-- 형식) alter table 테이블명 modify (칼럼명 자료형(n) 제약조건); 
ALTER TABLE member MODIFY (pwd varchar2(25));

DESC member;
-- (4) 테이블 칼럼 삭제 (칼럼 이름변경이 안되기 때문에 삭제후 다시만들던가 해야함)
-- 형식) alter table 테이블명 drop column  칼럼명;
ALTER TABLE member DROP COLUMN pwd;
DESC member;

-- 3) Table 제거 
-- 형식) drop table 테이블명 purge;
-- purge 속성 : 임시파일 까지 제거해버림.
DROP TABLE member; --임시파일이 제공됨.
SELECT * FROM tab; --전체테이블 목록 확인.

PURGE RECYCLEBIN; --임시파일 제거 명령문.
SELECT * FROM tab;

SELECT * FROM tab;


-- 2. DML : 데이터 조작어

CREATE TABLE depart( --depart는 식별자임. 데이터 조작어 실습에 앞서 테이블 생성한다.
dno number(4),
dname varchar(50),
daddress varchar(100)
);

-- 1) insert : 레코드 삽입 -- 테이블 칼럼 갯수와 value 갯수는 일치하여야 함.
-- 형식) insert into 테이블명(칼럼명1, .. 칼럼명n) values(값1, ... 값n);
INSERT INTO depart(dno, dname, daddress) values(1001,'영업부','서울시');
--전체 컬럼에 값 입력 시, 컬럼명은 생략 가능하다. 
INSERT INTO depart values(1002,'영업부','싱가포르');
INSERT INTO depart(dno, dname) values(1003,'총무부'); --컬럼 생략시, (null) 공백

SELECT * FROM depart; --asterisk는 모든 컬럼을 지칭한다. 
-- 2) select : 레코드 검색 
-- 형식) select 칼럼명 from 테이블명 [where 조건식];

SELECT dno, daddress FROM depart; --부분 칼럼만 조회한다. 
SELECT * FROM depart WHERE daddress is NULL; --조건 걸어서 조회한다. 
SELECT * FROM depart WHERE dname = '영업부';

-- 3) update : 레코드 수정 / ★★★주의: where절을 사용해서 특정 칼럼만 바꾸자!!!★★★
-- 형식) update 테이블명 set 칼럼명 = 값 where 조건식;
UPDATE depart SET daddress = '대전시' WHERE dno = 1003;

SELECT * FROM depart;
-- 4) delete : 레코드 삭제  ★★★주의: where절을 사용해서 특정 칼럼만 바꾸자!!!★★★
-- 형식) delete from 테이블명 where 조건식;
DELETE FROM depart WHERE dno = 1003;

--DB에 반영하기 위해서 커밋한다. 
COMMIT;
-- ★DDL은 자동 커밋을 수행하지만, DML은 수동으로 커밋(반영)해야 함.★
-- 수동 커밋 전에는 복원(ROLLBACK)이 가능하다. 


-- 3. DCL : 데이터 제어어
-- 1) 권한 설정(부여) : grant 권한, ... to user;
-- 2) 권한 해제 : revoke 권한, ... to user;
/*
관리자모드 명령문
CREATE USER c##kmj identified by tiger; --일반사용자 만들기 
GRANT CONNECT, RESOURCE, DBA TO c##kmj; --권한 부여
SHOW USER
CONN c##kmj/tiger; --일반 사용자 로그인 
SHOW USER --현재 DB 접속자 확인

*/


