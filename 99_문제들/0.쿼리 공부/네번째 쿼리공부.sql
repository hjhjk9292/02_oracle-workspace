-- ���� ����
SELECT DEPT_CODE, SUM(SALARY) --JOB_CODE, SALARY
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- ���� : JOB_CODE, SALARY �÷��� GROUP BY�� �������� �ʰ�, GROUP BY ��� �� �׷��Լ��� �Բ� ����ϴµ� �׷��� �ʾҴ�...
-- ��ġ���� : SELECT ����� GROUP BY�� ��ġ���� �����Ƿ� ������ �ʿ���
-- GROUP BY�� ������ GROUP BY�� ���õ� �͸� ������

SELECT DEPT_CODE, JOB_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
-- GROUP BY�� ���� ���� �ݵ�� SELECT���� ���;���. �׸��� �׷��Լ��� ���� ��ߵȴ�.
-- GROUP BY�� �������� ������ ���� ���� / GROUP BY�� ���� ���� SELECT�� �������־����

--���ν����� ������ ����!