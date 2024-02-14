-- 1. 동물 보호소 테이블(ANIMAL_INS) 만들기 

CREATE TABLE animal_ins(
aid int primary key, -- 동물 id(구분자)
atype varchar2(20) not null, -- 동물 유형 
datetime date not null, -- 보호 시작일 
condition varchar2(30), -- 상태
name varchar2(20) -- 동물 이름 
);

-- 동물 보호소 테이블(ANIMAL_INS) 레코드 추가 
INSERT INTO animal_ins VALUES(1001, '강아지', sysdate,	'양호','푸들');
INSERT INTO animal_ins VALUES(1002, '강아지', sysdate,	'부상','진도');
INSERT INTO animal_ins VALUES(1003, '고양이', sysdate,'양호',	'러시안블루');
INSERT INTO animal_ins VALUES(1004, '강아지', sysdate,	'부상', 	'달마티안');
INSERT INTO animal_ins VALUES(1005, '고양이', sysdate,'양호', '봄베이');
INSERT INTO animal_ins VALUES(1006, '고양이', sysdate,'부상', '메이쿤');
INSERT INTO animal_ins VALUES(1007, '강아지', sysdate,	'양호', 	'차우차우');
INSERT INTO animal_ins VALUES(1008, '고양이', sysdate,'부상', '버만');
INSERT INTO animal_ins VALUES(1009, '강아지', sysdate,	'부상', 	'블록');

-- sysdate : 현재 시스템의 날짜와 시간을 입력하는 명령어 

SELECT * FROM animal_ins;

SELECT ROWNUM, aid, name FROM animal_ins;


-- [문1] 다음 조건으로 동물 입양 테이블(animal_outs) 작성하기
/*
 * 테이블명 : animal_outs
 * 칼럼명 : aid -> 자료형 : int, 제약조건 : 생략불가, 중복 불가
 * 칼럼명 : atype -> 자료형 : 고정길이 문자(10자리), 제약조건 : 생략 불가
 * 칼럼명 : datetime -> 자료형 : 날짜형, 제약조건 : 생략 불가
 * 칼럼명 : name -> 자료형 : 가변길이 문자(최대 20자리), 제약조건 : 생략 가능  
 * 외래키 : aid 칼럼 -> animal_ins의 기본키 참조 
 */

-- [문1] SQL문 작성
CREATE TABLE animal_outs(
aid INT NOT NULL UNIQUE,
atype CHAR(10) NOT NULL,
datetime DATE NOT NULL,
name VARCHAR2(20),
FOREIGN KEY(aid) REFERENCES animal_ins(aid)
);


-- animal_outs 테이블 작성 후 레코드 5개 삽입하기  
INSERT INTO animal_outs VALUES(1001, '강아지', '2020-10-03', '푸들');
INSERT INTO animal_outs VALUES(1003, '고양이', '2024-12-10','러시안블루');
INSERT INTO animal_outs VALUES(1004, '강아지', '2020-03-12', '달마티안');
INSERT INTO animal_outs VALUES(1005, '고양이', '2024-12-25', '봄베이');
INSERT INTO animal_outs VALUES(1006, '고양이', '2020-06-10', '메이쿤');

SELECT * FROM animal_outs; 
-- 입양일(datetime) : 24/12/10 확인 


/*
 [문2] 관리자의 실수로 일부 동물의 입양일이 잘못 입력되었다. 즉 동물 보호소 테이블(animal_ins)의 
   입소일(datetime)은 오늘 날짜이다. 그런데 동물 입양 테이블(animal_outs)의 입양일(datetime)이   
   입소일(datetime) 보다 더 빠른 자료가 있다. 
   이렇게 잘못 표기된 동물의 id, 이름, 입양일을 id 오름차순으로 출력하시오.
   힌트 : 다중행 서브쿼리 이용  
  <사용 테이블>
     - 동물 보호소 테이블 : animal_ins
     - 동물 입양 테이블 : animal_outs
*/ 

/*
 * <조회 결과>  
 * AID  NAME     입양일 
 * 1001 푸들     20/10/03 
 * 1004 달마티안  20/03/12
 * 1006 메이쿤   20/06/10
 */

-- [문2] SQL문 작성
SELECT aid, name, datetime 입양일 
FROM animal_outs
WHERE datetime < ALL(SELECT datetime FROM animal_ins) -- 입소일 보다 적은 입양일 
ORDER BY aid;
-- 입소일 중 최댓값(가장 최근 입소일)을 기준으로 더 적은 입양 동물 선정 


/*
 [문3] 천재지변으로 인해 일부 데이터가 유실된 동물 보호소 테이블을 아래와 같이 만드시오. 
    입양 테이블(animal_outs)에서 동물 유형이 '강아지'인 레코드만 선정하여 
    유실된 동물 보호소 테이블(animal_ins2)을 만든다.
    힌트 : SUBQUERY 방식으로 테이블 만들기  
  <사용 테이블>
     - 입양 테이블 : animal_outs
*/

-- [문3] SQL문 작성
CREATE TABLE animal_ins2
AS
SELECT * FROM animal_outs
       WHERE atype = '강아지';

SELECT * FROM animal_ins2;

/*
 [문4] 유실된 동물 보호소 테이블를 대상으로 입양을 간 기록은 있는데, 보호소에 
  입소된 기록이 없는 동물의 id와 이름을 id 오름차순으로 출력하시오.
  힌트 : 다중행 서브쿼리 이용 
  <사용 테이블> 
     - 유실된 동물 보호소 테이블 : animal_ins2
     - 동물 입양 테이블 : animal_outs
*/

/*
 * <조회결과>
 * AID   NAME     ATYPE
 * 1003  러시안블루 고양이 
 * 1005  봄베이    고양이
 * 1006  메이쿤    고양이
 */


-- [문4] SQL문 작성 
SELECT aid, name, atype
FROM animal_outs -- 입양 동물 
WHERE aid NOT IN (SELECT aid FROM animal_ins2) -- 유실된 동물 
ORDER BY aid;
-- 입양동물 5마리 중에서 유실된 동물 보호소 2마리 제외 

/*
  [문5] 아직 입양을 못 간 동물 중, 가장 오래 보호소에 있었던 동물 3마리의 이름과
  보호 시작일을 조회하는 SQL문을 작성하시오.
  힌트 : 다중행 서브쿼리 & ROWNUM 이용 
  <사용 테이블> 
     - 동물 보호소 테이블 : animal_ins
     - 동물 입양 테이블 : animal_outs
 */


/*
 * <조회결과>
 * AID   NAME   DATETIME
 * 1002  진도    23/01/31
 * 1007  차우차우 23/01/31
 * 1008  버만    23/01/31
 */

-- [문5] SQL문 작성
SELECT aid, name, datetime
FROM animal_ins -- 동물 보호소
WHERE aid NOT IN (SELECT aid FROM animal_outs); -- 입양동물 
-- 1차 : 보호소에서 입양동물 제외(IN 연산자 적용)

-- 2차 : 가장 오래 보호소에 있었던 동물 3마리(ROWNUM 적용)
SELECT aid, name, datetime
FROM animal_ins
WHERE aid NOT IN (SELECT aid FROM animal_outs)
      AND ROWNUM <= 3;
