*&---------------------------------------------------------------------*
*& Report ZEDR20_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_34 MESSAGE-ID ZMED20.

INCLUDE ZEDR20_34_TOP.
INCLUDE ZEDR20_34_SCR.
INCLUDE ZEDR20_34_F01.
INCLUDE ZEDR20_34_PBO.
INCLUDE ZEDR20_34_PAI.

*INITIALIZATION.
*  PERFORM SET_INITIAL.
*
*AT SELECTION-SCREEN OUTPUT.
*  PERFORM SET_SCREEN.

START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM MODIFY_DATA.

  IF GT_STUDENT[] IS NOT INITIAL.
    CALL SCREEN 100.
  ELSE.
    MESSAGE I000.
    EXIT.
  ENDIF.

FORM ALV_SORT .

  CLEAR : GS_SORT, GT_SORT.

*  GS_SORT-SPOS = 1.
*  GS_SORT-FIELDNAME = 'ZCODE'.
*  GS_SORT-UP = 'X'.
*  APPEND GS_SORT TO GT_SORT.

ENDFORM.