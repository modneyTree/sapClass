*&---------------------------------------------------------------------*
*&  Include           ZPROJECT20_GR_F01
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

  DATA: LS_HEADER   TYPE ZEDT20_P004,
        LT_HEADER   TYPE TABLE OF ZEDT20_P004,
        LS_ITEM     LIKE GS_PO_OUTPUT_ALV.

  CLEAR GT_PO_OUTPUT_ALV.

  " 1) 아이템 데이터 조회
  SELECT * FROM ZEDT20_P005
    INTO CORRESPONDING FIELDS OF TABLE GT_PO_OUTPUT_ALV
    WHERE ( EBELN = P_EBELN AND GRSTATUS <> 2 ).

  IF SY-SUBRC <> 0.
    " 해당 EBELN에 대한 아이템이 없으면 종료
    EXIT.
  ENDIF.

  " 2) 헤더 데이터 조회 (1:1 관계 가정, SINGLE 사용)
  SELECT SINGLE * FROM ZEDT20_P004
    INTO LS_HEADER
    WHERE EBELN = P_EBELN.

  IF SY-SUBRC <> 0.
    " 해당 EBELN에 대한 헤더가 없으면 종료
    EXIT.
  ENDIF.

  " 3) LOOP를 돌며 헤더 필드 덮어쓰기
  LOOP AT GT_PO_OUTPUT_ALV INTO LS_ITEM.
    LS_ITEM-LIFNR = LS_HEADER-LIFNR.
    LS_ITEM-BEDAT = LS_HEADER-BEDAT.
    LS_ITEM-WAERS = LS_HEADER-WAERS.
    " 필요 시 추가 헤더 필드를 매핑
    MODIFY GT_PO_OUTPUT_ALV FROM LS_ITEM.
  ENDLOOP.

ENDFORM.

FORM GET_DATA2 .

  DATA: LS_HEADER   TYPE ZEDT20_P004,
        LT_HEADER   TYPE TABLE OF ZEDT20_P004,
        LS_ITEM     LIKE GS_PO_OUTPUT_ALV.

  CLEAR GT_PO_OUTPUT_ALV.

  " 1) 아이템 데이터 조회
  SELECT * FROM ZEDT20_P005
    INTO CORRESPONDING FIELDS OF TABLE GT_PO_OUTPUT_ALV
    WHERE ( EBELN = P_EBELN2 AND GRSTATUS = 2 ).

  IF SY-SUBRC <> 0.
    " 해당 EBELN에 대한 아이템이 없으면 종료
    EXIT.
  ENDIF.

  " 2) 헤더 데이터 조회 (1:1 관계 가정, SINGLE 사용)
  SELECT SINGLE * FROM ZEDT20_P004
    INTO LS_HEADER
    WHERE EBELN = P_EBELN2.

  IF SY-SUBRC <> 0.
    " 해당 EBELN에 대한 헤더가 없으면 종료
    EXIT.
  ENDIF.

  " 3) LOOP를 돌며 헤더 필드 덮어쓰기
  LOOP AT GT_PO_OUTPUT_ALV INTO LS_ITEM.
    LS_ITEM-LIFNR = LS_HEADER-LIFNR.
    LS_ITEM-BEDAT = LS_HEADER-BEDAT.
    LS_ITEM-WAERS = LS_HEADER-WAERS.
    " 필요 시 추가 헤더 필드를 매핑
    MODIFY GT_PO_OUTPUT_ALV FROM LS_ITEM.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  MAKE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MAKE_DATA_HEAD .
*  " 빈 줄 하나를 만든다 (편집용도). 단, ZLFA1_EBELN 자동 채번되어야 한다. PO 관련해서 가져옴
*  CLEAR : GS_PO_HEAD.
*
*  " 현재 최대 EBELN 값 가져오기
*  DATA: LV_EBELN TYPE ZEDT20_P004-EBELN.
*  SELECT MAX( EBELN ) INTO LV_EBELN FROM ZEDT20_P004.
*
*  " 최대값이 없을 경우 초기값 설정
*  IF LV_EBELN IS INITIAL.
*    LV_EBELN = '0000000000'.
*  ENDIF.
*
*  " 다음 LIFNR 값 계산
*  DATA: LV_EBELN_NUM TYPE i.
*  LV_EBELN_NUM = LV_EBELN. " 문자형 LIFNR을 정수형으로 변환
*  LV_EBELN_NUM = LV_EBELN_NUM + 1. " 최대값 + 1
*  LV_EBELN = LV_EBELN_NUM. " 정수형 값을 다시 문자형으로 변환
*
*  " 자리수 포맷팅 (예: 10자리)
*  LV_EBELN = LV_EBELN+0(10).
*
*  " 자동 채번된 EBELN 설정
*  GS_PO_HEAD-EBELN = LV_EBELN.
*
*  " 추가 필드 초기화
*  GS_PO_HEAD-EKORG = P_EKORG.
*  GS_PO_HEAD-BEDAT = P_BEDAT.
*
*  " 내부 테이블에 추가
*  APPEND GS_PO_HEAD TO GT_PO_HEAD.
ENDFORM.

FORM MAKE_DATA_INPUT .
  " 빈 줄 하나를 만든다 (편집용도). 단, ZLFA1_EBELN 자동 채번되어야 한다. PO 관련해서 가져옴
  CLEAR : GS_PO_INPUT.

*  " 현재 인터벌 테이블에서  최대값 가져오기 GT_PO_INPUT
  DATA: LV_EBELP TYPE ZEDT20_P005-EBELP.

  LOOP AT GT_PO_INPUT INTO GS_PO_INPUT.
    IF GS_PO_INPUT-EBELP > LV_EBELP.
      LV_EBELP = GS_PO_INPUT-EBELP.
    ENDIF.
  ENDLOOP.

  " 최대값이 없을 경우 초기값 설정
  IF LV_EBELP IS INITIAL.
*    LV_EBELP = '0000000010'.
    LV_EBELP = 10.
  ELSE.
    LV_EBELP = LV_EBELP + 10.
  ENDIF.

  " 자동 채번된 EBELN 설정
  GS_PO_INPUT-EBELP = LV_EBELP.

  " 추가 필드 초기화

  " 내부 테이블에 추가
  APPEND GS_PO_INPUT TO GT_PO_INPUT.
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

  CLEAR : GS_FIELDCAT_OUTPUT, GT_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 1.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'ZCHECKBOX'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '체크'.
  GS_FIELDCAT_OUTPUT-CHECKBOX = 'X'.
  GS_FIELDCAT_OUTPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 2.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'EBELN'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '구매오더'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 3.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'EBELP'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '품목번호'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 4.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'LIFNR'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '구매처'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 5.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'BEDAT'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '증빙일'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 6.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'WAERS'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '통화'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 7.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'ZMATNR'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '자재번호'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 8.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'ZMATNAME'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '자재명'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 9.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'MENGE'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '수량'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 10.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'ZMEINS'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '단위'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 11.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'STPRS'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '단가'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 12.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'PRDAT '.
  GS_FIELDCAT_OUTPUT-COLTEXT = '납품일'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 13.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'ZWERKS'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '플랜트'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

  CLEAR : GS_FIELDCAT_OUTPUT.
  GS_FIELDCAT_OUTPUT-COL_POS = 13.
  GS_FIELDCAT_OUTPUT-FIELDNAME = 'ZLGORT'.
  GS_FIELDCAT_OUTPUT-COLTEXT = '저장위치'.
  APPEND GS_FIELDCAT_OUTPUT TO GT_FIELDCAT_OUTPUT.

ENDFORM.


FORM FIELD_CATALOG2 .

  CLEAR : GS_FIELDCAT_ITEM, GT_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 1.
  GS_FIELDCAT_ITEM-FIELDNAME = 'EBELN'.
  GS_FIELDCAT_ITEM-COLTEXT = 'PO번호'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

  CLEAR : GS_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 2.
  GS_FIELDCAT_ITEM-FIELDNAME = 'EBELP'.
  GS_FIELDCAT_ITEM-COLTEXT = '품목'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

  CLEAR : GS_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 3.
  GS_FIELDCAT_ITEM-FIELDNAME = 'ZMATNR'.
  GS_FIELDCAT_ITEM-COLTEXT = '자재번호'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

  CLEAR : GS_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 4.
  GS_FIELDCAT_ITEM-FIELDNAME = 'ZMATNAME'.
  GS_FIELDCAT_ITEM-COLTEXT = '자재명'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

  CLEAR : GS_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 5.
  GS_FIELDCAT_ITEM-FIELDNAME = 'MMENGE'.
  GS_FIELDCAT_ITEM-COLTEXT = 'PO수량'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

  CLEAR : GS_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 6.
  GS_FIELDCAT_ITEM-FIELDNAME = 'STPRS'.
  GS_FIELDCAT_ITEM-COLTEXT = '단가'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

  CLEAR : GS_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 7.
  GS_FIELDCAT_ITEM-FIELDNAME = 'ZMEINS'.
  GS_FIELDCAT_ITEM-COLTEXT = '단위'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

  CLEAR : GS_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 8.
  GS_FIELDCAT_ITEM-FIELDNAME = 'PRDAT'.
  GS_FIELDCAT_ITEM-COLTEXT = '납품일'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

  CLEAR : GS_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 9.
  GS_FIELDCAT_ITEM-FIELDNAME = 'ZWERKS'.
  GS_FIELDCAT_ITEM-COLTEXT = '플랜트'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

  CLEAR : GS_FIELDCAT_ITEM.
  GS_FIELDCAT_ITEM-COL_POS = 10.
  GS_FIELDCAT_ITEM-FIELDNAME = 'ZLGORT'.
  GS_FIELDCAT_ITEM-COLTEXT = '저장위치'.
  APPEND GS_FIELDCAT_ITEM TO GT_FIELDCAT_ITEM.

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
      IT_OUTTAB                     = GT_PO_OUTPUT_ALV
      IT_FIELDCATALOG               = GT_FIELDCAT_OUTPUT
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
      IT_OUTTAB                     = GT_PO_ITEM
      IT_FIELDCATALOG               = GT_FIELDCAT_ITEM
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

  DATA: LS_MODI    TYPE LVC_S_MODI,
        LV_ZMATNR   TYPE CHAR10,
        LV_WERKS    TYPE CHAR4,   " 플랜트 필드 길이에 맞게 변경 필요
        LV_LGORT    TYPE CHAR4.   " 저장위치 필드 길이에 맞게 변경 필요

  CLEAR : LS_MODI.

  LOOP AT P_DATA_CHANGED->MT_GOOD_CELLS INTO LS_MODI.
    READ TABLE GT_PO_OUTPUT_ALV INTO GS_PO_OUTPUT_ALV INDEX LS_MODI-ROW_ID.

    " 변경된 필드에 따라 처리
    IF LS_MODI-FIELDNAME = 'ZCHECKBOX' AND LS_MODI-VALUE = 'X'.

      GS_PO_OUTPUT_ALV-ZCHECKBOX = 'X'.

      MODIFY GT_PO_OUTPUT_ALV FROM GS_PO_OUTPUT_ALV INDEX LS_MODI-ROW_ID.
      CLEAR GS_PO_OUTPUT_ALV.
    ENDIF.



  ENDLOOP.

  PERFORM REFRESH.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DELETE_SELECTED_ROW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DELETE_SELECTED_ROW .
  DATA: LT_ROWID TYPE LVC_T_ROW,
        LS_ROWID TYPE LVC_S_ROW.

  " ALV Grid에서 선택된 행 인덱스 가져오기
  CALL METHOD GC_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_ROWID.

  IF LT_ROWID[] IS INITIAL.
    MESSAGE '선택된 행이 없습니다.' TYPE 'I'.
    EXIT.
  ENDIF.

  " 선택된 행을 GT_PO_INPUT에서 삭제
  " 여러 행이 선택될 수 있으므로 LOOP 수행
  LOOP AT LT_ROWID INTO LS_ROWID.
    DELETE GT_PO_INPUT INDEX LS_ROWID-INDEX.
  ENDLOOP.

  " 삭제 후 ALV 화면 갱신
  PERFORM REFRESH.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SAVE_DATA .
*  DATA: LV_EBELN     TYPE ZEDT20_P004-EBELN,
*        LV_EBELN_NUM TYPE I.
*
*  " EBELN 최대값 가져오기
*  SELECT MAX( EBELN ) INTO LV_EBELN FROM ZEDT20_P004.
*
*  " 초기값 처리
*  IF SY-SUBRC <> 0 OR LV_EBELN IS INITIAL.
*    LV_EBELN_NUM = 1.
*  ELSE.
*    LV_EBELN_NUM = LV_EBELN.
*    LV_EBELN_NUM = LV_EBELN_NUM + 1.
*  ENDIF.
*
*  " 정수를 CHAR10으로 변환
*  WRITE LV_EBELN_NUM TO LV_EBELN(10).
*
*  " GS_PO_HEAD에 데이터 대입
*  CLEAR GS_PO_HEAD.
*  GS_PO_HEAD-EBELN       = LV_EBELN.
*  GS_PO_HEAD-ZLFB1_BUKRS = P_BUKRS.
*  GS_PO_HEAD-LIFNR       = P_EKORG.
*  GS_PO_HEAD-BEDAT       = P_BEDAT.
*
*  " 헤더 저장용 내부테이블에 담기
*  CLEAR GT_PO_HEAD.
*  APPEND GS_PO_HEAD TO GT_PO_HEAD.
*
*  " 헤더 저장
*  INSERT ZEDT20_P004 FROM TABLE GT_PO_HEAD.
*  IF SY-SUBRC <> 0.
*    MESSAGE '헤더 저장 실패' TYPE 'E'.
*    EXIT.
*  ENDIF.
*
*  " 아이템 저장 로직
*  CLEAR GT_PO_INPUT_SAVE.
*  LOOP AT GT_PO_INPUT INTO GS_PO_INPUT.
*    CLEAR GS_PO_INPUT_SAVE.
*    MOVE-CORRESPONDING GS_PO_INPUT TO GS_PO_INPUT_SAVE.
*    " EBELN 값을 아이템에 매핑
*    GS_PO_INPUT_SAVE-EBELN = LV_EBELN.
*    APPEND GS_PO_INPUT_SAVE TO GT_PO_INPUT_SAVE.
*  ENDLOOP.
*
*  IF GT_PO_INPUT_SAVE[] IS NOT INITIAL.
*    INSERT ZEDT20_P005 FROM TABLE GT_PO_INPUT_SAVE.
*    IF SY-SUBRC = 0.
*      MESSAGE '저장성공' TYPE 'I'.
*    ELSE.
*      MESSAGE '아이템 저장 실패' TYPE 'E'.
*    ENDIF.
*  ELSE.
*    MESSAGE '아이템 데이터가 없습니다.' TYPE 'I'.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GOOD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
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

    GS_GR_ITEM_SAVE-EBELN  = GS_PO_OUTPUT_ALV-EBELN.
    "GS_GR_ITEM_SAVE-ZLFB1_BUKRS  = GS_PO_OUTPUT_ALV-ZLFB1_BUKRS.
    GS_GR_ITEM_SAVE-ZGJAHR  = SY-DATUM. " 회계연도 문서작성일
    GS_GR_ITEM_SAVE-ZBELNR  = 'WE'.
    GS_GR_ITEM_SAVE-SHKZG  = 'H'.  " 차변 대변
    "GS_GR_ITEM_SAVE-DMBTR  = GS_PO_OUTPUT_ALV-. " 금액
    APPEND GS_GR_ITEM_SAVE TO GT_GR_ITEM_SAVE.

    "GS_GR_ITEM_SAVE-SHKZG = 'S'.
    "APPEND GS_GR_ITEM_SAVE TO GT_GR_ITEM_SAVE.

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
*&---------------------------------------------------------------------*
*&      Form  REGR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  " 취소를 눌렀을 때 GT_PO_OUTPUT_ALV 인터널 테이블에서 삭제를 하고 005 테이블의 GRSTATUS 값을 1로 바꾼다.
FORM REGR_DATA .

  LOOP AT GT_PO_OUTPUT_ALV INTO GS_PO_OUTPUT_ALV WHERE ZCHECKBOX = 'X'.

    " ZEDT20_P005의 GRSTATUS를 1로 업데이트
    UPDATE ZEDT20_P005
      SET GRSTATUS = '1'
      WHERE EBELN = GS_PO_OUTPUT_ALV-EBELN
        AND EBELP = GS_PO_OUTPUT_ALV-EBELP.

    IF SY-SUBRC <> 0.
      MESSAGE 'ZEDT20_P005 업데이트(취소) 실패' TYPE 'E'.
      EXIT.
    ENDIF.

  ENDLOOP.

  " 체크된 행 삭제
  DELETE GT_PO_OUTPUT_ALV WHERE ZCHECKBOX = 'X'.

  MESSAGE '입고 취소 완료: GRSTATUS 값이 복원되었습니다.' TYPE 'S'.

ENDFORM.