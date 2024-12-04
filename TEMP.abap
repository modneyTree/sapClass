FORM MAKE_DATA .
  " 빈 줄 하나를 만든다 (편집용도). 단, ZLFA1_LIFNR 자동 채번되어야 한다.
  CLEAR : GS_MASTER_ALL.

  " 현재 최대 LIFNR 값 가져오기
  DATA: lv_lifnr TYPE zedt20_p001-zlfa1_lifnr.
  SELECT MAX( zlfa1_lifnr ) INTO lv_lifnr FROM zedt20_p001.

  " 최대값이 없을 경우 초기값 설정
  IF lv_lifnr IS INITIAL.
    lv_lifnr = '0000000000'.
  ENDIF.

  " 다음 LIFNR 값 계산
  DATA: lv_lifnr_num TYPE i.
  lv_lifnr_num = lv_lifnr. " 문자형 LIFNR을 정수형으로 변환
  lv_lifnr_num = lv_lifnr_num + 1. " 최대값 + 1
  lv_lifnr = lv_lifnr_num. " 정수형 값을 다시 문자형으로 변환

  " 자리수 포맷팅 (예: 10자리)
  lv_lifnr = lv_lifnr+0(10).

  " 자동 채번된 LIFNR 설정
  GS_MASTER_ALL-ZLFA1_LIFNR = lv_lifnr.

  " 추가 필드 초기화
  GS_MASTER_ALL-ZLFB1_BUKRS = P_BUKRS.
  GS_MASTER_ALL-ZLFA1_KTOKK = P_KTOKK.

  " 내부 테이블에 추가
  APPEND GS_MASTER_ALL TO GT_MASTER_ALL.
ENDFORM.