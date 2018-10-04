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
  printf "Usage: anl_viewer.sh %s %s\n" YMD access_directory
  exit 1
fi

if [ ! -e "${SAVE_TWEET_PATH}/${access_directory}" ]
then
  printf "引数エラー %s\n" "指定されたディレクトリがーありません"
  printf "Usage: anl_viewer.sh %s %s\n" YMD access_directory
  exit 1
fi

#
# 実行エラー処理
#

change_dir_error() {
  printf "実行エラー %s\n" "ディレクトリーの移動に失敗しました"
  printf "Usage: anl_viewer.sh %s %s\n" YMD access_directory
  exit 1
}

#
# 必要なディレクトリーを生成
#

# markディレクトリーを作成
cd ${SAVE_MARK_PATH} || change_dir_error
[ ! -e "${SAVE_MARK_PATH}/${access_directory}" ] && mkdir ${access_directory}


#
# ツイートビュワー
#

cd ${SAVE_TWEET_PATH}/${access_directory}/ANL/${access_YMD} || change_dir_error

total_tweet_count=$(tree -i -f -L 2     |
                           grep txt     |
                           xargs wc -l  |
                           grep txt     |
                           awk 'BEGIN{tweet_count=0} {tweet_count+=$1} END{print tweet_count}')

read_counter=1
for tweet_txt_path in $(tree -i -f -L 2 | grep txt)
do
    # １テキストに対して複数のツイートを表示するためのループ
    for tweet in $(cat ${tweet_txt_path} | sed -e 's/\n$//g' -e 's/ /_/g')
    do
        tweet=$(printf "%s\n" "$tweet" | tr '_' ' ')

        printf "%s/%s\n\n" $read_counter $total_tweet_count
        printf "%s\n\n" "$tweet"
        read -p "next(enter) mark(m):" input_key

        # mでツイートを保存
        case "$input_key" in 
        "m" ) echo "mark" ;
              printf "%s\n" "${tweet}" >> ${SAVE_MARK_PATH}/${access_directory}/${access_YMD} ;;
        esac
        
        read_counter=$(($read_counter+1))
    done

done
