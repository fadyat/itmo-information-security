# ViniJR Blog

<p align="center">
    <img src="images/blog-fe.png"/>
</p>

This is a simple PHP web application that contains an example of a Security Misconfiguration (XXE) vulnerability and the
main goal of this app is to describe how a malicious user could exploit it.

## Index

- [Definition](#what-is-xxe)
- [Setup](#setup)

## What is XXE?

Many older or poorly configured XML processors evaluate external entity references within XML documents. External
entities can be used to disclose internal files using the file URI handler, internal file shares, internal port
scanning, remote code execution, and denial of service attacks.

The main goal of this app is to discuss how **XXE** vulnerabilities can be exploited and to encourage developers to send
Pull Requests on how they would mitigate these flaws.

## Setup

To start this intentionally **insecure application**, you will need [Docker](https://docs.docker.com/get-docker/)
and [Docker Compose](https://docs.docker.com/compose/install/).

You must type the following commands to start:

```sh
make install
```

Then simply visit http://localhost:10004

## Get to know the app ⚽️

To properly understand how this application works, you can follow these simple steps:

- Visit its homepage!
- Try sending ViniJR a message.
