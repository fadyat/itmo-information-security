## Создание ключевой пары

Установим директорию `.gnupg` как местоположение для хранения файлов
конфигурации и ключей GPG, чтобы не засорять глобальные конфиги.

```shell
export GNUPGHOME=./.gnupg
```

Создаем новую ключевую пару с помощью интерактивного интерфейса.
> Выбор параметров, таких как тип ключа, длина ключа и срок действия,
> осуществляется в процессе выполнения этой команды.

```shell
gpg --full-generate-key --keyserver hkp://keyserver.ubuntu.com
```

Проверим, что оба ключа создались.

```shell
➜  cryptography git:(master) ✗ gpg --list-secret-keys
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: next trustdb check due at 2024-03-08
[keyboxd]
---------
sec   rsa3072 2024-02-07 [SC] [expires: 2024-03-08]
      55A938309D29D6F071B5542406A0CC888F1AE9EC
uid           [ultimate] artyomka the-legend <fadeyev-artyom@itmo.ru>
ssb   rsa3072 2024-02-07 [E] [expires: 2024-03-08]
```

```shell
➜  cryptography git:(master) ✗ gpg --list-keys
[keyboxd]
---------
pub   rsa3072 2024-02-07 [SC] [expires: 2024-03-08]
      55A938309D29D6F071B5542406A0CC888F1AE9EC
uid           [ultimate] artyomka the-legend <fadeyev-artyom@itmo.ru>
sub   rsa3072 2024-02-07 [E] [expires: 2024-03-08]

➜  cryptography git:(master) ✗ 
```

Опубликуем наш публичный ключ на сервере для его доступности другим пользователям.

```shell
gpg --keyserver hkps://keyserver.ubuntu.com --send-keys 55A938309D29D6F071B5542406A0CC888F1AE9EC
```

## Шифрованный обмен

Делаем очень секретный файл для нашего коллеги, который хотим спрятать
от недоброжелателей.

Скачаем публичный ключ нашего коллеги, чтобы зашифровать файл.

```shell
gpg --recv-keys=sergo.elizbarashvily@itmo.ru --keyserver=https://keyserver.ubuntu.com

export RECIPIENT_ID=55A938309D29D6F071B5542406A0CC888F1AE9EC

echo -e "- eat\n- sleep\n- code\n- repeat" > secret.txt
gpg --encrypt --recipient $RECIPIENT_ID --output encrypted_secret.gpg secret.txt
```

Получили такой же секретный файл, который нам подготовил коллега с нашим публичным
ключом.

За счет наличия парного приватного ключа, смотрим что там такого секретного
нам написал, придется ввести наш супер секретный passphrase для получения
контента файла.

```shell
export COLLEAGUE_FILE_NAME=encrypted_secret.gpg

gpg --decrypt $COLLEGE_FILE_NAME > secret-decrypted.txt
```

## Электронная подпись

Делаем электронную подпись для файла с приватным ключом.

```shell
gpg --detach-sign -o secret.sig secret.txt
```

Проверяем подпись уважаемого коллеги с публичным ключом (ключ у нас имеется
так как мы его скачали ранее).

Видим, что коллега настоящий гений своего дела и правильно поставил подпись.

```shell
export COLLEAGUE_SIG_NAME=secret.sig
export COLLEAGUE_FILE_NAME=secret.txt

gpg --verify $COLLEAGUE_SIG_NAME $COLLEAGUE_FILE_NAME
```

```shell
➜  cryptography git:(master) ✗ gpg --verify $COLLEAGUE_SIG_NAME $COLLEAGUE_FILE_NAME
gpg: Signature made четверг,  8 февраля 2024 г. 01:33:47 MSK
gpg:                using RSA key 55A938309D29D6F071B5542406A0CC888F1AE9EC
gpg: Good signature from "artyomka the-legend <fadeyev-artyom@itmo.ru>" [ultimate]
```

Мы ребята рассеянные и при наличии нового дела перепутали список дел коллеги
со своим, поэтому записали не туда.

Захотели проверить подпись, но увы, она имеет плохую сигнатуру.

```shell
echo "- detaching sign" >> $COLLEAGUE_FILE_NAME

gpg --verify $COLLEAGUE_SIG_NAME $COLLEAGUE_FILE_NAME
```

```shell
➜  cryptography git:(master) ✗ gpg --verify $COLLEAGUE_SIG_NAME $COLLEAGUE_FILE_NAME
gpg: Signature made четверг,  8 февраля 2024 г. 01:37:39 MSK
gpg:                using RSA key 55A938309D29D6F071B5542406A0CC888F1AE9EC
gpg: BAD signature from "artyomka the-legend <fadeyev-artyom@itmo.ru>" [ultimate]
```

## Resources

- [Manual key submit](https://keyserver.ubuntu.com/#submitKey)
- [Searching a key](https://keyserver.ubuntu.com/pks/lookup?search=55a938309d29d6f071b5542406a0cc888f1ae9ec&fingerprint=on&op=index)
- https://www.gnupg.org/gph/en/manual/x110.html
- https://www.gnupg.org/gph/en/manual/x135.html
