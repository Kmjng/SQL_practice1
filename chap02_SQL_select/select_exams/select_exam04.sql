-- <종합문제>

-- [문1] emp에서 30번 부서에 근무하는 사원의 이름, 급여, 사번 출력하기 
-- 사용 칼럼명 : 이름(ename),급여(sal),사번(empno) 출력하기
SELECT ename,sal, empno FROM emp 
WHERE deptno = 30 ;

-- [문2] student 테이블의 전체 학생들을 대상으로 다음 예)와 같이 출력하기 
-- 예) 홍길동의 키는 175cm, 몸무게는 65kg입니다.
-- 사용 컬럼명 : 키(height), 몸무게(weight)
SELECT '홍길동의 키는 '||height||'cm, 몸무게는 '||weight||'kg입니다.' AS "height and weight" FROM student;

--[문3] student 테이블을 사용하여 2학년 중에서 키가 180cm 보다 크고,
--     몸무게가 70kg 보다 큰 학생들의 이름,학년,키,몸무게 출력하기
-- 사용 컬럼명 : 이름(name), 학년(grade), 키(height), 몸무게(weight)
SELECT name, grade, height, weight FROM student
WHERE height > 180 AND weight > 70 ;
      
--[문4] student 테이블을 사용하여 몸무게가 50kg 이상 학생들을 대상으로 
--  이름, 학년, 키, 몸무게를 선택하고, 학년은 오름차순, 키는 내림차순으로 정렬하여 출력하기 
-- 사용 컬럼명 : 이름(name), 학년(grade), 키(height), 몸무게(weight)
SELECT name, grade, height, weight FROM student 
WHERE weight >= 50 
ORDER BY name, grade, height, weight, height DESC;

--[문5] student 테이블을 사용하여 1학년 학생의 '이름'과  '키' 출력(별칭 이용)
--  (단, 이름 오름차순으로 정렬)
SELECT name 이름, height 키 FROM student
WHERE grade = 1 
ORDER BY name ASC;

--[문6] professor 테이블에서 교수들의 이름을 조회하여 
-- 성 부분에 '김'이 포함된 사람의 이름을 오름차순으로 출력
SELECT name FROM professor 
WHERE name LIKE '김__' 
ORDER BY name ASC;

--[문7] professor 테이블를 대상으로 '전임'으로 검색하여 전임강사를 
-- 모두 검색하고, 학과번호 기준으로 오름차순 정렬하기
-- 사용 칼럼명 : 직책(position), 학과번호(deptno)
SELECT * FROM professor 
WHERE position LIKE '전임%'
ORDER BY deptno ASC;

 