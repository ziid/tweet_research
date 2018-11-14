#!/bin/sh

# コンフィグを読み込む
home_dir=$(cd ../; pwd)
. ${home_dir}/CONFIG/config

access_YMD=$1
access_directory=$2

# 
# 引数エラー処理
#

if [ ! $# -eq 2 ]
then
  printf "引数エラー\n" ""
  printf "Usage: get_youtube_link.sh %s %s\n" YMD access_directory
  exit 1
fi

if [ ! -e "${SAVE_TWEET_PATH}/${access_directory}" ]
then
  printf "引数エラー %s\n" "指定されたディレクトリがーありません"
  printf "Usage: get_youtube_link.sh %s %s\n" YMD access_directory
  exit 1
fi


#
# 実行エラー処理
#

change_dir_error() {
  printf "実行エラー %s\n" "ディレクトリーの移動に失敗しました"
  printf "Usage: get_youtube_link.sh %s\n" access_directory
  exit 1
}

# 移動しないと正しく処理出来ない
cd "${SAVE_TWEET_PATH}/${access_directory}/ANL/${access_YMD}" || change_dir_error

find -name '*.txt'     |
    xargs cat          |
    awk '{print $6}'   |
    grep -E "youtu.be" |
    sed 's/\\_/_/g'    |
    grep -E -o "youtu.be\/[a-zA-Z0-9_\\-]{11}+"
