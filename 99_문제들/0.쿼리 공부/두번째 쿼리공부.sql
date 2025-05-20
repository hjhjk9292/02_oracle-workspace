-- �ι�° ��������
------------------------------------ QUIZ1 ------------------------------------
-- ROWNUM�� Ȱ���ؼ� �޿��� ���� ���� 5���� ��ȸ�ϰ� �;�����, ����� ��ȸ�� �ȵ���!!
-- �� �� �ۼ��� SQL���� �Ʒ��� ����
SELECT ROWNUM, EMP_NAME, SALARY --3
FROM EMPLOYEE --1
WHERE ROWNUM <= 5 --2
ORDER BY SALARY DESC; --4
-- � ������ �ִ���, �ذ�� SQL�� �ۼ�!
-- ������ : ORDER BY�� ������ �Ǳ⵵ ���� WHERE������ ROWNUM�� �ο���. ������ �̻��ϰ� �����.

-- ��ġ�� ������
SELECT *
FROM EMPLOYEE
ORDER BY SALARY DESC;

SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC)  -- FROM���� �̹� ������ �� �����͸� �ֱ�)
WHERE ROWNUM <= 5;

---------------------------------- QUIZ2 ----------------------------------------
-- �μ��� ��ձ޿��� 270������ �ʰ��ϴ� �μ��鿡 ���� (�μ��ڵ�, �μ��� �� �޿���, �μ��� ��ձ޿�, �μ��� �����) ��ȸ�Ҳ���
-- �� �� �ۼ��� SQL���� ������ ����
SELECT DEPT_CODE, SUM(SALARY) ����, FLOOR(AVG(SALARY)) ��ձ޿�, COUNT(*) ����� --4
FROM EMPLOYEE --1
WHERE SALARY > 2700000 --2
GROUP BY DEPT_CODE --3
ORDER BY 1; --5

-- � ������ �ִ���, �ذ�� SQL�� �ۼ�!!
SELECT DEPT_CODE, SUM(SALARY) ����, FLOOR(AVG(SALARY)) ��ձ޿�, COUNT(*) ����� 
FROM EMPLOYEE 
WHERE AVG(SALARY) > 2700000  -- "group function is not allowed here"
GROUP BY DEPT_CODE 
ORDER BY 1;

SELECT DEPT_CODE, SUM(SALARY) ����, FLOOR(AVG(SALARY)) ��ձ޿�, COUNT(*) ����� 
FROM EMPLOYEE --1
GROUP BY DEPT_CODE --2 // GROUP BY ���� WHERE �� ���� ����� �̻��ϰ� ���´� (O) /  �׷��Լ������� WHERE���� �ȵȴ� (X)
HAVING AVG(SALARY) > 2700000
ORDER BY 1;

---------------------------------- QUIZ3 ----------------------------------------
-- ������ �޿� ��ȸ �� �� ���޺��� �λ��ؼ� ��ȸ
-- J7�� ����� �޿��� 10% �λ� (SALARY * 1.1)
-- J6�� ����� �޿��� 15% �λ� (SALARY * 1.15)
-- J5�� ����� �޿��� 20% �λ� (SALARY * 1.2)
-- �� ���� ����� �޿��� 5% �λ� (SALARY * 1.05)

SELECT EMP_NAME, JOB_CODE, SALARY,
       DECODE(JOB_CODE, 'J7', SALARY * 1.1, -- JOB_CODE�� 'J7'�� ������� 10% �λ�
                        'J6', SALARY * 1.15,
                        'J5', SALARY * 1.2,
                        SALARY * 1.05) AS "�λ�� �޿�"-- �� �� ������
FROM EMPLOYEE;

-- '25/01/05' �� ���� ���ڿ��� ������ '2025-01-06'���� ǥ���غ���  -- ��¥������ ����Ÿ�� => ����Ÿ�� (���ڿ��� ��¥Ÿ������ �ٲٰ� �� ���ڿ��� �ٲٴ� 2�� ����ȯ)
-- TO_DATE('���ڿ�', [����]) : DATE
-- TO_CHAR(��¥, [����]) : CHARACTER

SELECT TO_CHAR(TO_DATE('25/01/05'), 'YYYY-MM-DD')
FROM DUAL; -- �������̺� �̸�

-- '240106'�� ���� ���ڿ��� ������ 2024�� 1�� 6�� ǥ�� -- 01�� 06���� �ƴ�!!
-- ���۸�!
SELECT TO_CHAR(TO_DATE('240106'), 'YYYY"��" FMMM"��" DD"��"') AS "��¥"
FROM DUAL;

-- SUBSTR �̿��� ���� ��� ( 2024�� 1�� 6�� )
SELECT SUBSTR(TO_CHAR(TO_DATE('240106'), 'YYYY"��" MM"��" DD"��"'), 1, 6)
|| SUBSTR(TO_CHAR(TO_DATE('240106'), 'YYYY"��" MM"��" DD"��"'), 8, 3)
|| SUBSTR(TO_CHAR(TO_DATE('240106'), 'YYYY"��" MM"��" DD"��"'), 12, 2)
FROM DUAL;











