--Ʈ���� �ǽ� ����

--1. �������̺�(�й�, �̸�, ��, ��, ��), �������̺�(�й�, ������, ���, ���) �����
--�������̺� : TB_SCORE
--�������̺� : TB_GRADE

CREATE TABLE TB_SCORE (
    STUDENT_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(50),
    KOR NUMBER,
    ENG NUMBER,
    MATH NUMBER
);

CREATE TABLE TB_GRADE (
    STUDENT_ID NUMBER PRIMARY KEY,
    TOTAL_SCORE NUMBER,
    AVG_SCORE NUMBER,
    RANKING NUMBER
);


--2. �������̺� INSERT �߻��ϸ� �ڵ����� �������̺� INSERT���ִ� Ʈ���� ����
CREATE OR REPLACE TRIGGER TRG_INSERT_GRADE
AFTER INSERT ON TB_SCORE
FOR EACH ROW
BEGIN
    INSERT INTO TB_GRADE (STUDENT_ID, TOTAL_SCORE, AVG_SCORE)
    VALUES (
        :NEW.STUDENT_ID,
        :NEW.KOR + :NEW.ENG + :NEW.MATH,
        (:NEW.KOR + :NEW.ENG + :NEW.MATH) / 3
    );
END;
/



--3. �������̺��� UPDATE�Ǹ� �ش� ����, ����, ���� ������ ���� ����Ŭ �ֿܼ� ��µǴ� Ʈ���� ����
CREATE OR REPLACE TRIGGER TRG_UPDATE_SCORE
AFTER UPDATE OF KOR, ENG, MATH ON TB_SCORE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Updated Scores - KOR: ' || :NEW.KOR || ', ENG: ' || :NEW.ENG || ', MATH: ' || :NEW.MATH);
END;
/


--4. �������̺� INSERT/ UPDATE �Ǹ� ����� �Űܼ� �������ִ� ���ν��� ����(���������)
CREATE OR REPLACE PROCEDURE PROC_UPDATE_RANKING IS
BEGIN
    UPDATE TB_GRADE T
    SET RANKING = (
        SELECT RANK() OVER (ORDER BY TOTAL_SCORE DESC)
        FROM TB_GRADE G
        WHERE G.STUDENT_ID = T.STUDENT_ID
    );
END;
/


--5. ���� ���̺� �л� �����Ͱ� �����Ǹ� ���� ���̺��� �л� ������ ���� + ������ ��� ��� �ű�� Ʈ���� ����
CREATE OR REPLACE TRIGGER TRG_DELETE_SCORE
AFTER DELETE ON TB_SCORE
FOR EACH ROW
BEGIN
    DELETE FROM TB_GRADE WHERE STUDENT_ID = :OLD.STUDENT_ID;
    -- ��� ������Ʈ ���ν��� ȣ��
    PROC_UPDATE_RANKING;
END;
/


--Ʈ���Ÿ� �����~

-- 1. ������ ����
INSERT INTO TB_SCORE (STUDENT_ID, NAME, KOR, ENG, MATH) VALUES (1, 'John Doe', 90, 85, 80);
INSERT INTO TB_SCORE (STUDENT_ID, NAME, KOR, ENG, MATH) VALUES (2, 'Jane Smith', 95, 80, 85);

-- 2. ������ ������Ʈ
UPDATE TB_SCORE SET KOR = 88, ENG = 90, MATH = 84 WHERE STUDENT_ID = 1;

-- 3. ������ ����
DELETE FROM TB_SCORE WHERE STUDENT_ID = 1;

-- 4. ��� Ȯ�� (�������� ����)
EXEC PROC_UPDATE_RANKING;

-- 5. Ȯ��
SELECT * FROM TB_SCORE;
SELECT * FROM TB_GRADE;
