
" 필드 카탈로그
*&---------------------------------------------------------------------*
*& Report ZEDR20_29
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_29.

TABLES : ZEDT20_002.

DATA : BEGIN OF GS_STUDENT.
  INCLUDE TYPE ZEDT20_002.
DATA : END OF GS_STUDENT.
DATA : GT_STUDENT LIKE TABLE OF ZEDT20_002.

DATA : GS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.
DATA : GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
  SELECT-OPTIONS : S_ZCODE FOR ZEDT20_002-ZCODE.
  PARAMETERS : P_ZPERNR LIKE ZEDT20_002-ZPERNR.
*  PARAMETERS : P_ZGEN LIKE ZEDT20_002-ZGENDER MODIF ID SC1.
SELECTION-SCREEN END OF BLOCK B1.

INITIALIZATION.
S_ZCODE-LOW = 'SSU-01'.
S_ZCODE-HIGH = 'SSU-99'.
APPEND S_ZCODE.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'SC1'.
      SCREEN-INPUT = 0.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.


START-OF-SELECTION.
  PERFORM GET_DATA.
*  PERFORM MODIFY_DATA.

END-OF-SELECTION.
  PERFORM ALV_DISPLAY.


FORM ALV_DISPLAY .

  PERFORM FIELD_CATALOG.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    IT_FIELDCAT = GT_FIELDCAT
  TABLES
    T_OUTTAB = GT_STUDENT.

*  PERFORM FIELD_CATALOG.
*  PERFORM CALL_ALV.

ENDFORM.

FORM GET_DATA.
  SELECT * FROM ZEDT20_002
    INTO CORRESPONDING FIELDS OF TABLE GT_STUDENT
    WHERE ZCODE IN S_ZCODE.
ENDFORM.

*FORM WRITE_DATA. " 함수명 수정
*  LOOP AT GT_STUDENT INTO GS_STUDENT.
*    WRITE :/ GS_STUDENT-ZCODE, GS_STUDENT-ZKNAME.
*  ENDLOOP.
*ENDFORM.

FORM FIELD_CATALOG .

  CLEAR : GS_FIELDCAT, GT_FIELDCAT.
  GS_FIELDCAT-COL_POS = 1.
  GS_FIELDCAT-FIELDNAME = 'ZCODE'.
  GS_FIELDCAT-SELTEXT_M = '학생코드'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 2.
  GS_FIELDCAT-FIELDNAME = 'ZPERNR'.
  GS_FIELDCAT-SELTEXT_M = '출석번호'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 3.
  GS_FIELDCAT-FIELDNAME = 'ZMAJOR'.
  GS_FIELDCAT-SELTEXT_M = '전공'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 4.
  GS_FIELDCAT-FIELDNAME = 'ZMNAME'.
  GS_FIELDCAT-SELTEXT_M = '전공명'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR : GS_FIELDCAT.
  GS_FIELDCAT-COL_POS = 5.
  GS_FIELDCAT-FIELDNAME = 'ZSUM'.
  GS_FIELDCAT-SELTEXT_M = '등록금액'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.

FORM CALL_ALV .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid    " 현재 프로그램 이름
      it_fieldcat        = GT_FIELDCAT " 필드 카탈로그
    TABLES
      t_outtab           = GT_STUDENT  " 출력할 데이터
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    WRITE: / 'ALV 출력 중 오류가 발생했습니다.'.
  ENDIF.

ENDFORM.