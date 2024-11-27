*&---------------------------------------------------------------------*
*& Report ZEDR20_37
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_37 MESSAGE-ID ZMED20.

INCLUDE ZEDR20_37_TOP.
INCLUDE ZEDR20_37_SCR.
INCLUDE ZEDR20_37_F01.
INCLUDE ZEDR20_37_PBO.
INCLUDE ZEDR20_37_PAI.

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