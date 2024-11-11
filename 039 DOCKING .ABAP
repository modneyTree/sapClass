*&---------------------------------------------------------------------*
*& Report ZEDR20_36
*& Report ZEDR20_36
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_36.

INCLUDE ZEDR20_36_TOP.
INCLUDE ZEDR20_36_SCR.
INCLUDE ZEDR20_36_F01.
INCLUDE ZEDR20_36_PBO.
INCLUDE ZEDR20_36_PAI.

INITIALIZATION.
  PERFORM SET_INIT.

AT SELECTION-SCREEN OUTPUT.

START-OF-SELECTION.
  IF S_ZCODE IS INITIAL.
    MESSAGE I000.
    EXIT.
  ENDIF.
  PERFORM GET_DATA.

  IF GT_STUDENT[] IS NOT INITIAL.
    CALL SCREEN 100.
  ELSE.
    MESSAGE I000.
    EXIT.
  ENDIF.