*&---------------------------------------------------------------------*
*&  Include           ZEDR06_HW003_TOP
*&---------------------------------------------------------------------*
TABLES : ZEDT06_100. "주문내역 테이블
TABLES : ZEDT06_101. "배송내역 테이블

CONSTANTS : CHECK_X TYPE CHAR1 VALUE 'X'.
RANGES : R_FLAG FOR ZEDT06_101-ZFLAG.

"주문내역에 대한 구조체
DATA : BEGIN OF GS_ORDER,
  ZORDNO LIKE ZEDT06_100-ZORDNO, "주문번호
  ZIDCODE LIKE ZEDT06_100-ZIDCODE, "회원ID
  ZMATNR LIKE ZEDT06_100-ZMATNR, "제품번호
  ZMTART LIKE ZEDT06_100-ZMTART, "제품유형
  ZMATNAME LIKE ZEDT06_100-ZMATNAME, "제품명
  ZVOLUM LIKE ZEDT06_100-ZVOLUM, "수량
  VOLUM LIKE ZEDT06_100-VOLUM, "VOLUME
  VRKME LIKE ZEDT06_100-VRKME, "SALES UNIT
  ZSALES_UNIT LIKE ZEDT06_100-VRKME, "단위
  ZNSAMT LIKE ZEDT06_100-ZNSAMT, "판매금액
  ZSLAMT LIKE ZEDT06_100-ZSLAMT, "매출금액
  ZDCAMT LIKE ZEDT06_100-ZDCAMT, "할인금액
  ZDC_FG LIKE ZEDT06_100-ZDC_FG, "할인구분
  ZSALE_FG LIKE ZEDT06_100-ZSALE_FG, "매출구분
  ZRET_FG LIKE ZEDT06_100-ZRET_FG, "반품구분
  ZJDATE LIKE ZEDT06_100-ZJDATE, "판매일자
  ZRDATE LIKE ZEDT06_100-ZRDATE, "반품일자
  END OF GS_ORDER.
"주문내역에 대한 인터널테이블
DATA : GT_ORDER LIKE TABLE OF GS_ORDER.

"주문내역 출력용 ALV 구조체
DATA : BEGIN OF GS_ORDER_ALV,
  ZICON(6) TYPE C, "신호등 구분
  ZORDNO LIKE ZEDT06_100-ZORDNO, "주문번호
  ZIDCODE LIKE ZEDT06_100-ZIDCODE, "회원ID
  ZMATNR LIKE ZEDT06_100-ZMATNR, "제품번호
  ZMATNAME LIKE ZEDT06_100-ZMATNAME, "제품명
  ZMTART_NAME(6) TYPE C, "제품유형명
  ZVOLUM LIKE ZEDT06_100-ZVOLUM, "수량
  VRKME LIKE ZEDT06_100-VRKME, "단위
  ZNSAMT LIKE ZEDT06_100-ZNSAMT, "판매금액
  ZSLAMT LIKE ZEDT06_100-ZSLAMT, "매출금액
  ZDCAMT LIKE ZEDT06_100-ZDCAMT, "할인금액
  ZSALE_FG_NAME(4) TYPE C, "매출구분명
  ZJDATE LIKE ZEDT06_100-ZJDATE, "판매일자
  ZRET_FG_NAME(8) TYPE C, "반품구분명
  ZRDATE LIKE ZEDT06_100-ZRDATE, "반품일자
  END OF GS_ORDER_ALV.
"주문내역 출력용 ALV 인터널테이블
DATA : GT_ORDER_ALV LIKE TABLE OF GS_ORDER_ALV.

"배송관리에 대한 구조체
DATA : BEGIN OF GS_DELIVERY,
  ZORDNO TYPE ZEDT06_101-ZORDNO, "주문번호
  ZIDCODE TYPE ZEDT06_101-ZIDCODE, "회원ID
  ZMATNR TYPE ZEDT06_101-ZMATNR, "제품번호
  ZMTART TYPE ZEDT06_101-ZMTART, "제품유형
  ZMATNAME TYPE ZEDT06_101-ZMATNAME, "제품명
  ZVOLUM TYPE ZEDT06_101-ZVOLUM, "수량
  ZSALES_UNIT TYPE ZEDT06_101-VRKME, "단위
  VRKME TYPE ZEDT06_101-VRKME, "단위
  ZSLAMT TYPE ZEDT06_101-ZSLAMT, "매출금액
  ZDFLAG TYPE ZEDT06_101-ZDFLAG, "배송현황
  ZDGUBUN TYPE ZEDT06_101-ZDGUBUN, "배송지역
  ZDDATE TYPE ZEDT06_101-ZDDATE, "배송일자
  ZRDATE TYPE ZEDT06_101-ZRDATE, "반품일자
  ZFLAG TYPE ZEDT06_101-ZFLAG, "반품표시
  END OF GS_DELIVERY.
"배송관리에 대한 인터널테이블
DATA : GT_DELIVERY LIKE TABLE OF GS_DELIVERY.

"배송관리 출력용 ALV 구조체
DATA : BEGIN OF GS_DELIVERY_ALV,
  ZICON(6) TYPE C, "신호등출력
  ZORDNO TYPE ZEDT06_101-ZORDNO, "주문번호
  ZIDCODE TYPE ZEDT06_101-ZIDCODE, "회원ID
  ZMATNR TYPE ZEDT06_101-ZMATNR, "제품번호
  ZMATNAME TYPE ZEDT06_101-ZMATNAME, "제품명
  ZMTART_NAME(6) TYPE C, "제품유형명
  ZVOLUM TYPE ZEDT06_101-ZVOLUM, "수량
  VRKME TYPE ZEDT06_101-VRKME, "단위
  ZSLAMT TYPE ZEDT06_101-ZSLAMT, "매출금액
  ZDFLAG_NAME(8) TYPE C, "배송현황명
  ZDGUBUN_NAME(4) TYPE C, "배송지역명
  ZDDATE TYPE ZEDT06_101-ZDDATE, "배송일자
  ZRDATE TYPE ZEDT06_101-ZRDATE, "반품일자
  ZFLAG TYPE ZEDT06_101-ZFLAG, "반품표시
  END OF GS_DELIVERY_ALV.
"배송관리 출력용 ALV 인터널테이블
DATA : GT_DELIVERY_ALV LIKE TABLE OF GS_DELIVERY_ALV.

"PDF 출력용 구조체
DATA : BEGIN OF GS_ORDER_PDF,
  SEL(1) TYPE C, "선택 필드
  ZORDNO TYPE ZEDT06_100-ZORDNO, "주문번호
  ZIDCODE TYPE ZEDT06_100-ZIDCODE, "회원ID
  ZMATNR TYPE ZEDT06_100-ZMATNR, "제품번호
  ZMATNAME TYPE ZEDT06_100-ZMATNAME, "제품명
  ZSLAMT TYPE ZEDT06_100-ZSLAMT, "매출금액
  ZJDATE LIKE ZEDT06_100-ZJDATE, "판매일자
  END OF GS_ORDER_PDF.
"PDF 출력용 인터널테이블
DATA : GT_ORDER_PDF LIKE TABLE OF GS_ORDER_PDF.


DATA : OK_CODE TYPE SY-UCOMM. "OK_CODE 변수 선언

"DOCKING CONTAINER, GRID 변수 선언
DATA : GC_DOCKING TYPE REF TO CL_GUI_DOCKING_CONTAINER.
DATA : GC_GRID TYPE REF TO CL_GUI_ALV_GRID.

DATA : GS_VARIANT TYPE DISVARIANT. "레이아웃 변경 변수 선언

DATA : GS_FIELDCAT TYPE LVC_S_FCAT.
DATA : GT_FIELDCAT TYPE LVC_T_FCAT.

DATA : GS_LAYOUT TYPE LVC_S_LAYO.

DATA : GS_SORT TYPE LVC_S_SORT.
DATA : GT_SORT TYPE LVC_T_SORT.

"이벤트 변수 생성
DATA : GO_EVENT TYPE REF TO EVENT.