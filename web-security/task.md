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
