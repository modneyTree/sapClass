*&---------------------------------------------------------------------*
*& Report ZCUSTOM_CONTAINER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCUSTOM_CONTAINER MESSAGE-ID ZMED00.

INCLUDE ZCUSTOM_CONTAINER_TOP.
INCLUDE ZCUSTOM_CONTAINER_SCR.
INCLUDE ZCUSTOM_CONTAINER_F01.
INCLUDE ZCUSTOM_CONTAINER_O01.
INCLUDE ZCUSTOM_CONTAINER_I01.

INITIALIZATION.
  PERFORM SET_INITIAL.

AT SELECTION-SCREEN OUTPUT.
  PERFORM SET_SCREEN.

START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM MODIFY_DATA.

  IF GT_STUDENT[] IS NOT INITIAL.
    CALL SCREEN 100.
  ELSE.
    MESSAGE I000.
    EXIT.
  ENDIF.

"
*&---------------------------------------------------------------------*
*&      Form  ALV_SORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_SORT .

  CLEAR : GS_SORT, GT_SORT.

  GS_SORT-SPOS = 1.
  GS_SORT-FIELDNAME = 'ZCODE'.
  GS_SORT-UP = 'X'.
  APPEND GS_SORT TO GT_SORT.

ENDFORM.