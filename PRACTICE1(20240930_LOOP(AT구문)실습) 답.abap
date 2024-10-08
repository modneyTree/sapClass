*&---------------------------------------------------------------------*
*& REPORT ZEDR20_PRACTICE001.
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEDR20_PRACTICE001.

"1. DATA선언
DATA : BEGIN OF GS_GRADE.   "구조체 선언
  INCLUDE TYPE ZEDT00_003.  "ZEDT00_003 포함시킨다.
DATA : ZCAL_SUM TYPE I,     "ZCLA_SUM은 구조체에 포함된다. : 성적 합계를 저장하는 용도
      END OF GS_GRADE.

DATA : GT_GRADE LIKE TABLE OF GS_GRADE. "인터널 테이블을 만든다.

"FOR 장학구분 변수 선언
DATA : GV_ZCODE LIKE ZEDT00_003-ZCODE.
DATA : GV_SUM TYPE I.
DATA : GV_GRADE, GV_NEW, GV_END, GV_FLAG.

"합계 계산 변수 선언
DATA : GV_SUM_ALL TYPE I.

"2. GET DATA
SELECT * FROM ZEDT00_003
INTO CORRESPONDING FIELDS OF TABLE GT_GRADE.    "ZEDT00_003에 있는 내용을 -> 인터널 테이블에?

SORT GT_GRADE BY ZCODE ZPERNR ZEXAM.  

CLEAR : GS_GRADE.
CLEAR : GV_ZCODE, GV_GRADE, GV_END, GV_SUM.

"3. MODIFY DATA
LOOP AT GT_GRADE INTO GS_GRADE.
  AT NEW ZCODE.
    GV_ZCODE = GS_GRADE-ZCODE.
    GV_NEW = 'X'.   "체크 표시
  ENDAT.

  IF GV_NEW = 'X'.  "새로운 ZCODE가 등장했으면
    IF GS_GRADE-ZGRADE = 'A'.   "그 중에서 A면
      GV_GRADE = 'A'.   "성적 A로 
    ENDIF.
  ELSE.
    IF GV_GRADE = 'A'. "그룹 내 모든 레코드가 'A' 등급인지 확인하는 플래그를 설정.
      IF GS_GRADE-ZGRADE = 'A'.
        GV_FLAG = 'X'. 
      ELSE.
        CLEAR : GV_GRADE, GV_FLAG.
      ENDIF.
    ENDIF.
  ENDIF.

  AT END OF ZCODE.
    GV_END = 'X'.
    CLEAR : GV_ZCODE.
  ENDAT.

  IF GV_END = 'X'.
    GS_GRADE-ZCAL_SUM = GS_GRADE-ZSUM * 100.
    IF GV_FLAG = 'X'.
      GS_GRADE-ZFLAG = 'X'.
      IF GS_GRADE-ZSCHOOL = 'A'.
        GS_GRADE-ZCAL_SUM = GS_GRADE-ZCAL_SUM * '0.8'.
      ELSEIF GS_GRADE-ZSCHOOL = 'B'.
        GS_GRADE-ZCAL_SUM = GS_GRADE-ZCAL_SUM * '0.9'.
      ENDIF.
    ENDIF.

    GV_SUM_ALL = GV_SUM_ALL + GS_GRADE-ZCAL_SUM.

    MODIFY GT_GRADE FROM GS_GRADE INDEX SY-TABIX.

    CLEAR : GS_GRADE.
    CLEAR : GV_FLAG, GV_GRADE.
  ENDIF.

  CLEAR : GV_NEW, GV_END.
  CLEAR : GS_GRADE.
ENDLOOP.

SORT GT_GRADE DESCENDING BY ZCODE ZCAL_SUM.
DELETE ADJACENT DUPLICATES FROM GT_GRADE COMPARING ZCODE.

SORT GT_GRADE BY ZCODE.

"4. WRITE DATA
LOOP AT GT_GRADE INTO GS_GRADE.
  AT FIRST.
    WRITE :/ '--------------------------------------------------------------------------'.
    WRITE :/ '|   학생코드   |          전공명          |장학구분|       납부금액      |'.
    WRITE :/ '--------------------------------------------------------------------------'.
  ENDAT.

  WRITE :/ '|  ', GS_GRADE-ZCODE, '|    ',GS_GRADE-ZMNAME,'|',  GS_GRADE-ZFLAG  ,'     |  ' ,        GS_GRADE-ZCAL_SUM,'      |'.
  WRITE :/ '--------------------------------------------------------------------------'.

  AT LAST.
    WRITE :/ '|' ,'               ','합      계','                     ','|'   ,'  ',    GV_SUM_ALL   ,'    ','|'  .
    WRITE :/ '--------------------------------------------------------------------------'.
  ENDAT.

ENDLOOP.