*&---------------------------------------------------------------------*
*& Report ZPROJECT20_IR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPROJECT20_IR MESSAGE-ID ZMED20.


INCLUDE ZPROJECT20_IR_CLS.
INCLUDE ZPROJECT20_IR_TOP.
INCLUDE ZPROJECT20_IR_SCR.
INCLUDE ZPROJECT20_IR_F01.
INCLUDE ZPROJECT20_IR_PBO.
INCLUDE ZPROJECT20_IR_PAI.

INITIALIZATION.
  PERFORM SET_INIT.

AT SELECTION-SCREEN OUTPUT.
  PERFORM SET_SCREEN.

START-OF-SELECTION.
  IF ( P_EBELN IS INITIAL AND P_EBELN2 IS INITIAL ).
    MESSAGE I000.
    EXIT.
  ENDIF.

" 조건
  CASE C_X.
    WHEN P_R1. "
      PERFORM GET_DATA.
*      PERFORM MODIFY_DATA.

      IF GT_PO_OUTPUT_ALV[] IS NOT INITIAL.
        CALL SCREEN 100.
      ELSE.
        MESSAGE I000.
        EXIT.
      ENDIF.
    WHEN P_R2.
      PERFORM GET_DATA2.
      "PERFORM MODIFY_DATA.
      "IF GT_PO_OUTPUT_ALV[] IS INITIAL.
       " MESSAGE I001.
        "EXIT.
      "ENDIF.

      IF GT_IR_OUTPUT_ALV[] IS NOT INITIAL.
        CALL SCREEN 200.
      ELSE.
        MESSAGE I000.
        EXIT.
      ENDIF.
   ENDCASE.