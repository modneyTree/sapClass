FUNCTION ZED20_CALCULATE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_NUM1) TYPE  I DEFAULT 3
*"     REFERENCE(I_NUM2) TYPE  I DEFAULT 5
*"     REFERENCE(I_OPTION) TYPE  C
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  I
*"     REFERENCE(E_MESSAGE) TYPE  C
*"  TABLES
*"      T_ZEDT20_001 STRUCTURE  ZEDT20_001 OPTIONAL
*"  CHANGING
*"     REFERENCE(P_ZEDT20_001) TYPE  ZEDT20_001 OPTIONAL
*"  EXCEPTIONS
*"      DIV_ZERO
*"----------------------------------------------------------------------


IF I_NUM2 = 0.
  RAISE DIV_ZERO.
  EXIT.
ENDIF.

CASE I_OPTION.
  WHEN '+'.
    E_RESULT = I_NUM1 + I_NUM2.
  WHEN '-'.
    E_RESULT = I_NUM1 - I_NUM2.
  WHEN '*'.
    E_RESULT = I_NUM1 * I_NUM2.
  WHEN '/'.
    E_RESULT = I_NUM1 / I_NUM2.
  WHEN OTHERS.
    E_MESSAGE = ' 올바른 부호를 입력해주세요'.
    EXIT.
ENDCASE.



ENDFUNCTION.






"TABLE SOURCE
FUNCTION ZED20_CALCULATE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_NUM1) TYPE  I DEFAULT 3
*"     REFERENCE(I_NUM2) TYPE  I DEFAULT 5
*"     REFERENCE(I_OPTION) TYPE  C
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  I
*"     REFERENCE(E_MESSAGE) TYPE  C
*"  TABLES
*"      T_ZEDT20_001 STRUCTURE  ZEDT20_001 OPTIONAL
*"  CHANGING
*"     REFERENCE(P_ZEDT20_001) TYPE  ZEDT20_001 OPTIONAL
*"  EXCEPTIONS
*"      DIV_ZERO
*"----------------------------------------------------------------------

DATA : L_ZMNAME LIKE ZEDT20_002-ZMNAME.

IF T_ZEDT20_001[] IS NOT INITIAL.
  LOOP AT T_ZEDT20_001.
    SELECT SINGLE ZKNAME FROM ZEDT00_001 INTO T_ZEDT20_001-ZKNAME
      WHERE ZCODE = P_ZEDT20_001-ZCODE
      AND ZPERNR = P_ZEDT20_001-ZPERNR.

    MODIFY T_ZEDT20_001.


    IF SY-SUBRC = 0.
      E_RESULT = L_ZMNAME.
      E_MESSAGE = '성공'.
    ELSE.
      E_MESSAGE = '실패'.
    ENDIF.
  ENDLOOP.
ELSE.
  E_MESSAGE = '실행할 데이터가 없습니다.'.
ENDIF.


IF I_NUM2 = 0.
  RAISE DIV_ZERO.
  EXIT.
ENDIF.

CASE I_OPTION.
  WHEN '+'.
    E_RESULT = I_NUM1 + I_NUM2.
  WHEN '-'.
    E_RESULT = I_NUM1 - I_NUM2.
  WHEN '*'.
    E_RESULT = I_NUM1 * I_NUM2.
  WHEN '/'.
    E_RESULT = I_NUM1 / I_NUM2.
  WHEN OTHERS.
    E_MESSAGE = ' 올바른 부호를 입력해주세요'.
    EXIT.
ENDCASE.



ENDFUNCTION.










