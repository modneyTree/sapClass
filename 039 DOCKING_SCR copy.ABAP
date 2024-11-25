*&---------------------------------------------------------------------*
*&  Include           ZEDR20_39_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
  SELECT-OPTIONS : S_ZCODE FOR ZEDT20_001-ZCODE DEFAULT 'SSU-01' TO 'SSU-10'.
  PARAMETERS : P_ZPERNR LIKE ZEDT20_001-ZPERNR.
  PARAMETERS : P_GENDER LIKE ZEDT20_001-ZGENDER MODIF ID SC1.
SELECTION-SCREEN END OF BLOCK B1.