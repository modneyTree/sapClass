*&---------------------------------------------------------------------*
*&  Include           ZPROJECT20_PO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SET_INIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_INIT .
  "초기값 세팅
  "자리수 맞추기
  "에러 메세지 뿌려주기

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_SCREEN .

  LOOP AT SCREEN.
    IF P_R1 = C_X.
      IF SCREEN-GROUP1 = 'M2'.
        SCREEN-ACTIVE = '0'.
      ENDIF.
    ELSE.
      IF SCREEN-GROUP1 = 'M1'.
        SCREEN-ACTIVE = '0'.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

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

  SELECT * FROM ZEDT20_P001
  INTO CORRESPONDING FIELDS OF TABLE GT_GENERAL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MAKE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
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

FORM MODIFY_DATA .

*  LOOP AT GT_MASTER_ALL INTO GT_MASTER_ALL.
*    MOVE-CORRESPONDING GT_MASTER_ALL_ALV TO GT_MASTER_ALL_ALV.
*  ENDLOOP.

ENDFORM.

FORM CREATE_OBJECT .
  CREATE OBJECT GC_DOCKING
    EXPORTING
*      PARENT                      =
      REPID                       = SY-REPID
      DYNNR                       = SY-DYNNR
*      SIDE                        = DOCK_AT_LEFT
      EXTENSION                   = 2000
*      STYLE                       =
*      LIFETIME                    = lifetime_default
*      CAPTION                     =
*      METRIC                      = 0
*      RATIO                       =
*      NO_AUTODEF_PROGID_DYNNR     =
*      NAME                        =
*    EXCEPTIONS
*      CNTL_ERROR                  = 1
*      CNTL_SYSTEM_ERROR           = 2
*      CREATE_ERROR                = 3
*      LIFETIME_ERROR              = 4
*      LIFETIME_DYNPRO_DYNPRO_LINK = 5
*      others                      = 6
      .
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



  CREATE OBJECT GC_GRID
    EXPORTING
*      I_SHELLSTYLE      = 0
*      I_LIFETIME        =
      I_PARENT          = GC_DOCKING
*      I_APPL_EVENTS     = space
*      I_PARENTDBG       =
*      I_APPLOGPARENT    =
*      I_GRAPHICSPARENT  =
*      I_NAME            =
*      I_FCAT_COMPLETE   = SPACE
*    EXCEPTIONS
*      ERROR_CNTL_CREATE = 1
*      ERROR_CNTL_INIT   = 2
*      ERROR_CNTL_LINK   = 3
*      ERROR_DP_CREATE   = 4
*      others            = 5
      .
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  CREATE OBJECT GO_EVENT.

ENDFORM.

FORM FIELD_CATALOG .
  CLEAR : GS_FIELDCAT, GT_FIELDCAT.
  GS_FIELDCAT-COL_POS = 1.
  GS_FIELDCAT-FIELDNAME = 'ZLFA1_LIFNR'.
  GS_FIELDCAT-COLTEXT = '구매처번호'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-FIELDNAME = 'ZLFB1_BUKRS'.
  GS_FIELDCAT-COLTEXT = '회사코드'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 3.
  GS_FIELDCAT-FIELDNAME = 'ZLFA1_KTOKK'.
  GS_FIELDCAT-COLTEXT = '구매처그룹'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 4.
  GS_FIELDCAT-FIELDNAME = 'ZLFA1_NAME1'.
  GS_FIELDCAT-COLTEXT = '구매처명'.
  GS_FIELDCAT-EDIT = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 5.
  GS_FIELDCAT-FIELDNAME = 'ZLFA1_LAND1'.
  GS_FIELDCAT-COLTEXT = '국가키'.
  GS_FIELDCAT-EDIT = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 6.
  GS_FIELDCAT-FIELDNAME = 'ZLFA1_STCD1'.
  GS_FIELDCAT-COLTEXT = '개인번호'.
  GS_FIELDCAT-EDIT = 'X'.

  " 계정그룹 3000클릭시만 개인번호(LFA1-STCD1)필드가 보여야 하며
  IF P_KTOKK <> '3000'.
    GS_FIELDCAT-NO_OUT = 'X'.
  ENDIF.

  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 7.
  GS_FIELDCAT-FIELDNAME = 'ZLFA1_STCD2'.
  GS_FIELDCAT-COLTEXT = '사업자번호'.
  GS_FIELDCAT-EDIT = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 8.
  GS_FIELDCAT-FIELDNAME = 'ZLFA1_STRAS'.
  GS_FIELDCAT-COLTEXT = '주소'.
  GS_FIELDCAT-EDIT = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 9.
  GS_FIELDCAT-FIELDNAME = 'ZLFB1_AKONT'.
  GS_FIELDCAT-COLTEXT = '계정'.
  GS_FIELDCAT-EDIT = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 10.
  GS_FIELDCAT-FIELDNAME = 'ZLFB1_ZTERM'.
  GS_FIELDCAT-COLTEXT = '지급조건'.
  GS_FIELDCAT-EDIT = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 11.
  GS_FIELDCAT-FIELDNAME = 'ZLFM1_WAERS'.
  GS_FIELDCAT-COLTEXT = '구매오더통화'.
  GS_FIELDCAT-EDIT = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 12.
  GS_FIELDCAT-FIELDNAME = 'ZLFM1_MWSKZ'.
  GS_FIELDCAT-COLTEXT = '세금코드'.
  GS_FIELDCAT-EDIT = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.

FORM FIELD_CATALOG2 .
    CLEAR : GS_FIELDCAT_GENERAL, GT_FIELDCAT_GENERAL.
    GS_FIELDCAT_GENERAL-COL_POS = 1.
    GS_FIELDCAT_GENERAL-FIELDNAME = 'ZLFA1_LIFNR'.
    GS_FIELDCAT_GENERAL-COLTEXT = '구매처번호'.
    APPEND GS_FIELDCAT_GENERAL TO GT_FIELDCAT_GENERAL.


    CLEAR : GS_FIELDCAT_GENERAL.
    GS_FIELDCAT_GENERAL-COL_POS = 3.
    GS_FIELDCAT_GENERAL-FIELDNAME = 'ZLFA1_KTOKK'.
    GS_FIELDCAT_GENERAL-COLTEXT = '구매처그룹'.
    APPEND GS_FIELDCAT_GENERAL TO GT_FIELDCAT_GENERAL.

    CLEAR : GS_FIELDCAT_GENERAL.
    GS_FIELDCAT_GENERAL-COL_POS = 4.
    GS_FIELDCAT_GENERAL-FIELDNAME = 'ZLFA1_NAME1'.
    GS_FIELDCAT_GENERAL-COLTEXT = '구매처명'.
    GS_FIELDCAT_GENERAL-EDIT = 'X'.
    APPEND GS_FIELDCAT_GENERAL TO GT_FIELDCAT_GENERAL.

    CLEAR : GS_FIELDCAT_GENERAL.
    GS_FIELDCAT_GENERAL-COL_POS = 5.
    GS_FIELDCAT_GENERAL-FIELDNAME = 'ZLFA1_LAND1'.
    GS_FIELDCAT_GENERAL-COLTEXT = '국가키'.
    GS_FIELDCAT_GENERAL-EDIT = 'X'.
    APPEND GS_FIELDCAT_GENERAL TO GT_FIELDCAT_GENERAL.

    CLEAR : GS_FIELDCAT_GENERAL.
    GS_FIELDCAT_GENERAL-COL_POS = 6.
    GS_FIELDCAT_GENERAL-FIELDNAME = 'ZLFA1_STCD1'.
    GS_FIELDCAT_GENERAL-COLTEXT = '개인번호'.
    GS_FIELDCAT_GENERAL-EDIT = 'X'.

    " 계정그룹 3000클릭시만 개인번호(LFA1-STCD1)필드가 보여야 하며
    IF P_KTOKK <> '3000'.
      GS_FIELDCAT_GENERAL-NO_OUT = 'X'.
    ENDIF.

    APPEND GS_FIELDCAT_GENERAL TO GT_FIELDCAT_GENERAL.

    CLEAR : GS_FIELDCAT_GENERAL.
    GS_FIELDCAT_GENERAL-COL_POS = 7.
    GS_FIELDCAT_GENERAL-FIELDNAME = 'ZLFA1_STCD2'.
    GS_FIELDCAT_GENERAL-COLTEXT = '사업자번호'.
    GS_FIELDCAT_GENERAL-EDIT = 'X'.
    APPEND GS_FIELDCAT_GENERAL TO GT_FIELDCAT_GENERAL.

    CLEAR : GS_FIELDCAT_GENERAL.
    GS_FIELDCAT_GENERAL-COL_POS = 8.
    GS_FIELDCAT_GENERAL-FIELDNAME = 'ZLFA1_STRAS'.
    GS_FIELDCAT_GENERAL-COLTEXT = '주소'.
    GS_FIELDCAT_GENERAL-EDIT = 'X'.
    APPEND GS_FIELDCAT_GENERAL TO GT_FIELDCAT_GENERAL.

  ENDFORM.

FORM ALV_LAYOUT .
  CLEAR GS_LAYOUT.
*  GS_LAYOUT-NO_HEADERS = 'X'.
  GS_LAYOUT-ZEBRA = 'X'.

  CLEAR GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-USERNAME = SY-UNAME.

ENDFORM.


FORM ALV_SORT .
  GS_SORT-SPOS = 1.
  GS_SORT-FIELDNAME = 'ZLFB1_LIFNR'.
  GS_SORT-UP = 'X'.
  APPEND GS_SORT TO GT_SORT.
ENDFORM.

FORM ALV_DISPLAY .
  CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*      I_BUFFER_ACTIVE               =
*      I_BYPASSING_BUFFER            =
*      I_CONSISTENCY_CHECK           =
*      I_STRUCTURE_NAME              =
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = 'A'
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
      IT_OUTTAB                     = GT_MASTER_ALL
      IT_FIELDCATALOG               = GT_FIELDCAT
*      IT_SORT                       = GT_SORT
*      IT_FILTER                     =
*    EXCEPTIONS
*      INVALID_PARAMETER_COMBINATION = 1
*      PROGRAM_ERROR                 = 2
*      TOO_MANY_LINES                = 3
*      others                        = 4
          .
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM ALV_DISPLAY2 .
  CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*      I_BUFFER_ACTIVE               =
*      I_BYPASSING_BUFFER            =
*      I_CONSISTENCY_CHECK           =
*      I_STRUCTURE_NAME              =
      IS_VARIANT                    = GS_VARIANT
      I_SAVE                        = 'A'
*      I_DEFAULT                     = 'X'
*      IS_LAYOUT                     = GS_LAYOUT
*      IS_PRINT                      =
*      IT_SPECIAL_GROUPS             =
*      IT_TOOLBAR_EXCLUDING          =
*      IT_HYPERLINK                  =
*      IT_ALV_GRAPHICS               =
*      IT_EXCEPT_QINFO               =
*      IR_SALV_ADAPTER               =
    CHANGING
      IT_OUTTAB                     = GT_GENERAL
      IT_FIELDCATALOG               = GT_FIELDCAT_GENERAL
*      IT_SORT                       = GT_SORT
*      IT_FILTER                     =
*    EXCEPTIONS
*      INVALID_PARAMETER_COMBINATION = 1
*      PROGRAM_ERROR                 = 2
*      TOO_MANY_LINES                = 3
*      others                        = 4
          .
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM REFRESH .

  DATA : LS_STABLE TYPE LVC_S_STBL.

  LS_STABLE-ROW = 'X'.
  LS_STABLE-COL = 'X'.

  CALL METHOD GC_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE      = LS_STABLE
*      I_SOFT_REFRESH =
*    EXCEPTIONS
*      FINISHED       = 1
*      others         = 2
          .
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.

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

  CALL METHOD GC_GRID->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED
*    EXCEPTIONS
*      ERROR      = 1
*      others     = 2
          .
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.

  SET HANDLER GO_EVENT->HANDLER_DATA_CHANGED FOR GC_GRID.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ALV_DATA_CHANGED_FINISHED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_MODIFIED  text
*      -->P_ET_GOOD_CELLS  text
*----------------------------------------------------------------------*
FORM ALV_DATA_CHANGED_FINISHED  USING    P_MODIFIED
                                         PT_GOOD_CELLS TYPE LVC_T_MODI.
  "MT_GOOD_CELLS TYPE LVC_T_MODI
  "LVC_T_MODI TYPE LVC_S_MODI
  "LVC_S_MODI->FILEDNAME(필드제어), ROW_ID(인덱스제어), VALUE(값제어)
  DATA : LS_MODI TYPE LVC_S_MODI.

  CLEAR : LS_MODI.

*  LOOP AT PT_GOOD_CELLS INTO LS_MODI.
*    IF LS_MODI-FIELDNAME = 'ZTEL'.
*      READ TABLE GT_STUDENT INTO GS_STUDENT INDEX LS_MODI-ROW_ID.
*
*      IF GS_STUDENT-ZCOLOR NE ICON_LED_GREEN.
*        DELETE TABLE GT_STUDENT FROM GS_STUDENT.
*      ENDIF.
*
*      CLEAR GS_STUDENT.
*    ENDIF.
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_HANDLER_DATA_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*      -->P_E_ONF4  text
*      -->P_E_ONF4_BEFORE  text
*      -->P_E_ONF4_AFTER  text
*      -->P_E_UCOMM  text
*----------------------------------------------------------------------*
FORM ALV_HANDLER_DATA_CHANGED USING P_DATA_CHANGED TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                    P_ONF4
                                    P_ONF4_BEFORE
                                    P_ONF4_AFTER
                                    P_UCOMM.

*  DATA LS_MODI TYPE LVC_S_MODI.
*  DATA LV_LEN(02).
*
*  CLEAR : LS_MODI, LV_LEN.
*
*  LOOP AT P_DATA_CHANGED->MT_GOOD_CELLS INTO LS_MODI.
*
*    INSERT GS_MASTER_ALL INTO GT_MASTER_ALL INDEX LS_MODI-ROW_ID.
**    MODIFY GT_MASTER_ALL FROM GS_MASTER_ALL INDEX LS_MODI-ROW_ID.
*
*    CLEAR GS_MASTER_ALL.
*  ENDLOOP.
*
*  PERFORM REFRESH.

ENDFORM.