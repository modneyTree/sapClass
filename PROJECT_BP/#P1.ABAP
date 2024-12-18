*&---------------------------------------------------------------------*
*& Report ZPROJECT20_BP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPROJECT20_BP MESSAGE-ID ZMED20.


INCLUDE ZPROJECT20_BP_CLS.
INCLUDE ZPROJECT20_BP_TOP.
INCLUDE ZPROJECT20_BP_SCR.
INCLUDE ZPROJECT20_BP_F01.
INCLUDE ZPROJECT20_BP_PBO.
INCLUDE ZPROJECT20_BP_PAI.

INITIALIZATION.
  PERFORM SET_INIT.

AT SELECTION-SCREEN OUTPUT.
  PERFORM SET_SCREEN.

START-OF-SELECTION.
  IF ( P_BUKRS IS INITIAL ) OR ( P_KTOKK IS INITIAL ).
    MESSAGE I000.
    EXIT.
  ENDIF.

  IF ( P_KTOKK = '3000' ).
    " 개인번호가(LFA1-STCD1)가 보인다.

  ELSEIF ( P_KTOKK = '2000' ).
    " 2000클릭시에는 LFA1-STCD1 , STCD2필드가 보이면 안됨
  ENDIF.

  CASE C_X.
    WHEN P_R1. "
      PERFORM MAKE_DATA.
      IF GT_MASTER_ALL[] IS INITIAL.
        MESSAGE I001.
        EXIT.
      ENDIF.

      IF GT_MASTER_ALL[] IS NOT INITIAL.
        CALL SCREEN 100.
      ELSE.
        MESSAGE I000.
        EXIT.
      ENDIF.
    WHEN P_R2.
*      PERFORM MAKE_DATA.
      PERFORM GET_DATA.
*      PERFORM MODIFY_DATA.
*      IF GT_MASTER_ALL[] IS INITIAL.
*        MESSAGE I001.
*        EXIT.
*      ENDIF.

      IF GT_MASTER_ALL[] IS NOT INITIAL.
        CALL SCREEN 200.
      ELSE.
        MESSAGE I000.
        EXIT.
      ENDIF.
   ENDCASE.