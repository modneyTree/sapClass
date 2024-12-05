DATA: lv_max_egeln TYPE ZEDT20_P005-EBELP. " 최대값 저장 변수
CLEAR lv_max_egeln.

LOOP AT GT_PO_INPUT INTO DATA(wa_po_input).
  IF wa_po_input-egeln > lv_max_egeln.
    lv_max_egeln = wa_po_input-egeln.
  ENDIF.
ENDLOOP.


DATA: LV_EBELP TYPE ZEDT20_P005-EBELP.
CELAR : LV_MAX_EGELP.

LOOP AT GT_PO_INPUT INTO DATA (GS_PO_INPUT).
  IF GS_PO_INPUT-EBELP > LV_EBELP.
    LV_EBELP = GS_PO_INPUT-EBELP