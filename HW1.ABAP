FORM CALL_ALV .

  "P_R1이 체크되어 있으면, GT_ORDER_ALV, GT_FIELDCAT, GT_SORT를 채워준다.
  "P_R2가 체크되어 있으면, GT_DELIVERY_ALV, GT_FIELDCAT2, GT_SORT2를 채워준다.

  
  CASE C_X.
    WHEN P_R1.
    
      CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
  *      I_BUFFER_ACTIVE               =
  *      I_BYPASSING_BUFFER            =
  *      I_CONSISTENCY_CHECK           =
  *      I_STRUCTURE_NAME              =
        IS_VARIANT                    = GS_VARIANT
  *      I_SAVE                        =
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
        IT_OUTTAB                     = GT_ORDER_ALV
        IT_FIELDCATALOG               = GT_FIELDCAT
        IT_SORT                       = GT_SORT
  *      IT_FILTER                     =
      EXCEPTIONS
        INVALID_PARAMETER_COMBINATION = 1
        PROGRAM_ERROR                 = 2
        TOO_MANY_LINES                = 3
        OTHERS                        = 4
            .

    WHEN P_R2.
      CALL METHOD GC_GRID->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
  *      I_BUFFER_ACTIVE               =
  *      I_BYPASSING_BUFFER            =
  *      I_CONSISTENCY_CHECK           =
  *      I_STRUCTURE_NAME              =
        IS_VARIANT                    = GS_VARIANT
  *      I_SAVE                        =
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
        IT_OUTTAB                     = GT_DELEVER_ALV
        IT_FIELDCATALOG               = GT_FIELDCAT2
        IT_SORT                       = GT_SORT2
  *      IT_FILTER                     =
      EXCEPTIONS
        INVALID_PARAMETER_COMBINATION = 1
        PROGRAM_ERROR                 = 2
        TOO_MANY_LINES                = 3
        OTHERS                        = 4
            .
  ENDCASE.
  
  IF SY-SUBRC <> 0.
*   Implement suitable error handling here
  ENDIF.


ENDFORM.