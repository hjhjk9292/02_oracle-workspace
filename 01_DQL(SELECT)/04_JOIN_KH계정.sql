   < JOIN >
    두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
    조회 결과는 하나의 결과물(RESULT SET)로 나옴
    
    관계형 데이터베이스는 최소한의 데이터로 각각의 테이블에 데이터를 담고 있음 (중복을 최소화하기 위해 최대한 쪼개서 관리함)
    
    -- 어떤 사원이 어떤 부서에 속해있는지 궁금함! 코드말고.. 이름으로!..
    
    => 관계형 데이터베이스에서 SQL문을 이용한 테이블간의 "관계"를 맺는 방법
    (무작정 다 조회를 해오는게 아니라 각 테이블간의 연결고리로써의 데이터를 매칭 시켜서 조회해야됨!)
    
                 JOIN은 크게 "오라클 전용구문"과 "ANSI 구문" (ANSI == 미국국립표준협회) => 아스키코드표 만드는 단체!
                                            [ JOIN 용어 정리 ]
                        오라클 전용 구문              |            ANSI 구문
        =======================================================================================================
                            등가조인                 |    내부 조인(INNER JOIN)
                            (EQUAL JOIN)            |    자연 조인(NATURAL JOIN)
        -------------------------------------------------------------------------------------------------------
                            포괄조인                 |    왼쪽 외부 조인(LEFT OUTER JOIN)
                            (LEFT OUTER)            |   오른쪽 외부 조인(RIGHT OUTER JOIN)
                            (RIGHT OUTER)           |   전체 외부 조인(FULL OUTER JOIN)
        -------------------------------------------------------------------------------------------------------
                            자체조인(SELF JOIN)      |
                    비등가 조인(NON EQUAL JOIN)      |
        -------------------------------------------------------------------------------------------------------
*/


-- 전체 사원들의 사번, 사원명, 부서코드, 부서명 조회하고자 할 때
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 전체 사원들의 사번, 사원명, 직급코드, 직급명 조회하고자 할 때
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

/*
    1. 등가조인(EQUAL JOIN) / 내부 조인(INNER JOIN)
        연결 시키는 컬럼의 값이 일치하는 행들만 조인되서 조회(== 일치하는 값이 없는 행은 조회에서 제외)
*/

-- >> 오라클 전용 구문★
--     FROM절에 조회하고자 하는 테이블들을 나열 (, 구분자로)
--     WHERE절에 매칭시킬 컬럼(연결고리)에 대한 조건을 제시함

-- 1) 연결할 두 컬럼명이 다른 경우(EMPLOYEE : DEPT_CODE, DEPARTMENT : DEPT_ID)
-- 사번, 사원명, 부서코드, 부서명을 같이 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
--> 일치하는 값이 없는 행은 조회에서 제외된 거 확인 가능
-- DEPT_CODE 가 NULL인 사원 조회 X, DEPT_ID D3, D4, D7 조회 X

-- 2) 연결할 두 컬럼명이 같은 경우 (EMPLOYEE : JOB_CODE, JOB : JOB_CODE)
-- 사번, 사원명, 직급코드, 직급명
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE;
-- ambiguously : 애매하다, 모호하다.

-- 1) 해결방법 : 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME -- 컬럼명 같을 때
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 2) 해결방법 : 테이블에 별칭을 부여해서 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;


-- >> ANSI 구문
-- FROM절에 기준이 되는 테이블을 하나만 기술한 후
-- JOIN절에 같이 조회하고자 하는 테이블 기술 + 매칭시킬 컬럼에 대한 조건도 기술
-- JOIN USING, JOIN ON

-- 1) 연결할 두 컬럼명이 다른 경우 (EMPLOYEE:DEPT_CODE, DEPARTMENT : DEPT_ID)
-- 오로지 JOIN ON구문으로만 가능!!
-- 사번, 사원명, 부서코드, 부서명
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- JOIN DEPARTMENT ON (연결고리);

-- 2) 연결할 두 컬럼명이 같은 경우 ( E : JOB_CODE, J: JOB_CODE)
-- JOIN ON, JOIN USING 구문도 사용가능
-- 사번, 사원명, 직급코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB ON (JOB_CODE = JOB_CODE);

-- 해결방법 1) 테이블명 또는 별칭을 이용해서 하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 해결방법 2) JOIN USING 구분을 사용하는 방법(두 컬럼명 일치할 때만 사용 가능!!)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

----------- 참고 사항 ------------
-- 자연조인(NATURAL JOIN : 각 테이블마다 동일한 컬럼이 딱 한개만 존재할 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;


-- 추가적인 조건도 당근 제시 가능
-- 직급이 대리인 사원의 이름, 직급명, 급여 조회

-- >> 오라클 전용 구문
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME = '대리';

-- >> ANSI 구문
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';


-------------------------------- 실습 문제 ---------------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번, 이름, 보너스 조회
-->> 오라클 전용 구문
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DETP_ID


SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '인사관리부';

-- 내가 푼 거(SELECT에 DEPT_CODE, DEPT_TITLE는 조회 안해도 됨) /  별칭 불필요..
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
AND DEPT_TITLE = '인사관리부';


-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) -- JOIN 이름이 다를 경우
WHERE DEPT_TITLE = '인사관리부';

-- 내가 푼 거 (USING을 사용해서 틀렸음)
--SELECT EMP_ID, EMP_NAME, BONUS, DEPT_CODE, DEPT_TITLE
--FROM EMPLOYEE
--JOIN DEPARTMENT USING(DEPT_ID)
--WHERE DEPT_TITLE = '인사관리부';

-- 2. DEPARTMENT와 LOCATION을 참고해서 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
-->> 오라클 전용 구문
SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION; -- LOCAL_CODE

SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- 내가 푼 거 
--SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
--FROM DEPARTMENT D, LOCATION L
--WHERE D.LOCATION_ID = L.LOCAL_CODE;

-->> ANSI 구문
SELECT DEPT_ID, DEPT_TILTE, LOCATION_CODE, LOCATION_NAME
FROM DEPARTMENT
JOIN DEPARTMENT ON(LOCATION_ID = LOCAL_CODE);


-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DETP_ID

-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND BONUS IS NOT NULL;

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;

--4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID

-->> 오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE != '총무부';

-->> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE != '총무부';
-- 지금 현재 DEPT_CODE가 NULL인 것은 나오지 않고 있음

--------------------------------------------------------------------------------------- 위에 문제 3,4번 다시 풀기
/*
    2. 포괄조인 / 외부조인
    두 테이블간의 JOIN 시 일치하지 않는 행동 포함시켜서 조회 가능
    단, LEFT / RIGHT를 반드시 지정해야됨!! (기준이 되는 테이블 지정)

*/

-- 월급 주기
-- 사원명, 부서명, 급여, 연봉
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 21명만 나옴 (등가조인이기 때문)
-- 부서 배치가 아직 안된 사원 2명에 대한 정보는 조회 X
-- 부서에 배정된 사원이 없는 부서 같은 경우도 조회가 X

-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼편에 기술된 테이블 기준으로 JOIN
-- >> ANSI 구문 ( JOIN절 )
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE -- EMPLOYEE에 있는건 무조건 다 나오는 거임
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- 부서배치를 받지 않았던 2명의 사원 정보도 조회됨(등가조인에서는 절대 안나오는 정보)

-- >> 오라클 전용 구문 (WHERE절에서 지지고 볶자)
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); -- 기준으로 삼고자 하는 테이블의 반대편 컬럼 뒤에 (+)를 붙이기!

-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN

-- >> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 등가는 둘 다 갖고 있는 것이 나오는데 RIGHT[OUTER] 조인은 너가 갖고 있거나 내가 갖고 있거나

-- >> 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID; -- 내가 나오게 하고픈 상대편 거에 (+)

-- 3) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행을 조회할 수 있음.(단, 오라클 전용 구문으로는 안됨!★)
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

---------------------------------------------------------------------------------------
/*
    3. 비등가 조인(NON EQUAL JOIN) => 얘는 참고용..중요도↓ 요즘 많이 사용하지 않음
        매칭시킬 컬럼에 대한 조건 작성 시 '=(등호)'를 사용하지 않는 조인문
        ANSI 구문으로는 JOIN ON만 사용 가능!
*/

SELECT * FROM EMPLOYEE; -- SAL_LEVEL
SELECT * FROM SAL_GRADE; -- SAL_LEVEL

SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE;

SELECT SAL_LEVEL, MIN_SAL, MAX_SAL
FROM SAL_GRADE;

-- 사원명, 급여, 최대 월급 한도
-- >> 오라클 전용 구문
SELECT EMP_NAME, SALARY, MAX_SAL
FROM EMPLOYEE, SAL_GRADE
WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL
AND SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- >> ANSI 구문 : JOIN USING(컬럼의 이름이 같으면), JOIN ON(컬럼의 이름이 다르면)

---------------------------------------------------------------------------------
/*
    4. 자체 조인 (SELF JOIN)
    같은 테이블을 다시 한 번 조인하는 경우
*/
SELECT * FROM EMPLOYEE;

-- 전체 사원의 사번, 사원명, 사원부서코드, 사수의 사번, 사수명, 사수부서코드

SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

-- 전체 사원의 사번, 사원명, 사원부서코드       => EMPLOYEE E => MANAGER_ID
--      사수의 사번, 사수명, 사수부서코드      => EMPLOYEE M => EMP_ID

-- >> 오라클 전용 구문
SELECT E.EMP_ID "사원사번", E.EMP_NAME "사원명", E.DEPT_CODE "사원부서코드",
       M.EMP_ID "사수사번", M.EMP_NAME "사수명", M.DEPT_CODE "사수부서코드"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- >> ANSI 구문
SELECT E.EMP_ID "사원사번", E.EMP_NAME "사원명", E.DEPT_CODE "사원부서코드",
       M.EMP_ID "사수사번", M.EMP_NAME "사수명", M.DEPT_CODE "사수부서코드"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON(E.MANAGER_ID = M.EMP_ID);
--  사수가 없는 사람도 나오게 하고 싶으면 LEFT JOIN



