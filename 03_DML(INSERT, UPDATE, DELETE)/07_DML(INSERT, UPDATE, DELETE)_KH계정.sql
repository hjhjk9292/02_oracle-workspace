-- ���� ����
/*
    DQL (QUERY ������ ���� ���) : SELECT
    
    DML (MANIPULATION ������ ���� ���) : [SELECT,] INSERT, UPDATE, DELETE
    DDL (DEFINITION ������ ���� ���) : CREATE, ALTER, DROP
    DCL (CONTROL ������ ���� ���) : GRANT, REVOKE [,COMMIT, ROLLBACK]
    
    TCL (TRANSACTION Ʈ������ ���� ���) : COMMIT, ROLLBACK
    
    < DML : DATA MANIPULATION LANGUAGE >
    ������ ���� ���
    
    ���̺� ���� ����(INSERT)�ϰų�, ����(UPDATE)�ϰų�, ����(DELETE)�ϴ� ����
*/

/*
    1. INSERT
    ���̺� ���ο� ���� �߰��ϴ� ����
    
    [ǥ����]
    1) INSERT INTO ���̺�� VALUES(��1, ��2, ...)
        ���̺� ��� �÷��� ���� ���� ���� �����ؼ� �� �� INSERT �ϰ��� �� �� ���
        �÷������� ���Ѽ� VALUES�� ���� ���� �ؾߵ�!!
        
        �����ϰ� ���� �������� ��� => not enough values ����!
        ���� �� ���� �������� ��� => too many values ����!
*/

INSERT INTO EMPLOYEE
VALUES(900, '������', '900101-1111111', 'cha_00@kh.or.kr', '01011112222', 'D1', 'J7', 'S3', 4000000, 0.2, 200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

/*
    2) INSERT INTO ���̺��(�÷���, �÷���, �÷���) VALUES(��1,��2,��3);
        ���̺� ���� ������ �÷��� ���� ���� INSERT �� �� ���
        �׷��� �� �� ������ �߰� �Ǳ� ������
        ������ �� �� �÷��� �⺻�����δ� NULL ��!
        => NOT NULL ���������� �ɷ��ִ� �÷��� �ݵ�� �����ؼ� ���� �� �����ؾߵ�!
        ��, DEFAULT ���� �ִ� ���� NULL�� �ƴ� DEFAULT ���� ����!
*/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SAL_LEVEL, HIRE_DATE)
VALUES(901, '������', '880202-1111111', 'J1', 'S2', SYSDATE);

SELECT * FROM EMPLOYEE;

-- EMT_YN�� ����Ʈ ������ ������! �������� NULL
-- ���߿� ������Ʈ �� �� �ؿ�ó�� �ۼ��ؼ� ������ ����!

INSERT
  INTO EMPLOYEE
      (
        EMP_ID
      , EMP_NAME
      , EMP_NO
      , JOB_CODE
      , SAL_LEVEL
      , HIRE_DATE
      )
VALUES
      (
        901
      , '������'
      , '880202-1111111'
      , 'J1'
      , 'S2'
      , SYSDATE);

-- �� ���
---------------------------------------------------------------------------------
/*
    3) INSERT INTO ���̺�� (��������);
       VALUES�� �� ���� ����ϴ� �� ��ſ�
       ���������� ��ȸ�� ������� ��°�� INSERT ����! (������ INSERT ����!)
*/

-- ���ο� ���̺� ����
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

-- ��ü ������� ���, �̸�, �μ��� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- ������� �ƴ϶� ���ʿ� �ִ� ���̺� ��ü�� ���´�

INSERT INTO EMP_01 (
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
);

SELECT * FROM EMP_01;

---------------------------------------------------------------------------------
/*
    2. INSERT ALL
*/

-- �켱 �׽�Ʈ �� ���̺� �����
-- ������ �賢��
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
   FROM EMPLOYEE
   WHERE 1 = 0; --������ FALSE�� ����
   
CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
   FROM EMPLOYEE
   WHERE 1 = 0;

SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;

-- �μ��ڵ尡 D1�� ������� ���, �̸�, �μ��ڵ�, �Ի���, ������ ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

/*
    [ǥ����]
    INSERT ALL
    INTO ���̺��1 VALUES(�÷���, �÷���, �÷���, ...)
    INTO ���̺��2 VALUES(�÷���, �÷���, �÷���, ...)
        ��������;
*/

INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';
    
SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;

-- * ������ ����ؼ��� �� ���̺� INSERT ����

-- > 2000�⵵ ���� �Ի��� �Ի��ڵ鿡 ���� ���� ���� ���̺�


-- ���̺� ������ �貸�� ���� �����
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0 ;
   
-- > 2000�⵵ ���� �Ի��� �Ի��ڵ鿡 ���� ���� ���� ���̺�
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0 ;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

/*
    INSERT ALL
    WHEN ����1 THEN
        INTO ���̺��1 VALUES(�÷���, �÷���, ..)
    WHEN ����2 THEN
        INTO ���̺��2 VALUES(�÷���, �÷���, ..)
        ��������;
*/

INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

---------------------------------------------------------------------------------
/*
    3. UPDATE
       ���̺� ��ϵǾ� �ִ� ������ �����͸� �����ϴ� ����
       
       [ǥ����]
       UPDATE ���̺��
       SET �÷��� = �ٲܰ�, 
           �÷��� = �ٲܰ�,
           ...    --> �������� �÷��� ���� ���� ����(,�� �����ؾߵ�!! AND �ƴ�!!)
       [WHERE ����]; --> �����ϸ� ��ü ���� ��� �����Ͱ� ����ȴ�..! �׷��� �� ���Ǿ���! (���������δ� �����ص� ���� ������,, ����!)
*/

-- ���纻 ���̺� ���� �� �۾�
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- D9 �μ��� �μ����� '������ȹ��'���� ����
UPDATE DEPT_COPY
SET DEPT_TITLE = '������ȹ��'; -- ��ü �� ������ȹ������ �����;

ROLLBACK;

UPDATE DEPT_COPY
SET DEPT_TITLE = '������ȹ��' -- �ѹ��� (���� ������ ����صα�)
WHERE DEPT_ID = 'D9';

-- �켱 ���纻 ���� ����
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
    FROM EMPLOYEE;
    
SELECT * FROM EMP_SALARY;

-- �����غ���
-- ���ö ����� �޿��� 100�������� ����!! ������ ���

SELECT * FROM EMP_SALARY
WHERE EMP_NAME = '���ö'; -- 202 3700000 // �ĺ�Ű�� ������������ üũ 

UPDATE EMP_SALARY
SET SALARY = 1000000 --3700000
--WHERE EMP_NAME = '���ö'; -- WHERE ������ �ĺ�Ű�� ġ��!!
WHERE EMP_ID = 202;

-- ������ ����� �޿��� 700�������� ����, ���ʽ��� 0.2�� ����

SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMP_SALARY
WHERE EMP_NAME = '������'; -- 200 ������ 8000000 0.3


UPDATE EMP_SALARY
SET SALARY = 7000000, BONUS = 0.2 -- SALARY = 8700000 / BONUS = 0.3
WHERE EMP_ID = 200;

-- ��ü ����� �޿��� ������ �޿��� 10���� �λ��� �ݾ� (�����޿� * 1.1)
SELECT EMP_NAME, SALARY
FROM EMP_SALARY;

UPDATE EMP_SALARY
SET SALARY = SALARY * 1.1;

-- UPDATE �� ���������� ��� ����

/*
    UPDATE ���̺��
    SET �÷��� = (��������)
    WHERE ����;
*/

-- ���� ����� �޿��� ���ʽ����� ����� ����� �޿��� ���ʽ� ������ ����

SELECT * FROM EMP_SALARY
WHERE EMP_NAME = '����'; -- 1518000 X

-- ������ ��������
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY FROM EMP_SALARY WHERE EMP_NAME = '�����'),  --����Ļ���Ǳ޿�
    BONUS = (SELECT BONUS FROM EMP_SALARY WHERE EMP_NAME = '�����') --����Ļ���Ǻ��ʽ�
WHERE EMP_ID = 214;

-- ���߿� ��������
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME = '�����')--������� ����, ���ʽ�
WHERE EMP_ID = 214;

-- ASIA �������� �ٹ��ϴ� ������� ���ʽ� ���� 0.3���� ����
-- ASIA �������� �ٹ��ϴ� ����� ��ȸ
SELECT EMP_ID
FROM EMP_SALARY
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';

SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;

-- ������ ��������
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID                      -- ������ ���������� IN ��� , = ���� �ϸ� �ȵ�
FROM EMP_SALARY
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%');

SELECT * FROM EMP_SALARY;

--------------------------------------------------------------------------------- UPDATE�� �� �� ���������� �� �� �ִ�
-- UPDATE �ÿ��� �ش� �÷��� ���� �������ǿ� ����Ǹ� �ȵ�!! �������� �����ֱ�!
-- ��� 200���� ����� �̸��� NULL�� ����

UPDATE EMPLOYEE
SET EMP_NAME = NULL -- ������
WHERE EMP_ID = 200;
-- ORA-01407: cannot update ("KH"."EMPLOYEE"."EMP_NAME") to NULL

-- ���ö ����� �����ڵ带 J9�� ����
UPDATE EMPLOYEE
SET JOB_CODE = 'J9'
WHERE EMP_NAME = '���ö';
-- ORA-02291: integrity constraint (KH.SYS_C007149) violated - parent key not found
-- fOREIGN KEY �������� ����!

----------------------------------------------------------------------------------
COMMIT;

/*
    4. DELETE
        ���̺� ��ϵ� �����͸� �����ϴ� ���� (�� �� ������ ������)
        
        [ǥ����]
        DELETE FROM ���̺��
        [WHERE ����]; --> WHERE�� ���� ���ϸ� ��ü �� �� ������ !
*/

-- ������ ����� ������ �����
DELETE FROM EMPLOYEE;

SELECT * FROM EMPLOYEE;
ROLLBACK; -- ������ Ŀ�� �������� ���ư�

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '������';

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '������';

COMMIT;

-- DEPARTMENT ���̺��� DEPT_ID�� D1�� �μ��� ����
SELECT * FROM DEPARTMENT;

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';
-- ORA-02292: integrity constraint (KH.SYS_C007148) violated - child record found
-- �ܷ�Ű �������� 
-- D1�� ���� ������ ���� �ڽĵ����Ͱ� �ֱ� ������ ���� �ȵ�!!

-- D3�� ��� ������ ���� �ڽĵ����Ͱ� ���� ������ ���� ����!!
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3';

ROLLBACK;

-- * TRUNCATE : ���̺��� ��ü ���� ������ �� ����ϴ� ����
--              DELETE ���� ����ӵ��� ����
--              ������ ���� ���� �Ұ�, ROLLBACK �Ұ��ϴ�.
-- [ǥ����] TRUNCATE TABLE ���̺��;

TRUNCATE TABLE EMP_SALARY; -- ���̺��� �״�� �ְ� �����͸� ����

SELECT * FROM EMP_SALARY;
ROLLBACK; -- TRUNCATE �� ROLLBACK �ص� ������ ���� �� ����




