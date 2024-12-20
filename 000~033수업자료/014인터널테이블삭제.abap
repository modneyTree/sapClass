*&---------------------------------------------------------------------*
*& Report ZEDR20_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_001.

DATA : GS_STUDENT TYPE ZEDT20_001.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

CLEAR : GS_STUDENT, GT_STUDENT.

GS_STUDENT-ZPERNR = '0000000001'.
GS_STUDENT-ZCODE = 'SSU-01'.
GS_STUDENT-ZKNAME = '강동원'.
GS_STUDENT-ZENAME = 'DONG'.
GS_STUDENT-ZGENDER = 'M'.
GS_STUDENT-ZTEL = '01011112222'.
APPEND GS_STUDENT TO GT_STUDENT.

CLEAR : GS_STUDENT.
GS_STUDENT-ZPERNR = '0000000002'.
GS_STUDENT-ZCODE = 'SSU-02'.
GS_STUDENT-ZKNAME = '이제훈'.
GS_STUDENT-ZENAME = 'HOON'.
GS_STUDENT-ZGENDER = 'M'.
GS_STUDENT-ZTEL = '01022223333'.
APPEND GS_STUDENT TO GT_STUDENT.

CLEAR : GS_STUDENT.
GS_STUDENT-ZPERNR = '0000000003'.
GS_STUDENT-ZCODE = 'SSU-32'.
GS_STUDENT-ZKNAME = '손예진'.
GS_STUDENT-ZENAME = 'SON'.
GS_STUDENT-ZGENDER = 'F'.
GS_STUDENT-ZTEL = '01033334444'.
APPEND GS_STUDENT TO GT_STUDENT.

CLEAR : GS_STUDENT.

BREAK-POINT.


----------------------------------------------
*&---------------------------------------------------------------------*
*& Report ZEDR20_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_001.

DATA : GS_STUDENT TYPE ZEDT20_001.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

CLEAR : GS_STUDENT, GT_STUDENT.

GS_STUDENT-ZPERNR = '0000000001'.
GS_STUDENT-ZCODE = 'SSU-01'.
GS_STUDENT-ZKNAME = '강동원'.
GS_STUDENT-ZENAME = 'DONG'.
GS_STUDENT-ZGENDER = 'M'.
GS_STUDENT-ZTEL = '01011112222'.
APPEND GS_STUDENT TO GT_STUDENT.

CLEAR : GS_STUDENT.
GS_STUDENT-ZPERNR = '0000000002'.
GS_STUDENT-ZCODE = 'SSU-02'.
GS_STUDENT-ZKNAME = '이제훈'.
GS_STUDENT-ZENAME = 'HOON'.
GS_STUDENT-ZGENDER = 'M'.
GS_STUDENT-ZTEL = '01022223333'.
APPEND GS_STUDENT TO GT_STUDENT.

CLEAR : GS_STUDENT.
GS_STUDENT-ZPERNR = '0000000003'.
GS_STUDENT-ZCODE = 'SSU-03'.
GS_STUDENT-ZKNAME = '손예진'.
GS_STUDENT-ZENAME = 'SON'.
GS_STUDENT-ZGENDER = 'F'.
GS_STUDENT-ZTEL = '01033334444'.
APPEND GS_STUDENT TO GT_STUDENT.

CLEAR : GS_STUDENT.

LOOP AT GT_STUDENT INTO GS_STUDENT.
  BREAK-POINT.
  IF GS_STUDENT-ZGENDER NE 'M'.
    DELETE TABLE GT_STUDENT FROM GS_STUDENT.

    IF SY-SUBRC = 0.
    ELSE.
      WRITE :/ '삭제실패'.
    ENDIF.
  ELSE.
    WRITE :/ GS_STUDENT-ZCODE, GS_STUDENT-ZKNAME, GS_STUDENT-ZGENDER.
  ENDIF.
ENDLOOP.

BREAK-POINT.