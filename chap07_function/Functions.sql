/*
함수 
형식: 함수명(인수1, 인수2..)
- 특정 기능을 정의해 놓은 단위 프로그램 (라이브러리)
*/

-- 1. 숫자 처리 함수  (날짜형DATE 처리 가능)
-- 1.1. ABS 함수 
SELECT -10, ABS(-10) FROM dual; 
-- FROM dual ; - 의사테이블의 일종. ★★★ 간단하게 연산결과를 테스트할 때 사용 (dummy)

-- 1.2. FLOOR 함수 (소수점 처리. 버리고 반환) 
SELECT 35.678, FLOOR(35.678) FROM dual; 
SELECT 35.678, FLOOR(35.678, 2) FROM dual;  -- [오류] --TRUNC 함수 사용할 것
-- 1.3. ROUND 함수 (소수점 처리. 반올림 반환) 
SELECT 12.345, ROUND(12.345), ROUND(12.765) FROM dual; 
SELECT 12.345, ROUND(12.3454534, 2), ROUND(12.765) FROM dual;  -- 두번 째 자리에서 반올림
-- 1.4. TRUNC 함수 (소수점 처리. 특정 위치 제거 반환)
SELECT TRUNC(42.5425, 2) ,  TRUNC(42.5425, -1) ,TRUNC(42.5425) FROM dual; -- ★ 음수값은 정수 자리
SELECT TRUNC(42.5425) FROM dual ; -- 소숫점 전체 버림 
-- 1.5. MOD 함수 (나머지값 반환 %)
SELECT MOD(27, 2), MOD(27,3) FROM dual; 
SELECT ename, MOD(sal, 2) FROM emp; -- 급여가 홀수/짝수 인지
-- WHERE절에서 사용 가능 
-- 실습1: 전체 사원 중 사번이 홀수인 경우, 사원정보 출력 
SELECT * FROM emp WHERE MOD(empno, 2) = 1 ; -- != 0

--1.6. LOG 함수 (밑수: 2, e) - ★★★ 해당 숫자(n)의 지수가 몇인지를 반환함 
-- LOG(2, n)  
SELECT LOG(2,8) FROM dual; 
SELECT ROUND(LOG(2,8)) FROM dual ; 
-- LOG(e, n) (X) LOG(exp(1), n) (O)  
SELECT LOG(exp(1), 8) FROM dual ;
-- 1.7. exp() 함수 - 지수를 기입한다. 
SELECT exp(2.07944) FROM dual;

-- 로그함수와 지수함수 역함수 관계 
-- f(x) -> y , f^(-1)(y)= x 
-- LOG(): 로그함수(밑,지수) -> 로그값 반환 
-- exp(): 지수함수(지수값) -> 로그함수 인수 반환 


-- 1.6.2. 로그변환과 지수변환 Scailing 
-- There's x = 5, 15, 30. Let's translate to Log
SELECT LOG(exp(1),5),LOG(exp(1),15),LOG(exp(1),30) FROM dual; 
-- Let's translate to Exponential 
SELECT exp(5), exp(15), exp(30) FROM dual ;

-- 1.8. POWER 함수 
SELECT POWER(2,8) FROM dual; 

-- 1.9. SQRT

-- 삼각함수는 수업 생략 

-- 입사년도가 홀수인 사람들을 조회해라 : ★★★ DATE 자료형을 추출하기 위해 SUBSTR()함수 사용
SELECT * FROM emp WHERE MOD(SUBSTR(hiredate, 1,2),2 ) != 0;

-- 2. 문자 처리 함수 (날짜형DATE 처리 가능)
-- 2.1. UPPER 함수 (모두 대문자로 바꿈) -- ★★★ 텍스트 전처리할 때 사용
SELECT 'Welcome to Oracle' , UPPER('Welcome to Oracle') FROM dual; 

-- 2.2. LOWER 함수 (모두 소문자로 바꿔서 읽음 ) 
SELECT 'Welcome to Oracle' , LOWER('Welcome to Oracle') FROM dual; 

-- 2.3. INITCAP 함수 (단어 시작만 대문자 변경) 영어 중심 세상 (Init Capitals)
SELECT 'welcome to oracle', INITCAP('welcome to oracle') FROM dual;

-- 실습
SELECT empno, ename, job FROM emp WHERE job = 'manager'; --[못 찾음]
SELECT empno, ename, job FROM emp WHERE job = UPPER('manager'); -- 대문자로 변경 후 찾음

-- 2.4. LENGTH() - 음절의 갯수 반환
-- 2.5. LENGTHB() - 음절의 바이트 수 반환 
-- 영문은 음절당 1Byte, 한글은 음절당 2Byte 
-- ★★★ 오라클 UTF8 기준 한글자 당 3Byte 
SELECT LENGTH('oracle'), LENGTHB('oracle') FROM dual; -- 결과: 6, 6
SELECT LENGTH('오라클'), LENGTHB('오라클') FROM dual; -- 결과: 3, 9

-- 2.6. SUBSTR() - 부분 문자 추출 (~, 시작위치,추출갯수) 
-- 1부터 시작, 역순 카운트: -1부터 시작

-- 날짜형(DATE) 의 경우, 슬래쉬도 자리 포함됨
SELECT SUBSTR(hiredate,1,2) 연도, SUBSTR(hiredate,4,2) 달 FROM emp; 
SELECT SUBSTR(hiredate,-2,2) 일자 FROM emp; 

-- 실습: 9월에 입사한 사원을 출력해라 (emp테이블) 
SELECT * FROM emp WHERE SUBSTR(hiredate, 4,2) = '09' ;

-- 2.7. TRIM( FROM ) 함수 - 특정 문자열(또는 공백) 삭제
SELECT TRIM('A' FROM 'AAAaaaa') FROM dual ;
SELECT TRIM('' FROM '  asdf') FROM dual; --[이거 아님]
SELECT TRIM('   asdf   ') FROM dual; 
SELECT TRIM(' a a a a a ') FROM dual; -- 앞과 끝 공백만 삭제함

-- 2.8. REPLACE() 함수 - 특정 문자열 교체
-- REPLACE(대상, 교체할대상, 교체문구) 
SELECT REPLACE('ASDF', 'A','W') FROM dual; 

SELECT hiredate FROM emp ; -- yy/mm/dd 
SELECT REPLACE(hiredate, '/','-') FROM emp; -- yy-mm-dd

-- ★★★ 마스킹 비식별화 처리할 때 사용한다. 
-- 실습: 전체 학생 20명을 대상으로 주민번호 뒷자리 7개 마스킹 처리 해라 
SELECT * FROM student; 
SELECT REPLACE(JUMIN, SUBSTR(JUMIN,7,7), '******') FROM student; 

-- 3. 날짜함수 
/*
    이외 날짜함수
    ADD_MONTHS(): 특정 날짜에 개월 수를 더한다. 
    NEXT_DAY(): 특정날짜에서 최초로 도래하는 인자로 받은 요일의 날짜를 반환한다. ??
    LAST_DAY(): 해당 달(MONTH)의 마지막 날짜를 반환한다. 
    ROUND(), TRUNC()
*/

-- 3.1. SYSDATE 
-- 시스템 상 현재 날짜 반환, 괄호 사용 X, 현재 시각 정보도 있음(TO_CHAR()로 출력)
-- 저장형태: 2024-02-16  / DB 출력표기: 24/02/16 
SELECT SYSDATE FROM dual; 

-- 산술연산 가능 (DAY 계산) 
SELECT SYSDATE -1 FROM dual; 

--날짜 반올림 가능 (ROUND함수 사용) 
 -- ★★★ 월(MONTH): 일자(DAY)를 반올림
SELECT hiredate, ROUND(hiredate, 'MONTH') FROM emp; -- MONTH, MON, MM, RM

-- 3.2. MONTHS_BETWEEN 함수 - 날짜 사이의 개월 수
-- MONTHS_BETWEEN(최근, 과거) 
SELECT MONTHS_BETWEEN (SYSDATE, hiredate) FROM emp ; -- 소숫점까지 출력됨 
SELECT TRUNC(MONTHS_BETWEEN (SYSDATE, hiredate)) FROM emp ; --소숫점 버림 


-- 3.3. ★★★ 형 변환 함수 ★★★ 중요할 것 같다 
-- 숫자형,날짜형 -> 문자형:  TO_CHAR()  
-- 문자형 -> 숫자형: TO_NUMBER()
-- 문자형 -> 날짜형:  TO_DATE()  

-- ★ 날짜형 데이터 입력할 때: '2024-02-16' 
-- ★ SELECT으로 조회할 때는 '24/02/16'으로 출력됨. (오라클 기본 날짜 형식임) 

-- (1) TO_CHAR() 
-- 날짜 정보를 (내가 원하는 양식으로) 읽고 싶을 때 
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM dual; 
SELECT hiredate, TO_CHAR(hiredate, 'YY.MM.DD.') FROM emp; 

/*
날짜 출력의 Format 
YYYY/YY : 년도 4자리/2자리 
MM/MON: 월 2자리/문자
DD: 일자 2자리 
DAY/DY: 요일 3자리/1자리

시각 Format 
HH/HH12/HH24: 시
MI: 분 
SS: 초 
AM/A.M
PM/P.M

*/

-- 요일 확인  
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY') FROM dual; 
-- 시간 확인 
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD / HH24:MI:SS') FROM dual; 

/*
0: 자릿수를 나타내며 자릿수가 맞지 않을경우 0으로 채움 
9: 자릿수를 나타내며 자릿수가 맞지 않아도 채우지 않음
L: 각 지역별 통화 기호를 앞에 표시한다. 
.: 소수점 
,:  천 단위 자리 구분 

ex) TO_CHAR(숫자, '999,999,999') 두번째 인자 형태(문자형태)로 반환함
*/

SELECT TO_CHAR(sal, 'L999,999') FROM emp ; 

-- (2) TO_DATE() - TO_DATE(문자형/숫자형, FORMAT)

-- 날짜 자료를 DB에 저장 (인자들 끼리 양식 맞춰줘야 함)
-- INSERT 구문에서 주로 사용
-- 또는, 날짜 비교할 때 
SELECT * FROM emp WHERE hiredate =TO_DATE(19810220,'YYYYMMDD'); 

-- (3) TO_NUMBER() 함수 
-- 문자형 -> 숫자형
SELECT '20000' -'10000' FROM dual; --[가능]
SELECT '20,000' -'10,000' FROM dual; --[오류]
SELECT TO_NUMBER('20,000','99,999') - TO_NUMBER('10,000','99,999') FROM dual; --[가능]


SELECT * FROM emp WHERE SUBSTR(hiredate,4,2) = '09';
SELECT * FROM emp WHERE TO_NUMBER(SUBSTR(hiredate,4,2),'99') = 09;

-- 4. 기타 함수 
-- 4.1. NVL() - NULL 처리 함수 
-- NVL(대상, 대체값/수식) 
-- NVL2(대상, NULL이 아닌경우, NULL인 경우) 

-- 성과급을 포함한 연봉계산 (두가지 방법) 
SELECT ename, sal, comm, sal*12+NVL(comm,0) 
FROM emp;
SELECT ename, sal, comm, NVL2(comm, sal*12+comm, sal*12) 
FROM emp ; 

-- 5. DECODE() 함수 - 특정 칼럼의 값을 비교 판단하여 번역
-- (인코딩: 기계어로, 디코딩: 기계어 해독 ) 
-- 형식: DECODE(칼럼명, 값1, '내용1',값2,'내용2','나머지') --★★★ 해당 칼럼이 "범주형"일 경우 (예: 성별, 직급) 

SELECT ename, deptno, decode(deptno, 10, '기획실', 20, '연구실','기타') FROM emp ; 

SELECT DISTINCT deptno, decode(deptno, 10, '기획실', 20, '연구실','기타') FROM emp 
ORDER BY deptno ASC; 

