*&---------------------------------------------------------------------*
*& Report ZEDR00_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR00_TEMP.

"1. DATA선언
DATA : BEGIN OF GS_GRADE.   "구조체 선언
  INCLUDE TYPE ZEDT00_003.  "ZEDT00_003 포함시킨다.
DATA : END OF GS_GRADE.

DATA : GT_GRADE LIKE TABLE OF GS_GRADE. "인터널 테이블을 만든다.

"2. GET DATA
SELECT * FROM ZEDT00_003
INTO CORRESPONDING FIELDS OF TABLE GT_GRADE.    "ZEDT00_003에 있는 내용을 -> 인터널 테이블에?

SORT GT_GRADE BY ZCODE ZPERNR ZEXAM.

"3. MODIFY DATA

"4. WRITE DATA
LOOP AT GT_GRADE INTO GS_GRADE.
  AT FIRST.
    WRITE :/ '--------------------------------------------------------------------------'.
    WRITE :/ '|   학생코드   |          전공명          |장학구분|       납부금액      |'.
    WRITE :/ '--------------------------------------------------------------------------'.
  ENDAT.

ENDLOOP.