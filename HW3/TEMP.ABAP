PERFORM set_cell_value USING worksheet 'A1' '주문번호'.
PERFORM set_cell_value USING worksheet 'A2' '회원ID : '.
PERFORM set_cell_value USING worksheet 'A3' '제품번호 : '.
PERFORM set_cell_value USING worksheet 'A4' '제품명 : '.
PERFORM set_cell_value USING worksheet 'A5' '매출금액 : '.
PERFORM set_cell_value USING worksheet 'A6' '판매일자 : '.



PERFORM set_cell_value USING worksheet 'A1' |주문번호 : { is_data-zordno }|.
PERFORM set_cell_value USING worksheet 'A2' |회원ID : { is_data-zidcode }|.
PERFORM set_cell_value USING worksheet 'A3' |제품번호 : { is_data-zmatnr }|.
PERFORM set_cell_value USING worksheet 'A4' |제품명 : { is_data-zmatname }|.
PERFORM set_cell_value USING worksheet 'A5' |매출금액 : { is_data-zslamt }|.
PERFORM set_cell_value USING worksheet 'A6' |판매일자 : { is_data-zjdate }|.