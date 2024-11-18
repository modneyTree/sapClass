*&---------------------------------------------------------------------*
*& Report ZEDR20_013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_013.

DATA : GS_STUDENT TYPE ZEDT20_001.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT WITH NON-UNIQUE KEY ZCODE.

CLEAR : GS_STUDENT, GT_STUDENT.

GS_STUDENT-ZPERNR = '0000000001'.
GS_STUDENT-ZCODE = 'SSU-01'.
GS_STUDENT-ZKNAME = '강동원'.
GS_STUDENT-ZENAME = 'DONG'.
GS_STUDENT-ZGENDER = 'F'.
GS_STUDENT-ZTEL = '01011112222'.
APPEND GS_STUDENT TO GT_STUDENT.

GS_STUDENT-ZENAME = 'KANG'.
GS_STUDENT-ZGENDER = 'M'.

MODIFY TABLE GT_STUDENT FROM GS_STUDENT TRANSPORTING ZGENDER.


BREAK-POINT.
