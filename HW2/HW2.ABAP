*&---------------------------------------------------------------------*
*& Report ZEDR20_HW002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_HW002 MESSAGE-ID ZMED20.

INCLUDE ZEDR20_HW002_TOP.
INCLUDE ZEDR20_HW002_SCR.
INCLUDE ZEDR20_HW002_F01.
INCLUDE ZEDR20_HW002_PBO.
INCLUDE ZEDR20_HW002_PAI.

*****3. 초기값 설정
INITIALIZATION.
  PERFORM SET_INIT.


*****4. 스크린 제어
AT SELECTION-SCREEN OUTPUT.
  PERFORM SET_SCREEN.

*****5. MAIN PROGRAM
START-OF-SELECTION.
  PERFORM CHECK_DATA.

  CASE C_X.
    WHEN P_R1. "주문내역
      PERFORM GET_DATA_R1.
      IF GT_ORDER[] IS INITIAL.
        MESSAGE I001.
        EXIT.
      ENDIF.
      PERFORM MODIFY_DATA_R1.

      IF GT_ORDER_ALV[] IS NOT INITIAL.
        CALL SCREEN 100.
      ELSE.
        MESSAGE I000.
        EXIT.
      ENDIF.
    WHEN P_R2.
      PERFORM GET_DATA_R2.
      IF GT_DELEVER[] IS INITIAL.
        MESSAGE I001.
        EXIT.
      ENDIF.
      PERFORM MODIFY_DATA_R2.

      IF GT_DELEVER_ALV[] IS NOT INITIAL.
        CALL SCREEN 200.
      ELSE.
        MESSAGE I000.
        EXIT.
      ENDIF.
  ENDCASE.

*  PERFORM GET_DATA.