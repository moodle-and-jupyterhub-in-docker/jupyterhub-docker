#!/bin/bash

#イメージ選択コマンド設定
cmd="whiptail --checklist --separate-output \"ダウンロードするイメージを選んでください\" 0 0 0"

#imagelistsからイメージリストを取得
numline=0
while read list
do
    cmd="$cmd $numline \"$list\" OFF"
    numline=$((numline + 1))
done < imagelists
cmd="$cmd 3>&1 1>&2 2>&3"

#選択画面表示
checked=$(eval $cmd)

#ユーザが選択したものを読み取る
checked=(${checked// / })

for i in "${checked[@]}"
do
#行数からイメージを取得
i=$((i + 1))
i=$i\p
cmd="sed -n '$i' imagelists"
image=$(eval $cmd) 
#イメージ名のみを取得
image=(${image// / })
#イメージをプル
docker image pull $image
done
