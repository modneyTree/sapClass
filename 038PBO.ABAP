*&---------------------------------------------------------------------*
*&  Include           ZEDR20_37_PBO
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'T100'.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE SET_ALV OUTPUT.

  IF GC_DOCKING IS INITIAL.
    PERFORM CREATE_OBJECT.
    PERFORM FIELD_CATALOG.
    PERFORM ALV_LAYOUT.
    PERFORM ALV_SORT.
    PERFORM CALL_ALV.
  ELSE.
    "REFRESH 기능 추가
    PERFORM REFRESH.
  ENDIF.

ENDMODULE.