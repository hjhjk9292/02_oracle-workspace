-- 먼저 저장
SELECT DEPT_CODE, SUM(SALARY) --JOB_CODE, SALARY
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- 원인 : JOB_CODE, SALARY 컬럼이 GROUP BY로 묶여있지 않고, GROUP BY 사용 시 그룹함수와 함께 써야하는데 그러지 않았다...
-- 조치사항 : SELECT 목록이 GROUP BY와 일치하지 않으므로 수정이 필요함
-- GROUP BY를 쓰려면 GROUP BY와 관련된 것만 쓰도록

SELECT DEPT_CODE, JOB_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
-- GROUP BY로 묶은 것은 반드시 SELECT절에 나와야함. 그리고 그룹함수랑 같이 써야된다.
-- GROUP BY는 여러개의 조건을 제시 가능 / GROUP BY로 묶은 것을 SELECT에 제시해주어야함

--프로시저는 나오지 않음!