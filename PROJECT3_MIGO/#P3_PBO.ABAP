*&---------------------------------------------------------------------*
*&  Include           ZPROJECT20_PO_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'T100'.
ENDMODULE.

MODULE SET_ALV OUTPUT.

  IF GC_DOCKING IS INITIAL.
    PERFORM CREATE_OBJECT.
    PERFORM FIELD_CATALOG.
    PERFORM ALV_LAYOUT.
*    PERFORM ALV_SORT.
    PERFORM CLASS_EVENT.
    PERFORM ALV_DISPLAY.
  ELSE.
    PERFORM REFRESH.
  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.
  SET PF-STATUS 'STATUS_0200'.
  SET TITLEBAR 'T200'.
ENDMODULE.

MODULE SET_ALV2 OUTPUT.

  IF GC_DOCKING IS INITIAL.
    PERFORM CREATE_OBJECT.
    PERFORM FIELD_CATALOG2.
    PERFORM ALV_LAYOUT.
*    PERFORM ALV_SORT.
    PERFORM CLASS_EVENT.
    PERFORM ALV_DISPLAY2.
  ELSE.
    PERFORM REFRESH.
  ENDIF.

ENDMODULE.