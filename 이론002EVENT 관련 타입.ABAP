038 메서드 REFRESH_TABLE_DISPLAY
사용예시
    DATA : LS_STABLE TYPE LVC_S_STBL.

    LS_STABLE-ROW = 'X'.
    LS_STABLE-COL = 'X'.

    CALL METHOD GC_GRID1->REFRESH_TABLE_DISPLAY
    EXPORTING
        IS_STABLE      = LS_STABLE
    *      I_SOFT_REFRESH =
    *    EXCEPTIONS
    *      FINISHED       = 1
    *      others         = 2
            .
    IF SY-SUBRC <> 0.
    *   Implement suitable error handling here
    ENDIF.

파라미터 : 
    IS_STABLE TYPE LVC_S_STBL 

LVC_S_STBL 구조체
    필드
    ROW
    COL

039 EVENT TOOLBAR
파라미터
    E_OBJECT    TYPE CL_ALV_EVENT_TOOLBAR_SET
    E_INTERACTIVE   TYPE CHAR01

CL_ALV_EVENT_TOOLBAR_SET 클래스
    필드
    MT_TOOLBAR  TYPE TTB_BUTTON
    MT_BTNMNU   TYPE TTB_BTNMNU

TTB_BUTTON 구조체
    필드
    FUNCTION
    ICON
    QUICKINFO
    
