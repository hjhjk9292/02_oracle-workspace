-- 두번째 쿼리공부
------------------------------------ QUIZ1 ------------------------------------
-- ROWNUM을 활용해서 급여가 가장 높은 5명을 조회하고 싶었으나, 제대로 조회가 안됐음!!
-- 이 때 작성된 SQL문이 아래와 같음
SELECT ROWNUM, EMP_NAME, SALARY --3
FROM EMPLOYEE --1
WHERE ROWNUM <= 5 --2
ORDER BY SALARY DESC; --4
-- 어떤 문제가 있는지, 해결된 SQL문 작성!
-- 문제점 : ORDER BY로 정렬이 되기도 전에 WHERE절에서 ROWNUM이 부여됨. 데이터 이상하게 현출됨.

-- 조치한 쿼리문
SELECT *
FROM EMPLOYEE
ORDER BY SALARY DESC;

SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC)  -- FROM절에 이미 정렬이 된 데이터를 넣기)
WHERE ROWNUM <= 5;

---------------------------------- QUIZ2 ----------------------------------------
-- 부서별 평균급여가 270만원을 초과하는 부서들에 대해 (부서코드, 부서별 총 급여합, 부서별 평균급여, 부서별 사원수) 조회할꺼임
-- 이 때 작성한 SQL문이 다음과 같음
SELECT DEPT_CODE, SUM(SALARY) 총합, FLOOR(AVG(SALARY)) 평균급여, COUNT(*) 사원수 --4
FROM EMPLOYEE --1
WHERE SALARY > 2700000 --2
GROUP BY DEPT_CODE --3
ORDER BY 1; --5

-- 어떤 문제가 있는지, 해결된 SQL문 작성!!
SELECT DEPT_CODE, SUM(SALARY) 총합, FLOOR(AVG(SALARY)) 평균급여, COUNT(*) 사원수 
FROM EMPLOYEE 
WHERE AVG(SALARY) > 2700000  -- "group function is not allowed here"
GROUP BY DEPT_CODE 
ORDER BY 1;

SELECT DEPT_CODE, SUM(SALARY) 총합, FLOOR(AVG(SALARY)) 평균급여, COUNT(*) 사원수 
FROM EMPLOYEE --1
GROUP BY DEPT_CODE --2 // GROUP BY 에서 WHERE 절 쓰면 결과가 이상하게 나온다 (O) /  그룹함수에서는 WHERE절은 안된다 (X)
HAVING AVG(SALARY) > 2700000
ORDER BY 1;

---------------------------------- QUIZ3 ----------------------------------------
-- 직원의 급여 조회 시 각 직급별로 인상해서 조회
-- J7인 사원은 급여를 10% 인상 (SALARY * 1.1)
-- J6인 사원은 급여를 15% 인상 (SALARY * 1.15)
-- J5인 사원은 급여를 20% 인상 (SALARY * 1.2)
-- 그 외의 사원은 급여를 5% 인상 (SALARY * 1.05)

SELECT EMP_NAME, JOB_CODE, SALARY,
       DECODE(JOB_CODE, 'J7', SALARY * 1.1, -- JOB_CODE가 'J7'인 사원에게 10% 인상
                        'J6', SALARY * 1.15,
                        'J5', SALARY * 1.2,
                        SALARY * 1.05) AS "인상된 급여"-- 그 외 나머지
FROM EMPLOYEE;

-- '25/01/05' 와 같은 문자열을 가지고 '2025-01-06'으로 표현해보기  -- 날짜같지만 문자타입 => 문자타입 (문자열을 날짜타입으로 바꾸고 또 문자열로 바꾸는 2번 형변환)
-- TO_DATE('문자열', [포맷]) : DATE
-- TO_CHAR(날짜, [포맷]) : CHARACTER

SELECT TO_CHAR(TO_DATE('25/01/05'), 'YYYY-MM-DD')
FROM DUAL; -- 가상테이블 이름

-- '240106'와 같은 문자열을 가지고 2024년 1월 6일 표현 -- 01월 06일이 아님!!
-- 구글링!
SELECT TO_CHAR(TO_DATE('240106'), 'YYYY"년" FMMM"월" DD"일"') AS "날짜"
FROM DUAL;

-- SUBSTR 이용한 강제 출력 ( 2024년 1월 6일 )
SELECT SUBSTR(TO_CHAR(TO_DATE('240106'), 'YYYY"년" MM"월" DD"일"'), 1, 6)
|| SUBSTR(TO_CHAR(TO_DATE('240106'), 'YYYY"년" MM"월" DD"일"'), 8, 3)
|| SUBSTR(TO_CHAR(TO_DATE('240106'), 'YYYY"년" MM"월" DD"일"'), 12, 2)
FROM DUAL;











