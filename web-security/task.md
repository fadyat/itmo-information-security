# Безопасность WEB-приложений

## Цель работы

- получить навыки эксплуатации уязвимостей WEB-приложений

### Broken Access Control

https://owasp.org/Top10/A01_2021-Broken_Access_Control/

- запустить приложение
- создать двух пользователей
- сыграть несколько раз первым пользователем и посмотреть его статистику
- проверить как статистика получается с сервера через Developer Tools
- используя `GET`-запрос и параметры сессии второго пользователя, вывести статистику
  первого пользователя

### Cross-Site Scripting

https://owasp.org/Top10/A03_2021-Injection/

- запустить приложение
- используя `<script>alert(1)</script>` проверить формы приложения
- подумать как можно развить эту атаку

### Security Misconfiguration

https://owasp.org/Top10/A05_2021-Security_Misconfiguration/

- запустить приложение
- изучить Request Payload в Developer Tools
- используя `curl` и повторяя структуру `POST` запроса, создать файл `payload.xml`
- запустить `curl -d @payload.xml localhost:10004/contact.php ; echo`
- проверить загрузку со стороны сервера
- доработать файл `@payload.xml` и получить от сервера `/etc/passwd`

### Server Side Injection

https://owasp.org/Top10/A03_2021-Injection/

- запустить приложение
- исследовать работу приложения: `curl http://localhost:10001?name=$name`
- используя операцию умножения в параметре `name` проверить некорректную
  обработку пользовательского ввода
- вывести содержимое файла `/etc/passwd` используя в строке запроса Python
  команду `os.popеn`

### NoSQL Injection

https://owasp.org/Top10/A03_2021-Injection/

- запустить приложение:
- изучить файл `db.js`
- ответить на вопрос за что отвечают `$ne` и `$gt` в MongoDB
- обойти аутентификацию, создав вредоносный запрос с использованием `{"$ne": ""}` в
  полях `email` и `password`
