*&---------------------------------------------------------------------*
*&  Include           ZEDR02_021_PAI
*&---------------------------------------------------------------------*

MODULE USER_COMMAND_0100 INPUT.
  CASE OK_CODE.
    WHEN 'APND'.
      CLEAR GS_STUDENT.
      GS_STUDENT-ZCODE = 'SSU-30'.
      GS_STUDENT-ZPERNR = '0000000030'.
      GS_STUDENT-ZKNAME = '도레미'.
      GS_STUDENT-ZENAME = 'MI'.
      GS_STUDENT-ZGENDER = 'F'.
      GS_STUDENT-ZTEL = '01055851143'.
      APPEND GS_STUDENT TO GT_STUDENT.
    WHEN 'SAVE'.
      LOOP AT GT_STUDENT INTO GS_STUDENT.
        MOVE-CORRESPONDING GS_STUDENT TO GS_SAVE.
        APPEND GS_SAVE TO GT_SAVE.
      ENDLOOP.

      MODIFY ZEDT20_001 FROM TABLE GT_SAVE.

      IF SY-SUBRC = 0.
        MESSAGE '저장성공' TYPE 'I'.
      ELSE.
        MESSAGE '저장실패' TYPE 'I'.
      ENDIF.

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