-- ���� ����
/*
    < ������ SEQUENCE >
    �ڵ����� ��ȣ �߻������ִ� ������ �ϴ� ��ü
    �������� ���������� �������� ������Ű�鼭 ��������(�⺻�����δ� 1�� ����)
    
    EX ) ȸ����ȣ, �����ȣ, �Խñ۹�ȣ �� ���� ���ļ��� �ȵǴ� �����͵�..    
*/

/*
    1. ������ ��ü ����
    
    [ǥ����]
    CREATE SEQUENCE ��������
    
    [�� ǥ����]
    CREATE SEQUENCE ��������
    [START WITH ���ۼ���]        -- ó�� �߻���ų ���۰� ���� (�⺻�� 1) -- ���Ŀ� �� �ٲ�, �̹� ���۵Ʊ� ������
    [INCREMENT BY ����]         -- �� �� ������ų ���� (�⺻�� 1)
    [MAXVALUE ����]             -- �ִ밪 ���� (�⺻�� �̳�ŭ,, ���� ���Ѵ� 999999999999999999999
    [MINVALUE ����]             -- �ּҰ� ���� (�⺻�� 1) => �ִ밪 ��� ó������ �ٽ� ���ƿͼ� �����ϰ� �� �� ����
    [CYCLE|NOCYCLE]             -- �� ��ȯ ���� ���� (NOCYCLE)
    [NOCACHE|CACHE ����Ʈũ��]   -- ĳ�� �޸� �Ҵ� (�⺻�� CACHE 20)
    
    * ĳ�� �޸� : �ӽð���
                  �̸� �߻��� ������ �����ؼ� �����صδ� ����
                  �Ź� ȣ��� ������ ������ ��ȣ�� �����ϴ°� �ƴ϶�
                  ĳ�� �޸� ������ �̸� ������ ������ ������ �� �� ���� (�ӵ��� ������)
                  ������ �����Ǹ� => ĳ�ø޸𸮿� �̸� ����� �� ��ȣ���� �� ����
                  ��ȣ�� �����ϰ� �ο� �ȵ� �� ������ Ȯ���� �� �ؾ���
                  
     ���̺��  : TB_
     ���     : VW_
     ������    : SEQ_
     Ʈ����    : TRG_
*/

CREATE SEQUENCE SEQ_TEST;

-- [����] ���� ������ �����ϰ� �ִ� �������� �������� ������ �� ��
SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

/*
    2. ������ ���
    ��������.CURRVAL : ���� �������� ��(���������� ���������� ����� NEXTVAL�� ��) / CURRVAL = CURRENT + VALUE
    ��������.NEXTVAL : ���������� �������� �������Ѽ� �߻��� ��
                      ���� ������ ������ INCREMENT BY �� ��ŭ ������ ��
                      == ��������.CURRVAL + INCREMENT BY ��
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;                         -- ���� SEQ_EMPNO�� �ִ� ���� ������ ���� �˷���
-- ORA-08002: sequence SEQ_EMPNO.CURRVAL is not yet defined in this session
--*Action:   select NEXTVAL from the sequence before selecting CURRVAL

-- NEXTVAL�� �� �ѹ��� �������� �ʴ� �̻� CURRVAL �� �� ����!
-- ��? ���������� ���������� ����� NEXTVAL ���� CURRVAL �̱� ����!

-- SELECT ������ ġ�� ����!
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 300 : ���������� ������ NEXVAL�� ��

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- ������ MAXVALUE��(315) �ʰ��߱� ������ ���� �߻�! (����!)
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 310

/*
    3. ������ ���� ����
    ALTER SEQUENCE ��������
    [INCREMENT BY ����]         -- �� �� ������ų ���� (�⺻�� 1)
    [MAXVALUE ����]             -- �ִ밪 ���� (�⺻�� �̳�ŭ,, ���� ���Ѵ� 999999999999999999999
    [MINVALUE ����]             -- �ּҰ� ���� (�⺻�� 1) => �ִ밪 ��� ó������ �ٽ� ���ƿͼ� �����ϰ� �� �� ����
    [CYCLE|NOCYCLE]             -- �� ��ȯ ���� ���� (NOCYCLE)
    [NOCACHE|CACHE ����Ʈũ��]   -- ĳ�� �޸� �Ҵ� (�⺻�� CACHE 20)
    
    ** START WITH�� ���� �Ұ�!
*/

ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310 + 10 => 320

-- 4. ������ ����
DROP SEQUENCE SEQ_EMPNO;
---------------------------------------------------------------------------------

-- �����ȣ�� Ȱ���� ������ ����
CREATE SEQUENCE SEQ_EID
START WITH 400
NOCACHE;

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
        SEQ_EID.NEXTVAL
      , '������'
      , '111111-1111111'
      , 'J7'
      , 'S1'
      , SYSDATE
      );                    -- ��� 400 ������

SELECT * FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;


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
        SEQ_EID.NEXTVAL         
      , '������'                   
      , '222222-2222222'
      , 'J6'
      , 'S1'
      , SYSDATE
      );                    -- ��� 401 ������


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
        SEQ_EID.NEXTVAL         -- ����ϰ� �Ǹ� ����� �̷� ������ �Է��ϰ� �� ����
      , ?                       -- ? �� � ����� �� �� �𸣴ϱ�
      , ?
      , ?
      , ?
      , SYSDATE
      );




