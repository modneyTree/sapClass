*&---------------------------------------------------------------------*
*&  Include           ZPROJECT20_PO_CLS
*&---------------------------------------------------------------------*

CLASS EVENT DEFINITION.
    PUBLIC SECTION.
  
  *
  *    METHODS HANDLER_USER_COMMAND FOR EVENT USER_COMMAND
  *                                 OF CL_GUI_ALV_GRID
  *                                 IMPORTING E_UCOMM.
  *
  
  *
      METHODS HANDLER_DATA_CHANGED FOR EVENT DATA_CHANGED
                                   OF CL_GUI_ALV_GRID
                                   IMPORTING ER_DATA_CHANGED
                                             E_ONF4
                                             E_ONF4_BEFORE
                                             E_ONF4_AFTER
                                             E_UCOMM.
  
  
  ENDCLASS.
  
  CLASS EVENT IMPLEMENTATION.
  
  *  METHOD HANDLER_USER_COMMAND.
  *      PERFORM ALV_HANDLER_USER_COMMAND USING E_UCOMM.
  *    ENDMETHOD.
  
    METHOD HANDLER_DATA_CHANGED.
      PERFORM ALV_HANDLER_DATA_CHANGED USING ER_DATA_CHANGED
                                              E_ONF4
                                              E_ONF4_BEFORE
                                              E_ONF4_AFTER
                                              E_UCOMM.
      ENDMETHOD.
  
  
  ENDCLASS.