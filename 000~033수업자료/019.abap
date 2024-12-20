

*&---------------------------------------------------------------------*
*& Report ZEDR20_019
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_019.

RANGES GR_SCARR FOR SCARR-CARRID.

DATA : BEGIN OF GS_SCARR,
  ZCHECK TYPE C,
      CARRID LIKE SCARR-CARRID,
      CARRNAME LIKE SCARR-CARRNAME,
      END OF GS_SCARR.
DATA : GT_SCARR LIKE TABLE OF GS_SCARR.

GR_SCARR-SIGN = 'I'.
GR_SCARR-OPTION = 'BT'.
GR_SCARR-LOW = 'AA'.
GR_SCARR-HIGH = 'AC'.

APPEND GR_SCARR.


GR_SCARR-LOW = 'AD'.
GR_SCARR-HIGH = 'AZ'.
APPEND GR_SCARR.

SELECT CARRID
  CARRNAME
  FROM SCARR
  INTO CORRESPONDING FIELDS OF TABLE GT_SCARR
  WHERE CARRID IN GR_SCARR.

LOOP AT GT_SCARR INTO GS_SCARR.
  WRITE :/ GS_SCARR-CARRID, GS_SCARR-CARRNAME.
ENDLOOP.

BREAK-POINT.




"--------------------------------------------
REPORT ZEDR20_019.

*RANGES GR_SCARR FOR SCARR-CARRID.
RANGES GR_STUDENT FOR ZEDT20_001-ZCODE.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_001.
DATA : END OF GS_STUDENT.

DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.

GR_STUDENT-SIGN = 'I'.
GR_STUDENT-OPTION = 'BT'.
GR_STUDENT-LOW = 'SSU-01'.
GR_STUDENT-LOW = 'SSU-09'.
APPEND GR_STUDENT.

SELECT *
  FROM ZEDT20_001
  INTO CORRESPONDING FIELDS OF TABLE GT_STUDENT.


LOOP AT GT_STUDENT INTO GS_STUDENT.
  WRITE :/ GS_STUDENT-ZCODE.
ENDLOOP.

*BREAK-POINT.