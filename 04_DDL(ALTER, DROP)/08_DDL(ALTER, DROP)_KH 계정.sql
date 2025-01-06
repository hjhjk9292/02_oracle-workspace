-- ���� ����

/*
    DDL (DATA DEFINITION LANGUAGE) : ������ ���� ���
    
    ��ü���� ����(CREATE), ����(ALTER), ����(DROP) �ϴ� ����
    
    < ALTER >
    ��ü�� �����ϴ� ����
    
    [ǥ����]
    ALTER TABLE ���̺�� �����ҳ���;
    
    * ������ ����
    1) �÷� �߰� / ���� / ����
    2) �������� �߰� / ���� --> ������ �Ұ� (�����ϰ��� �Ѵٸ� ������ �� ������ �߰�)
    3) �÷��� / �������Ǹ� / ���̺�� ����
*/

-- 1) �÷� �߰� / ���� / ����
-- 1_1) �÷� �߰�(ADD) : ADD �÷��� �ڷ��� [DEFAULT �⺻�� ��������]
-- DEPT_COPY�� CNAME �÷� �߰�
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
-- > ���ο� �÷��� ��������� �⺻�����δ� NULL�� �¿���

-- LNAME �÷� �߰� (�⺻���� ������ä��)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '�ѱ�'; -- DEFAULT�� NULL�� �ƴ� ��

-- 1_2) �÷� ����(MODIFY)
--> �ڷ��� ����      : MODIFY �÷��� �ٲٰ����ϴ� �ڷ���
--> DEFAULT�� ����  : MODIFY �÷��� DEFAULT �ٲٰ����ϴ� �⺻��

ALTER TABLE DEPT_COPY �����ҳ���;
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;
-- �̰� ������!! �̹� �����Ͱ� ���� �ƴѰ͵� �������
-- �����ϴ� �����Ͱ� ����߸� �̷��� �ٲ� �� ����!! 

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);
-- �̰͵� ���� �߻�! (some value is too big)
-- �̹� ����ִ� �����Ͱ� 10����Ʈ���� ŭ!

-- DEPT_TITLE �÷��� VARCHAR2(50) => DEPT_COPY ���̺� �ٲٴ°�!!
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(50);
-- LOCATION_ID �÷��� VARCHAR(4)�� = > 
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR(4);
-- LNAME �÷��� �⺻���� '����'���� ����
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '����';
SELECT * FROM DEPT_COPY; -- ��ȸ�ϸ� '�ѱ�'���� ���´� �� �������� �����Ͱ� '����'���� �� ��

-- ���� ���� ����
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(50)
    MODIFY LOCATION_ID VARCHAR(4)
    MODIFY LNAME DEFAULT '����';

-- 1_3) �÷� ���� (DROP COLUMN) : DROP COLUMN �����ϰ��� �ϴ� �÷���
-- ������ ���� ���纻 ���̺� ����
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY; -- DEPT_COPY ����

SELECT * FROM DEPT_COPY2;

-- DEPT_COPY2�� ���� DEPT_ID�÷� �����
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;

-- DROP COLUMN�� ���� ALTER �ȵ�! �ϳ��ϳ� ���ֱ�!

ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
-- ORA-12983: cannot drop all columns in a table
-- �ּ� �� ���� �÷��� �����ؾߵ�!!

--------------------------------------------------------------------------------
-- 2) �������� �߰� / ����
/*
    2_1)�������� �߰�
    PRIMARY KEY : ADD PRIMARY KEY(�÷���)
    FOREIGN KEY : ADD FOREIGN KEY(�÷���) REFERENCES ������ ���̺�� [(�÷���)]
    UNIQUE : ADD UNIQUE(�÷���)
    CHECK : ADD CHECK(�÷��� ���� ����)
    NOT NULL : MODIFY �÷��� NOT NULL | NULL
    
    �������Ǹ��� �����ϰ��� �Ѵٸ� [CONSTAINT �������Ǹ�] ��������
*/
-- DEPT_ID�� PRIMARY KEY �������� �߰� (ADD ���)
-- DEPT_TITLE�� UNIQUE �������� �߰� ADD
-- LNAME�� NOT NULL �������� �߰� MODIFY

ALTER TABLE DEPT_COPY
    ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
    ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
    MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;

-- 2_2) �������� ���� : DROP CONSTRAINT �������Ǹ�
-- NOT NULL�� ������ �ȵǰ� MODIFY NULL �̰ɷ� ����������Ѵ�.
ALTER TABLE DEPT_COPY �����ҳ���;
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;

ALTER TABLE DEPT_COPY 
    DROP CONSTRAINT DCOPY_UQ
    MODIFY LNAME NULL;

-----------------------------------------------------------------------------
-- 3) �÷��� / �������Ǹ� / ���̺�� ���� (RENAME)
-- 3_1) �÷��� ���� : RENAME COLUMN �����÷��� TO �ٲ��÷���

--DEPT_TITLE ==> DEPT_NAME
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3_2) �������Ǹ� ���� : RENAME CONTRINT �����������Ǹ� TO �ٲ��������Ǹ�;
-- DEPT_COPY ���̺��� SYS_C007228�� DCOPY_DID_NN�� �ٲٱ�
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007228 TO DCOPY_DID_NN;

-- 3_3) ���̺�� ���� : RENAME [�������̺��] TO �ٲ����̺��
-- DEPT_COPY ���̺� �̸��� DEPT_TES�� ����
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

SELECT * FROM DEPT_TEST;

--------------------------------------------------------------------------------
/*
    2. DROP
    ��ü�� �����ϴ� ����
    
    [ǥ����]
    DROP TABLE �����ϰ����ϴ� ���̺��;
*/

-- EMP_NEW ����
DROP TABLE EMP_NEW;

-- �θ����̺��� ������ ���, �׽�Ʈ �� ȯ�� �����
-- 1) DEPT_TEST ���̺� DEPT_ID �÷��� ���� PRIMARY KEY �������� �߰� ��Ű��
ALTER TABLE DEPT_TEST
ADD CONSTRAINT DTEST_PK PRIMARY KEY(DEPT_ID);

-- 2) EMPLOYEE_COPY3�� �÷� �߰� => �ܷ�Ű ��������
ALTER TABLE EMPLOYEE_COPY3
ADD DEPT_CODE CHAR(3);

SELECT * FROM EMPLOYEE_COPY3;

UPDATE EMPLOYEE_COPY3
SET DEPT_CODE = 'D1';

ALTER TABLE EMPLOYEE_COPY3
ADD CONSTRAINT ECOPY_FK FOREIGN KEY(DEPT_CODE) REFERENCES DEPT_TEST; -- �θ� : DEPT_ TEST / �ڽ� : EMPLOYEE_COPY3

DROP TABLE DEPT_TEST;
-- ORA-02449: unique/primary keys in table referenced by foreign keys

-- ��, �����ǰ� �ִ� �θ����̺��� �������� ����
-- ���࿡ �θ����̺��� �����ϰ��� �Ѵٸ�

-- ���1) �ڽ����̺��� ���� ���� �� �θ����̺� ����
DROP TABLE �ڽ����̺�;
DROP TABLE �θ����̺�;

-- ���2) �ڽ����̺��� �ܷ�Ű �������� ���� ��, �θ����̺� �����











