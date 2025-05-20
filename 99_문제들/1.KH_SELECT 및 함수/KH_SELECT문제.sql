--1. JOB ���̺��� ��� ���� ��ȸ 
SELECT *
FROM JOB;


--2. JOB ���̺��� ���� �̸� ��ȸ 
SELECT JOB_NAME
FROM JOB;


--3. DEPARTMENT ���̺��� ��� ���� ��ȸ 
SELECT *
FROM DEPARTMENT;


--4. EMPLOYEE���̺��� ������, �̸���, ��ȭ��ȣ, ����� ��ȸ 
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM EMPLOYEE;


--5. EMPLOYEE���̺��� �����, ��� �̸�, ���� ��ȸ 
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM EMPLOYEE;


----6. EMPLOYEE���̺��� �̸�, ����, �Ѽ��ɾ�(���ʽ�����), �Ǽ��ɾ�(�Ѽ��ɾ� - (����*���� 3%)) ��ȸ 
SELECT EMP_NAME, 
        SALARY * 12 AS "����", 
        (SALARY * 12 + SALARY * 12 * BONUS) AS "�Ѽ��ɾ�",
        ((SALARY * 12 + SALARY * 12* BONUS) - (SALARY * 12 *0.03)) AS "�Ǽ��ɾ�"
FROM EMPLOYEE;


--7. EMPLOYEE���̺��� SAL_LEVEL�� S1�� ����� �̸�, ����, �����, ����ó ��ȸ 
SELECT EMP_NAME, SALARY, HIRE_DATE, PHONE
FROM EMPLOYEE
WHERE SAL_LEVEL = 'S1';


----8. EMPLOYEE���̺��� �Ǽ��ɾ�(6�� ����)�� 5õ���� �̻��� ����� �̸�, ����, �Ǽ��ɾ�, ����� ��ȸ --
SELECT EMP_NAME, SALARY, ((SALARY + SALARY * BONUS) * 12) - (SALARY * 12 * 1.03) AS "�Ǽ��ɾ�", HIRE_DATE
FROM EMPLOYEE
WHERE ((SALARY + SALARY * BONUS) * 12) - (SALARY * 12 * 1.03) >= 50000000;


--9. EMPLOYEE���̺� ������ 4000000�̻��̰� JOB_CODE�� J2�� ����� ��ü ���� ��ȸ 
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 4000000 AND JOB_CODE = 'J2';


--10. EMPLOYEE���̺� DEPT_CODE�� D9�̰ų� D5�� ��� ��  
--������� 02�� 1�� 1�Ϻ��� ���� ����� �̸�, �μ��ڵ�, ����� ��ȸ 
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE ='D9' OR DEPT_CODE = 'D5' AND HIRE_DATE >= '02/01/01';


--11. EMPLOYEE���̺� ������� 90/01/01 ~ 01/01/01�� ����� ��ü ������ ��ȸ 
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

--12. EMPLOYEE���̺��� �̸� ���� '��'���� ������ ����� �̸� ��ȸ 
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��';

--13. EMPLOYEE���̺��� ��ȭ��ȣ ó�� 3�ڸ��� 010�� �ƴ� ����� �̸�, ��ȭ��ȣ�� ��ȸ
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

--14. EMPLOYEE���̺��� �����ּ� '_'�� ���� 4���̸鼭 DEPT_CODE�� D9 �Ǵ� D6�̰�  
--������� 90/01/01 ~ 00/12/01�̰�, �޿��� 270�� �̻��� ����� ��ü�� ��ȸ 
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '____$_%' ESCAPE '$' AND DEPT_CODE IN('D9','D6') AND HIRE_DATE BETWEEN '90/01/01' AND '00/12/01' AND SALARY >= 2700000;

----15. EMPLOYEE���̺��� ��� ��� ������ �ֹι�ȣ�� �̿��Ͽ� ����, ����, ���� ��ȸ --
SELECT EMP_NAME, 
       SUBSTR(EMP_NO, 1, 2) AS "����", 
       SUBSTR(EMP_NO, 3, 2) AS "����", 
       SUBSTR(EMP_NO, 5, 2) AS "����"
FROM EMPLOYEE;

--16. EMPLOYEE���̺��� �����, �ֹι�ȣ ��ȸ (��, �ֹι�ȣ�� ������ϸ� ���̰� �ϰ�, '-'���� ���� '*'�� �ٲٱ�) 
SELECT EMP_NAME, SUBSTR(EMP_NO, 1,7)|| '*******' AS "�ֹι�ȣ"
FROM EMPLOYEE;

----17. EMPLOYEE���̺��� �����, �Ի���-����, ����-�Ի��� ��ȸ 
--(��, �� ��Ī�� �ٹ��ϼ�1, �ٹ��ϼ�2�� �ǵ��� �ϰ� ��� ����(����), ����� �ǵ��� ó��) --
SELECT EMP_NAME, 
       HIRE_DATE, 
       FLOOR(SYSDATE - HIRE_DATE) AS "�ٹ��ϼ�1", 
       FLOOR(SYSDATE - HIRE_DATE) AS "�ٹ��ϼ�2"
FROM EMPLOYEE;

----18. EMPLOYEE���̺��� ����� Ȧ���� �������� ���� ��� ��ȸ 
--SELECT *
--FROM EMPLOYEE
--WHERE EMP_ID LIKE '__1','__3','__5','__7','__9';

SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) IN (1, 3, 5, 7, 9);
--MOD �Լ��� ������ ������ �����ϴ� �Լ� // MOD(EMP_ID, 2)�� EMP_ID ���� 2�� ������ �������� ����


----19. EMPLOYEE���̺��� �ٹ� ����� 20�� �̻��� ���� ���� ��ȸ --
SELECT EMP_NAME, 
       EXTRACT(YEAR FROM HIRE_DATE) AS "�Ի�⵵"
FROM EMPLOYEE
WHERE HIRE_DATE <= ADD_MONTHS(SYSDATE, -20 * 12);


--20. EMPLOYEE ���̺��� �����, �޿� ��ȸ (��, �޿��� '\9,000,000' �������� ǥ��) 
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999')
FROM EMPLOYEE;


----21. EMPLOYEE���̺��� ���� ��, �μ��ڵ�, �������, ����(��) ��ȸ 
--(��, ��������� �ֹι�ȣ���� �����ؼ� 00�� 00�� 00�Ϸ� ��µǰ� �ϸ� ���̴� �ֹι�ȣ���� ����ؼ� ��¥�����ͷ� ��ȯ�� ���� ���) 
SELECT EMP_NAME, 
       DEPT_CODE, 
       TO_TIMESTAMP(SUBSTR(EMP_NO, 1, 6), 'YYMMDD') AS "�������",
       FLOOR(MONTHS_BETWEEN(SYSDATE, TO_TIMESTAMP(SUBSTR(EMP_NO, 1, 6), 'YYMMDD')) / 12) AS "����"
FROM EMPLOYEE
WHERE EMP_NO IS NOT NULL;


----22. EMPLOYEE���̺��� �μ��ڵ尡 D5, D6, D9�� ����� ��ȸ�ϵ� D5�� �ѹ���, D6�� ��ȹ��, D9�� �����η� ó�� 
--(��, �μ��ڵ� ������������ ����) --
SELECT EMP_NAME, 
       CASE 
           WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
           WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
           WHEN DEPT_CODE = 'D9' THEN '������'
       END AS "�μ�"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY DEPT_CODE;


----23. EMPLOYEE���̺��� ����� 201���� �����, �ֹι�ȣ ���ڸ�, �ֹι�ȣ ���ڸ�,  --�ֹι�ȣ ���ڸ��� ���ڸ��� �� ��ȸ  --
SELECT EMP_ID, EMP_NAME, EMP_NO,  
       SUBSTR(EMP_NO, 1, 6) || SUBSTR(EMP_NO, 7) AS "�ֹι�ȣ ��"
FROM EMPLOYEE
WHERE EMP_ID = 201;

--SELECT EMP_ID, EMP_NAME, EMP_NO
--FROM EMPLOYEE
--WHERE EMP_ID = '201', SUBSTR(EMP_NO,6,-1);


---24. EMPLOYEE���̺��� �μ��ڵ尡 D5�� ������ ���ʽ� ���� ���� �� ��ȸ <NVL> --
SELECT SUM(SALARY + SALARY * NVL(BONUS, 0)) * 12 --AS "�μ��ڵ尡 D5�� ������ ���ʽ� ���� ���� ��"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

----25. EMPLOYEE���̺��� �������� �Ի��Ϸκ��� �⵵�� ������ �� �⵵�� �Ի� �ο��� ��ȸ ��ü ���� ��, 
-- 2001��, 2002��, 2003��, 2004�� <��� >2001���� ����̴�~ ǥó�� �ѹ��� --
SELECT EXTRACT(YEAR FROM HIRE_DATE) AS "�Ի�⵵",
       COUNT(*) AS "�Ի��ο���"
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) IN (2001, 2002, 2003, 2004)
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
ORDER BY "�Ի�⵵";


-- NULL�� ����
SELECT EXTRACT(YEAR FROM HIRE_DATE) AS "�Ի�⵵", COUNT(*) AS "�Ի��ο���"
FROM EMPLOYEE
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
HAVING EXTRACT(YEAR FROM HIRE_DATE) IN (2001, 2002, 2003, 2004)

UNION ALL

SELECT NULL AS "�Ի�⵵", COUNT(*) AS "�Ի��ο���"
FROM EMPLOYEE;



-------------------------------- �ǽ� ���� ---------------------------------------
-- 1. �μ��� �λ�������� ������� ���, �̸�, ���ʽ� ��ȸ

SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DETP_ID

-->> ����Ŭ ���� ����
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '�λ������';

-->> ANSI ����

SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '�λ������';



-- 2. DEPARTMENT�� LOCATION�� �����ؼ� ��ü �μ��� �μ��ڵ�, �μ���, �����ڵ�, ������ ��ȸ
-->> ����Ŭ ���� ����
SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION; -- LOCAL_CODE

SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION;-- LOCAL_CODE

-->> ANSI ����
SELECT DEPT_ID, DEPT_TILTE, LOCATION_CODE, LOCATION_NAME
FROM DEPARTMENT
JOIN DEPARTMENT ON(LOCATION_ID = LOCAL_CODE);


-- 3. ���ʽ��� �޴� ������� ���, �����, ���ʽ�, �μ��� ��ȸ
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DETP_ID

-->> ����Ŭ ���� ����
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND BONUS IS NOT NULL;

-->> ANSI ����
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;

--4. �μ��� �ѹ��ΰ� �ƴ� ������� �����, �޿�, �μ��� ��ȸ
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID

-->> ����Ŭ ���� ����
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE != '�ѹ���';

-->> ANSI ����
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE != '�ѹ���';
-- ���� ���� DEPT_CODE�� NULL�� ���� ������ �ʰ� ����





-------------------------------- �ǽ� ���� ---------------------------------------
-- 1. �μ��� �λ�������� ������� ���, �̸�, ���ʽ� ��ȸ

SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DETP_ID

-->> ����Ŭ ���� ����
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '�λ������';

-->> ANSI ����

SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '�λ������';



-- 2. DEPARTMENT�� LOCATION�� �����ؼ� ��ü �μ��� �μ��ڵ�, �μ���, �����ڵ�, ������ ��ȸ
-->> ����Ŭ ���� ����
SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION; -- LOCAL_CODE

SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION;-- LOCAL_CODE

-->> ANSI ����
SELECT DEPT_ID, DEPT_TILTE, LOCATION_CODE, LOCATION_NAME
FROM DEPARTMENT
JOIN DEPARTMENT ON(LOCATION_ID = LOCAL_CODE);


-- 3. ���ʽ��� �޴� ������� ���, �����, ���ʽ�, �μ��� ��ȸ
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DETP_ID

-->> ����Ŭ ���� ����
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND BONUS IS NOT NULL;

-->> ANSI ����
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;

--4. �μ��� �ѹ��ΰ� �ƴ� ������� �����, �޿�, �μ��� ��ȸ
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID

-->> ����Ŭ ���� ����
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE != '�ѹ���';

-->> ANSI ����
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE != '�ѹ���';
-- ���� ���� DEPT_CODE�� NULL�� ���� ������ �ʰ� ����



----------------------------------- �ǽ����� -------------------------------------
-- 1. ���, �����, �μ���, ������, ������ (EMP,DEP, NAT ����)
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID    LOCATION_ID
SELECT * FROM LOCATION; --              LOCATION_CODE      NATIONAL_CODE
SELECT * FROM NATIONAL;--                                  NATIONAL_CODE

-- >> ����Ŭ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION L, NATIONAL N
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND L.NATIONAL_CODE  = N.NATIONAL_CODE;

-- >> ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE);


-- 2. ���, �����, �μ���, ���޸�, ������, ������ �ش� �޿���޿��� ���� �� �ִ� �ִ� �ݾ� ��ȸ(��� ���̺� ����)
SELECT * FROM EMPLOYEE; --   DEPT_CODE  JOB_CODE                                  SAL_LEVEL
SELECT * FROM DEPARTMENT; -- DEPT_ID               LOCATION_ID
SELECT * FROM JOB; --                   JOB_CODE
SELECT * FROM LOCATION; --                         LOCATION_CODE   NATIONAL_CODE
SELECT * FROM NATIONAL; --                                         NATIONAL_CODE
SELECT * FROM SAL_GRADE; --                                                       SAL_LEVEL                                 

-- >> ����Ŭ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, MAX_SAL
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE  = N.NATIONAL_CODE
AND E.SAL_LEVEL = S.SAL_LEVEL;

-- >> ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, MAX_SAL
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J USING(JOB_CODE)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N USING(NATIONAL_CODE)
JOIN SAL_GRADE S USING(SAL_LEVEL);

