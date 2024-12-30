   < JOIN >
    �� �� �̻��� ���̺��� �����͸� ��ȸ�ϰ��� �� �� ���Ǵ� ����
    ��ȸ ����� �ϳ��� �����(RESULT SET)�� ����
    
    ������ �����ͺ��̽��� �ּ����� �����ͷ� ������ ���̺� �����͸� ��� ���� (�ߺ��� �ּ�ȭ�ϱ� ���� �ִ��� �ɰ��� ������)
    
    -- � ����� � �μ��� �����ִ��� �ñ���! �ڵ帻��.. �̸�����!..
    
    => ������ �����ͺ��̽����� SQL���� �̿��� ���̺��� "����"�� �δ� ���
    (������ �� ��ȸ�� �ؿ��°� �ƴ϶� �� ���̺��� ������ν��� �����͸� ��Ī ���Ѽ� ��ȸ�ؾߵ�!)
    
                 JOIN�� ũ�� "����Ŭ ���뱸��"�� "ANSI ����" (ANSI == �̱�����ǥ����ȸ) => �ƽ�Ű�ڵ�ǥ ����� ��ü!
                                            [ JOIN ��� ���� ]
                        ����Ŭ ���� ����              |            ANSI ����
        =======================================================================================================
                            �����                 |    ���� ����(INNER JOIN)
                            (EQUAL JOIN)            |    �ڿ� ����(NATURAL JOIN)
        -------------------------------------------------------------------------------------------------------
                            ��������                 |    ���� �ܺ� ����(LEFT OUTER JOIN)
                            (LEFT OUTER)            |   ������ �ܺ� ����(RIGHT OUTER JOIN)
                            (RIGHT OUTER)           |   ��ü �ܺ� ����(FULL OUTER JOIN)
        -------------------------------------------------------------------------------------------------------
                            ��ü����(SELF JOIN)      |
                    �� ����(NON EQUAL JOIN)      |
        -------------------------------------------------------------------------------------------------------
*/


-- ��ü ������� ���, �����, �μ��ڵ�, �μ��� ��ȸ�ϰ��� �� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- ��ü ������� ���, �����, �����ڵ�, ���޸� ��ȸ�ϰ��� �� ��
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

/*
    1. �����(EQUAL JOIN) / ���� ����(INNER JOIN)
        ���� ��Ű�� �÷��� ���� ��ġ�ϴ� ��鸸 ���εǼ� ��ȸ(== ��ġ�ϴ� ���� ���� ���� ��ȸ���� ����)
*/

-- >> ����Ŭ ���� ������
--     FROM���� ��ȸ�ϰ��� �ϴ� ���̺���� ���� (, �����ڷ�)
--     WHERE���� ��Ī��ų �÷�(�����)�� ���� ������ ������

-- 1) ������ �� �÷����� �ٸ� ���(EMPLOYEE : DEPT_CODE, DEPARTMENT : DEPT_ID)
-- ���, �����, �μ��ڵ�, �μ����� ���� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
--> ��ġ�ϴ� ���� ���� ���� ��ȸ���� ���ܵ� �� Ȯ�� ����
-- DEPT_CODE �� NULL�� ��� ��ȸ X, DEPT_ID D3, D4, D7 ��ȸ X

-- 2) ������ �� �÷����� ���� ��� (EMPLOYEE : JOB_CODE, JOB : JOB_CODE)
-- ���, �����, �����ڵ�, ���޸�
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE;
-- ambiguously : �ָ��ϴ�, ��ȣ�ϴ�.

-- 1) �ذ��� : ���̺���� �̿��ϴ� ���
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME -- �÷��� ���� ��
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 2) �ذ��� : ���̺� ��Ī�� �ο��ؼ� �̿��ϴ� ���
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;


-- >> ANSI ����
-- FROM���� ������ �Ǵ� ���̺��� �ϳ��� ����� ��
-- JOIN���� ���� ��ȸ�ϰ��� �ϴ� ���̺� ��� + ��Ī��ų �÷��� ���� ���ǵ� ���
-- JOIN USING, JOIN ON

-- 1) ������ �� �÷����� �ٸ� ��� (EMPLOYEE:DEPT_CODE, DEPARTMENT : DEPT_ID)
-- ������ JOIN ON�������θ� ����!!
-- ���, �����, �μ��ڵ�, �μ���
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- JOIN DEPARTMENT ON (�����);

-- 2) ������ �� �÷����� ���� ��� ( E : JOB_CODE, J: JOB_CODE)
-- JOIN ON, JOIN USING ������ ��밡��
-- ���, �����, �����ڵ�, ���޸� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB ON (JOB_CODE = JOB_CODE);

-- �ذ��� 1) ���̺�� �Ǵ� ��Ī�� �̿��ؼ� �ϴ� ���
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- �ذ��� 2) JOIN USING ������ ����ϴ� ���(�� �÷��� ��ġ�� ���� ��� ����!!)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

----------- ���� ���� ------------
-- �ڿ�����(NATURAL JOIN : �� ���̺��� ������ �÷��� �� �Ѱ��� ������ ���
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;


-- �߰����� ���ǵ� ��� ���� ����
-- ������ �븮�� ����� �̸�, ���޸�, �޿� ��ȸ

-- >> ����Ŭ ���� ����
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME = '�븮';

-- >> ANSI ����
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮';


-------------------------------- �ǽ� ���� ---------------------------------------
-- 1. �μ��� �λ�������� ������� ���, �̸�, ���ʽ� ��ȸ
-->> ����Ŭ ���� ����
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DETP_ID


SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '�λ������';

-- ���� Ǭ ��(SELECT�� DEPT_CODE, DEPT_TITLE�� ��ȸ ���ص� ��) /  ��Ī ���ʿ�..
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
AND DEPT_TITLE = '�λ������';


-->> ANSI ����
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) -- JOIN �̸��� �ٸ� ���
WHERE DEPT_TITLE = '�λ������';

-- ���� Ǭ �� (USING�� ����ؼ� Ʋ����)
--SELECT EMP_ID, EMP_NAME, BONUS, DEPT_CODE, DEPT_TITLE
--FROM EMPLOYEE
--JOIN DEPARTMENT USING(DEPT_ID)
--WHERE DEPT_TITLE = '�λ������';

-- 2. DEPARTMENT�� LOCATION�� �����ؼ� ��ü �μ��� �μ��ڵ�, �μ���, �����ڵ�, ������ ��ȸ
-->> ����Ŭ ���� ����
SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION; -- LOCAL_CODE

SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- ���� Ǭ �� 
--SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
--FROM DEPARTMENT D, LOCATION L
--WHERE D.LOCATION_ID = L.LOCAL_CODE;

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

--------------------------------------------------------------------------------------- ���� ���� 3,4�� �ٽ� Ǯ��
/*
    2. �������� / �ܺ�����
    �� ���̺��� JOIN �� ��ġ���� �ʴ� �ൿ ���Խ��Ѽ� ��ȸ ����
    ��, LEFT / RIGHT�� �ݵ�� �����ؾߵ�!! (������ �Ǵ� ���̺� ����)

*/

-- ���� �ֱ�
-- �����, �μ���, �޿�, ����
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 21�� ���� (������̱� ����)
-- �μ� ��ġ�� ���� �ȵ� ��� 2�� ���� ������ ��ȸ X
-- �μ��� ������ ����� ���� �μ� ���� ��쵵 ��ȸ�� X

-- 1) LEFT [OUTER] JOIN : �� ���̺� �� ���� ����� ���̺� �������� JOIN
-- >> ANSI ���� ( JOIN�� )
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE -- EMPLOYEE�� �ִ°� ������ �� ������ ����
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- �μ���ġ�� ���� �ʾҴ� 2���� ��� ������ ��ȸ��(����ο����� ���� �ȳ����� ����)

-- >> ����Ŭ ���� ���� (WHERE������ ������ ����)
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); -- �������� ����� �ϴ� ���̺��� �ݴ��� �÷� �ڿ� (+)�� ���̱�!

-- 2) RIGHT [OUTER] JOIN : �� ���̺� �� ������ ����� ���̺��� �������� JOIN

-- >> ANSI ����
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- ��� �� �� ���� �ִ� ���� �����µ� RIGHT[OUTER] ������ �ʰ� ���� �ְų� ���� ���� �ְų�

-- >> ����Ŭ ���� ����
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID; -- ���� ������ �ϰ��� ����� �ſ� (+)

-- 3) FULL [OUTER] JOIN : �� ���̺��� ���� ��� ���� ��ȸ�� �� ����.(��, ����Ŭ ���� �������δ� �ȵ�!��)
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

---------------------------------------------------------------------------------------
/*
    3. �� ����(NON EQUAL JOIN) => ��� �����..�߿䵵�� ���� ���� ������� ����
        ��Ī��ų �÷��� ���� ���� �ۼ� �� '=(��ȣ)'�� ������� �ʴ� ���ι�
        ANSI �������δ� JOIN ON�� ��� ����!
*/

SELECT * FROM EMPLOYEE; -- SAL_LEVEL
SELECT * FROM SAL_GRADE; -- SAL_LEVEL

SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE;

SELECT SAL_LEVEL, MIN_SAL, MAX_SAL
FROM SAL_GRADE;

-- �����, �޿�, �ִ� ���� �ѵ�
-- >> ����Ŭ ���� ����
SELECT EMP_NAME, SALARY, MAX_SAL
FROM EMPLOYEE, SAL_GRADE
WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL
AND SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- >> ANSI ���� : JOIN USING(�÷��� �̸��� ������), JOIN ON(�÷��� �̸��� �ٸ���)

---------------------------------------------------------------------------------
/*
    4. ��ü ���� (SELF JOIN)
    ���� ���̺��� �ٽ� �� �� �����ϴ� ���
*/
SELECT * FROM EMPLOYEE;

-- ��ü ����� ���, �����, ����μ��ڵ�, ����� ���, �����, ����μ��ڵ�

SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

-- ��ü ����� ���, �����, ����μ��ڵ�       => EMPLOYEE E => MANAGER_ID
--      ����� ���, �����, ����μ��ڵ�      => EMPLOYEE M => EMP_ID

-- >> ����Ŭ ���� ����
SELECT E.EMP_ID "������", E.EMP_NAME "�����", E.DEPT_CODE "����μ��ڵ�",
       M.EMP_ID "������", M.EMP_NAME "�����", M.DEPT_CODE "����μ��ڵ�"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- >> ANSI ����
SELECT E.EMP_ID "������", E.EMP_NAME "�����", E.DEPT_CODE "����μ��ڵ�",
       M.EMP_ID "������", M.EMP_NAME "�����", M.DEPT_CODE "����μ��ڵ�"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON(E.MANAGER_ID = M.EMP_ID);
--  ����� ���� ����� ������ �ϰ� ������ LEFT JOIN



