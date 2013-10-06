#!/bin/sh

`/usr/bin/mysql -uroot -proot isucon -e"ALTER TABLE memos ADD username varchar(255) NOT NULL DEFAULT '' AFTER user"`;

`/usr/bin/mysql -uroot -proot isucon -e"BEGIN TRANSACTION; UPDATE memos INNER JOIN users on memos.user = users.id SET memos.username = users.username"; COMMIT`;

