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

SELECT * FROM ZEDT20_P005
  INTO CORRESPONDING FIELDS OF TABLE GT_PO_ITEM.

SELECT * FROM ZEDT20_P006
  APPENDING CORRESPONDING FIELDS OF TABLE GT_PO_ITEM.


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
  " 빈 줄 하나를 만든다 (편집용도). 단, ZLFA1_EBELN 자동 채번되어야 한다. PO 관련해서 가져옴
  CLEAR : GS_PO_HEAD.

  " 현재 최대 EBELN 값 가져오기
  DATA: LV_EBELN TYPE ZEDT20_P004-EBELN.
  SELECT MAX( EBELN ) INTO LV_EBELN FROM ZEDT20_P004.

  " 최대값이 없을 경우 초기값 설정
  IF LV_EBELN IS INITIAL.
    LV_EBELN = '0000000000'.
  ENDIF.

  " 다음 LIFNR 값 계산
  DATA: LV_EBELN_NUM TYPE i.
  LV_EBELN_NUM = LV_EBELN. " 문자형 LIFNR을 정수형으로 변환
  LV_EBELN_NUM = LV_EBELN_NUM + 1. " 최대값 + 1
  LV_EBELN = LV_EBELN_NUM. " 정수형 값을 다시 문자형으로 변환

  " 자리수 포맷팅 (예: 10자리)
  LV_EBELN = LV_EBELN+0(10).

  " 자동 채번된 EBELN 설정
  GS_PO_HEAD-EBELN = LV_EBELN.

  " 추가 필드 초기화
  GS_PO_HEAD-EKORG = P_EKORG.
  GS_PO_HEAD-BEDAT = P_BEDAT.

  " 내부 테이블에 추가
  APPEND GS_PO_HEAD TO GT_PO_HEAD.
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

  CLEAR : GS_FIELDCAT_INPUT, GT_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 1.
  GS_FIELDCAT_INPUT-FIELDNAME = 'ZCOLOR'.
  GS_FIELDCAT_INPUT-COLTEXT = '체크'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 2.
  GS_FIELDCAT_INPUT-FIELDNAME = 'EBELP'.
  GS_FIELDCAT_INPUT-COLTEXT = '품목'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 3.
  GS_FIELDCAT_INPUT-FIELDNAME = 'ZMATNR'.
  GS_FIELDCAT_INPUT-COLTEXT = '자재번호'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 4.
  GS_FIELDCAT_INPUT-FIELDNAME = 'ZMATNAME'.
  GS_FIELDCAT_INPUT-COLTEXT = '자재명'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 5.
  GS_FIELDCAT_INPUT-FIELDNAME = 'MMENGE'.
  GS_FIELDCAT_INPUT-COLTEXT = 'PO수량'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 6.
  GS_FIELDCAT_INPUT-FIELDNAME = 'STPRS'.
  GS_FIELDCAT_INPUT-COLTEXT = '단가'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 7.
  GS_FIELDCAT_INPUT-FIELDNAME = 'ZMEINS'.
  GS_FIELDCAT_INPUT-COLTEXT = '단위'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 8.
  GS_FIELDCAT_INPUT-FIELDNAME = 'WAERS'.
  GS_FIELDCAT_INPUT-COLTEXT = '통화'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 9.
  GS_FIELDCAT_INPUT-FIELDNAME = 'ZLFM1_MWSKZ'.
  GS_FIELDCAT_INPUT-COLTEXT = '세금코드'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 10.
  GS_FIELDCAT_INPUT-FIELDNAME = 'PRDAT'.
  GS_FIELDCAT_INPUT-COLTEXT = '납품일'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 11.
  GS_FIELDCAT_INPUT-FIELDNAME = 'ZWERKS'.
  GS_FIELDCAT_INPUT-COLTEXT = '플랜트'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

  CLEAR : GS_FIELDCAT_INPUT.
  GS_FIELDCAT_INPUT-COL_POS = 12.
  GS_FIELDCAT_INPUT-FIELDNAME = 'ZLGORT'.
  GS_FIELDCAT_INPUT-COLTEXT = '저장위치'.
  GS_FIELDCAT_INPUT-EDIT = 'X'.
  APPEND GS_FIELDCAT_INPUT TO GT_FIELDCAT_INPUT.

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
      IT_OUTTAB                     = GT_PO_INPUT
      IT_FIELDCATALOG               = GT_FIELDCAT_INPUT
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
    READ TABLE GT_PO_INPUT INTO GS_PO_INPUT INDEX LS_MODI-ROW_ID.

    " 변경된 필드에 따라 처리
    IF LS_MODI-FIELDNAME = 'ZMATNR' OR
       LS_MODI-FIELDNAME = 'ZWERKS' OR
       LS_MODI-FIELDNAME = 'ZLGORT'.

      " 내부 테이블에서 현재 자재, 플랜트, 저장위치 값 가져오기
      LV_ZMATNR = GS_PO_INPUT-ZMATNR.
      LV_WERKS = GS_PO_INPUT-ZWERKS.
      LV_LGORT = GS_PO_INPUT-ZLGORT.

      " 만약 변경된 필드에 따라 값이 LS_MODI-VALUE로 변경되었다면 반영
      IF LS_MODI-FIELDNAME = 'ZMATNR'.
        LV_ZMATNR = LS_MODI-VALUE.
        GS_PO_INPUT-ZMATNR = LS_MODI-VALUE.
      ELSEIF LS_MODI-FIELDNAME = 'ZWERKS'.
        LV_WERKS = LS_MODI-VALUE.
        GS_PO_INPUT-ZWERKS = LS_MODI-VALUE.
      ELSEIF LS_MODI-FIELDNAME = 'ZLGORT'.
        LV_LGORT = LS_MODI-VALUE.
        GS_PO_INPUT-ZLGORT = LS_MODI-VALUE.
      ENDIF.

      " 자재번호가 없으면 체크할 필요 없음 -> 빨간 불로 처리하거나 유지
      IF LV_ZMATNR IS INITIAL.
        GS_PO_INPUT-ZCOLOR = ICON_LED_RED.
      ELSE.
        " 자재마스터 정합성 체크
        " ZEDT20P_200에서 ZMATNR, ZWERKS, ZLGORT로 조회
        SELECT SINGLE ZMATNR FROM ZEDT20P_200
               WHERE ZMATNR = @LV_ZMATNR
                 AND ZWERKS = @LV_WERKS
                 AND ZLGORT = @LV_LGORT
               INTO @DATA(LV_EXIST_MATNR).

        IF sy-subrc = 0.
          " 자재 마스터에 해당 조합 존재 -> 녹색 표시
          GS_PO_INPUT-ZCOLOR = ICON_LED_GREEN.
        ELSE.
          " 해당 조합 미존재 -> 빨간 표시
          GS_PO_INPUT-ZCOLOR = ICON_LED_RED.
        ENDIF.
      ENDIF.

      MODIFY GT_PO_INPUT FROM GS_PO_INPUT INDEX LS_MODI-ROW_ID.
      CLEAR GS_PO_INPUT.
    ENDIF.

    " 납품일 정합성 체크
    IF LS_MODI-FIELDNAME = 'PRDAT'.
      DATA LV_PRDAT TYPE D.
      LV_PRDAT = LS_MODI-VALUE.

      IF LV_PRDAT IS INITIAL.
        " 납품일이 없으면 체크 불가 - 필요하다면 처리 로직 추가
        " 여기서는 임의로 빨간색을 주거나 유지하는 방식을 택할 수 있음
        GS_PO_INPUT-ZCOLOR = ICON_LED_RED.
      ELSEIF LV_PRDAT GE P_BEDAT.
        " 납품일이 증빙일(P_BEDAT) 보다 같거나 뒤일 경우
        GS_PO_INPUT-ZCOLOR = ICON_LED_GREEN.
      ELSE.
        " 납품일이 증빙일보다 이전이면 오류
        GS_PO_INPUT-ZCOLOR = ICON_LED_RED.
        MESSAGE '납품일이 증빙일보다 이전입니다.' TYPE 'E' DISPLAY LIKE 'I'.
        EXIT. " 오류 발생 시 루프 종료
      ENDIF.

      MODIFY GT_PO_INPUT FROM GS_PO_INPUT INDEX LS_MODI-ROW_ID.
      CLEAR GS_PO_INPUT.

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
*&---------------------------------------------------------------------*
*&      Form  RIGHT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM RIGHT_DATA.

  DATA: LV_COUNT TYPE I. " 데이터 존재 여부를 확인하기 위한 변수

  " P_EKORG가 ZEDT20_P003 테이블에 존재하는지 확인
  SELECT COUNT( * ) INTO LV_COUNT
    FROM ZEDT20_P003
    WHERE ZLFA1_LIFNR = P_EKORG. " P_EKORG와 일치하는 데이터 확인

  " 정합성 체크 결과
  IF LV_COUNT > 0.
    MESSAGE '구매처번호가 존재합니다.' TYPE 'S'. " 정상 메시지
  ELSE.
    MESSAGE '구매처번호가 존재하지 않습니다.' TYPE 'E'. " 오류 메시지
  ENDIF.

ENDFORM.