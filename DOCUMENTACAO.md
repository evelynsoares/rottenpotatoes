# Estudo dirigido — Rails e GitHub com RottenPotatoes

Estudo dirigido da disciplina de Engenharia de Software, usando a aplicação RottenPotatoes para praticar desenvolvimento Rails e o fluxo colaborativo do GitHub.

## Objetivo

Construir, testar e documentar uma aplicação Rails de filmes e, em seguida, aplicar um fluxo de versionamento com Git e GitHub: commits, branches, issues, pull requests, revisão, merge e sincronização.

## Estrutura

- **Parte 1 — Rails:** preparação do ambiente, criação do recurso `Movie`, MVC, validações, views Haml, seeds, ordenação, testes e depuração.
- **Parte 2 — Git e GitHub:** estados do Git, repositório remoto, `.gitignore`, commits, issues, branches, pull requests, conflitos, histórico e entrega.
- **README.md:** instruções para instalar, preparar o banco, testar e executar a aplicação.
- **DOCUMENTACAO.md:** relatório do estudo dirigido, com as etapas, conceitos e evidências do trabalho.

## Como executar

Instale as dependências e prepare o banco:

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
```

Execute os testes:

```bash
bin/rails test
```

Inicie o servidor e acesse `http://localhost:3000/movies`:

```bash
bin/rails server
```

---

# Parte 1 — Rails

As etapas abaixo documentam a construção e a validação da aplicação RottenPotatoes com Rails.

---

# Etapa 1 — Preparar o ambiente

Objetivo: deixar o ambiente Rails funcionando corretamente antes de criar a aplicação.

Pré-requisitos:
- Ruby instalado
- Rails instalado
- Git instalado
- SQLite disponível
- RubyMine com interpretador configurado

Comandos de verificação:

```bash
ruby --version
rails --version
git --version
```

No projeto atual, a verificação foi confirmada com:
- Ruby 3.4.10
- Rails 8.1.3.1
- Bundler funcionando

O ambiente foi validado com sucesso depois do comando:

```bash
bundle install
```

Esse passo é importante porque o projeto não consegue rodar sem as gems instaladas.

---

# Etapa 2 — Criar o projeto e configurar Haml

Objetivo: criar a aplicação Rails e preparar o uso de Haml nas views.

O PDF diz para adicionar a gem no [Gemfile](Gemfile):

```ruby
gem "haml-rails"
```

Depois, instalar as dependências:

```bash
bundle install
```

Esse passo já está presente no projeto atual, em [Gemfile](Gemfile).

O projeto usa a estrutura padrão do Rails:
- [app/controllers](app/controllers)
- [app/models](app/models)
- [app/views](app/views)
- [config/routes.rb](config/routes.rb)
- [db/migrate](db/migrate)
- [test](test)

Haml é diferente do HTML porque usa indentação em vez de tags de fechamento. Exemplo:

```haml
%h1 Filmes
%p.notice Oi
```

---

# Etapa 3 — Gerar o recurso Movie

Objetivo: criar o modelo, controller e views para o CRUD de filmes.

No PDF, o comando equivalente é:

```bash
bin/rails generate scaffold Movie title:string rating:string description:text release_date:date --skip-routes
```

Esse comando cria:
- model `Movie`
- migration
- controller
- views para CRUD
- testes

No projeto atual, o recurso já existe em:
- [app/models/movie.rb](app/models/movie.rb)
- [app/controllers/movies_controller.rb](app/controllers/movies_controller.rb)
- [app/views/movies](app/views/movies)

A rota foi declarada manualmente depois, como o PDF pede.

---

# Etapa 4 — Declarar o recurso, migrar e compreender o MVC

Objetivo: expor as rotas REST e entender como o MVC se conecta.

No [config/routes.rb](config/routes.rb), a regra correta é:

```ruby
Rails.application.routes.draw do
  resources :movies
end
```

Isso gera o conjunto de rotas REST:

```text
GET /movies
POST /movies
GET /movies/new
GET /movies/:id
GET /movies/:id/edit
PATCH /movies/:id
PUT /movies/:id
DELETE /movies/:id
```

Comando para confirmar:

```bash
bin/rails routes
```

Verificação no projeto:

```text
movies GET    /movies(.:format)
movies#create
new_movie GET /movies/new
movie GET /movies/:id
```

Também é necessário executar a migração:

```bash
bin/rails db:migrate
```

---

# Etapa 5 — Experimentar Active Record e validações

Objetivo: testar consultas e proteger regras de negócio no model.

O PDF mostra o seguinte no console:

```ruby
Movie.create!(
  title: "Toy Story",
  rating: "G",
  description: "Brinquedos ganham vida.",
  release_date: Date.new(1995, 11, 22)
)

Movie.count
Movie.all
Movie.where(rating: "G")
Movie.order(:title)
```

Essas consultas fazem:
- criar um filme
- contar registros
- listar todos
- filtrar por classificação
- ordenar por título

O model, em [app/models/movie.rb](app/models/movie.rb), já contém as validações:

```ruby
class Movie < ApplicationRecord
  RATINGS = %w[G PG PG-13 R NC-17].freeze
  validates :title, presence: true
  validates :rating, inclusion: { in: RATINGS }
  validates :release_date, presence: true
end
```

Isso significa que o model protege a regra, mesmo que o formulário seja usado de forma errada.

---

# Etapa 6 — Editar views Haml e criar dados iniciais

Objetivo: melhorar o formulário e popular o banco com dados iniciais.

A parte do formulário pede:

```haml
.field
  = form.label :rating
  = form.select :rating, Movie::RATINGS
```

Isso garante que o usuário escolha uma classificação válida, em vez de digitar livremente.

O seed em [db/seeds.rb](db/seeds.rb) foi ajustado com dados iniciais:

```ruby
movies = [
  { title: "Toy Story", rating: "G", release_date: Date.new(1995, 11, 22), description: "Brinquedos ganham vida." },
  { title: "The Matrix", rating: "R", release_date: Date.new(1999, 3, 31), description: "Um programador descobre a realidade." },
  { title: "Star Wars", rating: "PG", release_date: Date.new(1977, 5, 25), description: "Uma aventura em uma galáxia distante." }
]

movies.each do |attributes|
  Movie.find_or_create_by!(title: attributes[:title]) do |movie|
    movie.assign_attributes(attributes)
  end
end
```

Comando:

```bash
bin/rails db:seed
```

Validação executada com sucesso:

```text
count=3
Star Wars | The Matrix | Toy Story
```

---

# Etapa 7 — Implementar ordenação

Objetivo: adicionar links para ordenar a lista por título ou lançamento usando o parâmetro pedido no PDF.

A lógica correta no controller é:

```ruby
def index
  @sort = params[:sort_by]
  @movies = @sort ? Movie.order(@sort) : Movie.all
end
```

A visão precisa ter links como:

```haml
%th= link_to "Título", movies_path(sort_by: "title")
%th= link_to "Lançamento", movies_path(sort_by: "release_date")
```

Isso gera URLs como:

```text
/movies?sort_by=title
/movies?sort_by=release_date
```

O controller recebe o valor por `params[:sort_by]` e usa `Movie.order` para alterar apenas a ordem dos filmes.

Verificação executada:

```bash
bin/rails runner 'puts "sort_by=title => #{Movie.order(:title).pluck(:title).first.inspect}"; puts "sort_by=release_date => #{Movie.order(:release_date).pluck(:title).first.inspect}"'
```

Resultado válido:

```text
sort=release_date => "Star Wars"
```

---

# Etapa 8 — Depurar e testar

Objetivo: usar breakpoint e testes para confirmar a lógica em execução.

## 1) Depuração

O PDF pede colocar um breakpoint na primeira linha do método `index` e depois iniciar o servidor com debug.

A ideia é:
- abrir a página `/movies?sort_by=title`
- inspecionar `params`
- verificar se `params[:sort_by]` recebe `title`
- observar `@movies` antes da renderização

No Rails, isso ajuda a entender o fluxo de dados entre:

```text
URL → rota → controller → Active Record → view
```

## 2) Testes do model

Exemplo do PDF:

```ruby
require "test_helper"

class MovieTest < ActiveSupport::TestCase
  test "precisa ter título" do
    movie = Movie.new(rating: "PG", release_date: Date.current)
    assert_not movie.valid?
    assert_includes movie.errors[:title], "can't be blank"
  end

  test "aceita classificações conhecidas" do
    movie = Movie.new(title: "Filme", rating: "INVALIDA", release_date: Date.current)
    assert_not movie.valid?
  end
end
```

Esses testes validam:
- ausência de título
- classificação inválida

## 3) Como executar os testes

No RubyMine, basta clicar no triângulo verde ao lado do teste ou da classe.

No terminal:

```bash
bin/rails test
```

Esse é o momento em que você confirma se a regra de negócio está funcionando fora do console.

## 4) Depuração prática no projeto

Durante a execução dos testes, o projeto mostrou uma falha real no controller. Os dados de teste estavam com `rating: MyString`, o que não pertence ao conjunto válido definido em `Movie::RATINGS`.

A causa raiz foi corrigida ajustando as fixtures em [test/fixtures/movies.yml](test/fixtures/movies.yml) para usar valores válidos como `G` e `R`.

### Sintoma observado

```text
Expected response to be a <3XX: redirect>, but was a <422: Unprocessable Content>
`Movie.count` didn't change by 1, but by 0.
```

### Correção

```yaml
one:
  title: Toy Story
  rating: G
  description: Brinquedos ganham vida.
  release_date: 1995-11-22

two:
  title: The Matrix
  rating: R
  description: Um programador descobre a realidade.
  release_date: 1999-03-31
```

Esse ajuste faz os testes refletirem as regras do model e permitirem que o CRUD passe corretamente.

---

# Etapa 9 — Fechamento da primeira parte

Objetivo: validar o projeto completo como um conjunto funcional, cobrindo cadastro, edição, exclusão, ordenação, validação e testes.

A validação final de que o projeto está coerente do início ao fim.

---

## 2) Passo a passo da demonstração

### Passo 1 — abrir a listagem

No navegador, acesse:

```text
http://localhost:3000/movies
```

Se o servidor estiver parado, execute:

```bash
bin/rails server
```

Então a página de listagem deve mostrar os filmes existentes, vindos de:

- [config/routes.rb](config/routes.rb)
- [app/controllers/movies_controller.rb](app/controllers/movies_controller.rb)
- [app/views/movies/index.html.haml](app/views/movies/index.html.haml)

### Passo 2 — cadastrar um filme válido

Clique em "New movie" e preencha os campos:

- título: `Toy Story 2`
- classificação: `G`
- descrição: `Uma nova aventura dos brinquedos.`
- data de lançamento: `2000-11-13`

Clique em "Create Movie".

Resultado esperado:
- o registro é salvo
- a aplicação redireciona para a página do filme
- aparece a mensagem de sucesso

### Passo 3 — tentar cadastrar um filme inválido

Teste algo como:

- deixar o título em branco
- escolher uma classificação fora do conjunto válido
- guardar sem data de lançamento

Resultado esperado:
- o form não salva
- a aplicação volta ao formulário
- aparecem mensagens de erro

Isso valida que a regra do modelo está funcionando, porque o model e o formulário não podem ser separados em termos de regra de negócio.

### Passo 4 — editar um filme

Na página de detalhes ou listagem, clique em "Edit this movie".

Mude o título ou a descrição e salve.

Resultado esperado:
- a atualização acontece
- o sistema redireciona para a página do filme editado

### Passo 5 — excluir um filme

Na página de detalhes, clique em "Destroy this movie".

Resultado esperado:
- o filme é removido
- a aplicação volta para a listagem
- a mensagem de exclusão aparece

### Passo 6 — ordenar por título e por data

Na lista principal, use os links:

- Título
- Lançamento

Você deve testar:

```text
/movies?sort_by=title
/movies?sort_by=release_date
```

Resultado esperado:
- a lista fica em ordem alfabética por título
- ou em ordem cronológica por data

### Passo 7 — executar todos os testes

No terminal do projeto:

```bash
bin/rails test
```

Resultado esperado:
- todos os testes passam
- nenhuma falha em model ou controller

### Passo 8 — usar breakpoint para observar `params`

No RubyMine, coloque um breakpoint na primeira linha do método `index` em [app/controllers/movies_controller.rb](app/controllers/movies_controller.rb).

Depois rode o app em debug e visite:

```text
/movies?sort_by=title
```

Observe:
- `params[:sort_by]`
- o valor recebido por `@sort`
- o valor de `@movies`

Isso mostra o caminho real da requisição:

```text
URL -> rota -> controller -> Active Record -> view
```

---

## 3) Conceitos que a etapa 9 revisa

### Migração vs model

- migration: define a estrutura da tabela no banco
- model: representa a entidade e contém validações e regras de negócio

### Quem recebe os parâmetros da requisição?

O controller recebe os parâmetros e os repassa para o model, por exemplo:

```ruby
params[:sort_by]
params.expect(movie: [:title, :rating, :description, :release_date])
```

### Por que a validação fica no model?

Mesmo com `select` do formulário, o usuário pode manipular a requisição. O model precisa proteger a regra de negócio e garantir que os dados inválidos não entrem no banco.

### O que o scaffold criou?

O scaffold cria:
- migration
- model
- controller
- views
- testes

Mas, se a opção `--skip-routes` foi usada, a rota não é criada automaticamente.

### O que `resources :movies` acrescentou?

Ele adiciona as rotas REST para todo o CRUD de filmes.

### Diferença entre `=` e `-` no Haml

- `=` imprime a expressão Ruby na tela
- `-` executa código sem mostrar valor

Exemplo:

```haml
%h1= @movie.title
- if flash[:notice]
  %p.notice= flash[:notice]
```

### Por que limitar os campos aceitos para ordenação?

Para impedir que o usuário envie valores arbitrários na URL e que a aplicação execute consultas perigosas ou inválidas.

---

## 4) Perguntas de revisão do PDF

- Qual é a diferença entre uma migration e um model?
- Qual componente recebe os parâmetros da requisição?
- Por que a validação deve permanecer no model mesmo com um campo select?
- O que o scaffold criou e por que a rota não foi gerada automaticamente?
- O que `resources :movies` acrescentou à aplicação?
- Qual é a diferença entre `=` e `-` em uma view Haml?
- Por que limitamos os campos aceitos para ordenação?

Essas são as perguntas de fechamento da parte 1 e servem para revisar todo o fluxo do projeto.

---

## 5) Prática final recomendada

Antes de encerrar a parte 1, faça a sequência completa:

1. abrir a listagem
2. criar um filme válido
3. criar um filme inválido
4. editar um filme
5. excluir um filme
6. ordenar por título e data
7. rodar todos os testes
8. validar `params` com breakpoint

Se tudo isso funcionar, a primeira parte do RottenPotatoes está concluída e pronta para a Parte 2, que fala de Git e controle de versão.

---

## 6) Resumo final da etapa 9

A etapa 9 é o fechamento da prática. Ela não introduz uma nova funcionalidade nova; ela valida, em conjunto, tudo o que foi construído:

- CRUD
- Model com validações
- Haml e formulário
- Seed
- Ordenação segura
- Testes
- Debug

Quando você consegue executar essa demonstração completa sem erro, o projeto está pronto para a próxima etapa do curso.

---

# Parte 2 — Git e GitHub

Esta parte documenta, em formato de estudo dirigido, o fluxo de versionamento, colaboração e entrega descrito no PDF [Rottenpotatoes_P2-1.pdf](Rottenpotatoes_P2-1.pdf).

## Etapas 1 a 6 — fundamentos de Git e GitHub

### Etapa 1 — Entender Git, GitHub e os estados de um arquivo

O Git controla versões localmente: alterações, commits, branches e histórico. O GitHub hospeda o repositório remoto e oferece issues, pull requests e revisão. O fluxo é:

```text
arquivo de trabalho -> stage -> commit local -> push -> GitHub
```

### Etapa 2 — Confirmar e inicializar o repositório local

A raiz do repositório é `rottenpotatoes`, o Git está inicializado e a branch principal é `main`.

### Etapa 3 — Configurar identidade e proteger arquivos

O `.gitignore` exclui logs, arquivos temporários, armazenamento local, arquivos de ambiente, chaves e PDFs da disciplina. Segredos, bancos locais e credenciais não devem ser publicados.

### Etapa 4 — Criar o primeiro commit

Antes de um commit, o diff deve ser revisado e os testes executados. O histórico do projeto contém commits com mensagens descritivas.

### Etapa 5 — Publicar um novo repositório no GitHub

O remoto `origin` está configurado para `evelynsoares/rottenpotatoes`, e a branch `main` foi publicada no GitHub.

### Etapa 6 — Compreender `origin`, `main`, `push` e `pull`

```bash
git remote -v
git branch --show-current
git status
git log --oneline --decorate --graph --all
```

`push` envia commits locais ao remoto. `fetch` busca referências sem integrar mudanças. `pull` busca e integra mudanças na branch local.

## Etapas 7 a 10 — issue, branch e pull request

### Etapa 7 — Criar uma issue e uma branch de trabalho

Foi criada a issue [#5 — Documentar como executar o RottenPotatoes](https://github.com/evelynsoares/rottenpotatoes/issues/5), com critérios para dependências, banco, testes e servidor. A branch criada foi `docs/instrucoes-execucao`.

### Etapa 8 — Revisar, commitar e enviar a branch

O [README.md](README.md) recebeu instruções reais para `bundle install`, `bin/rails db:prepare`, `bin/rails db:seed`, `bin/rails test` e `bin/rails server`. O diff foi revisado no VS Code, equivalente à revisão visual solicitada pelo PDF.

### Etapa 9 — Abrir e revisar um pull request

Foi aberto o [PR #6 — Documenta execução local do RottenPotatoes](https://github.com/evelynsoares/rottenpotatoes/pull/6), da branch `docs/instrucoes-execucao` para `main`, com `Closes #5`.

### Etapa 10 — Fazer merge e sincronizar

Os checks foram corrigidos, a `main` foi atualizada e o PR #6 foi mergeado. A issue #5 ficou vinculada ao pull request.

## Etapa 11 — Conflito de merge

Um conflito ocorre quando branches alteram a mesma parte de um arquivo de formas incompatíveis. O Git marca as versões para que a pessoa responsável escolha e escreva o resultado final.

Depois da resolução:

```bash
git status
git add README.md
git commit
```

O arquivo deve ser revisado para garantir que nenhum marcador de conflito permaneceu. Esta é uma atividade guiada pelo professor e não foi criada artificialmente no projeto.

## Etapa 12 — Histórico, recuperação e entrega

O histórico pode ser analisado com:

```bash
git log --oneline --decorate --graph --all
git show <commit>
git blame README.md
```

`git revert <commit>` cria um novo commit que desfaz uma mudança publicada. Em trabalho colaborativo, `revert` é preferível a apagar histórico compartilhado.

Checklist confirmado no projeto:

- [x] Repositório GitHub acessível.
- [x] Nenhum segredo ou banco local publicado.
- [x] `main` atualizada e testes passando.
- [x] Issue, branch, commit e pull request criados.
- [x] Pull request revisado e mergeado.

Evidências: [issue #5](https://github.com/evelynsoares/rottenpotatoes/issues/5), [PR #6](https://github.com/evelynsoares/rottenpotatoes/pull/6) e [repositório](https://github.com/evelynsoares/rottenpotatoes).

## Etapa 13 — Cronograma e perguntas finais

### Cronograma autoguiado

1. Revisar conceitos e arquivos protegidos pelo `.gitignore`.
2. Confirmar identidade Git, branch e remoto.
3. Revisar o diff, executar testes e criar commits pequenos.
4. Publicar a `main` no GitHub.
5. Criar issue, branch e alteração relacionada.
6. Revisar o diff, fazer commit e push da branch.
7. Abrir o pull request e relacioná-lo à issue.
8. Revisar checks, responder feedback e fazer merge.
9. Atualizar a `main` local e conferir o histórico.

### Perguntas de fechamento

- **Commit e push:** `commit` registra localmente; `push` envia ao remoto.
- **`origin`:** nome convencional do repositório remoto.
- **Revisão do diff:** confirma as linhas alteradas e evita arquivos indevidos ou segredos.
- **Branch:** isola a tarefa e protege a estabilidade da `main`.
- **Novo commit no PR:** o pull request é atualizado automaticamente.
- **Pull após merge:** sincroniza a `main` local com o merge feito no GitHub.
