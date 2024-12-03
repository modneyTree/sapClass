*&---------------------------------------------------------------------*
*&  Include           ZPROJECT20_PO_PAI
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
    WHEN 'APND'.
      MESSAGE 'APND' TYPE 'I'.

      CLEAR : GS_MASTER_ALL.

      " 현재 최대 LIFNR 값 가져오기
      DATA: lv_lifnr TYPE zedt20_p001-zlfa1_lifnr.
      SELECT MAX( zlfa1_lifnr ) INTO lv_lifnr FROM zedt20_p001.

      IF lv_lifnr IS INITIAL.
        lv_lifnr = '0000000000'.
      ENDIF.

      " 다음 LIFNR 값 계산
      DATA: lv_lifnr_num TYPE i.
      lv_lifnr_num = lv_lifnr.
      lv_lifnr_num = lv_lifnr_num + 1.
      lv_lifnr = lv_lifnr_num.

      " 자리수 포맷팅 (예: 10자리)
      lv_lifnr = lv_lifnr+0(10).

      GS_MASTER_ALL-ZLFA1_LIFNR = lv_lifnr.
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

      " 두 번째 TABE에 집어 넣기
      LOOP AT GT_MASTER_ALL INTO GS_MASTER_ALL.
        MOVE-CORRESPONDING GS_MASTER_ALL TO GS_SAVE2.
        APPEND GS_SAVE2 TO GT_SAVE2.
      ENDLOOP.

      MODIFY ZEDT20_P002 FROM TABLE GT_SAVE2.

      " 세 번째 TABE에 집어 넣기
      LOOP AT GT_MASTER_ALL INTO GS_MASTER_ALL.
        MOVE-CORRESPONDING GS_MASTER_ALL TO GS_SAVE3.
        GS_SAVE3-ZLFM1_LIFNR = GS_MASTER_ALL-ZLFA1_LIFNR.
        APPEND GS_SAVE3 TO GT_SAVE3.
      ENDLOOP.

      MODIFY ZEDT20_P003 FROM TABLE GT_SAVE3.

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


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.

ENDMODULE.