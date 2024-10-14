*&---------------------------------------------------------------------*
*& Report ZEDR20_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_20.

PARAMETERS : P_ZCODE LIKE ZEDT00_001-ZCODE VISIBLE LENGTH 5.




====================================================
*&---------------------------------------------------------------------*
*& Report ZEDR20_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_20.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
PARAMETERS : P_ZCODE LIKE ZEDT00_001-ZCODE VISIBLE LENGTH 5.
PARAMETERS : P_ZPERNR TYPE C LENGTH 10 NO-DISPLAY.
PARAMETERS : P_ZGEN LIKE ZEDT00_001-ZGENDER DEFAULT 'M'.
SELECTION-SCREEN END OF BLOCK B1.



====================================================

*&---------------------------------------------------------------------*
*& Report ZEDR20_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_20.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
PARAMETERS : P_ZCODE LIKE ZEDT00_001-ZCODE VISIBLE LENGTH 5.
PARAMETERS : P_ZPERNR TYPE C LENGTH 10 NO-DISPLAY.
PARAMETERS : P_ZGEN LIKE ZEDT00_001-ZGENDER DEFAULT 'M'.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME.

SELECTION-SCREEN BEGIN OF LINE.
  PARAMETERS : P_R1 RADIOBUTTON GROUP R1 DEFAULT 'X'.
SELECTION-SCREEN POSITION 3.
SELECTION-SCREEN COMMENT (10) FOR FIELD P_R1.
  PARAMETERS : P_R2 RADIOBUTTON GROUP R1.
SELECTION-SCREEN POSITION 20.
SELECTION-SCREEN COMMENT (10) FOR FIELD P_R2.

SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK B2.





======================
*&---------------------------------------------------------------------*
*& Report ZEDR20_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_20.

DATA : GS_STUDENT TYPE ZEDT20_001.
DATA : GT_STUDENT LIKE TABLE OF GS_STUDENT.


SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
PARAMETERS : P_ZCODE LIKE ZEDT00_001-ZCODE VISIBLE LENGTH 5.
PARAMETERS : P_ZPERNR TYPE C LENGTH 10 NO-DISPLAY.
PARAMETERS : P_ZGEN LIKE ZEDT00_001-ZGENDER DEFAULT 'M'.
SELECTION-SCREEN END OF BLOCK B1.

SELECT * FROM ZEDT00_001
  INTO CORRESPONDING FIELDS OF TABLE GT_STUDENT
  WHERE ZCODE = P_ZCODE
  AND ZGENDER = P_ZGEN.

IF GT_STUDENT[] IS NOT INITIAL.
  WRITE :/ '데이터 있음'.
ELSE.
  WRITE :/ '데이터 없음'.
ENDIF.