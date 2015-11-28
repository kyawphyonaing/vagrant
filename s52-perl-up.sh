#!/bin/bash
export dt=`date +%y%m%d_%H%M%S`
export files=" \
template/ps/TMPL.aucview_PC_base.html \
template/ps/TMPL.aucview_PC_base_A.html \
template/ps/TMPL.aucview_PC_base_B.html \
template/ps/TMPL.aucview_PC_base_C.html \
template/ps/TMPL.aucview_PC_base_D.html \
template/ps/TMPL.aucview_PC_base_E.html \
template/ps/TMPL.aucview_PC_base_F.html \
template/ps/TMPL.aucview_PC_contents.html \
"

export host="s52"

tar cf - $files \
| ssh $host " \
cat - > /tmp/up_$dt.tar; \
cd /home/shuhei/public_html; \
tar xf /tmp/up_$dt.tar; \
yes | rm /tmp/up_$dt.tar; \
"

echo ""
echo ""
echo ""
