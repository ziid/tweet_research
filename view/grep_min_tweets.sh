#!/bin/sh

# コンフィグを読み込む
home_dir=$(cd ../; pwd)
. ${home_dir}/CONFIG/config

access_directory=$1

#
# 引数エラー処理
#

if [ ! $# -eq 1 ]
then
  printf "引数エラー: %s\n" "引数を1つ指定してください"
  printf "Usage: grep_min_tweets.sh %s\n" access_directory
  exit 1
fi

if [ ! -e "${SAVE_TWEET_PATH}/${access_directory}" ]
then
  printf "引数エラー %s\n" "指定されたディレクトリがーありません"
  printf "Usage: grep_min_tweets.sh %s\n" access_directory
  exit 1
fi

#
# 実行エラー処理
#

# min_tweetsがあるか確かめる
if [ ! -f "${SAVE_TWEET_PATH}/${access_directory}/min_tweets" ]
then
  printf "実行エラー %s\n" "min_tweetsファイルがありません。gather.shを最後まで実行してください"
  exit 1
fi

change_dir_error() {
  printf "実行エラー %s\n" "ディレクトリーの移動に失敗しました"
  printf "Usage: grep_min_tweets.sh %s\n" access_directory
  exit 1
}

while :
do
  clear
  printf "filter_dir: %s\n" ${SAVE_TWEET_PATH}/${access_directory}

  printf "1)%s \n" 1-5
  printf "2)%s \n" 5-9
  printf "3)%s \n" 10-99
  printf "4)%s \n" 20-99
  printf "5)%s \n" 30-99
  printf "6)%s \n" 100-999
  printf "7)%s \n" 200-999
  printf "8)%s \n" 500-999
  printf "9)%s \n" 1000-9999

  read key
  case "$key" in 
    "1" ) range=[1-5]
          break ;;
    "2" ) range=[5-9]
          break ;;
    "3" ) range=[0-9][0-9] 
          break ;;
    "4" ) range=[2-9][0-9] 
          break ;;
    "5" ) range=[3-9][0-9] 
          break ;;
    "6" ) range=[1-9][0-9][0-9]
          break ;;
    "7" ) range=[2-9][0-9][0-9]
          break ;;
    "8" ) range=[5-9][0-9][0-9]
          break ;;
    "9" ) range=[1-9][0-9][0-9][0-9]
          break ;;
  esac
done

YMDHM=$(cat ${SAVE_TWEET_PATH}/${access_directory}/min_tweets | grep -E '^'$range | peco | awk '{print $2'})

# ペーストされた日付を分解する
year=$(printf "%s" $YMDHM | cut -d'/' -f1)
month=$(printf "%s" $YMDHM | cut -d'/' -f2)
day=$(printf "%s" $YMDHM | cut -d'/' -f3 | sed 's/-[0-9]\{2\}:[0-9]\{2\}//g')

hour=$(printf "%s" $YMDHM | cut -d':' -f1 | sed 's/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}-//g')
minute=$(printf "%s" $YMDHM | cut -d':' -f2)

# 時刻(YMDH)で移動
cd ${SAVE_TWEET_PATH}/${access_directory}/RES/${year}${month}${day}/${hour} || change_dir_error

# 表示
cat ${hour}${minute}*
