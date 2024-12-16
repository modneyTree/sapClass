자재 마스터 테이블을 만든다.
    ZEDT20_102로 만든다. 동일한 구조

@완
일단 SPLITTER로 전환을 한다.
    현재 DOCKING으로 되어있는 상태, SPLITTER로 전환을 한다.

    화면(CONTAINER) -> DOCKING -> GRID 
    화면(CONTAINER) -> DOCKING -> SPLITTER -> 각각 CONTAINER -> GRID + SPLITTER생성 -> GRID + 각 GRID + GRID

    코드로 구현
        CREATE DOCKING 
        CREATE GRID

        CREATE GC_DOCKING
        CREATE GC_SPLITTER
        CALL METHOD : GC_SPLITTER->GET_CONTAINER
        CREATE GC_GRID
            I_PARENT GC_CONTAINER1

2번 데이터
    1번 데이터에서 조회되는 회원ID에 대한 정보 보여주기(SSU-00, 한국이름,영문이름, 성별, 전화번호)

    조회 데이터
        S_ZORDNO 주문번호
        P_IDCODE 회원ID
        S_MATNR 제품번호
        S_JDATE 날짜
        S_DDATE 날짜
    
% 문제점 발견
    제펌 번호에 해당하는 조건?

    P_IDCODE에 해당하는 정보를 또 가져와야 한다는 거
    ZEDT20_001(학생마스터) 전부 조회 가능하다.

    설계
        P_IDCODE -> GET_DATA_R1 추가 로직 작성
        
        먼저, TOP에 GS,GT 만들고
        출력용 ALV GS,GT 만들고
        ZEDT20_001 -> SELECT 쿼리문 작성, 집어 넣고
        % 위에서 조회한 GT_ORDER의 ZIDCODE를 기반으로
        조회를 한다

        필드칼탈로그 등등등 작성해서 최종 출력을 한다. 

    실제
        GS_STUDENT, GT_STUDNET, GS_ALV, GT_ALV
% 
    ZEDT20_100 테이블(주문정보)에 SELECT 쿼리를 해서 얻은 GT_ORDER 테이블의 ZIDCODE 데이터들을 가지고
    ZEDT20_001 테이블(회원정보)에 SELECT 쿼리를 해서 GT_STUDENT에 데이터를 저장해야 한다.

    예를 들얼 ZEDT20_100에서 SSU_01, SSU_02, SSU_03의 데이터를 얻었으면 해당하는 ZIDCODE 로 ZEDT20_001 테이블에 조회를 해서 이름, 전화번호 데이터를 GT_STUDENT에 저장해야 한다.

    어떻게 해야할까??

3번 ALV
    1번 데이터에서 조회되는 제품번호에 대한 자재마스터 데이터 내용 보여주기
    (제품번호(자재번호), 제품명, 플래트명, 저장윛명, 자재유형명, 단가 ,통화, 수량, 단위)