# RottenPotatoes — Documentação das etapas

Este documento reúne a parte prática do RottenPotatoes e a Parte 2 de Git/GitHub, com teoria, evidências e links para os arquivos do projeto.

## Índice da documentação

- [Parte 2: etapas 1 a 6 — fundamentos de Git e GitHub](#rottenpotatoes-parte-2--etapas-1-a-6)
- [Parte 2: etapas 7 a 10 — issue, branch e pull request](#parte-2--etapas-7-a-10)
- [Parte 2: etapa 11 — conflito de merge](#etapa-11--conflito-de-merge)
- [Parte 2: etapa 12 — histórico, recuperação e entrega](#etapa-12--histórico-recuperação-e-entrega)
- [Parte 2: etapa 13 — cronograma e perguntas finais](#etapa-13--cronograma-e-perguntas-finais)
- [Parte 1: etapas Rails](#etapa-1--preparar-o-ambiente)

---

# RottenPotatoes Parte 2 — Etapas 1 a 6

As etapas 1 a 6 do PDF (Rottenpotatoes_P2-1.pdf) tratam do fluxo de Git e GitHub. Elas foram realizadas no projeto da seguinte forma:

## Etapa 1 — Entender Git, GitHub e os estados de um arquivo

O projeto possui um repositório Git local. As alterações atuais aparecem separadas por estado no `git status`, permitindo distinguir arquivos modificados, não rastreados e versões registradas em commits. O GitHub funciona como repositório remoto, enquanto o Git mantém o histórico local.

## Etapa 2 — Confirmar e inicializar o repositório local

Esta etapa está concluída. A raiz do repositório é a pasta `rottenpotatoes`, e o comando `git status` funciona normalmente. O projeto está na branch `main`.

## Etapa 3 — Configurar identidade e proteger arquivos

O projeto possui um `.gitignore` com regras para logs, arquivos temporários, armazenamento local, arquivos de ambiente e chaves. Também foi adicionada a regra `*.pdf`, pois os PDFs usados como material da disciplina não fazem parte do código da aplicação.

Arquivos sensíveis, como credenciais e chaves, não devem ser publicados. Um PDF que já esteja rastreado pelo Git não deixa de ser rastreado apenas por entrar no `.gitignore`; a regra impede principalmente que novos PDFs sejam adicionados.

## Etapa 4 — Criar o primeiro commit

Há histórico Git local e um commit inicial da aplicação. Antes de registrar novas versões, devem ser revisados o diff, os testes e os arquivos selecionados. A validação atual da aplicação foi feita com `bin/rails test`.

## Etapa 5 — Publicar um novo repositório no GitHub

O remoto `origin` está configurado para o repositório GitHub `evelynsoares/rottenpotatoes`. A branch principal local é `main`, e o histórico remoto contém a versão publicada da aplicação.

## Etapa 6 — Compreender `origin`, `main`, `push` e `pull`

Os comandos de inspeção confirmam:

```text
origin = git@github.com:evelynsoares/rottenpotatoes.git
branch atual = main
```

No momento, a `main` local possui alterações posteriores ao último estado de `origin/main`. Portanto, as etapas de GitHub estão configuradas, mas as alterações recentes do trabalho ainda precisam ser enviadas com `push` quando for o momento adequado.

### Situação resumida

| Etapa | Situação |
|---|---|
| 1 | Concluída no repositório local |
| 2 | Concluída: Git e branch `main` ativos |
| 3 | Concluída: `.gitignore` revisado e PDFs ignorados |
| 4 | Concluída no histórico local |
| 5 | Concluída: remoto `origin` configurado |
| 6 | Concluída: relação entre local, `origin` e `main` verificada |

---

# Parte 2 — Etapas 7 a 10

## Etapa 7 — Criar uma issue e uma branch de trabalho

Foi criada a issue [#5 — Documentar como executar o RottenPotatoes](https://github.com/evelynsoares/rottenpotatoes/issues/5), com os critérios de aceitação para instalação, banco, testes e servidor.

Também foi criada a branch `docs/instrucoes-execucao`, relacionada à atividade da issue.

## Etapa 8 — Revisar, commitar e enviar a branch

O [README.md](README.md) foi preenchido com instruções reais para:

- instalar dependências com `bundle install`;
- preparar o banco com `bin/rails db:prepare`;
- carregar dados de exemplo com `bin/rails db:seed`;
- executar testes com `bin/rails test`;
- iniciar o servidor com `bin/rails server`.

O diff foi revisado no VS Code, que substituiu a revisão visual do RubyMine neste ambiente.

## Etapa 9 — Abrir e revisar um pull request

Foi aberto o [PR #6 — Documenta execução local do RottenPotatoes](https://github.com/evelynsoares/rottenpotatoes/pull/6), da branch `docs/instrucoes-execucao` para `main`, com a descrição da mudança e `Closes #5`.

## Etapa 10 — Responder ao feedback, fazer merge e sincronizar

Os checks do CI foram corrigidos na própria atividade e a `main` foi sincronizada. O PR #6 foi mergeado pelo GitHub. O histórico remoto confirma o merge:

```text
f5054bf Merge pull request #6 from evelynsoares/docs/instrucoes-execucao
```

O README foi integrado à `main`, e a issue #5 foi vinculada ao pull request.

---

# Etapa 11 — Conflito de merge

## Teoria

Um conflito acontece quando duas branches alteram a mesma parte de um arquivo de maneiras incompatíveis. O Git não escolhe sozinho qual intenção deve permanecer; a pessoa responsável precisa ler as duas alterações e produzir o texto final coerente.

Os marcadores que aparecem durante um conflito são:

```text
<<<<<<< HEAD
conteúdo da branch atual
=======
conteúdo da outra branch
>>>>>>> outra-branch
```

Depois de resolver o arquivo, é necessário:

```bash
git status
git add README.md
git commit
```

Antes de concluir, confirme que não restaram `<<<<<<<`, `=======` ou `>>>>>>>` e execute os testes.

## Aplicação ao projeto

Esta etapa é uma atividade guiada pelo professor. Ela não exige uma alteração permanente na aplicação e não foi criada artificialmente apenas para gerar conflito. A documentação registra o procedimento para quando o conflito for demonstrado em aula.

---

# Etapa 12 — Histórico, recuperação e entrega

## Teoria

O histórico do Git permite entender quando, por quem e por que um arquivo mudou. Os comandos e conceitos principais são:

```bash
git log --oneline --decorate --graph --all
git show <commit>
git blame README.md
```

- `git log` mostra a sequência de commits e branches;
- `git show` mostra o diff e os metadados de um commit;
- `git blame` relaciona cada linha ao commit que a alterou;
- `git revert <commit>` cria um novo commit que desfaz uma mudança publicada;
- desfazer o último commit local ainda não enviado é diferente de reverter uma mudança já compartilhada.

Em trabalho colaborativo, `revert` é preferível a apagar o histórico publicado.

## Checklist de entrega

- [x] Repositório GitHub acessível.
- [x] Nenhum segredo ou banco local publicado.
- [x] Branch `main` atualizada e testes passando.
- [x] Issue com critérios de aceitação.
- [x] Branch relacionada à atividade.
- [x] Commit com mensagem descritiva.
- [x] Pull request com descrição, checks e merge.

## Evidências do projeto

- Repositório: https://github.com/evelynsoares/rottenpotatoes
- Pull request: [#6](https://github.com/evelynsoares/rottenpotatoes/pull/6)
- Issue: [#5](https://github.com/evelynsoares/rottenpotatoes/issues/5)
- Testes: `11 runs, 22 assertions, 0 failures, 0 errors, 0 skips`

---

# Etapa 13 — Cronograma e perguntas finais

## Cronograma autoguiado

1. Revisar conceitos e conferir arquivos protegidos pelo `.gitignore`.
2. Confirmar identidade Git, branch e remoto.
3. Revisar o diff, executar testes e criar commits pequenos.
4. Publicar a `main` no GitHub.
5. Criar issue, branch de trabalho e alteração relacionada.
6. Revisar o diff, fazer commit e push da branch.
7. Abrir o pull request e relacioná-lo à issue.
8. Revisar checks, responder feedback e fazer merge.
9. Atualizar a `main` local e conferir o histórico.

## Perguntas de fechamento

### Qual é a diferença entre commit e push?

`commit` registra uma versão no repositório local. `push` envia os commits locais para o repositório remoto.

### O que `origin` representa?

`origin` é o nome convencional dado ao repositório remoto associado ao projeto local.

### Por que revisar o diff antes do commit?

Para confirmar quais linhas serão registradas, detectar arquivos não relacionados e evitar o envio de segredos, bancos ou arquivos gerados.

### Por que trabalhar em uma branch?

A branch isola uma tarefa e permite revisar a alteração antes de integrá-la à `main`, que deve permanecer estável.

### O que acontece quando um novo commit é enviado à branch do PR?

O pull request é atualizado automaticamente e passa a incluir o novo commit e seus efeitos nos checks.

### Por que executar pull depois de um merge no GitHub?

Para trazer o merge realizado no remoto para a cópia local e manter a `main` sincronizada.

## Estado final das etapas 11 a 13

As etapas 11 a 13 foram registradas teoricamente nesta documentação. A etapa 11 fica preparada para a atividade guiada de conflito; a etapa 12 registra o checklist e as evidências reais do projeto; e a etapa 13 consolida o cronograma e as respostas de revisão.


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

# Conformidade com o PDF

## O que foi implementado de acordo com o PDF

Depois da revisão, a implementação segue diretamente a lógica apresentada no PDF:

- a rota principal `/movies` continua acessando a lista de filmes;
- o controller captura `params[:sort_by]`;
- o controller usa `Movie.order(@sort)` para alterar a ordem;
- há suporte para ordenar por `title` e por `release_date`;
- há links de cabeçalho na view para disparar a ordenação;
- a view renderiza a lista em tabela e marca a coluna ativa com `hilite`.

Esses pontos estão refletidos em:

- [app/controllers/movies_controller.rb](app/controllers/movies_controller.rb)
- [app/views/movies/index.html.haml](app/views/movies/index.html.haml)
- [test/controllers/movies_controller_test.rb](test/controllers/movies_controller_test.rb)

## Por que a versão anterior estava diferente

A versão anterior usava `params[:sort]`, aceitava também `sort_by` como alternativa e aplicava `LOWER(title)` para títulos. Essas eram melhorias e extensões, mas não reproduziam literalmente a lógica ensinada no PDF. Elas foram removidas para que o código atual use exatamente `sort_by` e `Movie.order`, como solicitado.

## Conclusão

A implementação atual está alinhada ao PDF: os links enviam `sort_by`, o controller lê `params[:sort_by]` e `Movie.order` faz a ordenação.

Verificação executada:

```bash
cd "/home/evelyn/Documents/2026-2/eng de software/rottenpotatoes" && bin/rails test
```

Resultado confirmado:

```text
9 runs, 18 assertions, 0 failures, 0 errors, 0 skips
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

# Resumo final

As etapas 1 a 8 formam a base do projeto RottenPotatoes:

1. configurar ambiente
2. criar projeto Rails
3. gerar recurso Movie
4. declarar rotas e migrar
5. testar Active Record e validações
6. criar Haml e seed
7. ordenar com segurança
8. debugar e testar funcionalmente

Isso organiza a aplicação em MVC e mostra como Rails conecta:
- rota
- controller
- model
- view
- banco de dados
- testes

---

# Etapa 9 — Fechamento da primeira parte

Objetivo: validar o projeto completo como um conjunto funcional, cobrindo cadastro, edição, exclusão, ordenação, validação e testes.

A etapa 9 não cria uma nova funcionalidade; ela é a revisão final da primeira parte do curso. O foco é verificar se a aplicação funciona como um sistema integrado.

## 1) Demonstração final esperada

A checklist do PDF pede que você confirme cada item:

- [ ] Abrir a listagem de filmes.
- [ ] Cadastrar um filme válido.
- [ ] Tentar cadastrar um filme inválido e observar as mensagens.
- [ ] Editar e excluir um filme.
- [ ] Ordenar por título e por data.
- [ ] Executar todos os testes com sucesso.
- [ ] Usar um breakpoint para observar `params`.

Essa é a validação final de que o projeto está coerente do início ao fim.

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

# Conclusão geral

O projeto RottenPotatoes foi construído em etapas progressivas:

- Etapa 1 a 8: fundamentos e funcionalidade
- Etapa 9: revisão final e validação do sistema completo

A partir daqui, a próxima etapa costuma ser a Parte 2, com Git e controle de versão no RubyMine.


Próximo passo natural: continuar com a parte da depuração no RubyMine e rodar os testes do projeto.
