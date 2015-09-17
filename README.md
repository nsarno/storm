# Storm
[![Build Status](https://travis-ci.org/nsarno/storm.svg?branch=master)](https://travis-ci.org/nsarno/storm)

Storm is a test project through which I intend to learn about [Elixir](http://elixir-lang.org/) & [Phoenix](http://www.phoenixframework.org/).

### Description

Storm is a REST API to setup & execute HTTP load simulation.

**Example use cases**

- Simulate heavy traffic to test your application stability
- Simulate user scenarios and gather metrics to monitor improvements/degradation of your application performance over time.

## Getting started

```bash
$ git clone git@github.com:nsarno/storm.git
$ cd storm/
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

### Run the tests

```bash
$ mix test
```

## Architecture

Storm is composed of three distinct parts:

### 1. REST API

A typical REST API that allows users to do things like sign up, create and
manage projects etc.

**where**

- The relevant code can be found in `web/`
- The `web/router.ex` is an excellent place to start to understand what it's
  possible to do with the API.

### 2. Processing

The processing part is the main element of Storm. This is what is in charge of
executing all the HTTP request configured by a user.

It's itself composed of two modules:

#### a. Spawner

Spawner has only one role: to spawn worker for every mission of each project.
It's started by [Quantum](https://github.com/c-rack/quantum-elixir) every minutes.

**where**

- The Quantum configuration is in `config/config.exs`
- `lib/storm/spawner.ex`

#### b. Worker

A worker is going to hit every target of a given mission one after the other to simulate
the traffic of a visitor on the user's targeted website.

The Spawner only spawns 1 worker per mission. But a mission can be configured to be
executed n times per minute to simulate (+/-) heavy traffic. In that case a worker will
replicate itself n-times.

So a worker always execute 1 mission, but it can spawn N other workers to execute
the same mission.

**where**

- `lib/storm/worker.ex`

### 3. Metrics!

It's more fun with data!

[HTTPoison](https://github.com/edgurgel/httpoison) is used to execute the HTTP requests.
HTTPoison is powered by the erlang library [Hackney](https://github.com/benoitc/hackney/).

Fortunately, it's possible to enable metrics collection with Hackney by configuring it to
use our metrics module implementation in`config/config.exs`:

```elixir
config :hackney, mod_metrics: Storm.Metrics.Hackney
```

To be able to link metrics with their targets of origin, we use a `CompletionBucket`.
A completion bucket allows a worker to register itself and provide a completion callback before
firing an HTTP request. Then upon receiving the metrics from Hackney, it pops itself from
the bucket and execute the callback.

The storage of the metrics is not yet implemented, but this is where it would be implemented.
At the moment, the callback provided only outputs the result.

**where**

- `lib/storm/metrics/hackney.ex`
- `lib/storm/metrics/completion_bucket.ex`
- `lib/storm/worker.ex` in the `hit_target/2` function


## How metrics are stored (Not implemented yet)

Every metric stored corresponds to a metric item.
Every time an object is created, it can generate a set of items that will be used to collect metrics.

Example:

A `target` is created, it generates a response time" item.

When a `worker` hit a `target`, it's going to store the response time value and a timestamp for the "response time" item of this target.

### Requirements

1. It must be possible to add more metrics of different types (int, float, string, ...)
2. It must be possible to add more metrics related to different items (targets, missions, projects, ...)
3. Data size must be limited. (Generation of multiple metrics / targets / minutes could quickly go out of hand)
4. There can be only one 

### Solutions

1. One history table per type.
2. Polymorphic association to identify the source of an item.
3. Implement a round-robin like insert function with a fixed set size of allowed data per project.

**Example implementation for response time**

table: items
columns: id, item_type:string, source_id:integer, source_type:string

eg: id(1), item_type("response_time"), source_id(target.id), source_type("Target")

table: history_float
columns: item_id:integer, item_type:integer, value:float, clock:timestamp
indexes: index(item_id), unique(item_id, clock)

eg: item_id(1), item_type(1), value(1234.56), clock(1442470861)

Notes:
A primary key (id column) is not required as it would most likely never be used. Also on a potentially big table like history, this could result in a huge waste of space.
