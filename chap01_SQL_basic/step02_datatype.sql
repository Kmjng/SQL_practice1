-- dataType.sql : Oracle 주요 자료형 

create table student(
sid int primary key,            -- 학번 
name varchar(25) not null,  -- 이름 
phone varchar(30) unique,  -- 전화번호
email char(50),                  -- 이메일 
enter_date date not null     -- 입학년도 
);


/*
 * Oracle 주요 자료형 
 *  1. number(n) : n 크기 만큼 숫자(실수) 저장 
 *  2. int : 4바이트 정수 저장 
 *  3. varchar2(n) : n 크기 만큼 가변길이 문자 저장 
 *  4. char(n) : n 크기 만큼 고정길이 문자 저장
 *  5. date : 날짜/시간 저장 - sysdate : system의 날짜/시간 저장 
 */

/*
 * 제약조건 
 *  1. primary key : 해당 칼럼을 기본키로 지정(중복불가+null불가)
 *  2. not null : null값 허용 불가 
 *  3. unique : 중복 불가(null 허용)
 */



