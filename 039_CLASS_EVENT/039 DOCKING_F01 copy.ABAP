*&---------------------------------------------------------------------*
*&  Include           ZEDR20_39_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZCUSTOM_CONTAINER_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SET_INITIAL
*&---------------------------------------------------------------------*
FORM SET_INIT .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_SCREEN
*&---------------------------------------------------------------------*
FORM SET_SCREEN .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  SELECT * FROM ZEDT00_001
    INTO CORRESPONDING FIELDS OF TABLE GT_STUDENT
    WHERE ZCODE IN S_ZCODE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_OBJECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_OBJECT .

CREATE OBJECT GC_DOCKING
  EXPORTING
*    PARENT                      =
    REPID                       = SY-REPID
    DYNNR                       = SY-DYNNR
*    SIDE                        = DOCK_AT_LEFT
    EXTENSION                   = 2000
*    STYLE                       =
*    LIFETIME                    = lifetime_default
*    CAPTION                     =
*    METRIC                      = 0
*    RATIO                       =
*    NO_AUTODEF_PROGID_DYNNR     =
*    NAME                        =
*  EXCEPTIONS
*    CNTL_ERROR                  = 1
*    CNTL_SYSTEM_ERROR           = 2
*    CREATE_ERROR                = 3
*    LIFETIME_ERROR              = 4
*    LIFETIME_DYNPRO_DYNPRO_LINK = 5
*    others                      = 6
    .
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

CREATE OBJECT GC_GRID
  EXPORTING
*    I_SHELLSTYLE      = 0
*    I_LIFETIME        =
    I_PARENT          = GC_DOCKING
*    I_APPL_EVENTS     = space
*    I_PARENTDBG       =
*    I_APPLOGPARENT    =
*    I_GRAPHICSPARENT  =
*    I_NAME            =
*    I_FCAT_COMPLETE   = SPACE
*  EXCEPTIONS
*    ERROR_CNTL_CREATE = 1
*    ERROR_CNTL_INIT   = 2
*    ERROR_CNTL_LINK   = 3
*    ERROR_DP_CREATE   = 4
*    others            = 5
    .
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELD_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FIELD_CATALOG .

  CLEAR : GS_FIELDCAT , GT_FIELDCAT.
  GS_FIELDCAT-COL_POS = 1.
  GS_FIELDCAT-FIELDNAME = 'ZCODE'.
  GS_FIELDCAT-COLTEXT = '학생코드'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-FIELDNAME = 'ZPERNR'.
  GS_FIELDCAT-COLTEXT = '출석번호'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 3.
  GS_FIELDCAT-FIELDNAME = 'ZKNAME'.
  GS_FIELDCAT-COLTEXT = '이름'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 4.
  GS_FIELDCAT-FIELDNAME = 'ZENAME'.
  GS_FIELDCAT-COLTEXT = '영문이름'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_LAYOUT .

  CLEAR : GS_LAYOUT.
  GS_LAYOUT-ZEBRA = 'X'.

  CLEAR : GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-USERNAME = SY-UNAME.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALL_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_ALV .

  CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*      I_BUFFER_ACTIVE               =
*      I_BYPASSING_BUFFER            =
*      I_CONSISTENCY_CHECK           =
*      I_STRUCTURE_NAME              =
      IS_VARIANT                    = GS_VARIANT
*      I_SAVE                        =
*      I_DEFAULT                     = 'X'
      IS_LAYOUT                     = GS_LAYOUT
*      IS_PRINT                      =
*      IT_SPECIAL_GROUPS             =
*      IT_TOOLBAR_EXCLUDING          =
*      IT_HYPERLINK                  =
*      IT_ALV_GRAPHICS               =
*      IT_EXCEPT_QINFO               =
*      IR_SALV_ADAPTER               =
    CHANGING
      IT_OUTTAB                     = GT_STUDENT
      IT_FIELDCATALOG               = GT_FIELDCAT
      IT_SORT                       = GT_SORT
*      IT_FILTER                     =
*    EXCEPTIONS
*      INVALID_PARAMETER_COMBINATION = 1
*      PROGRAM_ERROR                 = 2
*      TOO_MANY_LINES                = 3
*      OTHERS                        = 4
          .
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MODIFY_DATA .

  LOOP AT GT_STUDENT INTO GS_STUDENT.
    MOVE-CORRESPONDING GS_STUDENT TO GS_ALV.

    IF GS_ALV-ZGENDER = 'M'.
      GS_ALV-ZGENDER_NAME = '남자'.
    ELSEIF GS_ALV-ZGENDER = 'F'.
      GS_ALV-ZGENDER_NAME = '여자'.
    ENDIF.

    APPEND GS_ALV TO GT_ALV.
  ENDLOOP.

ENDFORM.

 FORM ALV_SORT .

  CLEAR : GS_SORT, GT_SORT.

*  GS_SORT-SPOS = 1.
*  GS_SORT-FIELDNAME = 'ZCODE'.
*  GS_SORT-UP = 'X'.
*  APPEND GS_SORT TO GT_SORT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_HANDLER_TOOLBAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_OBJECT  text
*      -->P_E_INTERACTIVE  text
*----------------------------------------------------------------------*
FORM ALV_HANDLER_TOOLBAR  USING    P_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET
                                   P_INTERACTIVE.
  DATA : LS_TOOLBAR TYPE STB_BUTTON.

  LS_TOOLBAR-FUNCTION = 'TEXT'.
  LS_TOOLBAR-ICON = ICON_CHECKED.
  LS_TOOLBAR-QUICKINFO = 'INFORMATION'.

  APPEND LS_TOOLBAR TO P_OBJECT->MT_TOOLBAR.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CLASS_EVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLASS_EVENT .

  CREATE OBJECT GO_EVENT.

  SET HANDLER GO_EVENT->HANDLER_TOOLBAR FOR GC_GRID.
  SET HANDLER GO_EVENT->HANDLER_USER_COMMAND FOR GC_GRID.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_HANDLER_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_UCOMM  text
*----------------------------------------------------------------------*
FORM ALV_HANDLER_USER_COMMAND  USING    P_UCOMM.

  CASE P_UCOMM.
    WHEN 'TEXT'.
      MESSAGE '학생정보데이터입니다' TYPE 'I'.
  ENDCASE.

ENDFORM.