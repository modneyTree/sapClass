"에러잡기

*&---------------------------------------------------------------------*
*& Report ZEDR20_019
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_019.

*RANGES GR_SCARR FOR SCARR-CARRID.
RANGES GR_STUDENT FOR ZEDT20_001-ZCODE.

DATA : BEGIN OF GS_STUDENT,
  INCLUDE TYPE ZEDT20_001.
  DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

GR_STUDENT-SIGN = 'I'.
GR_STUDENT-OPTION = 'BT'.
GR_STUDENT-LOW = 'SSU-01'.
GR_STUDENT-LOW = 'SSU-09'.
APPEND GR_STUDENT.

*SELECT CARRID
*  CARRNAME
*  FROM SCARR
*  INTO CORRESPONDING FIELDS OF TABLE GT_SCARR
*  WHERE CARRID IN GR_SCARR.

SELECT ZCODE
  FROM ZEDT20_001
  INTO CORRESPONDING FIELDS OF TABLE GT_STUDENT.


LOOP AT GT_STUDENT INTO GS_STUDENT.
  WRITE :/ GS_STUDENT-ZCODE.
ENDLOOP.

BREAK-POINT.

==========================================================================
에러 해결 부분
*&---------------------------------------------------------------------*
*& Report ZEDR20_019
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_019.

* RANGES 선언
RANGES GR_STUDENT FOR ZEDT20_001-ZCODE.

* GS_STUDENT 구조 선언
DATA : BEGIN OF GS_STUDENT,
  ZCODE TYPE ZEDT20_001-ZCODE. " ZCODE 필드를 명시적으로 선언
  "다른 필드들도 필요하면 여기에 추가
DATA : END OF GS_STUDENT.

* 테이블 GT_STUDENT 선언
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

* RANGES 범위 설정
GR_STUDENT-SIGN = 'I'.
GR_STUDENT-OPTION = 'BT'.
GR_STUDENT-LOW = 'SSU-01'.
GR_STUDENT-HIGH = 'SSU-09'.
APPEND GR_STUDENT.

* ZEDT20_001 테이블에서 데이터를 조회
SELECT ZCODE
  FROM ZEDT20_001
  INTO CORRESPONDING FIELDS OF TABLE GT_STUDENT
  WHERE ZCODE IN GR_STUDENT.

* 테이블에 있는 데이터 출력
LOOP AT GT_STUDENT INTO GS_STUDENT.
  WRITE :/ GS_STUDENT-ZCODE.
ENDLOOP.

BREAK-POINT.