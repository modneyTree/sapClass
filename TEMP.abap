FORM GOOD_DATA .

    DATA: LV_ZMBLNR     TYPE ZEDT20_P006-ZMBLNR,
          LV_ZMBLNR_NUM TYPE I.
  
    " 1) ZMBLNR 최대값 가져오기
    SELECT MAX( ZMBLNR ) INTO LV_ZMBLNR FROM ZEDT20_P006.
  
    IF SY-SUBRC <> 0 OR LV_ZMBLNR IS INITIAL.
      LV_ZMBLNR_NUM = 1.
    ELSE.
      LV_ZMBLNR_NUM = LV_ZMBLNR.
      LV_ZMBLNR_NUM = LV_ZMBLNR_NUM + 1.
    ENDIF.
  
    " 정수를 문자열로 변환 (길이 10 가정)
    WRITE LV_ZMBLNR_NUM TO LV_ZMBLNR(10).
  
    " ALPHA 변환 (0000000001 형태로 맞추기 위해)
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = LV_ZMBLNR
      IMPORTING
        OUTPUT = LV_ZMBLNR.
  
    " 부분 입고 구현 : GS_PO_OUTPUT_ALV 의 해당 줄을 제거한다.
    " ZCHECKBOX = 'X'인 경우 -> 입고 헤더와 아이템 테이블에 저장
    LOOP AT GT_PO_OUTPUT_ALV INTO GS_PO_OUTPUT_ALV WHERE ZCHECKBOX = 'X'.
  
      " 1. 입고 헤더 데이터 저장
      CLEAR GS_GR_HEAD_SAVE.
      GS_GR_HEAD_SAVE-ZMBLNR = LV_ZMBLNR.
      GS_GR_HEAD_SAVE-ZMJAHR = SY-DATUM(4).    " 입고연도
      GS_GR_HEAD_SAVE-ZBLART = 'WE'.           " 전표유형
      GS_GR_HEAD_SAVE-ZBLDAT = SY-DATUM.       " 증빙일
      GS_GR_HEAD_SAVE-ZBUDAT = SY-DATUM.       " 전기일
      APPEND GS_GR_HEAD_SAVE TO GT_GR_HEAD_SAVE.
  
      " 2. 입고 아이템 데이터 저장
      CLEAR GS_GR_ITEM_SAVE.
      GS_GR_ITEM_SAVE-ZMBLNR = LV_ZMBLNR.      " 자동 채번한 입고문서번호
      GS_GR_ITEM_SAVE-ZMJAHR = SY-DATUM(4).    " 회계연도
      GS_GR_ITEM_SAVE-EBELP  = GS_PO_OUTPUT_ALV-EBELP.
      GS_GR_ITEM_SAVE-ZMATNR = GS_PO_OUTPUT_ALV-ZMATNR.
      GS_GR_ITEM_SAVE-ZWERKS = GS_PO_OUTPUT_ALV-ZWERKS.
      GS_GR_ITEM_SAVE-ZLGORT = GS_PO_OUTPUT_ALV-ZLGORT.
      GS_GR_ITEM_SAVE-MENGE  = GS_PO_OUTPUT_ALV-MENGE.
      GS_GR_ITEM_SAVE-MEINS  = GS_PO_OUTPUT_ALV-ZMEINS.
      APPEND GS_GR_ITEM_SAVE TO GT_GR_ITEM_SAVE.
  
    ENDLOOP.
  
    " 데이터베이스에 저장
    IF LINES( GT_GR_HEAD_SAVE ) > 0 AND LINES( GT_GR_ITEM_SAVE ) > 0.
      " 헤더 테이블 저장
      LOOP AT GT_GR_HEAD_SAVE INTO GS_GR_HEAD_SAVE.
        INSERT ZEDT20_P006 FROM GS_GR_HEAD_SAVE.
        IF SY-SUBRC <> 0.
          MESSAGE '입고 헤더 저장 실패' TYPE 'E'.
          EXIT.
        ENDIF.
      ENDLOOP.
  
      " 아이템 테이블 저장
      LOOP AT GT_GR_ITEM_SAVE INTO GS_GR_ITEM_SAVE.
        INSERT ZEDT20_P007 FROM GS_GR_ITEM_SAVE.
        IF SY-SUBRC <> 0.
          MESSAGE '입고 아이템 저장 실패' TYPE 'E'.
          EXIT.
        ENDIF.
      ENDLOOP.
  
      " 입고 완료 후 ZEDT20_P005의 GRSTATUS를 2로 업데이트
      LOOP AT GT_PO_OUTPUT_ALV INTO GS_PO_OUTPUT_ALV WHERE ZCHECKBOX = 'X'.
        UPDATE ZEDT20_P005
          SET GRSTATUS = '2'
          WHERE EBELN = GS_PO_OUTPUT_ALV-EBELN
            AND EBELP = GS_PO_OUTPUT_ALV-EBELP.
  
        IF SY-SUBRC <> 0.
          MESSAGE 'ZEDT20_P005 업데이트 실패' TYPE 'E'.
          EXIT.
        ENDIF.
      ENDLOOP.
  
      DELETE GT_PO_OUTPUT_ALV WHERE ZCHECKBOX = 'X'.  "
  
      MESSAGE '부분 입고 데이터가 성공적으로 저장되었습니다.' TYPE 'S'.
    ELSE.
      MESSAGE '저장된 데이터가 없습니다.' TYPE 'I'.
    ENDIF.
  
  ENDFORM.

  FORM REGR_DATA .
    " 취소를 눌렀을 때 GT_PO_OUTPUT_ALV 인터널 테이블에서 삭제를 하고 005 테이블의 GRSTATUS 값을 1로 바꾼다.
  
  ENDFORM.

  REGR_DATA.를 완성해줘
  취소를 눌렀을 때 RE_DATA가 실행되고 GT_PO_OUTPUT_ALV 인터널 테이블에서 ZCHECKBOX 'X'인 행을 GT_PO_OUPUT_ALV에서 삭제를 하고 
 ZEDT20_P005 테이블의 GRSTATUS 값을 1로 바꾼다. EBELN, EBELP를 해당하는 행을 찾아서 GRSTATUS를 1로 바꾼다.

 