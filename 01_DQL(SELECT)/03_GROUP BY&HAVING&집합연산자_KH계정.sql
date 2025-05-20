--먼저 저장
/*
    < GROUP BY 절 >
    그룹 기준을 제시할 수 있는 구문(해당 그룹 기준별로 여러 그룹으로 묶을 수 있음)
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/

SELECT SUM(SALARY)
FROM EMPLOYEE; -- 전체 사원을 하나의 그룹으로 묶어서 총합을 구한 결과

-- 각 부서별 총 급여합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 사원수 -> 그룹으로 묶기 위해 GROUP BY 작성 -> 그룹으로 묶은 DEPT_CODE는 SELECT에 항상 작성 -> 그룹함수 사용하기
SELECT DEPT_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 실행 순서
SELECT DEPT_CODE, COUNT(*), SUM(SALARY) -3
FROM EMPLOYEE --1
GROUP BY DEPT_CODE --2
ORDER BY DEPT_CODE; --4

-- 직급코드별로 총 인원수, 급여합 
SELECT JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 각 직급별 총 사원수, 보너스 받는 사원수, 급여합, 평균급여, 최저급여, 최대급여
SELECT JOB_CODE, COUNT(*) AS "총 사원수", COUNT(BONUS) AS " 보너스를 받는 사원수",
        SUM(SALARY) AS "급여합", FLOOR(AVG(SALARY)) AS "평균급여",
        MIN(SALARY) AS "최저급여", MAX(SALARY) AS "최대급여"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

-- 위 쿼리 부서별로
SELECT DEPT_CODE, COUNT(*) AS "총 사원수", COUNT(BONUS) AS " 보너스를 받는 사원수",
        SUM(SALARY) AS "급여합", FLOOR(AVG(SALARY)) AS "평균급여",
        MIN(SALARY) AS "최저급여", MAX(SALARY) AS "최대급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

-- GROUP BY 절에 함수식 기술 가능!
SELECT DECODE(SUBSTR(EMP_NO, 8, 1),'1','남','2','여') AS "성별", COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1); -- 8번에서 1자리 자르는거

-- GROUP BY 절에 여러 컬럼 기술 가능 ( 그룹바이는 그룹함수랑 같이 사용, 항시적으로 이 순서로 작성)
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE; -- 부서코드가 ~~일 때 직급 코드가 $$인 사람

---------------------------------------------------------------------------------
/*
    < HAVING 절 >
    그룹에 대한 조건을 제시할 때 사용되는 구문 (주로 그룹함수식을 가지고 조건을 제시할 때 사용)
*/

-- 각 부서별 평균 급여 조회
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 부서별 평균 급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
WHERE AVG(SALARY) >= 3000000  -- WHERE절에는 절대적으로 그룹 함수 사용 불가능
GROUP BY DEPT_CODE; -- -- 오류 발생!(그룹함수 가지고 조건 제시시 WHERE절에서는 안됨!) 밑에 쿼리처럼 해빙절 사용

SELECT DEPT_CODE, AVG(SALARY) --4
FROM EMPLOYEE -- 1
GROUP BY DEPT_CODE --2
HAVING AVG(SALARY) >= 3000000; -- 3 // HAVING의 위치는 GROUP BY보다 위에 있어도 상관 없지만 일반적으로는 이렇게 GROUP BY 밑에 사용

-- 이거는 이상한 쿼리임! 
-- 애초에 300만원 이상 받는 사람들만 가지고 그룹을 결성했다. ㄴ 위에 쿼리처럼 해야함
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE --1
WHERE (SALARY) >= 3000000 --2
GROUP BY DEPT_CODE;

-- 부서별 보너스를 받는 사원이 없는 부서만을 조회
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;
---------------------------------------------------------------------------------
/*
    < SELECT문 실행 순서 >
    5. SELECT * | 조회하고자 하는 컬럼 별칭 | 산술식 " 별칭" | 함수식 AS "별칭"
    1. FROM 조회하고자하는 테이블명
    2. WHERE 조건식(연산자들 가지고 기술)
    3. GROUP BY 그룹 기준으로 삼을 컬럼 | 함수식
    4. HAVING 조건식 (그룹함수를 가지고 기술)
    6. ORDER BY 컬럼명 | 별칭 | 순번 [ASC | DESC] [NULLS FIRST | NULLS LAST]

*/
---------------------------------------------------------------------------------
/*
    < 집계 함수 > - 어려움, 어려우면 까먹어도 됨
    그룹별 산출된 결과값에 중간집계를 계산해주는 함수
    
     ROLL UP
     
     => GROUP BY절에 기술하는 함수
*/

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE) -- 롤업 여러개도 가능(각각 합계 구해줌)
ORDER BY 1;

---------------------------------------------------------------------------------
/*
    < 집합 연산자 == SET OPERATION >
    
    여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
    
    - UNION         : OR | 합집합 (두 쿼리문 수행한 결과값을 더한 후 중복되는 값은 한번만 더해지도록)
    - INTERSECT     : AND | 교집합 (두 쿼리문 수행한 결과값에 중복된 결과값)
    - UNION ALL     : 합집합 + 교집합 (중복되는 부분이 두 번 표현될 수 있음!!)
    - MINUS         : 선행 결과값에서 후행결과값을 뺀 나머지 (차집합)    
*/

--1.  UNION
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회(사번, 이름, 부서코드, 급여)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 6개행 (박나라, 하이유, 김해술, 심봉선, 윤은해, 대북혼)

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8개 행 (성동일, 송종기, 노홍철, 유재식, 정중하, 심봉선, 대북혼, 전지연)

--1. UNION(합집합) -- 심봉선, 대북혼 중복을 뺀 12개 행
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 위의 쿼리문 대신 아래처럼 WHERE 절에 OR 써도 해결 가능!!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;

-- 2. INTERSECT(교집합)
-- 부서코드가 D5이면서 급여까지도 300만원 초과인 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 위의 쿼리문 대신 아래처럼 WHERE 절에 AND 써도 해결 가능!!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

---------------------------------------------------------------------------------
-- 집합 연산자 유의 사항
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- 각 쿼리문의 SELECT절에 작성돼있는 컬럼 개수 동일해야됨!!

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- 컬럼 개수 뿐만 아니라 각 컬럼 자리마다 동일한 타입으로 기술해야됨 (NUBER면 NUMBER, DATE면 DATE // 타입만 맞으면 UNION 자체는 가능, 근데 좀 이상)

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
ORDER BY EMP_NAME;
-- ORDER BY 절을 붙이고자 한다면 마지막에 기술해야됨!!

---------------------------------------------------------------------------------
--3. UNION ALL : 여러개의 쿼리 결과를 무조건 다 더하는 연산자(중복값 나옴!!)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

----------------------------------------------------------------------------------
--4. MINUS : 선행 SELECT 결과에서 후행 SELECT 결과를 뺀 나머지 (차집합)
-- 부서코드가 D5인 사원들 중 급여가 300만원 초과한 사원들은 제외해서 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 아래처럼 가능하긴 함!!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;














