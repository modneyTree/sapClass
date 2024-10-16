*&---------------------------------------------------------------------*
*& Report ZEDR20_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_22.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

PERFORM GET_DATA.

*INCLUDE zedr20_22_get_dataf01.

FORM GET_DATA .
  WRITE :/ 'PERFORM TEST'.

ENDFORM.



"USING 실습
*&---------------------------------------------------------------------*
*& Report ZEDR20_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_22.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

DATA : GV_ZCODE LIKE ZEDT20_001-ZCODE.
DATA : GV_ZKNAME LIKE ZEDT20_001-ZKNAME.

GV_ZCODE = 'SSU-01'.

PERFORM GET_DATA USING GV_ZCODE GV_ZKNAME.

WRITE :/ GV_ZCODE.
WRITE :/ GV_ZKNAME.


FORM GET_DATA USING P_ZCODE P_ZKNAME.

  SELECT SINGLE ZKNAME FROM ZEDT20_001
    INTO P_ZKNAME
    WHERE ZCODE = P_ZCODE.

ENDFORM.


"지역변수
*&---------------------------------------------------------------------*
*& Report ZEDR20_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_22.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

DATA : GV_ZCODE LIKE ZEDT20_001-ZCODE.
DATA : GV_ZKNAME LIKE ZEDT20_001-ZKNAME.

GV_ZCODE = 'SSU-02'.

PERFORM GET_DATA USING GV_ZCODE GV_ZKNAME.

WRITE :/ GV_ZCODE.
WRITE :/ GV_ZKNAME.


FORM GET_DATA USING P_ZCODE P_ZKNAME.
  DATA : LV_ZCODE LIKE ZEDT20_001-ZCODE.
  LV_ZCODE = 'SSU-01'.

  SELECT SINGLE ZKNAME FROM ZEDT20_001
    INTO P_ZKNAME
    WHERE ZCODE = LV_ZCODE.

  P_ZCODE = LV_ZCODE.

ENDFORM.


"USING VALUE
*&---------------------------------------------------------------------*
*& Report ZEDR20_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_22.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

DATA : GV_ZCODE LIKE ZEDT20_001-ZCODE.
DATA : GV_ZKNAME LIKE ZEDT20_001-ZKNAME.

GV_ZCODE = 'SSU-02'.

PERFORM GET_DATA USING GV_ZCODE GV_ZKNAME.

WRITE :/ GV_ZCODE.
WRITE :/ GV_ZKNAME.


FORM GET_DATA USING VALUE(P_ZCODE) P_ZKNAME.
  DATA : LV_ZCODE LIKE ZEDT20_001-ZCODE.
  LV_ZCODE = 'SSU-01'.

  SELECT SINGLE ZKNAME FROM ZEDT20_001
    INTO P_ZKNAME
    WHERE ZCODE = LV_ZCODE.

  P_ZCODE = LV_ZCODE.

ENDFORM.



" TYPE C
*&---------------------------------------------------------------------*
*& Report ZEDR20_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_22.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

DATA : GV_ZCODE LIKE ZEDT20_001-ZCODE.
DATA : GV_ZKNAME LIKE ZEDT20_001-ZKNAME.

GV_ZCODE = 'SSU-01'.

PERFORM GET_DATA USING GV_ZCODE
      CHANGING GV_ZKNAME.

WRITE :/ GV_ZCODE.
WRITE :/ GV_ZKNAME.


FORM GET_DATA USING P_ZCODE TYPE C
      P_ZKNAME TYPE C.

  SELECT SINGLE ZKNAME FROM ZEDT20_001
    INTO P_ZKNAME
    WHERE ZCODE = P_ZCODE.



ENDFORM.



"구조체
" TYPE C 실습
*&---------------------------------------------------------------------*
*& Report ZEDR20_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_22.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

DATA : GV_ZCODE LIKE ZEDT20_001-ZCODE.
DATA : GV_CRDATE LIKE ZEDT20_001-CRDATE.

GS_STUDENT-ZCODE = 'SSU-01'.

PERFORM GET_DATA USING GS_STUDENT.

WRITE :/ GS_STUDENT-ZCODE.
WRITE :/ GS_STUDENT-ZKNAME.


FORM GET_DATA USING PS_STUDENT STRUCTURE GS_STUDENT.

  SELECT SINGLE ZKNAME FROM ZEDT20_001
    INTO PS_STUDENT-ZKNAME
    WHERE ZCODE = PS_STUDENT-ZCODE.

ENDFORM.


" 인터널테이블
" TYPE C 실습
*&---------------------------------------------------------------------*
*& Report ZEDR20_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_22.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.


GS_STUDENT-ZCODE = 'SSU-01'.

PERFORM GET_DATA USING GS_STUDENT GT_STUDENT.

LOOP AT GT_STUDENT INTO GS_STUDENT.
  WRITE :/ GS_STUDENT-ZCODE , GS_STUDENT-ZKNAME.
ENDLOOP.


FORM GET_DATA USING PS_STUDENT STRUCTURE GS_STUDENT PT_STUDENT LIKE GT_STUDENT.

  PS_STUDENT-ZCODE = 'SSU-01'.

  SELECT SINGLE ZKNAME FROM ZEDT20_001
    INTO PS_STUDENT-ZKNAME
    WHERE ZCODE = GS_STUDENT-ZCODE.
    APPEND PS_STUDENT TO PT_STUDENT.

    PS_STUDENT-ZCODE = 'SSU-02'.

    SELECT SINGLE ZKNAME FROM ZEDT20_001
      INTO PS_STUDENT-ZKNAME
      WHERE ZCODE = GS_STUDENT-ZCODE.
      APPEND PS_STUDENT TO PT_STUDENT.


ENDFORM.


"EXTERNAL
" 인터널테이블
" TYPE C 실습
*&---------------------------------------------------------------------*
*& Report ZEDR20_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_22.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.


PERFORM GET_DATA CHANGING GT_STUDENT.

LOOP AT GT_STUDENT INTO GS_STUDENT.
  WRITE :/ GS_STUDENT-ZCODE , GS_STUDENT-ZKNAME.
ENDLOOP.


FORM GET_DATA CHANGING PT_STUDENT LIKE GT_STUDENT.

  DATA : LS_STUDENT LIKE GS_STUDENT.

  LS_STUDENT-ZCODE = 'SSU-01'.

  SELECT SINGLE ZKNAME FROM ZEDT20_001
    INTO LS_STUDENT-ZKNAME
    WHERE ZCODE = LS_STUDENT-ZCODE.
    APPEND LS_STUDENT TO PT_STUDENT.

  LS_STUDENT-ZCODE = 'SSU-02'.

  SELECT SINGLE ZKNAME FROM ZEDT20_001
    INTO LS_STUDENT-ZKNAME
    WHERE ZCODE = LS_STUDENT-ZCODE.
    APPEND LS_STUDENT TO PT_STUDENT.


ENDFORM.



*&---------------------------------------------------------------------*
*& Report ZEDR20_22_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_22_2.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.


PERFORM GET_DATA(ZEDR20_22) IF FOUND CHANGING GT_STUDENT.

LOOP AT GT_STUDENT INTO GS_STUDENT.
  WRITE :/ GS_STUDENT-ZCODE , GS_STUDENT-ZKNAME.
ENDLOOP.