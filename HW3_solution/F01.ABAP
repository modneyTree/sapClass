*&---------------------------------------------------------------------*
*&  Include           ZEDR06_HW003_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SET_DATE
*&---------------------------------------------------------------------*

FORM SET_DATE .

    "주문일자 DEFAULT 값 설정
     IF S_ZODATE[] IS INITIAL.
       CONCATENATE SY-DATUM(4) '01' '01' INTO S_ZODATE-LOW.
       S_ZODATE-HIGH = SY-DATUM(6) && '01'.
       S_ZODATE-SIGN = 'I'.
       S_ZODATE-OPTION = 'BT'.
   
       CALL FUNCTION 'LAST_DAY_OF_MONTHS'
         EXPORTING
           DAY_IN                  = S_ZODATE-HIGH
        IMPORTING
          LAST_DAY_OF_MONTH       = S_ZODATE-HIGH.
   
       APPEND S_ZODATE.
     ENDIF.
   
     "배송날짜 DEFAULT 값 설정
     IF S_ZDDATE[] IS INITIAL.
       CONCATENATE SY-DATUM(4) '01' '01' INTO S_ZDDATE-LOW.
       S_ZDDATE-HIGH = SY-DATUM(6) && '01'.
       S_ZDDATE-SIGN = 'I'.
       S_ZDDATE-OPTION = 'BT'.
   
       CALL FUNCTION 'LAST_DAY_OF_MONTHS'
         EXPORTING
           DAY_IN                  = S_ZDDATE-HIGH
        IMPORTING
          LAST_DAY_OF_MONTH       = S_ZDDATE-HIGH.
   
       APPEND S_ZDDATE.
     ENDIF.
   
   ENDFORM.
   
   *&---------------------------------------------------------------------*
   *&      Form  SELECTION_CONTROL
   *&---------------------------------------------------------------------*
   FORM SELECTION_CONTROL .
   
      LOOP AT SCREEN.
       IF SCREEN-GROUP1 = 'SC1'.
         IF P_RORD = CHECK_X.
           SCREEN-ACTIVE = '1'.
         ELSEIF P_RDEL = CHECK_X.
           SCREEN-ACTIVE = '0'.
         ENDIF.
   
       ELSEIF SCREEN-GROUP1 = 'SC2'.
         IF P_RORD = CHECK_X.
           SCREEN-ACTIVE = '0'.
         ELSEIF P_RDEL = CHECK_X.
           SCREEN-ACTIVE = '1'.
         ENDIF.
       ENDIF.
       MODIFY SCREEN.
      ENDLOOP.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  CHECK_CONDITION
   *&---------------------------------------------------------------------*
   FORM CHECK_CONDITION .
   
     IF S_ZORDNO IS INITIAL.
       IF P_ZID IS INITIAL.
         MESSAGE I000.
         STOP.
       ENDIF.
     ENDIF.
   
     IF P_ZID IS NOT INITIAL.
       IF S_ZODATE IS INITIAL.
         MESSAGE I000.
         STOP.
       ENDIF.
     ENDIF.
   *
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  SELECT_DATA_ORDER
   *&---------------------------------------------------------------------*
   FORM SELECT_DATA_ORDER .
   
     CLEAR : R_FLAG.
     IF P_RETURN <> CHECK_X. "반품내역이 체크가 안되어 있으면 매출만 가져오기
       R_FLAG-SIGN  = 'E'.
       R_FLAG-OPTION = 'EQ'.
       R_FLAG-LOW = '2'.
     ELSE. "반품내역이 체크되어있으면 반품,매출 모두 가져오기
       R_FLAG-SIGN = 'I'.
       R_FLAG-OPTION = 'BT'.
       R_FLAG-LOW = '1'.
       R_FLAG-HIGH = '2'.
     ENDIF.
     APPEND R_FLAG.
   
     SELECT ZORDNO "주문번호
            ZIDCODE "회원ID
            ZMATNR "제품번호
            ZMTART "제품유형
            ZMATNAME "제품명
            ZVOLUM "수량
            VRKME "단위
            ZNSAMT "판매금액
            ZSLAMT "매출금액
            ZDCAMT "할인금액
            ZDC_FG "할인구분
            ZSALE_FG "매출구분
            ZRET_FG "반품구분
            ZJDATE "판매일자
            ZRDATE "반품일자
       INTO CORRESPONDING FIELDS OF TABLE GT_ORDER
       FROM ZEDT06_100
       WHERE ZORDNO IN S_ZORDNO
       AND ZIDCODE IN P_ZID
       AND ZJDATE IN S_ZODATE
       AND ZSALE_FG IN R_FLAG.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  MODIFY_DATA_ORDER
   *&---------------------------------------------------------------------*
   FORM MODIFY_DATA_ORDER .
   
     LOOP AT GT_ORDER INTO GS_ORDER.
   
       CLEAR : GS_ORDER_ALV.
       MOVE-CORRESPONDING GS_ORDER TO GS_ORDER_ALV.
   
       PERFORM MAKE_ZMTART USING GS_ORDER-ZMTART
                           CHANGING GS_ORDER_ALV-ZMTART_NAME.
       PERFORM MAKE_SALE_FG USING GS_ORDER-ZSALE_FG
                           CHANGING GS_ORDER_ALV-ZSALE_FG_NAME.
       PERFORM MAKE_ZRET_FG USING GS_ORDER-ZRET_FG
                            CHANGING GS_ORDER_ALV-ZRET_FG_NAME.
   
       IF GS_ORDER-ZSALE_FG = '1'.
         GS_ORDER_ALV-ZICON = '@08@'.
       ELSEIF GS_ORDER-ZSALE_FG = '2'.
         GS_ORDER_ALV-ZICON = '@0A@'.
       ENDIF.
   
       APPEND GS_ORDER_ALV TO GT_ORDER_ALV.
   
     ENDLOOP.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  SELECT_DATA_DELIVERY
   *&---------------------------------------------------------------------*
   FORM SELECT_DATA_DELIVERY .
   
     CLEAR : R_FLAG.
     IF P_RETURN = CHECK_X. "반품내역에 체크가 되어있으면 반품내역도 포함하기
       R_FLAG-SIGN = 'I'.
       R_FLAG-OPTION = 'BT'.
       R_FLAG-LOW = ' '.
       R_FLAG-HIGH = CHECK_X.
     ELSEIF P_RETURN <> CHECK_X. "반품내역에 체크가 안되어있으면 반품내역 제외하기
       R_FLAG-SIGN = 'E'.
       R_FLAG-OPTION = 'EQ'.
       R_FLAG-LOW = 'X'.
     ENDIF.
     APPEND R_FLAG.
   
     SELECT ZORDNO "주문번호
            ZIDCODE "회원ID
            ZMATNR "제품번호
            ZMTART "제품유형
            ZMATNAME "제품명
            ZVOLUM "수량
            VRKME "단위
            ZSLAMT "매출금액
            ZDFLAG "배송현황
            ZDGUBUN "배송지역
            ZDDATE "배송일자
            ZRDATE "반품일자
            ZFLAG "반품체크
       INTO CORRESPONDING FIELDS OF TABLE GT_DELIVERY
       FROM ZEDT06_101
       WHERE ZORDNO IN S_ZORDNO
       AND ZIDCODE IN P_ZID
       AND ZDDATE IN S_ZDDATE
       AND ZFLAG IN R_FLAG.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  MODIFY_DATA_DELIVERY
   *&---------------------------------------------------------------------*
   
   FORM MODIFY_DATA_DELIVERY .
   
     LOOP AT GT_DELIVERY INTO GS_DELIVERY.
   
       CLEAR GS_DELIVERY_ALV.
       MOVE-CORRESPONDING GS_DELIVERY TO GS_DELIVERY_ALV.
   
       PERFORM MAKE_ZMTART USING GS_DELIVERY-ZMTART
                           CHANGING GS_DELIVERY_ALV-ZMTART_NAME. "제품유형 한글로 변경
       PERFORM MAKE_ZDFLAG USING GS_DELIVERY-ZDFLAG
                            CHANGING GS_DELIVERY_ALV-ZDFLAG_NAME. "배송현황 한글로 변경
       PERFORM MAKE_ZDGUBUN USING GS_DELIVERY-ZDGUBUN
                            CHANGING GS_DELIVERY_ALV-ZDGUBUN_NAME. "배송지역 한글로 변경
   
       IF GS_DELIVERY-ZFLAG = ' '.
         GS_DELIVERY_ALV-ZICON = '@08@'.
       ELSEIF GS_DELIVERY-ZFLAG = 'X'.
         GS_DELIVERY_ALV-ZICON = '@0A@'.
       ENDIF.
   
       APPEND GS_DELIVERY_ALV TO GT_DELIVERY_ALV.
   
     ENDLOOP.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  MAKE_ZMTART
   *&---------------------------------------------------------------------*
   FORM MAKE_ZMTART  USING    P_ORDER_ZMTART
                     CHANGING P_ORDER_ALV_ZMTART_NAME.
   
      CASE P_ORDER_ZMTART.
       WHEN '001'.
         P_ORDER_ALV_ZMTART_NAME = '식품'.
       WHEN '002'.
         P_ORDER_ALV_ZMTART_NAME = '상품'.
       WHEN '003'.
         P_ORDER_ALV_ZMTART_NAME = '제품'.
       WHEN '004'.
         P_ORDER_ALV_ZMTART_NAME = '의류'.
       WHEN '005'.
         P_ORDER_ALV_ZMTART_NAME = '도서'.
       WHEN '006'.
         P_ORDER_ALV_ZMTART_NAME = '서비스'.
     ENDCASE.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  MAKE_SALE_FG
   *&---------------------------------------------------------------------*
   FORM MAKE_SALE_FG  USING    P_ORDER_ZSALE_FG
                      CHANGING P_ORDER_ALV_ZSALE_FG_NAME.
   
     CASE P_ORDER_ZSALE_FG.
       WHEN '1'.
         P_ORDER_ALV_ZSALE_FG_NAME = '매출'.
       WHEN '2'.
         P_ORDER_ALV_ZSALE_FG_NAME = '반품'.
     ENDCASE.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  MAKE_ZRET_FG
   *&---------------------------------------------------------------------*
   FORM MAKE_ZRET_FG  USING    P_ORDER_ZRET_FG
                      CHANGING P_ORDER_ALV_ZRET_FG_NAME.
   
     CASE P_ORDER_ZRET_FG.
       WHEN '1'.
         P_ORDER_ALV_ZRET_FG_NAME = '단순변심'.
       WHEN '2'.
         P_ORDER_ALV_ZRET_FG_NAME = '제품하자'.
       WHEN '3'.
         P_ORDER_ALV_ZRET_FG_NAME = '배송문제'.
     ENDCASE.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  MAKE_ZDFLAG
   *&---------------------------------------------------------------------*
   
   FORM MAKE_ZDFLAG  USING    P_DELIVERY_ZDFLAG
                     CHANGING P_DELIVERY_ALV_ZDFLAG_NAME.
   
      CASE  P_DELIVERY_ZDFLAG.
       WHEN '1'.
         P_DELIVERY_ALV_ZDFLAG_NAME = '배송시작'.
       WHEN '2'.
         P_DELIVERY_ALV_ZDFLAG_NAME = '배송중'.
       WHEN '3'.
         P_DELIVERY_ALV_ZDFLAG_NAME = '배송완료'.
      ENDCASE.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  MAKE_ZDGUBUN
   *&---------------------------------------------------------------------*
   
   FORM MAKE_ZDGUBUN  USING    P_DELIVERY_ZDGUBUN
                      CHANGING P_DELIVERY_ALV_ZDGUBUN_NAME.
   
     CASE P_DELIVERY_ZDGUBUN.
       WHEN '1'.
         P_DELIVERY_ALV_ZDGUBUN_NAME = '서울'.
       WHEN '2'.
         P_DELIVERY_ALV_ZDGUBUN_NAME = '경기도'.
       WHEN '3'.
         P_DELIVERY_ALV_ZDGUBUN_NAME = '충청도'.
       WHEN '4'.
         P_DELIVERY_ALV_ZDGUBUN_NAME = '경상도'.
       WHEN '5'.
         P_DELIVERY_ALV_ZDGUBUN_NAME = '강원도'.
       WHEN '6'.
         P_DELIVERY_ALV_ZDGUBUN_NAME = '전라도'.
       WHEN '7'.
         P_DELIVERY_ALV_ZDGUBUN_NAME = '제주'.
      ENDCASE.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  CREATE_OBJECT
   *&---------------------------------------------------------------------*
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
   
   
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  FIELD_CATALOG
   *&---------------------------------------------------------------------*
   FORM FIELD_CATALOG .
   
     CLEAR : GS_FIELDCAT, GT_FIELDCAT.
     GS_FIELDCAT-COL_POS = 1.
     GS_FIELDCAT-FIELDNAME = 'ZICON'.
     GS_FIELDCAT-COLTEXT = '구분'.
     GS_FIELDCAT-ICON = 'X'.
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
   
     IF P_RORD = CHECK_X.
   
       CLEAR : GS_FIELDCAT.
       GS_FIELDCAT-COL_POS = 9.
       GS_FIELDCAT-FIELDNAME = 'ZNSAMT'.
       GS_FIELDCAT-COLTEXT = '판매금액'.
       GS_FIELDCAT-DO_SUM = 'X'.
       GS_FIELDCAT-CURRENCY = 'KRW'.
       APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
       CLEAR : GS_FIELDCAT.
       GS_FIELDCAT-COL_POS = 10.
       GS_FIELDCAT-FIELDNAME = 'ZSLAMT'.
       GS_FIELDCAT-COLTEXT = '매출금액'.
       GS_FIELDCAT-DO_SUM = 'X'.
       GS_FIELDCAT-CURRENCY = 'KRW'.
       APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
       CLEAR : GS_FIELDCAT.
       GS_FIELDCAT-COL_POS = 11.
       GS_FIELDCAT-FIELDNAME = 'ZDCAMT'.
       GS_FIELDCAT-COLTEXT = '할인금액'.
       GS_FIELDCAT-DO_SUM ='X'.
       GS_FIELDCAT-CURRENCY = 'KRW'.
       APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
       CLEAR : GS_FIELDCAT.
       GS_FIELDCAT-COL_POS = 12.
       GS_FIELDCAT-FIELDNAME = 'ZSALE_FG_NAME'.
       GS_FIELDCAT-COLTEXT = '매출구분'.
       GS_FIELDCAT-EMPHASIZE = 'X'.
       APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
       CLEAR : GS_FIELDCAT.
       GS_FIELDCAT-COL_POS = 13.
       GS_FIELDCAT-FIELDNAME = 'ZJDATE'.
       GS_FIELDCAT-COLTEXT = '판매일자'.
       APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
       IF P_RETURN = CHECK_X.
         CLEAR : GS_FIELDCAT.
         GS_FIELDCAT-COL_POS = 14.
         GS_FIELDCAT-FIELDNAME = 'ZRET_FG_NAME'.
         GS_FIELDCAT-COLTEXT = '반품구분'.
         APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
         CLEAR : GS_FIELDCAT.
         GS_FIELDCAT-COL_POS = 15.
         GS_FIELDCAT-FIELDNAME = 'ZRDATE'.
         GS_FIELDCAT-COLTEXT = '반품일자'.
         APPEND GS_FIELDCAT TO GT_FIELDCAT.
       ENDIF.
   
     ELSEIF P_RDEL = CHECK_X.
   
       CLEAR : GS_FIELDCAT.
       GS_FIELDCAT-COL_POS = 9.
       GS_FIELDCAT-FIELDNAME = 'ZSLAMT'.
       GS_FIELDCAT-COLTEXT = '매출금액'.
       GS_FIELDCAT-DO_SUM = 'X'.
       GS_FIELDCAT-CURRENCY = 'KRW'.
       APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
   
       CLEAR : GS_FIELDCAT.
       GS_FIELDCAT-COL_POS = 10.
       GS_FIELDCAT-FIELDNAME = 'ZDFLAG_NAME'.
       GS_FIELDCAT-COLTEXT = '배송현황'.
       APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
       CLEAR : GS_FIELDCAT.
       GS_FIELDCAT-COL_POS = 11.
       GS_FIELDCAT-FIELDNAME = 'ZDGUBUN_NAME'.
       GS_FIELDCAT-COLTEXT = '배송지역'.
       GS_FIELDCAT-EMPHASIZE = 'X'.
       APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
       CLEAR : GS_FIELDCAT.
       GS_FIELDCAT-COL_POS = 12.
       GS_FIELDCAT-FIELDNAME = 'ZDDATE'.
       GS_FIELDCAT-COLTEXT = '배송일자'.
       APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
       IF P_RETURN = CHECK_X.
         CLEAR : GS_FIELDCAT.
         GS_FIELDCAT-COL_POS = 13.
         GS_FIELDCAT-FIELDNAME = 'ZRDATE'.
         GS_FIELDCAT-COLTEXT = '반품일자'.
         APPEND GS_FIELDCAT TO GT_FIELDCAT.
   
         CLEAR : GS_FIELDCAT.
         GS_FIELDCAT-COL_POS = 14.
         GS_FIELDCAT-FIELDNAME = 'ZFLAG'.
         GS_FIELDCAT-COLTEXT = '반품체크'.
         GS_FIELDCAT-EMPHASIZE = 'X'.
         APPEND GS_FIELDCAT TO GT_FIELDCAT.
       ENDIF.
     ENDIF.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  ALV_LAYOUT
   *&---------------------------------------------------------------------*
   FORM ALV_LAYOUT .
   
     CLEAR : GS_LAYOUT.
     GS_LAYOUT-SEL_MODE = 'A'.
     GS_LAYOUT-ZEBRA = 'X'.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  ALV_SORT
   *&---------------------------------------------------------------------*
   FORM ALV_SORT .
   
     CLEAR : GS_SORT.
     GS_SORT-SPOS = 1.
     GS_SORT-FIELDNAME = 'ZIDCODE'.
     GS_SORT-UP = 'X'.
     GS_SORT-SUBTOT = 'X'.
     APPEND GS_SORT TO GT_SORT.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  ALV_DISPLAY
   *&---------------------------------------------------------------------*
   FORM ALV_DISPLAY  USING    P_ORDER_ALV TYPE STANDARD TABLE.
   
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
         IT_OUTTAB                     = P_ORDER_ALV
         IT_FIELDCATALOG               = GT_FIELDCAT
         IT_SORT                       = GT_SORT
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
   *&---------------------------------------------------------------------*
   *&      Form  REFRESH
   *&---------------------------------------------------------------------*
   FORM REFRESH .
   
     DATA :  LS_STABLE TYPE LVC_S_STBL.
   
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
   *&      Form  GENERATE_PDF
   *&---------------------------------------------------------------------*
   FORM GENERATE_PDF .
   
     DATA : LT_SELECTED_ROWS TYPE LVC_T_ROW. "선택된 행 인덱스 테이블
     DATA : CONDITION_CHECK(1) TYPE I.
   
     CONDITION_CHECK = 1.
   
     PERFORM SELECTED_ROW CHANGING LT_SELECTED_ROWS CONDITION_CHECK.
     PERFORM CONVERT_TO_PDF USING LT_SELECTED_ROWS CONDITION_CHECK.
   
     CLEAR : CONDITION_CHECK.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  SELECTED_ROW
   *&---------------------------------------------------------------------*
   FORM SELECTED_ROW CHANGING LT_SELECTED_ROWS TYPE LVC_T_ROW
                              CONDITION_CHECK.
   
     CLEAR : LT_SELECTED_ROWS.
   
     CALL METHOD GC_GRID->GET_SELECTED_ROWS
       IMPORTING
         ET_INDEX_ROWS = LT_SELECTED_ROWS
   *      ET_ROW_NO     =
         .
     IF LT_SELECTED_ROWS IS INITIAL.
       MESSAGE 'PDF로 변환하고 싶은 행을 선택하세요' TYPE 'I'.
       RETURN.
     ELSEIF LINES( LT_SELECTED_ROWS ) > 1.
        MESSAGE '한 데이터만 선택 가능합니다.' TYPE 'I'.
        RETURN.
     ELSE.
       CONDITION_CHECK = 2.
     ENDIF.
   
   ENDFORM.
   *&---------------------------------------------------------------------*
   *&      Form  CONVERT_TO_PDF
   *&---------------------------------------------------------------------*
   FORM CONVERT_TO_PDF USING LT_SELECTED_ROWS TYPE LVC_T_ROW
                             CONDITION_CHECK.
   
     "날짜와 시간 관련된 데이터
     DATA : LV_DATE TYPE STRING, "날짜
            LV_TIME TYPE STRING. "시간
   
     "파일 경로와 관련된 데이터
     DATA : LV_DIR       TYPE STRING,          " 선택한 디렉토리 경로
            LV_FILE_PATH TYPE STRING,          " 최종 파일 경로
            LV_FILENAME  TYPE STRING VALUE 'File.pdf'. "파일명 설정
   
     "선택된 행과 내용을 담고 있는 데이터
     DATA:  LS_SELECTED_ROW TYPE LVC_S_ROW, "선택된 행
            LS_SELECTED_DATA LIKE GS_ORDER_ALV. " ALV 데이터 구조
   
     "스풀과 관련된 데이터
     DATA: LV_SPOOLID TYPE RSPOID, "스풀ID
           LT_PDF_DATA TYPE TABLE OF TLINE, "스풀 데이터를 변환한 PDF 내용
           LV_PDF_LENGTH TYPE I. "PDF 데이터 길이
   
   
     LV_DATE = SY-DATUM+0(4) && SY-DATUM+4(2) && SY-DATUM+6(2). " YYYYMMDD 형식
     LV_TIME = SY-UZEIT+0(2) && SY-UZEIT+2(2) && SY-UZEIT+4(2). " HHMMSS 형식
   
      READ TABLE LT_SELECTED_ROWS INTO LS_SELECTED_ROW INDEX 1.
   
      IF SY-SUBRC = 0.
        READ TABLE GT_ORDER_ALV INTO LS_SELECTED_DATA INDEX LS_SELECTED_ROW-INDEX.
      ENDIF.
   
      IF sy-subrc <> 0.
        MESSAGE '선택된 행이 없습니다.' TYPE 'E'.
        RETURN.
     ENDIF.
   
     "행을 하나만 선택했을 경우에만 실행
     IF CONDITION_CHECK = 2.
   
       "디렉토리 선택
       CALL METHOD CL_GUI_FRONTEND_SERVICES=>DIRECTORY_BROWSE
   *      EXPORTING
   *        WINDOW_TITLE         =
   *        INITIAL_FOLDER       =
         CHANGING
           SELECTED_FOLDER      = LV_DIR
         EXCEPTIONS
           CNTL_ERROR           = 1
           ERROR_NO_GUI         = 2
           NOT_SUPPORTED_BY_GUI = 3
           others               = 4
               .
   
       IF SY-SUBRC <> 0.
        MESSAGE '디렉토리 선택 중 오류가 발생했습니다.' TYPE 'E'.
        RETURN.
       ENDIF.
   
       CONCATENATE LV_DIR '\' LV_DATE '_' LV_TIME '_' LV_FILENAME INTO LV_FILE_PATH. "최종 저장 될 위치 지정
   
       LS_SELECTED_DATA-ZSLAMT = LS_SELECTED_DATA-ZSLAMT * 100.
   
       NEW-PAGE PRINT ON NO DIALOG.
       WRITE : / '주문 번호: ' , LS_SELECTED_DATA-ZORDNO.
       WRITE : / '회원 ID: '  , LS_SELECTED_DATA-ZIDCODE.
       WRITE : / '제품번호: '  , LS_SELECTED_DATA-ZMATNR, ' 제품명: ' , LS_SELECTED_DATA-ZMATNAME.
       WRITE : / '매출금액: '  , LS_SELECTED_DATA-ZSLAMT DECIMALS 0 , ' 원'.
       WRITE : / '판매일자: '  , LS_SELECTED_DATA-ZJDATE.
       NEW-PAGE PRINT OFF.
   
       LV_SPOOLID = SY-SPONO.
   
       CALL FUNCTION 'CONVERT_ABAPSPOOLJOB_2_PDF'
         EXPORTING
           SRC_SPOOLID                    = LV_SPOOLID
           NO_DIALOG                      = 'X'
   *       DST_DEVICE                     =
   *       PDF_DESTINATION                =
   *       NO_BACKGROUND                  =
   *       GET_SIZE_FROM_FORMAT           = 'U'
   *       USE_CASCADING                  = ' '
        IMPORTING
          PDF_BYTECOUNT                  = LV_PDF_LENGTH
   *       PDF_SPOOLID                    =
   *       LIST_PAGECOUNT                 =
   *       BTC_JOBNAME                    =
   *       BTC_JOBCOUNT                   =
   *       BIN_FILE                       =
        TABLES
          PDF                            = LT_PDF_DATA.
   
       "PDF 파일로 저장
       CALL FUNCTION 'GUI_DOWNLOAD'
         EXPORTING
          BIN_FILESIZE                    = LV_PDF_LENGTH
           FILENAME                        = LV_FILE_PATH
           FILETYPE                        = 'BIN'
         TABLES
           DATA_TAB                        = LT_PDF_DATA.
   
       IF SY-SUBRC <> 0.
         MESSAGE 'PDF 파일로의 저장을 실패했습니다.' TYPE 'E'.
         RETURN.
       ELSE.
         MESSAGE 'PDF 저장을 성공적으로 수행했습니다.' TYPE 'I'.
       ENDIF.
     ENDIF.
   
   ENDFORM.