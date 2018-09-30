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
  printf "引数エラー %s\n" "1つ引数を指定してください"
  printf "Usage: total_tweet_count.sh %s\n" access_directory
  exit 1
fi

if [ ! -e "${SAVE_TWEET_PATH}/${access_directory}" ]
then
  printf "引数エラー %s\n" "指定されたディレクトリがありません"
  printf "Usage: total_tweet_count.sh %s\n" access_directory
  exit 1
fi

#
# 実行エラー処理
#

change_dir_error() {
  printf "実行エラー %s\n" "ディレクトリーの移動に失敗しました"
  printf "Usage: total_tweet_count.sh %s\n" access_directory
  exit 1
}

# 総ツイートの合計を計算
cd "${SAVE_TWEET_PATH}/${access_directory}" || change_dir_error

total_tweet=$(cat min_tweets | sort -n | awk 'BEGIN{total=0}; {total+=$1}; END{print total}')

# ボット数の合計を計算
cd "${SAVE_TWEET_PATH}/${access_directory}/ANL" || change_dir_error

total_bot_tweet=$(find -name "*.txt"                                           |
                         xargs cat                                             |
                         awk '{print $11}'                                     |
                         awk 'BEGIN{total=0}; /bot/{total+=1} END{print total}')

# 表示
printf "%s/%s\n" ${total_bot_tweet} ${total_tweet}
