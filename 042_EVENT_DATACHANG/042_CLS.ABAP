*&---------------------------------------------------------------------*
*&  Include           ZEDR02_021_CLS
*&---------------------------------------------------------------------*

CLASS EVENT DEFINITION.
  PUBLIC SECTION.
    METHODS HANDLER_TOOLBAR FOR EVENT TOOLBAR
                            OF CL_GUI_ALV_GRID
                            IMPORTING E_OBJECT
                                      E_INTERACTIVE.
  
    METHODS HANDLER_USER_COMMAND FOR EVENT USER_COMMAND
                                 OF CL_GUI_ALV_GRID
                                 IMPORTING E_UCOMM.
  
    METHODS HANDLER_HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK
                            OF CL_GUI_ALV_GRID
                            IMPORTING E_ROW_ID
                                      E_COLUMN_ID
                                      ES_ROW_NO.
  
    METHODS HANDLER_DATA_CHANGED FOR EVENT DATA_CHANGED
                                 OF CL_GUI_ALV_GRID
                                 IMPORTING ER_DATA_CHANGED
                                           E_ONF4
                                           E_ONF4_BEFORE
                                           E_ONF4_AFTER
                                           E_UCOMM.
  
    METHODS HANDLER_DATA_CHANGED_FINISHED FOR EVENT DATA_CHANGED_FINISHED OF CL_GUI_ALV_GRID IMPORTING E_MODIFIED ET_GOOD_CELLS.
  
ENDCLASS.
  
CLASS EVENT IMPLEMENTATION.
  METHOD HANDLER_TOOLBAR.
    PERFORM ALV_HANDLER_TOOLBAR USING E_OBJECT
                                      E_INTERACTIVE.
    ENDMETHOD.

  METHOD HANDLER_USER_COMMAND.
      PERFORM ALV_HANDLER_USER_COMMAND USING E_UCOMM.
    ENDMETHOD.

  METHOD HANDLER_HOTSPOT_CLICK.
    PERFORM ALV_HANDLER_HOTSPOT_CLICK USING E_ROW_ID
                                        E_COLUMN_ID
                                        ES_ROW_NO.
    ENDMETHOD.

  METHOD HANDLER_DATA_CHANGED.
    PERFORM ALV_HANDLER_DATA_CHANGED USING ER_DATA_CHANGED
                                            E_ONF4
                                            E_ONF4_BEFORE
                                            E_ONF4_AFTER
                                            E_UCOMM.
    ENDMETHOD.

  METHOD HANDLER_DATA_CHANGED_FINISHED.
    PERFORM ALV_DATA_CHANGED_FINISHED USING E_MODIFIED ET_GOOD_CELLS.
  ENDMETHOD.

ENDCLASS.