*&---------------------------------------------------------------------*
*& Report ZEDR20_39
*& Report ZEDR20_39
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_39 MESSAGE-ID ZMED20.

INCLUDE ZEDR20_39_CLS.
INCLUDE ZEDR20_39_TOP.
INCLUDE ZEDR20_39_SCR.
INCLUDE ZEDR20_39_F01.
INCLUDE ZEDR20_39_PBO.
INCLUDE ZEDR20_39_PAI.

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