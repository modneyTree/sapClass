*&---------------------------------------------------------------------*
*& Report ZPROJECT20_GR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPROJECT20_GR MESSAGE-ID ZMED20.


INCLUDE ZPROJECT20_GR_CLS.
INCLUDE ZPROJECT20_GR_TOP.
INCLUDE ZPROJECT20_GR_SCR.
INCLUDE ZPROJECT20_GR_F01.
INCLUDE ZPROJECT20_GR_PBO.
INCLUDE ZPROJECT20_GR_PAI.

INITIALIZATION.
  PERFORM SET_INIT.

AT SELECTION-SCREEN OUTPUT.
  PERFORM SET_SCREEN.

START-OF-SELECTION.
  IF ( P_EBELN IS INITIAL ).
    MESSAGE I000.
    EXIT.
  ENDIF.

" 조건
  CASE C_X.
    WHEN P_R1. "
      PERFORM GET_DATA.
*      PERFORM MODIFY_DATA.

      IF GT_PO_ITEM[] IS NOT INITIAL.
        CALL SCREEN 100.
      ELSE.
        MESSAGE I000.
        EXIT.
      ENDIF.
    WHEN P_R2.
*      PERFORM GET_DATA.
**      PERFORM MODIFY_DATA.
**      IF GT_MASTER_ALL[] IS INITIAL.
**        MESSAGE I001.
**        EXIT.
**      ENDIF.
*
*      IF GT_PO_ITEM[] IS NOT INITIAL.
*        CALL SCREEN 200.
*      ELSE.
*        MESSAGE I000.
*        EXIT.
*      ENDIF.
   ENDCASE.