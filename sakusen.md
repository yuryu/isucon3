# 作戦

## RDBMS チューニング

* そもそもユーザー情報とかKVSでよくね
* というかシングルインスタンスなのでオンメモリでよくね
* MySQL 自体のチューニング
* memos を KVS に入れるのは時間的に厳しそう

## web server

* nginx にする

# Memo

## by Yuryu

* markdown を表示のたびに変換している→postされた瞬間に変換→表示＆保存
* 保存は非同期でやってもよい(rabbitmq 経由?)
* markdown の表示がtempfile使ってるのでpipeでいいんじゃ
* post されたときは一度 queue に突っ込む→workerでpopして出力
* っていうかstatic html生成→rewriteでがんばって表示でいいんじゃ
* ワロス

## by matauken
* sha256_hexしないで生のpasswordを入れる（取り出すときも）
* $totalのインクリメントをmemdにするとか。
* configをべた書きにする。
* tempfileをメモリに持ってくとか。
