#!/bin/bash
case "$1" in
  back)    printf '\xef\x81\x8a' ;;
  fwd)     printf '\xef\x81\x8e' ;;
  play)    printf '\xef\x81\x8b' ;;
  pause)   printf '\xef\x81\x8c' ;;
  note)    printf '\xef\x80\x81' ;;
  list)    printf '\xef\x80\xba' ;;
  vol)     printf '\xef\x80\xa8' ;;
  volx)    printf '\xef\x80\xa6' ;;
  shuffle) printf '\xef\x81\xb4' ;;
  repeat)  printf '\xef\x80\x9e' ;;
esac
