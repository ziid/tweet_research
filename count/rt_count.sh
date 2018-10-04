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
  printf "引数エラー %s\n" "１つ引数を指定してください"
  printf "Usage: bot_count.sh %s\n" access_directory
  exit 1
fi

if [ ! -e "${SAVE_TWEET_PATH}/${access_directory}" ]
then
  printf "引数エラー %s\n" "指定されたディレクトリがありません"
  printf "Usage: bot_count.sh %s\n" access_directory
  exit 1
fi

#
# 実行エラー処理
#

change_dir_error() {
  printf "実行エラー %s\n" "ディレクトリーの移動に失敗しました"
  printf "Usage: bot_count.sh %s\n" access_directory
  exit 1
}

# 総ツイートの合計を計算
cd "${SAVE_TWEET_PATH}/${access_directory}" || change_dir_error

total_tweet=$(cat min_tweets | sort -n | awk 'BEGIN{total=0}; {total+=$1}; END{print total}')

cd "${SAVE_TWEET_PATH}/${access_directory}/ANL" || change_dir_error

rt_tweet=$(find -name '*.txt' | xargs cat | grep RT | wc -l)

# 表示
printf "%s/%s\n" ${rt_tweet} ${total_tweet}
