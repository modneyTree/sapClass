*&---------------------------------------------------------------------*
*& Report ZEDR20_PRACTICE003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_PRACTICE003.

"데이터 선언 : 구조체, 인터널 테이블
TABLES : ZEDT20_001.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.

DATA : GT_STUDENT LIKE TABLE OF ZEDT20_001.

RANGES GR_ZCODE FOR ZEDT00_001-ZCODE.

"RAGNE 설정하기
GR_ZCODE-SIGN = 'I'.
GR_ZCODE-OPTION = 'BT'.
GR_ZCODE-LOW = 'SSU-90'.
GR_ZCODE-HIGH = 'SSU-99'.
APPEND GR_ZCODE.

"1 SSU90 ~ 99 데이터 가져오기
SELECT * FROM ZEDT00_001
  INTO CORRESPONDING FIELDS OF TABLE GT_STUDENT
  WHERE ZCODE IN GR_ZCODE.

"2 FUNCTION 을 이용해서 ZPERNR이 자리수 맞게 0 채워지도록 변경


"3 INSERT ZEDT20_001(데이터 베이스 변경
MODIFY ZEDT20_001 FROM TABLE GT_STUDENT.

IF SY-SUBRC = 0.
  WRITE :/ '성공!'.
ENDIF.



" FUCTION 다루기