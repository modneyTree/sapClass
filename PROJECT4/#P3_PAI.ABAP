*&---------------------------------------------------------------------*
*&  Include           ZPROJECT20_IR_PAI
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
    WHEN 'APND'.
      PERFORM MAKE_DATA_INPUT.
    WHEN 'DELE'.
      " 현재 클릭한 것 삭제 로직
      PERFORM DELETE_SELECTED_ROW.

    WHEN 'SAVE'.
      PERFORM SAVE_DATA.
    WHEN 'GOOD'.
      PERFORM GOOD_DATA.
    WHEN 'REGR'.
      PERFORM REGR_DATA.

  ENDCASE.

ENDMODULE.


MODULE EXIT_COMMAND INPUT.
  CASE OK_CODE.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.
  CASE OK_CODE.
    WHEN 'APND'.
      PERFORM MAKE_DATA_INPUT.
    WHEN 'DELE'.
      " 현재 클릭한 것 삭제 로직
      PERFORM DELETE_SELECTED_ROW.

    WHEN 'SAVE'.
      PERFORM SAVE_DATA.
    WHEN 'GOOD'.
      PERFORM GOOD_DATA.
    WHEN 'REGR'.
      PERFORM REGR_DATA.

  ENDCASE.
ENDMODULE.