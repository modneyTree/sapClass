*&---------------------------------------------------------------------*
*&  Include           ZPROJECT20_BP_PAI
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
    WHEN 'APND'.
      MESSAGE 'APND' TYPE 'I'.

    CLEAR : GS_MASTER_ALL.
    
    GS_MASTER_ALL-ZLFA1_LIFNR = '0000100'.
    GS_MASTER_ALL-ZLFB1_BUKRS = P_BUKRS.
    GS_MASTER_ALL-ZLFA1_KTOKK = P_KTOKK.

    APPEND GS_MASTER_ALL TO GT_MASTER_ALL.

    WHEN 'SAVE'.
      LOOP AT GT_MASTER_ALL INTO GS_MASTER_ALL.
        MOVE-CORRESPONDING GS_MASTER_ALL TO GS_SAVE1.
        APPEND GS_SAVE1 TO GT_SAVE1.
      ENDLOOP.

      MODIFY ZEDT20_P001 FROM TABLE GT_SAVE1.

      IF SY-SUBRC = 0.
        MESSAGE '저장성공' TYPE 'I'.
      ELSE.
        MESSAGE '저장실패' TYPE 'I'.
      ENDIF.

    ENDCASE.

ENDMODULE.

MODULE EXIT_COMMAND INPUT.
  CASE OK_CODE.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

GS_MASTER_ALL-ZLFA1_LIFNR가 자동 채번되도록 하고 싶어

" 변경
DATA : lv_max_lifnr TYPE ??
SELECT MAX( ZLFA1_LIFNR ) INTO @DATA(lv_max_lifnr) FROM ZEDT20_P001.
IF lv_max_lifnr IS NOT INITIAL.
  lv_max_lifnr = lv_max_lifnr + 1.
ELSE.
  lv_max_lifnr = '0000001'.
ENDIF.
GS_MASTER_ALL-ZLFA1_LIFNR = lv_max_lifnr.


ZLFA1_LIFNR 는 CHAR 11 타입이야 

위 코드 완성시켜줘
