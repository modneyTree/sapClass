FORM ALV_HANDLER_DATA_CHANGED USING P_DATA_CHANGED TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                    P_ONF4
                                    P_ONF4_BEFORE
                                    P_ONF4_AFTER
                                    P_UCOMM.

  DATA: LS_MODI    TYPE LVC_S_MODI,
        LV_LEN(2),
        LV_ZMATNR   TYPE CHAR10.   " 변경된 자재번호를 담을 변수
  CLEAR : LS_MODI, LV_LEN.

  LOOP AT P_DATA_CHANGED->MT_GOOD_CELLS INTO LS_MODI.
    READ TABLE GT_PO_INPUT INTO GS_PO_INPUT INDEX LS_MODI-ROW_ID.

    IF LS_MODI-FIELDNAME = 'ZMATNR'.
      LV_ZMATNR = LS_MODI-VALUE.

      IF LV_ZMATNR IS INITIAL.
        " 자재번호가 없으면 빨간색 표시
        GS_PO_INPUT-ZCOLOR = ICON_LED_RED.
      ELSE.
        " 자재 정합성 체크
        SELECT SINGLE ZMATNR FROM ZEDT20P_200
               INTO @DATA(LV_EXIST_MATNR)
               WHERE ZMATNR = @LV_ZMATNR.
        IF sy-subrc = 0.
          " 자재 존재
          GS_PO_INPUT-ZCOLOR = ICON_LED_GREEN.
        ELSE.
          " 자재 미존재
          GS_PO_INPUT-ZCOLOR = ICON_LED_RED.
        ENDIF.
      ENDIF.

      MODIFY GT_PO_INPUT FROM GS_PO_INPUT INDEX LS_MODI-ROW_ID.
      CLEAR GS_PO_INPUT.
    ENDIF.

  ENDLOOP.

  PERFORM REFRESH.

ENDFORM.


위 코드에서 정합성 항목을 추가할거야
납품일 : 증빙일보다 최소한 같거나 뒤여야만 한다
  증빙일은 파라미터로 입력받는다. 