FORM SAVE_DATA .
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
  
    " 정수를 CHAR(10) 형식으로 변환하여 선행 0 추가
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = LV_EBELN
      IMPORTING
        output = LV_EBELN.
  
    " GS_PO_HEAD에 데이터 대입
    CLEAR GS_PO_HEAD.
    GS_PO_HEAD-EBELN       = LV_EBELN.
    GS_PO_HEAD-ZLFB1_BUKRS = P_BUKRS.
    GS_PO_HEAD-LIFNR       = P_EKORG.
    GS_PO_HEAD-BEDAT       = P_BEDAT.
  
    " 헤더 저장용 내부테이블에 담기
    CLEAR GT_PO_HEAD.
    APPEND GS_PO_HEAD TO GT_PO_HEAD.
  
    " 헤더 저장
    INSERT ZEDT20_P004 FROM TABLE GT_PO_HEAD.
    IF SY-SUBRC <> 0.
      MESSAGE '헤더 저장 실패' TYPE 'E'.
      EXIT.
    ENDIF.
  
    " 아이템 저장 로직
    CLEAR GT_PO_INPUT_SAVE.
    LOOP AT GT_PO_INPUT INTO GS_PO_INPUT.
      CLEAR GS_PO_INPUT_SAVE.
      MOVE-CORRESPONDING GS_PO_INPUT TO GS_PO_INPUT_SAVE.
      " EBELN 값을 아이템에 매핑
      GS_PO_INPUT_SAVE-EBELN = LV_EBELN.
      APPEND GS_PO_INPUT_SAVE TO GT_PO_INPUT_SAVE.
    ENDLOOP.
  
    IF GT_PO_INPUT_SAVE[] IS NOT INITIAL.
      INSERT ZEDT20_P005 FROM TABLE GT_PO_INPUT_SAVE.
      IF SY-SUBRC = 0.
        MESSAGE '저장성공' TYPE 'I'.
      ELSE.
        MESSAGE '아이템 저장 실패' TYPE 'E'.
      ENDIF.
    ELSE.
      MESSAGE '아이템 데이터가 없습니다.' TYPE 'I'.
    ENDIF.
  
  ENDFORM.

  위의 자동 채번 로직을 참고해서 아래 코드의 입고문서 번호 자동 채번 로직을 구현할거야(ZMBLNR)