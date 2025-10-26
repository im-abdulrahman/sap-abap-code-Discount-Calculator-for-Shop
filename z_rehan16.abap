*&---------------------------------------------------------------------*
*& Report Z_REHAN16
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_REHAN16.


TABLES : ZREHAN_PRDCT.

TYPES  : BEGIN OF ty_prod,
  PDT_NAME TYPE ZREHAN_PRDCT-PDT_NAME,
  END OF ty_prod.

DATA : it_prod TYPE TABLE OF ty_prod,
       wa_prod TYPE ty_prod.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TITLE1.
  PARAMETERS : P_PDT1 TYPE CHAR40 AS LISTBOX VISIBLE LENGTH 40.
    PARAMETERS : P_PDT2 TYPE I.
SELECTION-SCREEN END OF BLOCK B1.


  " --------------------- fetch table data : Products ----------------

INITIALIZATION.

  SELECT PDT_NAME
    FROM ZREHAN_PRDCT
    INTO TABLE @it_prod.

  DATA: vrm_tab TYPE vrm_values,
        vrm_line LIKE LINE OF vrm_tab.


  LOOP AT it_prod INTO wa_prod.
    vrm_line-key = wa_prod-PDT_NAME.
    vrm_line-text = wa_prod-PDT_NAME.
    APPEND vrm_line TO vrm_tab.
  ENDLOOP.

  CALL FUNCTION 'VRM_SET_VALUES'
  EXPORTING
    id = 'P_PDT1'
    values = vrm_tab.


  " -------------------- Aftter Run -----------------------------

  START-OF-SELECTION.

  DATA: lv_mrp TYPE ZREHAN_PRDCT-PDT_MRP.
  DATA: lv_sum TYPE P.
  DATA: lv_dis TYPE P.
  DATA: lv_amt TYPE P.
  SELECT SINGLE PDT_MRP
    FROM ZREHAN_PRDCT
    INTO @lv_mrp
    WHERE PDT_NAME = @P_PDT1.

    lv_sum = lv_mrp * P_PDT2.
    lv_dis = ( lv_sum * 10 ) / 100.
    lv_amt = lv_sum - lv_dis.


  WRITE : / 'Product Details',
          / '------------------------------------------',
          / 'Product Name : ' , P_PDT1,
          / 'Product Qty  : ' , P_PDT2 , 'X',
          / 'Product MRP  : ' , lv_mrp ,
          / '------------------------------------------',
          / 'Total Cost   : ' , lv_sum,
          / 'Discount 10% : ' , lv_dis,
          / '------------------------------------------',
          / 'Total Amount : ' , lv_amt.