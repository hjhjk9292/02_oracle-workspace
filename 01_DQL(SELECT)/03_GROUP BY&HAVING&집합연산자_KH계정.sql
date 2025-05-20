--���� ����
/*
    < GROUP BY �� >
    �׷� ������ ������ �� �ִ� ����(�ش� �׷� ���غ��� ���� �׷����� ���� �� ����)
    �������� ������ �ϳ��� �׷����� ��� ó���� �������� ���
*/

SELECT SUM(SALARY)
FROM EMPLOYEE; -- ��ü ����� �ϳ��� �׷����� ��� ������ ���� ���

-- �� �μ��� �� �޿���
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- �� �μ��� ����� -> �׷����� ���� ���� GROUP BY �ۼ� -> �׷����� ���� DEPT_CODE�� SELECT�� �׻� �ۼ� -> �׷��Լ� ����ϱ�
SELECT DEPT_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- ���� ����
SELECT DEPT_CODE, COUNT(*), SUM(SALARY) -3
FROM EMPLOYEE --1
GROUP BY DEPT_CODE --2
ORDER BY DEPT_CODE; --4

-- �����ڵ庰�� �� �ο���, �޿��� 
SELECT JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- �� ���޺� �� �����, ���ʽ� �޴� �����, �޿���, ��ձ޿�, �����޿�, �ִ�޿�
SELECT JOB_CODE, COUNT(*) AS "�� �����", COUNT(BONUS) AS " ���ʽ��� �޴� �����",
        SUM(SALARY) AS "�޿���", FLOOR(AVG(SALARY)) AS "��ձ޿�",
        MIN(SALARY) AS "�����޿�", MAX(SALARY) AS "�ִ�޿�"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

-- �� ���� �μ�����
SELECT DEPT_CODE, COUNT(*) AS "�� �����", COUNT(BONUS) AS " ���ʽ��� �޴� �����",
        SUM(SALARY) AS "�޿���", FLOOR(AVG(SALARY)) AS "��ձ޿�",
        MIN(SALARY) AS "�����޿�", MAX(SALARY) AS "�ִ�޿�"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

-- GROUP BY ���� �Լ��� ��� ����!
SELECT DECODE(SUBSTR(EMP_NO, 8, 1),'1','��','2','��') AS "����", COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1); -- 8������ 1�ڸ� �ڸ��°�

-- GROUP BY ���� ���� �÷� ��� ���� ( �׷���̴� �׷��Լ��� ���� ���, �׽������� �� ������ �ۼ�)
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE; -- �μ��ڵ尡 ~~�� �� ���� �ڵ尡 $$�� ���

---------------------------------------------------------------------------------
/*
    < HAVING �� >
    �׷쿡 ���� ������ ������ �� ���Ǵ� ���� (�ַ� �׷��Լ����� ������ ������ ������ �� ���)
*/

-- �� �μ��� ��� �޿� ��ȸ
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- �μ��� ��� �޿��� 300���� �̻��� �μ��鸸 ��ȸ
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
WHERE AVG(SALARY) >= 3000000  -- WHERE������ ���������� �׷� �Լ� ��� �Ұ���
GROUP BY DEPT_CODE; -- -- ���� �߻�!(�׷��Լ� ������ ���� ���ý� WHERE�������� �ȵ�!) �ؿ� ����ó�� �غ��� ���

SELECT DEPT_CODE, AVG(SALARY) --4
FROM EMPLOYEE -- 1
GROUP BY DEPT_CODE --2
HAVING AVG(SALARY) >= 3000000; -- 3 // HAVING�� ��ġ�� GROUP BY���� ���� �־ ��� ������ �Ϲ������δ� �̷��� GROUP BY �ؿ� ���

-- �̰Ŵ� �̻��� ������! 
-- ���ʿ� 300���� �̻� �޴� ����鸸 ������ �׷��� �Ἲ�ߴ�. �� ���� ����ó�� �ؾ���
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE --1
WHERE (SALARY) >= 3000000 --2
GROUP BY DEPT_CODE;

-- �μ��� ���ʽ��� �޴� ����� ���� �μ����� ��ȸ
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;
---------------------------------------------------------------------------------
/*
    < SELECT�� ���� ���� >
    5. SELECT * | ��ȸ�ϰ��� �ϴ� �÷� ��Ī | ����� " ��Ī" | �Լ��� AS "��Ī"
    1. FROM ��ȸ�ϰ����ϴ� ���̺��
    2. WHERE ���ǽ�(�����ڵ� ������ ���)
    3. GROUP BY �׷� �������� ���� �÷� | �Լ���
    4. HAVING ���ǽ� (�׷��Լ��� ������ ���)
    6. ORDER BY �÷��� | ��Ī | ���� [ASC | DESC] [NULLS FIRST | NULLS LAST]

*/
---------------------------------------------------------------------------------
/*
    < ���� �Լ� > - �����, ������ ��Ծ ��
    �׷캰 ����� ������� �߰����踦 ������ִ� �Լ�
    
     ROLL UP
     
     => GROUP BY���� ����ϴ� �Լ�
*/

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE) -- �Ѿ� �������� ����(���� �հ� ������)
ORDER BY 1;

---------------------------------------------------------------------------------
/*
    < ���� ������ == SET OPERATION >
    
    �������� �������� ������ �ϳ��� ���������� ����� ������
    
    - UNION         : OR | ������ (�� ������ ������ ������� ���� �� �ߺ��Ǵ� ���� �ѹ��� ����������)
    - INTERSECT     : AND | ������ (�� ������ ������ ������� �ߺ��� �����)
    - UNION ALL     : ������ + ������ (�ߺ��Ǵ� �κ��� �� �� ǥ���� �� ����!!)
    - MINUS         : ���� ��������� ���������� �� ������ (������)    
*/

--1.  UNION
-- �μ��ڵ尡 D5�� ��� �Ǵ� �޿��� 300���� �ʰ��� ����� ��ȸ(���, �̸�, �μ��ڵ�, �޿�)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 6���� (�ڳ���, ������, ���ؼ�, �ɺ���, ������, ���ȥ)

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8�� �� (������, ������, ��ȫö, �����, ������, �ɺ���, ���ȥ, ������)

--1. UNION(������) -- �ɺ���, ���ȥ �ߺ��� �� 12�� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- ���� ������ ��� �Ʒ�ó�� WHERE ���� OR �ᵵ �ذ� ����!!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;

-- 2. INTERSECT(������)
-- �μ��ڵ尡 D5�̸鼭 �޿������� 300���� �ʰ��� ��� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- ���� ������ ��� �Ʒ�ó�� WHERE ���� AND �ᵵ �ذ� ����!!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

---------------------------------------------------------------------------------
-- ���� ������ ���� ����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- �� �������� SELECT���� �ۼ����ִ� �÷� ���� �����ؾߵ�!!

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- �÷� ���� �Ӹ� �ƴ϶� �� �÷� �ڸ����� ������ Ÿ������ ����ؾߵ� (NUBER�� NUMBER, DATE�� DATE // Ÿ�Ը� ������ UNION ��ü�� ����, �ٵ� �� �̻�)

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
ORDER BY EMP_NAME;
-- ORDER BY ���� ���̰��� �Ѵٸ� �������� ����ؾߵ�!!

---------------------------------------------------------------------------------
--3. UNION ALL : �������� ���� ����� ������ �� ���ϴ� ������(�ߺ��� ����!!)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

----------------------------------------------------------------------------------
--4. MINUS : ���� SELECT ������� ���� SELECT ����� �� ������ (������)
-- �μ��ڵ尡 D5�� ����� �� �޿��� 300���� �ʰ��� ������� �����ؼ� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- �Ʒ�ó�� �����ϱ� ��!!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;














