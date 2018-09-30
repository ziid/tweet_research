#!/bin/sh

# コンフィグを読み込む
home_dir=$(cd ../; pwd)
. ${home_dir}/CONFIG/config

access_directory=$1

#
# 引数エラー処理
#

if [ ! -e "${SAVE_TWEET_PATH}/${access_directory}" ]
then
  printf "引数エラー %s\n" "指定されたディレクトリがーありません"
  printf "Usage: anl_all_access.sh %s\n" access_directory
  exit 1
fi

#
# 実行エラー処理
#

change_dir_error() {
  printf "実行エラー %s\n" "ディレクトリーの移動に失敗しました"
  printf "Usage: anl_all_access.sh %s\n" access_directory
  exit 1
}

# 移動しないと正しく処理出来ない
cd "${SAVE_TWEET_PATH}/${access_directory}/ANL" || change_dir_error

find -name '*.txt' | xargs cat
