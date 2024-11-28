*&---------------------------------------------------------------------*
*&  Include           ZEDR20_HW001_PBO
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

  IF P_R1 = 'X'.

    PERFORM CREATE_OBJECT.
    PERFORM FIELD_CATALOG.
    PERFORM ALV_LAYOUT.
    PERFORM ALV_SORT.
    PERFORM CALL_ALV.

  ELSE.
    PERFORM CREATE_OBJECT.
    PERFORM FIELD_CATALOG2.
    PERFORM ALV_LAYOUT2.
    PERFORM ALV_SORT2.
    PERFORM CALL_ALV.

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