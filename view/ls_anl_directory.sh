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
  printf "引数エラー %s\n" "１つの引数を指定してください"
  printf "使用法: anl_viewer.sh %s\n" access_directory
  exit 1
fi

if [ ! -e "${SAVE_TWEET_PATH}/${access_directory}" ]
then
  printf "引数エラー %s\n" "指定されたディレクトリがーありません"
  printf "使用法: anl_ls.sh %s\n" access_directory
  exit 1
fi

#
# 実行エラー処理
#

change_dir_error() {
  printf "実行エラー %s\n" "ディレクトリーの移動に失敗しました"
  printf "使用法: anl_ls.sh %s\n" access_directory
  exit 1
}

cd ${SAVE_TWEET_PATH}/${access_directory}/ANL || change_dir_error
ls *
