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

O projeto tem tres suites de teste:

```bash
bin/rails test           # Minitest: model Movie, CRUD e ordenacao
bundle exec cucumber     # Cucumber: cenarios BDD em features/
bundle exec rspec        # RSpec: specs de model e controller em spec/
```

Rodar `bundle exec rspec` e `bundle exec cucumber` gera o relatorio de cobertura do SimpleCov em `coverage/index.html`, juntando as duas suites. A pasta `coverage/` nao e versionada.

## Iniciar o servidor

Inicie o servidor Rails:

```bash
bin/rails server
```

Abra [http://localhost:3000/movies](http://localhost:3000/movies) no navegador.

Na lista de filmes:

- os cabecalhos `Movie Title` e `Release Date` ordenam os registros;
- as caixas de classificacao (G, PG, PG-13, R, NC-17) com o botao `Refresh` filtram a lista.

Na pagina de um filme, o link `Find Movies With Same Director` lista os outros filmes do mesmo diretor.

## Comandos uteis

```bash
bin/rails routes       # lista as rotas da aplicacao
bin/rails console      # abre o console Rails
bin/rails db:reset     # recria o banco e executa as seeds
```

## Documentacao do trabalho

Fiz os homeworks da disciplina sobre esta mesma aplicacao. O relato de cada um, com o que fiz e as decisoes que tomei, esta em [DOCUMENTACAO.md](DOCUMENTACAO.md), separado por homework.

| Homework | O que fiz | Arquivos principais |
|---|---|---|
| HW2 — Rails e GitHub (estudo dirigido) | Recurso `Movie`, validacoes, views Haml, ordenacao, testes e fluxo Git/GitHub | `app/`, `test/`, `config/routes.rb` |
| HW BDD — Cucumber | Sad path da busca no TMDb e cenario de ordenacao nas versoes imperativa e declarativa | `features/search_tmdb.feature`, `features/view_movie_list.feature` |
| HW3 — BDD e Cucumber | Filtro por classificacao e steps para os cenarios de filtro e de ordenacao | `features/filter_movie_list.feature`, `features/sort_movie_list.feature` |
| HW4 — Ciclo BDD+TDD | Coluna `director` e busca de filmes do mesmo diretor, com specs RSpec escritos antes do codigo e cobertura medida com SimpleCov | `features/movies_by_director.feature`, `spec/` |

### Cobertura de testes (HW4)

Gerei o relatorio do SimpleCov rodando `bundle exec rspec` e `bundle exec cucumber` uma vez cada. No HW4, models e controllers precisavam de pelo menos 90% de cobertura; os dois ficaram com 100%.

**Todos os arquivos — 94,20%.** `application_job.rb` e `application_mailer.rb` sao classes base geradas pelo Rails e nao usadas pela aplicacao.

<img width="1873" height="826" alt="Cobertura de todos os arquivos: 94,20%" src="https://github.com/user-attachments/assets/3455ebad-727b-4cfc-9ac9-522191c09cde" />

**Controllers — 100%.**

<img width="1892" height="891" alt="Cobertura dos controllers: 100%" src="https://github.com/user-attachments/assets/59474e22-7ef8-4913-a77c-b76b64c8e5c4" />

**Helpers — 100%.**

<img width="1900" height="879" alt="Cobertura dos helpers: 100%" src="https://github.com/user-attachments/assets/f510d59d-c4fe-432c-afea-57deba6b498d" />

**Models — 100%.**

<img width="1902" height="857" alt="Cobertura dos models: 100%" src="https://github.com/user-attachments/assets/f453ddc5-97ca-4d2f-9112-ce40f261fc59" />