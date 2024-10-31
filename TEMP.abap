*&---------------------------------------------------------------------*
*& Report ZEDR00_32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR00_32.

CONSTANTS : C_X TYPE CHAR1 VALUE 'X'.
RANGES : R_FLAG FOR ZEDT20_004-ZQFLAG.

*****1. 데이터선언
"1)ITAB
DATA : BEGIN OF GS_PERNR, "사원정보테이블
  ZPERNR LIKE ZEDT20_004-ZPERNR, "사원번호
  ZPNAME LIKE ZEDT20_005-ZPNAME, "사원이름
  ZDEPCODE LIKE ZEDT20_004-ZDEPCODE, "부서코드
  ZDEPRANK LIKE ZEDT20_004-ZDEPRANK, "직급
  ZEDATE LIKE ZEDT20_004-ZEDATE, "입사일
  ZQFLAG LIKE ZEDT20_004-ZQFLAG, "퇴직상태
  ZGENDER LIKE ZEDT20_005-ZGENDER, "성별
  ZADDRESS LIKE ZEDT20_005-ZADDRESS, "주소
  ZBANKCODE LIKE ZEDT20_008-ZBANKCODE, "은행코드
  ZACCOUNT LIKE ZEDT20_008-ZACCOUNT, "계좌번호
  END OF GS_PERNR.
DATA : GT_PERNR LIKE TABLE OF GS_PERNR.

DATA : BEGIN OF GS_PERNR_ALV, "사원정보 ALV출력용
  ZPERNR LIKE ZEDT20_004-ZPERNR, "사원번호
  ZPNAME LIKE ZEDT20_005-ZPNAME, "사원이름
  ZDEPCODE LIKE ZEDT20_004-ZDEPCODE, "부서코드
  ZDEPCODE_NAME(10), "부서명
  ZDEPRANK_NAME(6),  "직급명
  ZEDATE LIKE ZEDT20_004-ZEDATE, "입사일
  ZQFLAG_NAME(4), "퇴직상태
  ZGENDER_NAME(4), "성별
  ZADDRESS LIKE ZEDT20_005-ZADDRESS, "주소
  ZBANKCODE LIKE ZEDT20_008-ZBANKCODE, "은행코드
  ZBANK_NAME(10),"은행명
  ZACCOUNT LIKE ZEDT20_008-ZACCOUNT, "계좌번호
  END OF GS_PERNR_ALV.
DATA : GT_PERNR_ALV LIKE TABLE OF GS_PERNR_ALV.

"2)필드카탈로그
DATA : GS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.
DATA : GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.

"3)레이아웃
DATA : GS_LAYOUT TYPE SLIS_LAYOUT_ALV.

"4)SORT
DATA : GS_SORT TYPE SLIS_SORTINFO_ALV.
DATA : GT_SORT TYPE SLIS_T_SORTINFO_ALV.

*****2. SCREEN
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
 SELECT-OPTIONS : S_ZPERNR FOR ZEDT20_004-ZPERNR.
 SELECT-OPTIONS : S_DATE FOR ZEDT20_004-DATBI NO-EXTENSION MODIF ID M1.
 PARAMETERS : P_YEAR LIKE ZEDT20_007-ZYEAR DEFAULT SY-DATUM+0(4) MODIF ID M2.
 PARAMETERS : P_MON(2) DEFAULT SY-DATUM+4(2) MODIF ID M2 .
 SELECT-OPTIONS : S_ZDEP FOR ZEDT20_004-ZDEPCODE NO INTERVALS NO-EXTENSION MODIF ID M1.
SELECTION-SCREEN END OF BLOCK B1.

*****3. 초기값 설정
INITIALIZATION.

*****4. 스크린 제어
AT SELECTION-SCREEN OUTPUT.

*****5. MAIN PROGRAM
START-OF-SELECTION.
      PERFORM SELECT_DATA_R1.
*      PERFORM MODIFY_DATA_R1.
      PERFORM ALV_DISPLAY_R1.


*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA_R1
*&---------------------------------------------------------------------*
FORM SELECT_DATA_R1 .

  CLEAR R_FLAG.

  IF P_CH1 = C_X.
  ELSE.
    R_FLAG-SIGN = 'I'.
    R_FLAG-OPTION = 'BT'.
    R_FLAG-LOW = ' '.
    APPEND R_FLAG.
    R_FLAG-LOW = C_X.
    APPEND R_FLAG.
  ENDIF.

  SELECT A~ZPERNR "사원번호
         B~ZPNAME "사원이름
         A~ZDEPCODE "부서코드
         A~ZDEPRANK "직급코드
         A~ZEDATE "입사일
         A~ZQFLAG "퇴직상태
         B~ZGENDER "성별
         B~ZADDRESS "주소
         C~ZBANKCODE "은행코드
         C~ZACCOUNT "계좌번호
    INTO CORRESPONDING FIELDS OF TABLE GT_PERNR
    FROM ZEDT20_004 AS A  INNER JOIN ZEDT20_005 AS B
    ON A~ZPERNR = B~ZPERNR
    INNER JOIN ZEDT20_008 AS C
    ON A~ZPERNR = C~ZPERNR
    WHERE A~ZPERNR IN S_ZPERNR
    AND   A~DATBI => S_DATE-LOW
    AND   A~DATAB > S_DATE-HIGH
    AND   A~ZDEPCODE IN S_ZDEP
    AND   A~ZQFLAG IN R_FLAG.

ENDFORM.

FORM ALV_DISPLAY_R1 .

  PERFORM FIELD_CATALOG.
*  PERFORM SET_LAYOUT.
*  PERFORM SET_SORT.
  PERFORM CALL_ALV USING GT_PERNR_ALV.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
FORM SET_LAYOUT.

  CLEAR GS_LAYOUT.
  GS_LAYOUT-ZEBRA = C_X.

ENDFORM.

FORM SET_SORT.

  CLEAR : GS_SORT, GT_SORT.

  GS_SORT-SPOS = 1.
  GS_SORT-FIELDNAME = 'ZPERNR'.
  GS_SORT-UP = C_X.
  APPEND GS_SORT TO GT_SORT.

ENDFORM.

FORM CALL_ALV USING PT_ALV TYPE STANDARD TABLE.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
     IT_FIELDCAT = GT_FIELDCAT
     IS_LAYOUT = GS_LAYOUT
     IT_SORT = GT_SORT
    TABLES
      T_OUTTAB = PT_ALV.

ENDFORM.