# learn_ruby_crud

コンテナ起動

```zsh
docker-compose up -d
```

コンテナ停止

```zsh
docker-compose down
```

コンテナを削除

```zsh
docker-compose down --rmi all --volumes --remove-orphans
```

コンテナに入る

```zsh
docker-compose exec app bash
```

DBコンテナに入る

```zsh
docker-compose exec db psql -U postgres
```