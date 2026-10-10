#!/bin/bash
# usage:  CARD=300 POS=topleft ./theme.sh      (POS = topleft | center)
# palette: midnight blue + fire accents (edit these four lines to retune)
BLUE='#6384cc'; BLUE2='#8fb0ee'
FIRE='#ee9a3c'; FIRE2='#f7c46a'

cd ~/.config/eww || exit 1
CARD=${CARD:-300}
POS=${POS:-topleft}

# icons, redrawn in the palette colors
mkdir -p icons
mk() { printf '<svg xmlns="http://www.w3.org/2000/svg" viewBox="%s">%s</svg>\n' "$2" "$3" > "icons/$1.svg"; }
C='#aab6d4'; V='#7f8cb0'; W='#f2f6ff'
mk rew  "0 0 52 30" "<g fill='$C' stroke='$C' stroke-width='4' stroke-linejoin='round'><path d='M24 5V25L6 15Z'/><path d='M46 5V25L28 15Z'/></g>"
mk fwd  "0 0 52 30" "<g fill='$C' stroke='$C' stroke-width='4' stroke-linejoin='round'><path d='M6 5V25L24 15Z'/><path d='M28 5V25L46 15Z'/></g>"
mk pause "0 0 30 30" "<g fill='$W'><rect x='7' y='5' width='6' height='20' rx='2.5'/><rect x='17' y='5' width='6' height='20' rx='2.5'/></g>"
mk play  "0 0 30 30" "<path d='M10 6V24L25 15Z' fill='$W' stroke='$W' stroke-width='3' stroke-linejoin='round'/>"
mk vol_lo "0 0 24 30" "<path d='M3 11H8L15 5V25L8 19H3Z' fill='$V' stroke='$V' stroke-width='2' stroke-linejoin='round'/>"
mk vol_hi "0 0 30 30" "<path d='M2 11H6.5L13 5.5V24.5L6.5 19H2Z' fill='$V' stroke='$V' stroke-width='2' stroke-linejoin='round'/><path d='M17 11Q20.5 15 17 19M20.5 7Q27 15 20.5 23' fill='none' stroke='$V' stroke-width='2.2' stroke-linecap='round'/>"
mk list "0 0 30 22" "<g fill='$V' stroke='$V' stroke-width='2.4' stroke-linecap='round'><circle cx='3' cy='3' r='1.4'/><circle cx='3' cy='11' r='1.4'/><circle cx='3' cy='19' r='1.4'/><path d='M9 3H27M9 11H27M9 19H27'/></g>"
note() { mk "$1" "0 0 24 30" "<g fill='$2'><ellipse cx='7.5' cy='23' rx='5.5' ry='4.3' transform='rotate(-20 7.5 23)'/><rect x='11.5' y='4' width='3' height='19' rx='1.2'/><path d='M13 4Q21 6 20.5 13Q18 9.5 13 10.5Z'/></g>"; }
note note_c "$FIRE2"
note note_w '#e8edf8'

s=$(awk -v c="$CARD" 'BEGIN { printf "%.4f", c/1050 }')
r() { awk -v s="$s" -v n="$1" 'BEGIN { v=int(n*s+0.5); if (v<1) v=1; printf "%d", v }'; }
win=$(r 1170); vw=$(r 340); kw=$(r 32); dw=$(r 20)
tw=$(( $(r 994) - 4 ))
if [ "$POS" = center ]; then
  geo=':x "0px" :y "0px" :anchor "center"'
else
  geo=':x "20px" :y "20px" :anchor "top left"'
fi
subs=""
for kv in SKW:60 SKH:35 PPS:40 LOW:26 LOH:32 HIS:34 LSW:34 LSH:25 N1W:20 N1H:25 N2W:34 N2H:42 N3W:64 N3H:80 EQW:36 EQH:44 EQD:5; do
  subs="$subs -e s/__${kv%%:*}__/$(r ${kv##*:})/g"
done
printf '$s: %s;\n$blue: %s;\n$blue2: %s;\n$fire: %s;\n$fire2: %s;\n' "$s" "$BLUE" "$BLUE2" "$FIRE" "$FIRE2" > eww.scss
cat base.scss >> eww.scss
sed -e "s/__W__/${win}/" -e "s/__VW__/${vw}/g" -e "s/__KW__/${kw}/g" \
    -e "s/__TW__/${tw}/g" -e "s/__DW__/${dw}/g" -e "s|__GEO__|${geo}|" \
    -e "s|__S__|${s}|g" -e "s|__HOME__|$HOME|g" $subs eww.yuck.tpl > eww.yuck
eww kill 2>/dev/null; pkill -x eww 2>/dev/null; sleep 1
eww daemon; sleep 1; eww open desk
echo "card ${CARD}px  scale ${s}  palette midnight+fire"
eww open clock
