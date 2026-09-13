# RottenPotatoes

Aplicacao Rails para cadastro e consulta de filmes.

## Requisitos

- Ruby 3.4.10
- Bundler
- SQLite 3

O projeto usa Rails 8.1.3.1 e Haml nas views.

## Instalacao

Clone o repositorio e entre na pasta do projeto:

```bash
git clone git@github.com:evelynsoares/rottenpotatoes.git
cd rottenpotatoes
```

Instale as dependencias Ruby:

```bash
bundle install
```

## Preparar o banco de dados

Crie ou atualize o banco de desenvolvimento com as migrations:

```bash
bin/rails db:prepare
```

Para carregar os filmes de exemplo:

```bash
bin/rails db:seed
```

Os bancos SQLite sao armazenados em `storage/` e nao devem ser versionados.

## Executar os testes

Execute a suite completa:

```bash
bin/rails test
```

Os testes cobrem o model `Movie`, o CRUD e a ordenacao da lista por titulo ou data de lancamento.

## Iniciar o servidor

Inicie o servidor Rails:

```bash
bin/rails server
```

Abra [http://localhost:3000/movies](http://localhost:3000/movies) no navegador.

Na lista de filmes, os cabecalhos `Title` e `Release Date` permitem ordenar os registros.

## Comandos uteis

```bash
bin/rails routes       # lista as rotas da aplicacao
bin/rails console      # abre o console Rails
bin/rails db:reset     # recria o banco e executa as seeds
```

## Documentacao do trabalho

As etapas realizadas e as decisoes do projeto estao descritas em [DOCUMENTACAO.md](DOCUMENTACAO.md).
