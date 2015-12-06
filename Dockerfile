FROM trenpixster/elixir 

COPY . /storm

WORKDIR /storm

RUN mix deps.get
RUN mix compile

EXPOSE 4000

CMD ["mix", "phoenix.server"]
