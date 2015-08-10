# Winter
[![Build Status](https://travis-ci.org/nsarno/winter.svg?branch=master)](https://travis-ci.org/nsarno/winter)

Wintertest project through which I intend to learn about [Elixir](http://elixir-lang.org/) & [Phoenix](http://www.phoenixframework.org/).

## Description

Winter is a REST API to setup & execute HTTP load simulation.

**Example use cases**

- Simulate heavy traffic to test your application stability
- Simulate user scenarios and gather metrics to monitor improvements/degradation of your application performance over time.

## Getting started

```bash
$ git clone git@github.com:nsarno/winter.git
$ cd winter/
$ mix deps.get
$ mix phoenix.server
```

The server is up and running at `http://127.0.0.1:4000`.

```bash
$ curl -I http://127.0.0.1:4000
HTTP/1.1 404 Not Found
connection: keep-alive
server: Cowboy
...
```

## Run the tests

```bash
$ mix test
```

