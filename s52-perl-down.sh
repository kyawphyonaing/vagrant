#!/bin/bash
export dt=`date +%y%m%d_%H%M%S`
# セカンドキーワードv3
export files=" \
assets/css/serch123_header.css \
assets/css/serch_header.css \
css/result2_sr.css \
template/TMPL.aucview_PC_base.html \
template/TMPL.aucview_PC_base_A.html \
template/TMPL.aucview_PC_base_B.html \
template/TMPL.aucview_PC_base_C.html \
template/TMPL.aucview_PC_base_D.html \
template/TMPL.aucview_PC_base_E.html \
template/TMPL.aucview_PC_base_F.html \
template/tx.search.common.header-result.html \
template/tx.search.common.search-result_list.html \
template/tx.search.frame-result-past.html \
template/tx.search.frame-result.html \
"

export host="s52"

ssh $host " \
cd /home/shuhei/public_html; \
tar cf - $files
" | tar xf -
