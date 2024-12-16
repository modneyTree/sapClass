*&---------------------------------------------------------------------*
*&  Include           ZEDR20_HW003_F01
*&---------------------------------------------------------------------*

FORM SET_INIT .

  "주문날짜 초기값 세팅
  IF S_JDATE[] IS INITIAL.
    CONCATENATE SY-DATUM(4) '01' '01' INTO S_JDATE-LOW.
    S_JDATE-HIGH = SY-DATUM(6) && '01'. "&&로도 표현 가능 (=CONCATENATE)
    S_JDATE-SIGN = 'I'.
    S_JDATE-OPTION = 'BT'.

    CALL FUNCTION 'LAST_DAY_OF_MONTHS'
      EXPORTING
        DAY_IN            = S_JDATE-HIGH
      IMPORTING
        LAST_DAY_OF_MONTH = S_JDATE-HIGH.

    APPEND S_JDATE.
  ENDIF.

  "배송날짜 초기값 세팅
  IF S_DDATE[] IS INITIAL.
      CONCATENATE SY-DATUM(4) '01' '01' INTO S_DDATE-LOW.
      S_DDATE-HIGH = SY-DATUM(6) && '01'. "&&로도 표현 가능 (=CONCATENATE)
      S_DDATE-SIGN = 'I'.
      S_DDATE-OPTION = 'BT'.

      CALL FUNCTION 'LAST_DAY_OF_MONTHS'
          EXPORTING
          DAY_IN            = S_DDATE-HIGH
          IMPORTING
          LAST_DAY_OF_MONTH = S_DDATE-HIGH.

      APPEND S_DDATE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_SCREEN
*&---------------------------------------------------------------------*
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
*FORM GET_DATA .
*
*  SELECT * FROM ZEDT00_001
*    INTO CORRESPONDING FIELDS OF TABLE GT_STUDENT
*    WHERE ZCODE IN S_ZCODE.
*
*ENDFORM.
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

  " 아이콘 필드 설정
  GS_FIELDCAT-COL_POS = 1.
  GS_FIELDCAT-FIELDNAME = 'LIGHT_ICON'.
  GS_FIELDCAT-COLTEXT = '구분'.
  GS_FIELDCAT-ICON = 'X'. "아이콘 표시 활성화
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-FIELDNAME = 'ZORDNO'.
  GS_FIELDCAT-COLTEXT = '주문번호'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 3.
  GS_FIELDCAT-FIELDNAME = 'ZIDCODE'.
  GS_FIELDCAT-COLTEXT = '회원ID'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 4.
  GS_FIELDCAT-FIELDNAME = 'ZMATNR'.
  GS_FIELDCAT-COLTEXT = '제품번호'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 5.
  GS_FIELDCAT-FIELDNAME = 'ZMATNAME'.
  GS_FIELDCAT-COLTEXT = '제품명'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 6.
  GS_FIELDCAT-FIELDNAME = 'ZMTART_NAME'.
  GS_FIELDCAT-COLTEXT = '제품유형'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.


  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 7.
  GS_FIELDCAT-FIELDNAME = 'ZVOLUM'.
  GS_FIELDCAT-COLTEXT = '수량'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 8.
  GS_FIELDCAT-FIELDNAME = 'VRKME'.
  GS_FIELDCAT-COLTEXT = '단위'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 9.
  GS_FIELDCAT-FIELDNAME = 'ZNSAMT'.
  GS_FIELDCAT-COLTEXT = '판매금액'.
  GS_FIELDCAT-CURRENCY = 'KRW'.
  GS_FIELDCAT-DO_SUM = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 10.
  GS_FIELDCAT-FIELDNAME = 'ZSLAMT'.
  GS_FIELDCAT-COLTEXT = '매출금액'.
  GS_FIELDCAT-CURRENCY = 'KRW'.
  GS_FIELDCAT-DO_SUM = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 11.
  GS_FIELDCAT-FIELDNAME = 'ZDCAMT'.
  GS_FIELDCAT-COLTEXT = '할인금액'.
  GS_FIELDCAT-CURRENCY = 'KRW'.
  GS_FIELDCAT-DO_SUM = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 12.
  GS_FIELDCAT-FIELDNAME = 'ZSALE_FG_NAME'.
  GS_FIELDCAT-COLTEXT = '매출구분'.
*  GS_FIELDCAT-EDIT = 'X'.
  GS_FIELDCAT-EMPHASIZE = 'X'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 13.
  GS_FIELDCAT-FIELDNAME = 'ZJDATE'.
  GS_FIELDCAT-COLTEXT = '판매일자'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 14.
  GS_FIELDCAT-FIELDNAME = 'ZRET_FG_NAME'.
  GS_FIELDCAT-COLTEXT = '반품구분'.

  IF P_CH = 'X'.
  ELSE.
    GS_FIELDCAT-NO_OUT = 'X'.
  ENDIF.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 15.
  GS_FIELDCAT-FIELDNAME = 'ZRDATE'.
  GS_FIELDCAT-COLTEXT = '반품일자'.

  IF P_CH = 'X'.
  ELSE.
    GS_FIELDCAT-NO_OUT = 'X'.
  ENDIF.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.

FORM FIELD_CATALOG2 .

  CLEAR : GS_FIELDCAT2 , GT_FIELDCAT2.

  " 아이콘 필드 설정
  GS_FIELDCAT2-COL_POS = 1.
  GS_FIELDCAT2-FIELDNAME = 'LIGHT_ICON'.
  GS_FIELDCAT2-COLTEXT = '구분'.
  GS_FIELDCAT2-ICON = 'X'. "아이콘 표시 활성화
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 2.
  GS_FIELDCAT2-FIELDNAME = 'ZORDNO'.
  GS_FIELDCAT2-COLTEXT = '주문번호'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 3.
  GS_FIELDCAT2-FIELDNAME = 'ZIDCODE'.
  GS_FIELDCAT2-COLTEXT = '회원ID'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 4.
  GS_FIELDCAT2-FIELDNAME = 'ZMATNR'.
  GS_FIELDCAT2-COLTEXT = '제품번호'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 5.
  GS_FIELDCAT2-FIELDNAME = 'ZMATNAME'.
  GS_FIELDCAT2-COLTEXT = '제품명'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 6.
  GS_FIELDCAT2-FIELDNAME = 'ZMTART_NAME'.
  GS_FIELDCAT2-COLTEXT = '제품유형'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.


  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 7.
  GS_FIELDCAT2-FIELDNAME = 'ZVOLUM'.
  GS_FIELDCAT2-COLTEXT = '수량'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 8.
  GS_FIELDCAT2-FIELDNAME = 'VRKME'.
  GS_FIELDCAT2-COLTEXT = '단위'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 9.
  GS_FIELDCAT2-FIELDNAME = 'ZSLAMT'.
  GS_FIELDCAT2-COLTEXT = '매출금액'.
  GS_FIELDCAT2-CURRENCY = 'KRW'.
  GS_FIELDCAT2-DO_SUM = 'X'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 10.
  GS_FIELDCAT2-FIELDNAME = 'ZDFLAG_NAME'.
  GS_FIELDCAT2-COLTEXT = '배송현황'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 11.
  GS_FIELDCAT2-FIELDNAME = 'ZDGUBUN_NAME'.
  GS_FIELDCAT2-COLTEXT = '배송지역'.
  GS_FIELDCAT2-EMPHASIZE = 'X'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 12.
  GS_FIELDCAT2-FIELDNAME = 'ZDDATE'.
  GS_FIELDCAT2-COLTEXT = '배송일자'.
  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 13.
  GS_FIELDCAT2-FIELDNAME = 'ZRDATE'.
  GS_FIELDCAT2-COLTEXT = '반품일자'.

  IF P_CH = 'X'.
  ELSE.
    GS_FIELDCAT2-NO_OUT = 'X'.
  ENDIF.

  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

  CLEAR : GS_FIELDCAT2.
  GS_FIELDCAT2-COL_POS = 14.
  GS_FIELDCAT2-FIELDNAME = 'ZFLAG'.
  GS_FIELDCAT2-COLTEXT = '반품체크'.
  GS_FIELDCAT2-EMPHASIZE = 'X'.

  IF P_CH = 'X'.
  ELSE.
    GS_FIELDCAT2-NO_OUT = 'X'.
  ENDIF.

  APPEND GS_FIELDCAT2 TO GT_FIELDCAT2.

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
  GS_LAYOUT-ZEBRA = 'X'. " ZEBRA 패턴 활성화

  LOOP AT GT_ORDER_ALV INTO GS_ORDER_ALV.

    " 상태에 따른 아이콘 설정
    CASE GS_ORDER_ALV-ZSALE_FG. " 매출 구분에 따라 신호등 색상 설정
      WHEN '1'.
        LIGHT_ICON = '@08@ @0A@ @0A@'. " 빨강-꺼짐-꺼짐
      WHEN '2'.
        LIGHT_ICON = '@0A@ @09@ @0A@'. " 꺼짐-노랑-꺼짐
      WHEN '3'.
        LIGHT_ICON = '@0A@ @0A@ @08@'. " 꺼짐-꺼짐-초록
      WHEN OTHERS.
        LIGHT_ICON = '@0A@ @0A@ @0A@'. " 모두 꺼짐
    ENDCASE.

    GS_ORDER_ALV-LIGHT_ICON = LIGHT_ICON.
    MODIFY GT_ORDER_ALV FROM GS_ORDER_ALV.
    CLEAR : GS_ORDER_ALV.

  ENDLOOP.

  CLEAR : GS_VARIANT.
  GS_VARIANT-REPORT = SY-REPID.
  GS_VARIANT-USERNAME = SY-UNAME.

ENDFORM.

FORM ALV_LAYOUT2 .

  CLEAR : GS_LAYOUT2.
  GS_LAYOUT-ZEBRA = 'X'. " ZEBRA 패턴 활성화

  LOOP AT GT_DELEVER_ALV INTO GS_DELEVER_ALV.

    " 상태에 따른 아이콘 설정
    CASE GS_DELEVER_ALV-ZFLAG. " 매출 구분에 따라 신호등 색상 설정
      WHEN 'X'.
        LIGHT_ICON = '@0A@ @0A@ @08@'. " 빨강-꺼짐-꺼짐
      WHEN OTHERS.
        LIGHT_ICON = '@08@ @0A@ @0A@'. " 꺼짐-꺼짐-초록

    ENDCASE.

    GS_DELEVER_ALV-LIGHT_ICON = LIGHT_ICON.
    MODIFY GT_DELEVER_ALV FROM GS_DELEVER_ALV.
    CLEAR : GS_DELEVER_ALV.

  ENDLOOP.

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

  IF P_R1 = 'X'.
    CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
*        I_BUFFER_ACTIVE               =
*        I_BYPASSING_BUFFER            =
*        I_CONSISTENCY_CHECK           =
*        I_STRUCTURE_NAME              =
        IS_VARIANT                    = GS_VARIANT
*        I_SAVE                        =
*        I_DEFAULT                     = 'X'
        IS_LAYOUT                     = GS_LAYOUT
*        IS_PRINT                      =
*        IT_SPECIAL_GROUPS             =
*        IT_TOOLBAR_EXCLUDING          =
*        IT_HYPERLINK                  =
*        IT_ALV_GRAPHICS               =
*        IT_EXCEPT_QINFO               =
*        IR_SALV_ADAPTER               =
      CHANGING
        IT_OUTTAB                     = GT_ORDER_ALV
        IT_FIELDCATALOG               = GT_FIELDCAT
        IT_SORT                       = GT_SORT
*        IT_FILTER                     =
      EXCEPTIONS
        INVALID_PARAMETER_COMBINATION = 1
        PROGRAM_ERROR                 = 2
        TOO_MANY_LINES                = 3
        OTHERS                        = 4
            .
    IF SY-SUBRC <> 0.
*     Implement suitable error handling here
    ENDIF.

  ELSE.
    CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
*        I_BUFFER_ACTIVE               =
*        I_BYPASSING_BUFFER            =
*        I_CONSISTENCY_CHECK           =
*        I_STRUCTURE_NAME              =
        IS_VARIANT                    = GS_VARIANT
*        I_SAVE                        =
*        I_DEFAULT                     = 'X'
        IS_LAYOUT                     = GS_LAYOUT2
*        IS_PRINT                      =
*        IT_SPECIAL_GROUPS             =
*        IT_TOOLBAR_EXCLUDING          =
*        IT_HYPERLINK                  =
*        IT_ALV_GRAPHICS               =
*        IT_EXCEPT_QINFO               =
*        IR_SALV_ADAPTER               =
      CHANGING
        IT_OUTTAB                     = GT_DELEVER_ALV
        IT_FIELDCATALOG               = GT_FIELDCAT2
        IT_SORT                       = GT_SORT2
*        IT_FILTER                     =
      EXCEPTIONS
        INVALID_PARAMETER_COMBINATION = 1
        PROGRAM_ERROR                 = 2
        TOO_MANY_LINES                = 3
        others                        = 4
            .
    IF SY-SUBRC <> 0.
*     Implement suitable error handling here
    ENDIF.

  ENDIF.


ENDFORM.

*FORM CALL_ALV2 .
*
*CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
*  EXPORTING
**    I_BUFFER_ACTIVE               =
**    I_BYPASSING_BUFFER            =
**    I_CONSISTENCY_CHECK           =
**    I_STRUCTURE_NAME              =
*    IS_VARIANT                    = GS_VARIANT
**    I_SAVE                        =
**    I_DEFAULT                     = 'X'
*    IS_LAYOUT                     = GS_LAYOUT2
**    IS_PRINT                      =
**    IT_SPECIAL_GROUPS             =
**    IT_TOOLBAR_EXCLUDING          =
**    IT_HYPERLINK                  =
**    IT_ALV_GRAPHICS               =
**    IT_EXCEPT_QINFO               =
**    IR_SALV_ADAPTER               =
*  CHANGING
*    IT_OUTTAB                     = GT_DELEVER_ALV
*    IT_FIELDCATALOG               = GT_FIELDCAT2
*    IT_SORT                       = GT_SORT2
**    IT_FILTER                     =
*  EXCEPTIONS
*    INVALID_PARAMETER_COMBINATION = 1
*    PROGRAM_ERROR                 = 2
*    TOO_MANY_LINES                = 3
*    others                        = 4
*        .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.
*ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  MODIFY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM MODIFY_DATA .
*
*ENDFORM.

 FORM ALV_SORT .

  CLEAR : GS_SORT, GT_SORT.

  GS_SORT-SPOS = 1.
  GS_SORT-FIELDNAME = 'ZIDCODE'.
  GS_SORT-UP = 'X'.
  GS_SORT-SUBTOT = 'X'.

  APPEND GS_SORT TO GT_SORT.

ENDFORM.

 FORM ALV_SORT2 .

  CLEAR : GS_SORT2, GT_SORT2.

  GS_SORT2-SPOS = 1.
  GS_SORT2-FIELDNAME = 'ZIDCODE'.
  GS_SORT2-UP = 'X'.
  GS_SORT2-SUBTOT = 'X'.

  APPEND GS_SORT2 TO GT_SORT2.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CHECK_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM CHECK_DATA .

    "조회조건 점검 :
    "주문번호를를 입력하면 주문일자를 입력하지 않아도 되지만,
    "둘 다 입력이 되지 않으면 ERROR를 뿌리며 레포트가 실행되지 않는다.
    "회원 ID가 입력될 대 반드시 주문일지 입력되어야 한다.

*    IF ( S_ZORDNO IS INITIAL ) AND ( S_JDATE IS INITIAL ).
*      MESSAGE I000.
*      EXIT.
*    ENDIF.
*
*    IF ( P_IDCODE IS NOT INITIAL ) AND ( S_JDATE IS INITIAL ).
*      MESSAGE I000.
*      EXIT.
*    ENDIF.

    IF ( S_ZORDNO IS INITIAL ) AND ( P_IDCODE IS INITIAL ).
      MESSAGE E000.
      STOP.
    ENDIF.

    IF ( P_IDCODE IS NOT INITIAL ) AND ( S_JDATE IS INITIAL ).
      MESSAGE E000.
      STOP.
    ENDIF.

*    IF  S_JDATE IS INITIAL .
*    MESSAGE I000.
*    STOP.
*    ENDIF.
*
*    IF S_ZORDNO IS INITIAL.
*      MESSAGE E000.
*      EXIT.
*    ENDIF.

    "S_ZORNO의 길이가 10자리가 아니면 10자리로 변경
    LOOP AT S_ZORDNO ASSIGNING FIELD-SYMBOL(<fs_s_zordno>).
    IF <fs_s_zordno>-LOW IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = <fs_s_zordno>-LOW
        IMPORTING
          OUTPUT = <fs_s_zordno>-LOW.
    ENDIF.
    IF <fs_s_zordno>-HIGH IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = <fs_s_zordno>-HIGH
        IMPORTING
          OUTPUT = <fs_s_zordno>-HIGH.
    ENDIF.
  ENDLOOP.


    "전역변수 점검

  ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_R1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA_R1 .

  CLEAR R_FLAG.

  IF P_CH = C_X.
    R_FLAG-SIGN = 'I'.
    R_FLAG-OPTION = 'EQ'.
    R_FLAG-LOW = '1'.
    APPEND R_FLAG.
    R_FLAG-LOW = '2'.
    APPEND R_FLAG.

  ELSE.
    R_FLAG-SIGN = 'I'.
    R_FLAG-OPTION = 'EQ'.
    R_FLAG-LOW = '1'.
    APPEND R_FLAG.
  ENDIF.

  SELECT * FROM ZEDT20_100
  INTO CORRESPONDING FIELDS OF TABLE GT_ORDER
  WHERE ( ZORDNO IN S_ZORDNO ) AND ( ZJDATE IN S_JDATE ) AND ( ZSALE_FG IN R_FLAG ).

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA_R2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA_R2 .

  IF P_CH = 'X'.
    "반품내역 포함
    SELECT * FROM ZEDT20_101
    INTO CORRESPONDING FIELDS OF TABLE GT_DELEVER
    WHERE ( ZORDNO IN S_ZORDNO ) AND ( ZDDATE IN S_DDATE ).

  ELSE.
*    "반품내역 제외
    SELECT * FROM ZEDT20_101
    INTO CORRESPONDING FIELDS OF TABLE GT_DELEVER
    WHERE ( ZORDNO IN S_ZORDNO ) AND ( ZDDATE IN S_DDATE ) AND ( ZFLAG <> 'X' ) .
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  MODIFY_DATA_R1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MODIFY_DATA_R1 .

  LOOP AT GT_ORDER INTO GS_ORDER.
    MOVE-CORRESPONDING GS_ORDER TO GS_ORDER_ALV.

    "제품유형 변경
    IF GS_ORDER-ZMTART = '001'.
      GS_ORDER_ALV-ZMTART_NAME = '식품'.
    ELSEIF GS_ORDER-ZMTART = '002'.
      GS_ORDER_ALV-ZMTART_NAME = '상품'.
    ELSEIF GS_ORDER-ZMTART = '003'.
      GS_ORDER_ALV-ZMTART_NAME = '제품'.
    ELSEIF GS_ORDER-ZMTART = '004'.
      GS_ORDER_ALV-ZMTART_NAME = '의류'.
    ELSEIF GS_ORDER-ZMTART = '005'.
      GS_ORDER_ALV-ZMTART_NAME = '도서'.
    ELSE.
      GS_ORDER_ALV-ZMTART_NAME = '서비스'.
    ENDIF.

    "할인구분 변경

    "매출구분 변경
    IF GS_ORDER-ZSALE_FG = '1'.
      GS_ORDER_ALV-ZSALE_FG_NAME = '매출'.
    ELSE.
      GS_ORDER_ALV-ZSALE_FG_NAME = '반품'.
    ENDIF.

    "반품구분 변경
    IF GS_ORDER-ZRET_FG = '1'.
      GS_ORDER_ALV-ZRET_FG_NAME = '단순변심'.
    ELSEIF GS_ORDER-ZRET_FG = '2'.
      GS_ORDER_ALV-ZRET_FG_NAME = '제품하자'.
    ELSE.
      GS_ORDER_ALV-ZRET_FG_NAME = ''. "배송문제는 출력하지 않는다.
    ENDIF.

    APPEND GS_ORDER_ALV TO GT_ORDER_ALV.

  ENDLOOP.

ENDFORM.


FORM MODIFY_DATA_R2 .

  LOOP AT GT_DELEVER INTO GS_DELEVER.
    MOVE-CORRESPONDING GS_DELEVER TO GS_DELEVER_ALV.

    " 제품유형 변경
    IF GS_DELEVER-ZMTART = '001'.
      GS_DELEVER_ALV-ZMTART_NAME = '식품'.
    ELSEIF GS_DELEVER-ZMTART = '002'.
      GS_DELEVER_ALV-ZMTART_NAME = '상품'.
    ELSEIF GS_DELEVER-ZMTART = '003'.
      GS_DELEVER_ALV-ZMTART_NAME = '제품'.
    ELSEIF GS_DELEVER-ZMTART = '004'.
      GS_DELEVER_ALV-ZMTART_NAME = '의류'.
    ELSEIF GS_DELEVER-ZMTART = '005'.
      GS_DELEVER_ALV-ZMTART_NAME = '도서'.
    ELSEIF GS_DELEVER-ZMTART = '006'.
      GS_DELEVER_ALV-ZMTART_NAME = '서비스'.
    ENDIF.

    "배송현황 변경
    IF GS_DELEVER-ZDFLAG = '1'.
      GS_DELEVER_ALV-ZDFLAG_NAME = '배송시작'.
    ELSEIF GS_DELEVER-ZDFLAG = '2'.
      GS_DELEVER_ALV-ZDFLAG_NAME = '배송중'.
    ELSE.
      GS_DELEVER_ALV-ZDFLAG_NAME = '배송완료'.
    ENDIF.

    "배송지역 변경
    IF GS_DELEVER-ZDGUBUN = '1'.
      GS_DELEVER_ALV-ZDGUBUN_NAME = '서울'.
    ELSEIF GS_DELEVER-ZDGUBUN = '2'.
      GS_DELEVER_ALV-ZDGUBUN_NAME = '경기'.
    ELSEIF GS_DELEVER-ZDGUBUN = '3'.
      GS_DELEVER_ALV-ZDGUBUN_NAME = '충청'.
    ELSEIF GS_DELEVER-ZDGUBUN = '4'.
      GS_DELEVER_ALV-ZDGUBUN_NAME = '경상'.
    ELSEIF GS_DELEVER-ZDGUBUN = '5'.
      GS_DELEVER_ALV-ZDGUBUN_NAME = '강원'.
    ELSEIF GS_DELEVER-ZDGUBUN = '6'.
      GS_DELEVER_ALV-ZDGUBUN_NAME = '전라'.
    ELSE.
      GS_DELEVER_ALV-ZDGUBUN_NAME = '제주'.
    ENDIF.

    APPEND GS_DELEVER_ALV TO GT_DELEVER_ALV.

  ENDLOOP.

ENDFORM.
FORM generate_pdf_using_excel_ole USING is_data TYPE gs_order_alv.
  TYPE-POOLS: ole2.

  DATA: lv_temp_dir   TYPE string,
        lv_user_dir   TYPE string,
        lv_filename   TYPE string,
        lv_pdfname    TYPE string,
        lv_template   TYPE string,
        lv_rc         TYPE i,
        ls_wwwdata    TYPE wwwdata.

  "1. 임시 디렉토리 획득
  " 대화식 모드 확인
  IF sy-batch = 'X'.
    MESSAGE '해당 프로그램은 대화식 모드에서만 실행 가능합니다.' TYPE 'E'.
  ENDIF.

  " 임시 디렉토리 획득
  CALL METHOD cl_gui_frontend_services=>get_temp_directory
    CHANGING
      TEMP_DIR = lv_temp_dir
    EXCEPTIONS
      others = 1.

  " 오류 발생 시 기본 경로 설정
  IF sy-subrc <> 0 OR lv_temp_dir IS INITIAL.
    "MESSAGE '임시 디렉토리를 가져오는 중 오류가 발생했습니다.' TYPE 'I'.
    lv_temp_dir = 'C:/TEMP'. " 기본 경로 설정
  ENDIF.

  "2. 사용자 로컬 폴더 선택 (바탕화면 등)
  CALL METHOD cl_gui_frontend_services=>directory_browse
    CHANGING
      selected_FOLDER = lv_user_dir.
  IF sy-subrc <> 0 OR lv_user_dir IS INITIAL.
    MESSAGE '저장할 로컬 폴더를 선택하지 않았습니다.' TYPE 'E'.
  ENDIF.

  "4. Excel OLE 초기화
  DATA: excel       TYPE ole2_object,
        workbooks   TYPE ole2_object,
        workbook    TYPE ole2_object,
        worksheets  TYPE ole2_object,
        worksheet   TYPE ole2_object.

  CREATE OBJECT excel 'Excel.Application' NO FLUSH.
  IF sy-subrc <> 0.
    MESSAGE '엑셀 OLE 객체 생성 실패' TYPE 'E'.
  ENDIF.

  SET PROPERTY OF excel 'Visible' = 0.

  "3. 새로운 워크북 생성
  GET PROPERTY OF excel 'Workbooks' = workbooks.
  CALL METHOD OF workbook 'Add'.
  CALL METHOD OF workbook 'Worksheets' = worksheet EXPORTING #1 = 1.



  "5. 템플릿 시트에 데이터 설정
  PERFORM set_cell_value USING worksheet 'A1' '주문번호'.
  PERFORM set_cell_value USING worksheet 'A2' '회원ID : '.
  PERFORM set_cell_value USING worksheet 'A3' '제품번호 : '.
  PERFORM set_cell_value USING worksheet 'A4' '제품명 : '.
  PERFORM set_cell_value USING worksheet 'A5' '매출금액 : '.
  PERFORM set_cell_value USING worksheet 'A6' '판매일자 : '.


  "6. PDF 파일명 설정 (주문번호를 파일명에 활용)
  DATA(lv_pdf_file) = lv_user_dir && '\' && is_data-zordno && '.pdf'.

  "7. PDF로 내보내기 (0 = xlTypePDF)
  "5. PDF로 내보내기
  CALL METHOD OF workbook 'ExportAsFixedFormat'
    EXPORTING
      #1 = 0            " xlTypePDF
      #2 = lv_pdf_file.

  "8. 엑셀 종료
  CALL METHOD OF workbook 'Close' EXPORTING #1 = 0.
  CALL METHOD OF excel 'Quit'.

  FREE OBJECT worksheet.
  FREE OBJECT workbook.
  FREE OBJECT excel.

  "10. 완료 메시지
  MESSAGE |PDF 생성 완료: { lv_pdf_file }| TYPE 'I'.

ENDFORM.

"-----------------------------------------
" Cell 값 설정용 폼 루틴 예제
"-----------------------------------------
FORM set_cell_value USING io_worksheet TYPE ole2_object
                           iv_cell     TYPE string
                           iv_value    TYPE string.
  DATA range TYPE ole2_object.

  CALL METHOD OF io_worksheet 'Range' = range EXPORTING #1 = iv_cell.
  SET PROPERTY OF range 'Value' = iv_value.
  FREE OBJECT range.
ENDFORM.