-- QUIZ1 (DCL ����)
-- CREATE USER TEST IDENTIFIED BY 1234; ����
-- User TEST��(��) �����Ǿ����ϴ�.
-- ���� ������ �ϰ� ���� �� ����

-- �� ������ ������? �ذ� ���
-- ������ : ���� ������ �߰� ���� ������ �ο����� �ʾұ� ������
-- GRANT CONNECT, RESOURCE TO TEST; -- CONNECT : ����(ROLE) // �������� ���� ����� ������
-- GRANT CREATE SESSTION TO TEST; -- CREATE SESSION : ������ �� �ִ� ���� // �������� ���� ���� ���� ���� �̸����� �ۼ��Ͻÿ�. ��� ���� ��

-- QUIZ(JOIN ����)
CREATE TABLE TB_JOB(
    JOBCODE NUMBER PRIMARY KEY,
    JOBNAME VARCHAR2(10) NOT NULL
);

CREATE TABLE TB_EMP(
    EMPNO NUMBER PRIMARY KEY,
    EMPNAME VARCHAR2(10) NOT NULL,
    JOBNO NUMBER REFERENCES TB_JOB(JOBCODE)    
);

-- ���� �� ���̺��� �ִٴ� �����Ͽ�
-- �� ���̺� �����ؼ� EMPNO, EMPNAME, JOBNO, JOBNAME �÷��� ��ȸ�Ұ���
-- �� �� ������ SQL��

SELECT EMPNO, EMPNAME, JOBNO, JOBNAME
FROM TB_EMP
JOIN TB_JOB USING(JOBNO);
-- ����
-- ORA-00904: "TB_JOB"."JOBNO": invalid identifier

-- ������ : JOBNO �÷��� TB_EMP���� ����������, TB_JOB���� �������� �ʱ� ������ USING ������ ���� ����
-- �ذ᳻�� : USING(JOBNO)�� �ƴ϶� ON�� (JOBNO = JOBCODE)�� ����Ѵ�

SELECT EMPNO, EMPNAME, JOBNO, JOBNAME
FROM TB_EMP
JOIN TB_JOB ON (JOBNO = JOBCODE);

---------------------------------------------------------------------------------
-- ���̺� ���� ���� �ؼ� ������ Ÿ�� (CHAR, VARCHAR2 ������) �� �������� 2000BYTE, �������� 4000BYTE
-- ����Ŭ ��ü (SEQUENCE, TABLE, VIEW) ���� ����..
-- �������� => �ڴʰ� ���������� �߰��� �� �ִ� ALTER ��
-- DCL�� ����?
-- Ŀ�� �ѹ� ����?(TCL)

-- QUIZ3(JOIN ����)
-- �Ʒ��� SQL ������ �μ��� ���� �հ谡 15,000,000�� �ʰ��ϴ� �μ��� ��ȸ�� ���̴�.
-- ����� �ùٸ��� �ʴٰ� �� ��, �� ���ΰ� ��ġ����

SELECT DEPT_CODE, SUM(SALARY) --4
FROM EMPLOYEE --1
WHERE SALARY >= 15000000 --2
GROUP BY DEPT_CODE; --3

-- GROUP BY�� �� ���� WHERE���� �ȵȴ�. (X)
-- GROUP�� ���� ������ ������ ���� WHERE���� ���°� �ƴϴ�. => HAVING

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 15000000;

-- QUIZ4 (�������� ����)
CREATE TABLE QUIZ4(
    QNO NUMBER PRIMARY KEY,
    QNAME VARCHAR2(10),
    SCORE NUMBER
);

SELECT * FROM QUIZ4;

INSERT INTO QUIZ4 VALUES(1, '����1��', 30);
INSERT INTO QUIZ4 VALUES(1, '����2��', 50); -- PRIMARY ���������� �ߺ���, NULL�� �� ��

-- ������ �ֳ���~~~
-- ��ġ�غ�~~


-- CASE WHEN
-- SALARY�� 500 �̻��̸� ��ް�����
--          300 �̻��̸� �߱ް�����
--                      �ʱް����� (DECODE�� �ƴ϶� CASE WHEN���� Ǫ�ÿ�.)

SELECT EMP_NAME, SALARY,
        CASE WHEN SALARY >= 5000000 THEN '��� ������'
             WHEN SALARY >= 3000000 THEN '�߱� ������'
             ELSE '�ʱ� ������'
        END AS "����" -- END �� ���ֱ�
FROM EMPLOYEE;