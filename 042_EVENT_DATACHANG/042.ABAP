*&---------------------------------------------------------------------*
*& Report ZEDR20_042
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_042 MESSAGE-ID ZMED20.

INCLUDE ZEDR20_042_CLS.
INCLUDE ZEDR20_042_TOP.
INCLUDE ZEDR20_042_SCR.
INCLUDE ZEDR20_042_F01.
INCLUDE ZEDR20_042_PBO.
INCLUDE ZEDR20_042_PAI.

INITIALIZATION.
  PERFORM SET_INIT.

AT SELECTION-SCREEN OUTPUT.

START-OF-SELECTION.
  PERFORM GET_DATA.

  IF GT_STUDENT[] IS NOT INITIAL.
    CALL SCREEN 100.
  ENDIF.