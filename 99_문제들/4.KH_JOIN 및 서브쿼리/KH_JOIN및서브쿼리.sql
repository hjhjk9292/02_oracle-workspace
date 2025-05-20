-- KH_JOIN�׼�������_����
SELECT * FROM EMPLOYEE;   -- DEPT_CODE      JOB_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID
SELECT * FROM JOB; --                       JOB_CODE

---1. 70��� ��(1970~1979) �� �����̸鼭 ������ ����� �̸��� �ֹι�ȣ, �μ� ��, ���� ��ȸ 
-->> ANSI
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '��__';


-->> ����Ŭ
SELECT EMP_NAME AS "�̸�", EMP_NO AS "�ֹι�ȣ", DEPT_TITLE AS "�μ� ��", JOB_NAME AS "����"
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE;



----2. ���� �� ���� ������ ��� �ڵ�, ��� ��, ����, �μ� ��, ���� �� ��ȸ 
SELECT EMP_ID, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);
--HAVING MIN(EMP_NO);


--3. �̸��� �������� ���� ����� ��� �ڵ�, ��� ��, ���� ��ȸ 
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '%��%';

--4. �μ��ڵ尡 D5�̰ų� D6�� ����� ��� ��, ���� ��, �μ� �ڵ�, �μ� �� ��ȸ
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE IN('D5', 'D6')
ORDER BY DEPT_TITLE DESC;


--5. ���ʽ��� �޴� ����� ��� ��, �μ� ��, ���� �� ��ȸ 
SELECT * FROM EMPLOYEE;   -- DEPT_CODE      
SELECT * FROM DEPARTMENT; -- DEPT_ID        LOCATION_ID
SELECT * FROM LOCATION; --                  LOCAL_CODE

SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;

--6. ��� ��, ���� ��, �μ� ��, ���� �� ��ȸ 
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

--7. �ѱ��̳� �Ϻ����� �ٹ� ���� ����� ��� ��, �μ� ��, ���� ��, ���� �� ��ȸ 
SELECT * FROM EMPLOYEE;   -- DEPT_CODE      
SELECT * FROM DEPARTMENT; -- DEPT_ID        LOCATION_ID
SELECT * FROM LOCATION; --                  LOCAL_CODE      NATIONAL_CODE
SELECT * FROM NATIONAL; --                                  NATIONAL_CODE

SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME IN('�ѱ�','�Ϻ�');


--8. �� ����� ���� �μ����� ���ϴ� ����� �̸� ��ȸ 



--9. ���ʽ��� ���� ���� �ڵ尡 J4�̰ų� J7�� ����� �̸�, ���� ��, �޿� ��ȸ(NVL �̿�)��
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_CODE IN('J4','J7') AND BONUS IS NULL;

----10. ���ʽ� ������ ������ ���� 5���� ���, �̸�, �μ� ��, ����, �Ի���, ���� ��ȸ 


----11. �μ� �� �޿� �հ谡 ��ü �޿� �� ���� 20%���� ���� �μ��� �μ� ��, �μ� �� �޿� �հ� ��ȸ 


----11-1. JOIN�� HAVING ��� 


----11-2. �ζ��� �� ��� 


--12. �μ� ��� �μ� �� �޿� �հ� ��ȸ
-- ��Ʈ : OUTER JOIN
SELECT * FROM EMPLOYEE;

SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE;
