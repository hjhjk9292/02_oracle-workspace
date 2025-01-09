-- 먼저 저장
/*
    < 시퀀스 SEQUENCE >
    자동으로 번호 발생시켜주는 역할을 하는 객체
    정수값을 순차적으로 일정값씩 증가시키면서 생성해줌(기본적으로는 1씩 증가)
    
    EX ) 회원번호, 사원번호, 게시글번호 등 절대 겹쳐서는 안되는 데이터들..    
*/

/*
    1. 시퀀스 객체 생성
    
    [표현식]
    CREATE SEQUENCE 시퀀스명
    
    [상세 표현식]
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작숫자]        -- 처음 발생시킬 시작값 지정 (기본값 1) -- 추후에 못 바꿈, 이미 시작됐기 때문에
    [INCREMENT BY 숫자]         -- 몇 씩 증가시킬 건지 (기본값 1)
    [MAXVALUE 숫자]             -- 최대값 지정 (기본값 겁나큼,, 거의 무한대 999999999999999999999
    [MINVALUE 숫자]             -- 최소값 지정 (기본값 1) => 최대값 찍고 처음부터 다시 돌아와서 시작하게 할 수 있음
    [CYCLE|NOCYCLE]             -- 값 순환 여부 지정 (NOCYCLE)
    [NOCACHE|CACHE 바이트크기]   -- 캐시 메모리 할당 (기본값 CACHE 20)
    
    * 캐시 메모리 : 임시공간
                  미리 발생될 값들을 생성해서 저장해두는 공간
                  매번 호출될 때마다 새로이 번호를 생성하는게 아니라
                  캐시 메모리 공간에 미리 생성된 값들을 가져다 쓸 수 있음 (속도가 빨라짐)
                  접속이 해제되면 => 캐시메모리에 미리 만들어 둔 번호들은 다 날라감
                  번호가 일정하게 부여 안될 수 있으니 확인을 잘 해야함
                  
     테이블명  : TB_
     뷰명     : VW_
     시퀀스    : SEQ_
     트리거    : TRG_
*/

CREATE SEQUENCE SEQ_TEST;

-- [참고] 현재 계정이 소유하고 있는 시퀀스의 구조들을 보고자 할 때
SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

/*
    2. 시퀀스 사용
    시퀀스명.CURRVAL : 현재 시퀀스의 값(마지막으로 성공적으로 수행된 NEXTVAL의 값) / CURRVAL = CURRENT + VALUE
    시퀀스명.NEXTVAL : 시퀀스값에 일정값을 증가시켜서 발생된 값
                      현재 시퀀스 값에서 INCREMENT BY 값 만큼 증가된 값
                      == 시퀀스명.CURRVAL + INCREMENT BY 값
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;                         -- 현재 SEQ_EMPNO에 있는 현재 시퀀스 값을 알려줘
-- ORA-08002: sequence SEQ_EMPNO.CURRVAL is not yet defined in this session
--*Action:   select NEXTVAL from the sequence before selecting CURRVAL

-- NEXTVAL를 단 한번도 수행하지 않는 이상 CURRVAL 할 수 없음!
-- 왜? 마지막으로 성공적으로 수행된 NEXTVAL 값이 CURRVAL 이기 때문!

-- SELECT 여러번 치지 말기!
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 300 : 마지막으로 성공한 NEXVAL의 값

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 지정한 MAXVALUE값(315) 초과했기 때문에 오류 발생! (실패!)
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 310

/*
    3. 시퀀스 구조 변경
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY 숫자]         -- 몇 씩 증가시킬 건지 (기본값 1)
    [MAXVALUE 숫자]             -- 최대값 지정 (기본값 겁나큼,, 거의 무한대 999999999999999999999
    [MINVALUE 숫자]             -- 최소값 지정 (기본값 1) => 최대값 찍고 처음부터 다시 돌아와서 시작하게 할 수 있음
    [CYCLE|NOCYCLE]             -- 값 순환 여부 지정 (NOCYCLE)
    [NOCACHE|CACHE 바이트크기]   -- 캐시 메모리 할당 (기본값 CACHE 20)
    
    ** START WITH는 변경 불가!
*/

ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310 + 10 => 320

-- 4. 시퀀스 삭제
DROP SEQUENCE SEQ_EMPNO;
---------------------------------------------------------------------------------

-- 사원번호로 활용할 시퀀스 생성
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
      , '차은우'
      , '111111-1111111'
      , 'J7'
      , 'S1'
      , SYSDATE
      );                    -- 사번 400 차은우

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
      , '주지훈'                   
      , '222222-2222222'
      , 'J6'
      , 'S1'
      , SYSDATE
      );                    -- 사번 401 차은우


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
        SEQ_EID.NEXTVAL         -- 취업하게 되면 사번은 이런 식으로 입력하게 될 것임
      , ?                       -- ? 는 어떤 사람이 올 지 모르니까
      , ?
      , ?
      , ?
      , SYSDATE
      );




