-- ���� ����
/*
    * ��������(SUBQUERY)
    - �ϳ��� SQL�� �ȿ� ���Ե� �� �ٸ� SELECT��
    - ���� SQL���� ���� ���� ������ �ϴ� ������
*/

-- ���� �������� ����1
-- ���ö ����� ���� �μ��� ���� ����� ��ȸ�ϰ� ����!!

-- 1) ���� ���ö ����� �μ��ڵ� ��ȸ
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '���ö'; -- D9 �ΰ� �˾Ƴ�!!

-- 2) �μ��ڵ尡 D9�� ����� ��ȸ
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- > ���� 2 �ܰ踦 �ϳ��� ����������!!!
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (
                SELECT DEPT_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '���ö'
                );

-- ���� �������� ����2
-- �� ������ ��� �޿����� �� ���� �޿��� �޴� ������� ���, �̸�, �����ڵ�, �޿� ��ȸ

-- 1) �� ������ ��� �޿� ��ȸ
SELECT AVG(SALARY)
FROM EMPLOYEE; --3047663���ΰ� �˾Ƴ�!!

-- 2) �޿��� 3047663�� �̻��� ����� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

-- ���� 2�ܰ踦 �ϳ��� ����������!!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                    FROM EMPLOYEE
                    );

---------------------------------------------------------------------------------
/*
    * ���������� ����
    ���������� ������ ������� �� �� �� ���̳Ŀ� ���� �з���
    
    - ������ �������� : ���������� ��ȸ ������� ������ ������ 1���� �� (�� �� �� ��)
    - ������ �������� : ���������� ��ȸ ������� ������ �� ��(���� �� �� ��) => �������� ���ö 2���� ��
    - ���߿� �������� : ���������� ��ȸ ������� �� �� ������ �÷��� ������ �� �� (�� �� ���� ��)
    - ������ ���߿� �������� : ���������� ��ȸ ������� ���� �� ���� �÷��� �� (������ ������)
    
    >> ���������� ������ ���Ŀ� ���� �������� �տ� �ٴ� �����ڰ� �޶���!!!
*/

/*
    1. ������ �������� (SINGLE ROW SUBQUERY)
    ���������� ��ȸ ������� ������ ������ 1���� �� (�� �� �� ��)
    �Ϲ� �� ������ ��� ����
    =, !=, ^=, >, <, <=, ...
*/

-- 1) �� ������ ��� �޿����� �޿��� �� ���� �޴� ������� �����, �����ڵ�, �޿� ��ȸ
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
-- WHERE SALARY < �������� ��� �޿�;
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE);
                
-- 2) ���� �޿��� �޴� ����� ���, �̸�, �޿�, �Ի��� (����)
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
--WHERE SALARY = ��������޿��������޿�;
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);

-- 3) ���ö ����� �޿����� �� ���� �޴� ������� ���, �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE SALARY > ���ö����� �޿�;
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '���ö'); -- ������ �������� �� ������ ��� ����
                
-- >> ����Ŭ ���뱸��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND SALARY > (SELECT SALARY
              FROM EMPLOYEE
              WHERE EMP_NAME = '���ö');

-- >> ANSI ����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '���ö');
                
-- 4) �μ��� �޿� ���� ���� ū �μ��� �μ��ڵ�, �޿� �� ��ȸ
-- 4_1) ���� �μ��� �޿� �� �߿����� ���� ū �� �ϳ��� ��ȸ

SELECT MAX(SUM(SALARY)) /*DEPT_CODE,�����ؾ� ��ȸ ����*/ 
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 17700000

-- 4_2) �μ��� �޿��հ谡 17700000���� �μ� ��ȸ
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000; -- GROUP BY�� ���� �������� WHERE�� �ƴ� HAVING����

-- ���� �� �ܰ踦 �ϳ��� ����������!
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
                        SELECT MAX(SUM(SALARY)) 
                        FROM EMPLOYEE
                        GROUP BY DEPT_CODE
                        );

-- ������ ����� ���� �μ������� ���, �����, ��ȭ��ȣ, �Ի���, �μ���   (����)
-- ��, �������� ����
-- >> ����Ŭ ���� ����
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '������';

SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_CODE = (SELECT DEPT_CODE
                 FROM EMPLOYEE
                 WHERE EMP_NAME = '������')
AND EMP_NAME != '������';
--AND EMP_NAME != '������';

-- >> ANSI
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '������')
AND EMP_NAME != '������';

---------------------------------------------------------------------------------
/*
    2. ������ �������� (MULTI ROW SUBQUERY)
    ���������� ������ ������� ���� �� �� �� (�÷��� �� ��!)
    
    - IN �������� :  �������� ����� �߿��� �� ���� ��ġ�ϴ� ���� �ִٸ�
    
    - > ANY �������� : �������� ����� �߿��� "�Ѱ���" Ŭ ��� (�������� ����� �߿��� ���� ���� �� ���� Ŭ ���)
    - < ANY �������� : �������� ����� �߿��� "�Ѱ���" ���� ��� (�������� ����� �߿��� ���� ū �� ���� ���� ���)
    
        �񱳴�� > ANY (��1, ��2, ��3)
        �񱳴�� > ��1 OR �񱳴�� > ��2 OR �񱳴�� > ��3
        
    - > ALL �������� : �������� "���" ������� ���� Ŭ ���
    - < ALL �������� : �������� "���" ������� ���� ���� ���
    
        �񱳴�� > ALL (��1, ��2, ��3)
        �񱳴�� > ��1 AND �񱳴�� > ��2 AND �񱳴�� > ��3
*/

-- 1) ����� �Ǵ� ������ ����� ���� ������ ������� ���, �����, �����ڵ�, �޿� ��ȸ
-- 1_1) ����� �Ǵ� ������ ����� � �������� ��ȸ
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN('�����', '������'); -- J3, J7

-- 1_2) J3, J7�� ������ ����� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- ���� �� �ܰ踦 �ϳ��� ������
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (
                    SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME IN('�����', '������') -- = �̶�� ���� ������!! ���������� ��ȸ�Ʊ� ����!! IN ���
                    -- ���࿡ ������� ������ ���� �� ������ �׳� ���������� IN���� �ۼ�
                    );
                    
-- ��� => �븮 => ���� => ���� => ����...
-- 2) �븮 �����ӿ��� �ұ��ϰ� ���� ���� �޿��� �� �ּ� �޿����� ���� �޴� ���� ��ȸ(���, �̸�, ���޸�, �޿�)
-- 2_1) ���� ���� ������ ������� �޿� ��ȸ
SELECT SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J. JOB_CODE
AND JOB_NAME = '����'; -- 2200000 2500000 3760000

-- 2_2) ������ �븮�̸鼭 �޿����� ���� ��ϵ� �� �߿� �ϳ��� ū ���
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮'
AND (SALARY > 2200000 OR SALARY > 2500000 OR SALARY >3760000); -- �� ���ΰ��� �� �� �ۼ��� �� �ִ� ����

-- ���� �� �ܰ踦 �ϳ��� ���������� �ۼ�
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮'
AND SALARY > ANY (
                    SELECT SALARY
                    FROM EMPLOYEE E, JOB J
                    WHERE E.JOB_CODE = J. JOB_CODE
                    AND JOB_NAME = '����'
                    );

-- ������ ���������ε� �����ϴ�!
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮'
AND SALARY > (
                 SELECT MIN(SALARY)
                 FROM EMPLOYEE E, JOB J
                 WHERE E.JOB_CODE = J. JOB_CODE
                 AND JOB_NAME = '����'
                 );
                 
-- 3) ���� �������̵� �ұ��ϰ� ���� ������ ������� ��� �޿����ٵ� �� ���� �޴� ������� ���, �����, ���޸�, �޿�
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '����'
--AND SALARY > (���� ������ �ֵ��� �޿���);
AND SALARY > ALL (SELECT SALARY
                  FROM EMPLOYEE
                  JOIN JOB USING(JOB_CODE)
                  WHERE JOB_NAME = '����');

---------------------------------------------------------------------------------
/*
    3. ���߿� ��������
    ������� �� �� ������ ������ �÷����� �������� ���
*/

-- 1) ������ ����� ���� �μ��ڵ�, ���� �����ڵ忡 �ش��ϴ� ����� ��ȸ(�����, �μ��ڵ�, �����ڵ�, �Ի���)
-- >> ������ ���������ε� �����ϱ� ��!!

SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
/*
WHERE DEPT_CODE = ����������� �μ��ڵ�
AND JOB_CODE = ����������� �����ڵ�
*/
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '������')
AND JOB_CODE = (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '������');
                   
-- >> ���߿� ����������!
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
--WHERE (DEPT_CODE, JOB_CODE) = (����������� �μ��ڵ�, ����������� �����ڵ�);
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME = '������'); -- ���� �߿���!! ���� �������!! �� ���缭 �ۼ��ϱ�
                               
-- �ڳ��� ����� ���� �����ڵ�, ���� ����� ������ �ִ� ������� ���, �����, �����ڵ�, ��� ��� ��ȸ
SELECT * FROM EMPLOYEE; -- ��� MANAGER_ID

SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '�ڳ���');
                                
---------------------------------------------------------------------------------
/*
    4. ������ ���߿� ��������
    �������� ��ȸ ������� ������ �������� ��� 
*/

-- 1) �� ���޺� �ּұ޿��� �޴� ��� ��ȸ (���, �����, �����ڵ�, �޿�)
-- >> �� ���޺� �ּ� �޿� ��ȸ
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' AND SALARY = 3700000
   OR JOB_CODE = 'J7' AND SALARY = 1380000
   ...;
   
-- ���������� �����ؼ� �غ���!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE); -- IN ���� �����Ϳ� ���� �����Ͱ� 1�� 1 ��Ī�̶� ����
                                
-- 2) �� �μ��� �ְ�޿��� �޴� ������� ���, �����, �μ��ڵ�, �޿� --> �μ����̴ϱ� GROUP BY
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- �������� = ������ ���߿�

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE);

----------------------------------------------------------------------------------
/*
    5. �ζ��� �� (INLINE-VIEW)
    
    ���������� ������ ����� ��ġ ���̺�ó�� ���!
*/

-- ������� ���, �̸�, ���ʽ� ���� ����(��Ī�ο� : ����), �μ��ڵ� ��ȸ
-- ��, ���ʽ� ���� ������ 3000���� �̻��� ����鸸 ��ȸ

SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 AS "����", DEPT_CODE
FROM EMPLOYEE
WHERE (SALARY + SALARY * NVL(BONUS, 0)) * 12 >= 30000000; -- WHERE ���� �ٷ� ��Ī ��� ����!

SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 AS "����", DEPT_CODE
FROM EMPLOYEE;
-- �̰� ��ġ �����ϴ� ���̺��ΰ� ���� ����� �� ����!! �װ� �ٷ� �ζ��κ�

SELECT *
FROM (SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 AS "����", DEPT_CODE
FROM EMPLOYEE)
WHERE ���� >= 30000000;

SELECT EMP_NAME, DEPT_CODE, ���� --, MANAGER_ID  �̰� ������!
FROM (SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 AS "����", DEPT_CODE
FROM EMPLOYEE)
WHERE ���� >= 30000000;

-- >> �ζ��� �並 �ַ� ��� �ϴ� �� => TOP - N �м� (���� ��� �����ְ� ���� �� => BEST ��ǰ!!)

-- �� ���� �� �޿��� ���� ���� ���� 5�� ��ȸ
-- * ROWNUM : ����Ŭ���� �������ִ� ���� �÷�, ��ȸ�� ������� 1���� ������ �ο����ִ� �÷�

SELECT ROWNUM, EMP_NAME, SALARY --2
FROM EMPLOYEE --1
ORDER BY SALARY DESC; -- �����Ͱ� ���׹��� -- ������, ������, ������, ���ȥ, ���ö
-- FROM --> SELECT ROWNUM(�� �� ������ �ο���, ���ĵ� �ϱ� ���� �̹� ���� �ο�)

-- ���� �̻���... ���� ���� ����
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE --1
WHERE ROWNUM <= 5 --2
ORDER BY SALARY DESC;
--> �������� ����� ��ȸ ���� ����!! ( ������ �Ǳ⵵ ���� 5���� �߷����� ���� ����)

-- ORDER BY ���� �� ����� ����� ������ ROWNUM �ο� �� 5���� �߷�����!! ==> TOP N �м�
SELECT ROWNUM, EMP_NAME
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE --������ �̹� �� ������)
      FROM EMPLOYEE
      ORDER BY SALARY DESC)
WHERE ROWNUM <= 5; 

-- ROWNUM�̶� ��ü �÷� ��ȸ�ϰ� ���� => *�� ROWNUM�� ���� ����ϱ� ����� => ��Ī �ο� �ϴ� �������!
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
      FROM EMPLOYEE
      ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5; 


-- ���� �ֱٿ� �Ի��� ��� 5�� ��ȸ(�����, �޿�, �Ի���)
SELECT *
FROM EMPLOYEE -- 1
ORDER BY HIRE_DATE DESC;

-- ����
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT *
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

-- �� ��
SELECT ROWNUM, E. *
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC) E
WHERE ROWNUM <= 5;


-- �� �μ��� ��ձ޿��� ���� 3���� �μ��� ��ȸ
SELECT *
FROM (SELECT DEPT_CODE, AVG(SALARY)
      FROM EMPLOYEE
      GROUP BY DEPT_CODE);
      
SELECT ROWNUM, DEPT_CODE, FLOOR(��ձ޿�)
FROM (SELECT DEPT_CODE, AVG(SALARY) AS "��ձ޿�" -- �� ������ AVG(SALARY)�� �״�� ����ϸ� �ȵ�! SALARY��� ���� �ʿ����� ��
      FROM EMPLOYEE
      GROUP BY DEPT_CODE
      ORDER BY 2 DESC)
WHERE ROWNUM <= 3;


-- ����
SELECT ROWNUM, E. *
FROM (SELECT DEPT_CODE, ROUND(SALARY)
      FROM EMPLOYEE
      ORDER BY ROUND(SALARY) DESC) E
WHERE ROWNUM <=3;

/*
    * ���� �ű�� �Լ�(WINDOW FUNCTION)
    RANK() OVER(���ı���)            |          DENSE_RANK() OVER(���ı���)
    
    - RANK() OVER(���ı���) : ������ ���� ������ ����� ������ �ο��� ��ŭ �ǳʶٰ� ���� ���
                            EX) ���� 1���� 2���̸� �� ���� ������ 3�� => 1 1 3
    - DENSE_RANK() OVER(���ı���) : ������ ������ �ִٰ� �ص� �� ���� ����� ������ 1�� ������Ŵ
                                EX) ���� 1���� 2���̴��� �� ���� ������ 2��
                                
    >> �� �Լ��� ������ SELECT �������� ��� ����!!!
*/

-- �޿��� ���� ����� ������ �Űܼ� ��ȸ
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "����"
FROM EMPLOYEE;
-- ���� 19�� 2�� �� ���� ������ 21�� => ������ ����(23)�� ��ȸ�� ���(23)�� ����

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "����"
FROM EMPLOYEE;
-- ���� 19�� 2�� �� ���� ������ 20�� => ������ ����(22)�� ��ȸ�� ���(23)�� �ٸ�

SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "����" --3
FROM EMPLOYEE; --1
--WHERE ���� <= 5; --2
--WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5";

-- >> �ζ��� �並 �� �� �ۿ� ����!
SELECT *
FROM(SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "����" 
FROM EMPLOYEE)
WHERE ���� <= 5;


