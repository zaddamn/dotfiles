(defvar showmodes false)

(defpoll title   :interval "2s"  "playerctl metadata title 2>/dev/null || echo 'Nothing playing'")
(defpoll artist  :interval "2s"  "playerctl metadata artist 2>/dev/null")
(defpoll ctx     :interval "2s"  "~/.config/eww/context.sh")
(deflisten eq "~/.config/eww/eq.sh")
(defpoll isplay :interval "1s" "~/.config/eww/isplay.sh")
(defpoll rem    :interval "1s" "~/.config/eww/rem.sh")
(defvar showrem false)
(defpoll src     :interval "3s"  "~/.config/eww/src.sh")
(defpoll art     :interval "2s"  "~/.config/eww/art.sh")
(defpoll playing :interval "1s"  "playerctl status 2>/dev/null")
(defpoll pct     :interval "500ms"  "~/.config/eww/progress.sh")
(defpoll pos     :interval "1s"  "playerctl metadata --format '{{duration(position)}}' 2>/dev/null || echo '0:00'")
(defpoll len     :interval "5s"  "playerctl metadata --format '{{duration(mpris:length)}}' 2>/dev/null || echo '0:00'")
(defpoll shuf    :interval "3s"  "playerctl shuffle 2>/dev/null || echo Off")
(defpoll loop    :interval "3s"  "playerctl loop 2>/dev/null || echo None")
(defpoll vol     :interval "2s"  "~/.config/eww/vol.sh get")
(defpoll muted   :interval "2s"  "~/.config/eww/vol.sh muted")
(defpoll ic_shuf :interval "1h"  "~/.config/eww/icon.sh shuffle")
(defpoll ic_rep  :interval "1h"  "~/.config/eww/icon.sh repeat")

(defwindow desk
  :monitor 0
  :stacking "bg"
  :exclusive false
  :geometry (geometry __GEO__ :width "__W__px")
  (box :orientation "v" :space-evenly false :class "wrap"
    (eventbox :class "hz"
      (box :class {playing == "" ? "player idle" : "player"} :orientation "v" :space-evenly false

        (box :class "top" :orientation "h" :space-evenly false
          (eventbox :cursor "pointer" :valign "start" :onclick "playerctl play-pause; sleep 0.2; eww update playing=$(playerctl status)" :onrightclick "playerctl next"
            (box :class {art == "" ? "art ph" : "art"} :valign "start"
               :style "background-image: url('${art}');"
            (image :class "artnote" :visible {art == ""} :hexpand true :vexpand true
                   :path "__HOME__/.config/eww/icons/note_w.svg" :image-width __N3W__ :image-height __N3H__)))
          (box :class "txt" :orientation "v" :space-evenly false :hexpand true :valign "center"
            (box :class "hdr" :orientation "h" :space-evenly false
              (image :class "hnote" :path "__HOME__/.config/eww/icons/note_c.svg" :image-width __N1W__ :image-height __N1H__)
              (label :class "hname" :halign "start" :hexpand true :text src)
              (box :class "eqw" :orientation "h" :space-evenly false :valign "center" (box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[11] ?: 0) * (__EQH__ - __EQD__) * 0.70 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[10] ?: 0) * (__EQH__ - __EQD__) * 0.73 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[9] ?: 0) * (__EQH__ - __EQD__) * 0.75 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[8] ?: 0) * (__EQH__ - __EQD__) * 0.78 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[7] ?: 0) * (__EQH__ - __EQD__) * 0.80 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[6] ?: 0) * (__EQH__ - __EQD__) * 0.83 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[5] ?: 0) * (__EQH__ - __EQD__) * 0.86 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[4] ?: 0) * (__EQH__ - __EQD__) * 0.88 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[3] ?: 0) * (__EQH__ - __EQD__) * 0.91 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[2] ?: 0) * (__EQH__ - __EQD__) * 0.93 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[1] ?: 0) * (__EQH__ - __EQD__) * 0.96 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[0] ?: 0) * (__EQH__ - __EQD__) * 0.99 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[0] ?: 0) * (__EQH__ - __EQD__) * 0.99 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[1] ?: 0) * (__EQH__ - __EQD__) * 0.96 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[2] ?: 0) * (__EQH__ - __EQD__) * 0.93 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[3] ?: 0) * (__EQH__ - __EQD__) * 0.91 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[4] ?: 0) * (__EQH__ - __EQD__) * 0.88 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[5] ?: 0) * (__EQH__ - __EQD__) * 0.86 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[6] ?: 0) * (__EQH__ - __EQD__) * 0.83 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[7] ?: 0) * (__EQH__ - __EQD__) * 0.80 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[8] ?: 0) * (__EQH__ - __EQD__) * 0.78 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[9] ?: 0) * (__EQH__ - __EQD__) * 0.75 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[10] ?: 0) * (__EQH__ - __EQD__) * 0.73 / 100, 0)}px;")(box :class "eqb" :valign "center" :style "min-height: ${round(__EQD__ + isplay * (eq[11] ?: 0) * (__EQH__ - __EQD__) * 0.70 / 100, 0)}px;")))
            (label :class "title" :halign "start" :limit-width 54 :show-truncated false :text title
                   :style "font-size: ${round(__S__ * (strlength(title) > 22 ? (1160 / strlength(title) > 22 ? 1160 / strlength(title) : 22) : 53), 0)}px;")
            (label :class "artist" :halign "start" :limit-width 58 :show-truncated false :text artist
                   :style "font-size: ${round(__S__ * (strlength(artist) > 35 ? (1250 / strlength(artist) > 22 ? 1250 / strlength(artist) : 22) : 37), 0)}px;")))

        (overlay :class "seek"
          (box :class "sspace")
          (box :class "strack" :valign "center")
          (box :class "srow" :orientation "h" :space-evenly false :halign "start" :valign "center"
            (box :class "sfill" :valign "center"
                 :style "min-width: ${round(pct * (__TW__ - __DW__) / 100, 0)}px;")
            (box :class "sdot" :valign "center"))
          (scale :class "ghost" :min 0 :max 100 :value pct
                 :onchange "~/.config/eww/seek.sh {}"))
        (box :class "times" :orientation "h" :space-evenly false
          (label :class "t" :halign "start" :hexpand true :text pos)
          (eventbox :cursor "pointer" :halign "end" :onclick "eww update showrem=${!showrem}" (label :class "t" :text {showrem ? rem : len})))

        (box :class "ctls" :orientation "h" :space-evenly false
          (eventbox :class "btn" :cursor "pointer" :onclick "playerctl previous"
            (image :class "skip" :path "__HOME__/.config/eww/icons/rew.svg" :image-width __SKW__ :image-height __SKH__))
          (eventbox :cursor "pointer" :onclick "playerctl play-pause; sleep 0.2; eww update playing=$(playerctl status)"
            (box :class {playing == "Playing" ? "pp" : "pp off"} :halign "center" :valign "center"
              (image :path {playing == "Playing" ? "__HOME__/.config/eww/icons/pause.svg" : "__HOME__/.config/eww/icons/play.svg"}
                     :image-width __PPS__ :image-height __PPS__)))
          (eventbox :class "btn" :cursor "pointer" :onclick "playerctl next"
            (image :class "skip" :path "__HOME__/.config/eww/icons/fwd.svg" :image-width __SKW__ :image-height __SKH__))
          (box :class "vol" :orientation "h" :space-evenly false :hexpand true
               :halign "end" :valign "center"
            (eventbox :cursor "pointer" :onclick "~/.config/eww/vol.sh mute"
              (image :class {muted == "yes" ? "vi off" : "vi"} :path "__HOME__/.config/eww/icons/vol_lo.svg" :image-width __LOW__ :image-height __LOH__))
            (overlay :class {muted == "yes" ? "vsl off" : "vsl"} :valign "center"
              (box :class "vspace")
              (box :class "vtrack" :valign "center")
              (box :class "vrow" :orientation "h" :space-evenly false :halign "start" :valign "center"
                (box :class "vfill" :valign "center"
                     :style "min-width: ${round(vol * (__VW__ - __KW__) / 100, 0)}px;")
                (box :class "vknob" :valign "center"))
              (scale :class "ghost" :min 0 :max 100 :value vol
                     :onchange "eww update vol={}; ~/.config/eww/vol.sh set {}"))
            (image :class "vi hi" :path "__HOME__/.config/eww/icons/vol_hi.svg" :image-width __HIS__ :image-height __HIS__)))

        (box :class "foot" :orientation "h" :space-evenly false
          (box :class "ntile" :valign "center"
            (image :class "ntl" :path "__HOME__/.config/eww/icons/note_w.svg" :image-width __N2W__ :image-height __N2H__))
          (box :orientation "v" :space-evenly false :valign "center"
            (label :class "albl" :halign "start" :xalign 0 :text "ALBUM")
            (label :class "aname" :halign "start" :xalign 0 :limit-width 62 :show-truncated false :text ctx
                   :style "font-size: ${round(__S__ * (strlength(ctx) > 40 ? (1350 / strlength(ctx) > 22 ? 1350 / strlength(ctx) : 22) : 33), 0)}px;"))
          (eventbox :class "btn" :cursor "pointer" :hexpand true :halign "end" :valign "center"
                    :onclick "eww update showmodes=${!showmodes}"
            (image :class "side" :path "__HOME__/.config/eww/icons/list.svg" :image-width __LSW__ :image-height __LSH__)))

        (revealer :reveal showmodes :transition "slidedown" :duration "250ms"
          (box :class "modes" :orientation "h" :space-evenly false :halign "center" :spacing 18
            (eventbox :cursor "pointer" :onclick "~/.config/eww/mode.sh shuffle"
              (box :class {shuf == "On" ? "mode on" : "mode"}
                (label :class "mi" :text ic_shuf)))
            (eventbox :cursor "pointer" :onclick "~/.config/eww/mode.sh repeat"
              (box :class {loop == "Playlist" ? "mode on" : "mode"}
                (label :class "mi" :text ic_rep)))
            (eventbox :cursor "pointer" :onclick "~/.config/eww/mode.sh one"
              (box :class {loop == "Track" ? "mode on" : "mode"}
                (label :class "mi inf" :text "∞")))))))))
