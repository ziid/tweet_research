#!/bin/sh

# コンフィグを読み込む
home_dir=$(cd ../; pwd)
. ${home_dir}/CONFIG/config

since_date=$1
access_directory=$2
shift
queries=$*

#
# 引数エラー処理
#

if [ $# -lt 2 ] 
then
  printf "引数エラー %s\n" "3以上の引数を指定してください"
  printf "Usage: gather.sh %s %s %s\n" since_date save_directory_name "query query query..."
  exit 1
fi

#
# 実行エラー処理
#

change_dir_error() {
  printf "実行エラー %s\n" "ディレクトリーの移動に失敗しました"
  printf "Usage: gather.sh %s %s %s\n" since_date save_directory_name "query query query..."
  exit 1
}

#
# ツイートを集める
#

cd ${KOTORIOTOKO_PATH}/APPS || change_dir_error

sh gathertw.sh -s ${since_date} -p -d "${SAVE_TWEET_PATH}/${access_directory}" "${queries}"

#
# グラフ生成用に、毎分ツイートを集計
#

cd "${SAVE_TWEET_PATH}/${access_directory}/ANL" || change_dir_error

# 毎分のツイート数を数える
find -name '*.txt'                |
  xargs cat                       |
  awk '{print substr($1, 1, 16)}' |
  sort                            |
  uniq -c                         |
  sed 's/^ *//g' > ${SAVE_TWEET_PATH}/${access_directory}/min_tweets

