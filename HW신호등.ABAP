TYPES : BEGIN OF GTY_DATA.
              INCLUDE TYPE ZD23_VTABLE. "테이블 TYPE지정하기 
TYPES : LIGHT TYPE CHAR1,  "신호등 LIGHT 타입지정 
              END OF GTY_DATA.

DATA : GT_DATA TYPE TABLE OF GTY_DATA, 
        GS_DATA LIKE LINE OF GT_DATA.

 

DATA : GO_CONT TYPE REF TO CL_GUI_CUSTOM_CONTAINER, " ALV선언
            GO_ALV  TYPE REF TO CL_GUI_ALV_GRID.

DATA : OK_CODE TYPE SY-UCOMM. "ALV툴바

DATA : GS_LAYOUT TYPE LVC_S_LAYO. "신호등 LAYOUT

SELECT *
  FROM SBOOK
  INTO CORRESPONDING FIELDS OF TABLE GT_DATA. 

CALL SCREEN 100. "ALV호출


*&---------------------------------------------------------------------*
*& MODULE INT_ALV OUTPUT
*&---------------------------------------------------------------------*
*&  ALV설정
*&---------------------------------------------------------------------*

MODULE INT_ALV OUTPUT.
  IF GO_CONT IS INITIAL.
    CREATE OBJECT GO_CONT
      EXPORTING
        CONTAINER_NAME              = 'CONTAINER1' "레이아웃 이름으로 지정하기
      EXCEPTIONS
        CNTL_ERROR                       = 1
        CNTL_SYSTEM_ERROR      = 2
        CREATE_ERROR                  = 3
        LIFETIME_ERROR                = 4
        LIFETIME_DYNPRO_DYNPRO_LINK = 5
        OTHERS                                               = 6.
    IF SY-SUBRC <> 0.
    ENDIF.

    CREATE OBJECT GO_ALV
      EXPORTING
        I_PARENT          = GO_CONT
      EXCEPTIONS
        ERROR_CNTL_CREATE = 1
        ERROR_CNTL_INIT   = 2
        ERROR_CNTL_LINK   = 3
        ERROR_DP_CREATE   = 4
        OTHERS            = 5.
    IF SY-SUBRC <> 0.
    ENDIF.
    
    PERFORM light. "신호등 FORM문 호출


    CALL METHOD GO_ALV->SET_TABLE_FOR_FIRST_DISPLAY "ALV DISPLAY
      EXPORTING
        I_STRUCTURE_NAME              = 'ZD23_VTABLE' "STRUCTURE.
        I_SAVE                                       = 'A'
        IS_LAYOUT                                = GS_LAYOUT "신호등LAYOUT설정
      CHANGING
        IT_OUTTAB                                = GT_DATA "데이터출력
        IT_FIELDCATALOG                   = GT_FIELDCAT "FIELDCAT설정
      EXCEPTIONS
        INVALID_PARAMETER_COMBINATION = 1
        PROGRAM_ERROR                                = 2
        TOO_MANY_LINES                                 = 3
        OTHERS                                                  = 4.
    IF SY-SUBRC <> 0.
    ENDIF.


  ENDIF.
ENDMODULE.

FORM LIGHT. "신호등 LAYOUT 설정 

    GS_LAYOUT-EXCP_FNAME = 'light'.  "신호등LAYOUT 지정

    GS_LAYOUT-EXCP_LED = 'X'. "신호등LED로변경 

 

    LOOP AT GT_DATA INTO GS_DATA. "테이블 LOOP 조건별 신호등 색상지정

      IF GS_DATA-CARRID = 'AA'. 
        GS_DATA-LIGHT  = 1. "빨강

      ELSEIF GS_DATA-CARRID = 'DL'. 
        GS_DATA-LIGHT  = 2. "노랑

      ELSE .
        GS_DATA-LIGHT  = 3. "초록
      ENDIF.

      MODIFY GT_DATA FROM GS_DATA. "MODIFY 수정
      CLEAR : GS_DATA.

    ENDLOOP.

ENDFORM.