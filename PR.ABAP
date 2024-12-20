WHEN 'SAVE'.
LOOP AT GT_PO_INPUT INTO GS_PO_INPUT.
  MOVE-CORRESPONDING GS_PO_INPUT TO GS_PO_HEAD.

  DATA: LV_EBELN     TYPE ZEDT20_P004-EBELN,
        LV_EBELN_NUM TYPE I.

  " EBELN 최대값 가져오기
  SELECT MAX( EBELN ) INTO LV_EBELN FROM ZEDT20_P004.

  " 초기값 처리
  IF SY-SUBRC <> 0 OR LV_EBELN IS INITIAL.
    LV_EBELN_NUM = 1.
  ELSE.
    LV_EBELN_NUM = LV_EBELN.
    LV_EBELN_NUM = LV_EBELN_NUM + 1.
  ENDIF.

  " 정수를 CHAR10으로 변환
  WRITE LV_EBELN_NUM TO LV_EBELN(10).

  " GS_PO_HEAD에 데이터 대입
  GS_PO_HEAD-EBELN = LV_EBELN.
  GS_PO_HEAD-ZLFB1_BUKRS = P_BUKRS.
  GS_PO_HEAD-LIFNR = P_EKORG.
  GS_PO_HEAD-BEDAT = P_BEDAT.

*        APPEND GS_PO_HEAD TO GT_PO_HEAD.
  MODIFY TABLE GT_PO_HEAD FROM GS_PO_HEAD.
ENDLOOP.

" 헤더 저장
INSERT ZEDT20_P004 FROM TABLE GT_PO_HEAD.

" 아이템 저장



IF SY-SUBRC = 0.
  MESSAGE '저장성공' TYPE 'I'.
ELSE.
  MESSAGE '저장실패' TYPE 'I'.
ENDIF.


GT_PO_INPUT 의 데이터를 ZEDT20_P005에 저장해야한다.