#!/bin/sh

curlwithcode() {
  local code=0
  local tmpfile; tmpfile=$(mktemp /tmp/curl.XXXXXX)
  body="null"

  status_code=$(curl --connect-timeout 3 --retry 0 -s -w "%{http_code}" -o >(cat >"$tmpfile") "$1") || code="$?"
  [ $status_code = 200 ] && body="$(cat "$tmpfile")"
  rm "$tmpfile"

  return $code
}

curlwithcode $CURL_URL/wake_time

# could not get wake_time, exit with 1
[ $body = "null" ] && exit 1

# got off, disable rtc wakealarm
if [ $body = "off" ]; then
  echo 0 > /sys/class/rtc/rtc0/wakealarm
  logger -t rtcwake.sh "rtc: unset wakealarm"
  exit 0
fi

# set rtc wakealarm to wake from suspend
#WAKE_AT="08:00"
WAKE_AT="$body"

if [ -f /sys/class/rtc/rtc0/wakealarm ]; then
  CURRENT_TIME=$(date +%s)
  WAKE_TIME=$(date +%s -d "$WAKE_AT")

  # update wake time to next day when already passed
  if [ $CURRENT_TIME -gt $WAKE_TIME ]; then
    WAKE_TIME=$(($WAKE_TIME + 24 * 60 * 60))
  fi

  # get configured wake time from system
  WAKE_ALARM=$(cat /sys/class/rtc/rtc0/wakealarm)

  # update wakealarm if empty or different
  if [ -z $WAKE_ALARM ] || [ 1$WAKE_ALARM != 1$WAKE_TIME ]; then
    echo 0 > /sys/class/rtc/rtc0/wakealarm
    echo $WAKE_TIME > /sys/class/rtc/rtc0/wakealarm
    logger -t rtcwake.sh "rtc: set wakealarm to $(date -d @$WAKE_TIME)"
  fi
fi
