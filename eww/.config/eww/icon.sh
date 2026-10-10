#!/bin/bash
case "$1" in
  prev)   printf '\xef\x81\x88' ;;
  play)   printf '\xef\x81\x8b' ;;
  pause)  printf '\xef\x81\x8c' ;;
  next)   printf '\xef\x81\x91' ;;
  heart)  printf '\xef\x80\x84' ;;
  hearto) printf '\xef\x82\x8a' ;;
  moon)   printf '\xef\x86\x86' ;;
  cloud)  printf '\xef\x83\x82' ;;
esac
