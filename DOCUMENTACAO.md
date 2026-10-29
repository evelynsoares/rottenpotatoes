# Documentação do RottenPotatoes

Este documento reúne o que fiz em cada homework de Engenharia de Software sobre a aplicação RottenPotatoes, as decisões que tomei e as evidências. As instruções para instalar, testar e rodar a aplicação estão no [README.md](README.md).

## HW2 — Rails e GitHub (estudo dirigido)

### Ambiente e criação do projeto

Comecei conferindo o ambiente: Ruby 3.4.10, Rails 8.1.3.1, Git, SQLite e o RubyMine com o interpretador Ruby configurado. Verifiquei as versões com `ruby --version`, `rails --version` e `git --version` e rodei `bundle install` sem erros.

Criei a aplicação Rails e adicionei a gem `haml-rails` no [Gemfile](Gemfile) para escrever as views em Haml, que usa indentação no lugar das tags de fechamento do HTML (`%h1 Filmes` em vez de `<h1>Filmes</h1>`).

### Recurso Movie, rotas e banco

Gerei o model, o controller, as views e os testes do CRUD de filmes com o scaffold:

```bash
bin/rails generate scaffold Movie title:string rating:string description:text release_date:date --skip-routes
```

Como usei `--skip-routes`, declarei a rota manualmente com `resources :movies` em [config/routes.rb](config/routes.rb). Essa linha gera as rotas REST do CRUD (listar, criar, exibir, editar, atualizar e excluir filmes), que conferi com `bin/rails routes`. Depois apliquei a migration com `bin/rails db:migrate`.

### Active Record, validações e seeds

No console (`bin/rails console`), criei um filme com `Movie.create!` e testei as consultas `Movie.count`, `Movie.all`, `Movie.where(rating: "G")` e `Movie.order(:title)`.

Em seguida, coloquei as regras de negócio no [model](app/models/movie.rb): todo filme precisa de título e data de lançamento, e a classificação tem que ser `G`, `PG`, `PG-13`, `R` ou `NC-17`.

```ruby
class Movie < ApplicationRecord
  RATINGS = %w[G PG PG-13 R NC-17].freeze
  validates :title, presence: true
  validates :rating, inclusion: { in: RATINGS }
  validates :release_date, presence: true
end
```

No [formulário](app/views/movies/_form.html.haml), troquei o campo de texto da classificação por uma lista de opções (`form.select :rating, Movie::RATINGS`). A validação continua no model mesmo assim: o select só limita a interface, e alguém pode manipular a requisição e enviar qualquer valor.

Também preenchi o [db/seeds.rb](db/seeds.rb) com três filmes (Toy Story, The Matrix e Star Wars). Depois de `bin/rails db:seed`, o banco ficou com os três.

### Ordenação por título e por data

Transformei os cabeçalhos "Title" e "Release Date" da listagem em links que passam o parâmetro `sort_by` na URL (`/movies?sort_by=title` e `/movies?sort_by=release_date`). Cada link tem um id (`title_header` e `release_date_header`), e a coluna ordenada recebe a classe CSS `hilite`, que a destaca:

```haml
%th{class: ("hilite" if @sort == "title")}
  = link_to "Title", movies_path(sort_by: "title"), id: "title_header"
%th Rating
%th{class: ("hilite" if @sort == "release_date")}
  = link_to "Release Date", movies_path(sort_by: "release_date"), id: "release_date_header"
```

No controller, o `index` lê esse parâmetro e usa `Movie.order` para mudar só a ordem dos filmes:

```ruby
def index
  @sort = params[:sort_by]
  @movies = @sort ? Movie.order(@sort) : Movie.all
end
```

Conferi com `bin/rails runner` que, com os filmes do seed, Star Wars aparece primeiro nas duas ordens: é o primeiro em ordem alfabética e o mais antigo (1977).

### Depuração e testes

Coloquei um breakpoint na primeira linha do `index`, rodei a aplicação em debug no RubyMine e abri `/movies?sort_by=title`. Com a execução parada, vi `params[:sort_by]` chegar como `title` e inspecionei `@movies` antes da renderização. Isso deixou claro o caminho de uma requisição no Rails: URL, rota, controller, Active Record e view.

Escrevi testes para as validações em [test/models/movie_test.rb](test/models/movie_test.rb): um filme sem título e um filme com classificação inválida não podem ser válidos. Rodei os testes pelo RubyMine, no triângulo verde ao lado de cada teste, e no terminal com `bin/rails test`.

Ao rodar a suíte, encontrei uma falha real nos testes do controller:

```text
Expected response to be a <3XX: redirect>, but was a <422: Unprocessable Content>
`Movie.count` didn't change by 1, but by 0.
```

A causa era que as fixtures geradas pelo scaffold tinham `rating: MyString`, que o model recusa. Corrigi [test/fixtures/movies.yml](test/fixtures/movies.yml) para usar classificações válidas (Toy Story com `G`, The Matrix com `R`), e os testes do CRUD passaram.

### Demonstração final

Para fechar a parte de Rails, testei a aplicação inteira no navegador, em `http://localhost:3000/movies`. Cadastrei o filme Toy Story 2 (classificação `G`, lançado em 2000-11-13): ele foi salvo e a aplicação mostrou a mensagem de sucesso. Tentei salvar um filme com o título em branco e sem data de lançamento, e o formulário voltou com as mensagens de erro. Editei e excluí um filme, ordenei a lista pelos dois links e rodei `bin/rails test` com todos os testes passando.

### Git e GitHub

Configurei o `.gitignore` para não publicar logs, arquivos temporários, bancos locais, arquivos de ambiente, chaves e os PDFs da disciplina. O repositório local tem a branch principal `main`, e configurei o remoto `origin` apontando para [evelynsoares/rottenpotatoes](https://github.com/evelynsoares/rottenpotatoes), onde publiquei a `main`. Antes de cada commit, revisei o diff e rodei os testes.

Para praticar o fluxo de colaboração, abri a issue [#5 — Documentar como executar o RottenPotatoes](https://github.com/evelynsoares/rottenpotatoes/issues/5) e criei a branch `docs/instrucoes-execucao`. Nela, escrevi no README as instruções para instalar as dependências, preparar o banco, rodar os testes e iniciar o servidor, revisei o diff no VS Code e enviei a branch. Abri o [PR #6](https://github.com/evelynsoares/rottenpotatoes/pull/6) para a `main` com `Closes #5`, corrigi os checks do CI que estavam falhando e fiz o merge. Depois atualizei a `main` local e conferi o histórico com `git log --oneline --decorate --graph --all`.

O conflito de merge fiz na atividade guiada pelo professor; não criei um conflito artificial neste repositório. Para resolver um conflito, escolho e escrevo o resultado final no arquivo, confiro que não sobrou nenhum marcador de conflito e só então faço `git add` e `git commit`. Para desfazer uma mudança já publicada, o caminho certo é `git revert`, que cria um novo commit em vez de apagar o histórico compartilhado.

### Perguntas de revisão

**Migration e model.** A migration define a estrutura da tabela no banco; o model representa a entidade e guarda as validações e as regras de negócio.

**Quem recebe os parâmetros da requisição.** O controller. Ele lê, por exemplo, `params[:sort_by]` e filtra os campos do formulário com `params.expect` antes de repassá-los ao model.

**O que o scaffold criou.** Migration, model, controller, views e testes. A rota ficou de fora porque usei `--skip-routes`; foi o `resources :movies` que acrescentou as rotas REST do CRUD.

**`=` e `-` no Haml.** O `=` executa a expressão Ruby e imprime o resultado na página; o `-` só executa, como em `- if flash[:notice]`.

**Por que limitar os campos de ordenação.** Sem esse limite, alguém poderia enviar qualquer valor na URL e fazer a aplicação montar uma consulta inválida ou perigosa. Hoje o controller só ordena por `title` e `release_date` (`Movie::RATINGS_SORT_COLUMNS`).

**Commit, push, fetch e pull.** O `commit` registra a mudança no repositório local, e o `push` envia os commits para o remoto (`origin`, por convenção). O `fetch` busca as mudanças do remoto sem integrá-las; o `pull` busca e integra. Depois de um merge feito no GitHub, dou `pull` para sincronizar a `main` local.

**Branches e pull requests.** A branch isola a tarefa e protege a estabilidade da `main`. Um novo commit na branch de um pull request aberto atualiza o PR automaticamente.

## HW BDD — Cucumber

Neste homework, comecei a testar a aplicação com cenários BDD. Adicionei as gems `cucumber-rails` e `database_cleaner-active_record` e gerei a estrutura do Cucumber (`features/`, `config/cucumber.yml` e `bin/cucumber`).

O primeiro cenário, em [features/search_tmdb.feature](features/search_tmdb.feature), é o sad path da busca no TMDb: procurar um filme que não existe deve voltar para a lista com a mensagem "'Movie That Does Not Exist' was not found in TMDb.". Para isso, adicionei na listagem o formulário "Search TMDb for a movie", a rota `POST /movies/search_tmdb` e a ação `search_tmdb` no controller. Como ainda não há integração com a API do TMDb, a ação sempre responde que o filme não foi encontrado, só para validar esse cenário.

Em [features/view_movie_list.feature](features/view_movie_list.feature), escrevi o mesmo cenário de duas formas: cadastrar dois filmes (Zorro e Apocalypse Now) e conferir que, ordenada por título, a lista mostra Apocalypse Now antes de Zorro. A versão imperativa descreve cada clique, duas vezes: abrir o formulário, preencher título, classificação e data, salvar e voltar para a lista. A versão declarativa só diz que os filmes existem (`Given the following movies exist:` com uma tabela) e vai direto para a ordenação, que é o comportamento testado. Ela é mais curta e não quebra se o formulário de cadastro mudar.

Os steps ficaram em dois arquivos. Em [web_steps.rb](features/step_definitions/web_steps.rb) estão os passos genéricos de interface (preencher, selecionar, apertar um botão, seguir um link, ver um texto), que viram chamadas do Capybara, e o `I should see "X" before "Y"`, que confere a ordem procurando os dois textos no HTML da página (`page.body`) com uma expressão regular. Em [movie_steps.rb](features/step_definitions/movie_steps.rb) estão os passos do domínio de filmes, como o `the following movies exist`, que cria os filmes direto pelo Active Record, sem passar pela interface.

Gravei um vídeo rodando `bundle exec cucumber` com todos os passos verdes e explicando cada step definition.

## HW3 — BDD e Cucumber

No HW3, escrevi os steps para os cenários de filtro por classificação e de ordenação da lista. Usei os arquivos de feature do repositório da disciplina, [features/filter_movie_list.feature](features/filter_movie_list.feature) e [features/sort_movie_list.feature](features/sort_movie_list.feature), sem alterar os cenários.

Minha aplicação ainda não tinha o filtro por classificação, então comecei por ele. Na listagem, adicionei uma caixa de seleção para cada classificação (com ids `ratings_G`, `ratings_PG` e assim por diante) e o botão "Refresh" (id `ratings_submit`). O controller passou a mostrar só os filmes das classificações marcadas. Para o cenário "no ratings selected" funcionar, o formulário também envia um campo oculto, `ratings_submitted`: sem ele, na primeira visita, aparecem todas as classificações; com ele, aparecem só as marcadas, podendo não aparecer nenhuma. Também renomeei o link de ordenação para "Movie Title", como nos cenários, fiz os links de ordenação manterem o filtro atual e passei a aceitar só `title` e `release_date` como colunas de ordenação.

Os steps novos ficaram em [movie_steps.rb](features/step_definitions/movie_steps.rb). O `I check the following ratings: PG, R` (e a versão com `uncheck`) marca ou desmarca só as caixas listadas, reaproveitando os steps genéricos de `check` e `uncheck`. O `I check all ratings` marca todas. O `I should see all of the movies` conta as linhas da tabela e compara com o total de filmes no banco, em vez de citar cada filme. Para a ordenação, reaproveitei o `I should see "X" before "Y"` do HW BDD.

Durante os testes, a suíte contou 12 filmes onde deveria haver 10: o banco de teste tinha dois registros antigos, deixados por uma execução do Minitest. Criei [features/support/database_cleaner.rb](features/support/database_cleaner.rb), que esvazia o banco antes de o Cucumber começar.

## HW4 — Ciclo BDD+TDD

No HW4, adicionei a busca de filmes do mesmo diretor seguindo o ciclo BDD+TDD: primeiro o cenário do Cucumber falhando, depois os specs do RSpec falhando e só então o código, até os dois ficarem verdes. Continuei no mesmo repositório do HW3.

Comecei pelo setup. Adicionei as gems `rspec-rails`, `simplecov` e `rails-controller-testing` (para usar `assigns` e `render_template` nos specs de controller) e rodei `rails generate rspec:install`. O Cucumber já estava instalado desde o HW BDD. Não usei o `cucumber_rails_training_wheels`, uma gem antiga que só gera um `web_steps.rb`, que eu já tinha. Depois criei uma migration com `add_column :movies, :director, :string`, apliquei com `bin/rails db:migrate` e atualizei o banco de teste com `bin/rails db:test:prepare`.

Copiei os três cenários da disciplina para [features/movies_by_director.feature](features/movies_by_director.feature): adicionar o diretor a um filme existente, encontrar os filmes do mesmo diretor e o sad path de um filme sem diretor. Para os passos de navegação, como `I go to the edit page for "Alien"` e `I should be on the home page`, criei [features/support/paths.rb](features/support/paths.rb), que traduz o nome da página em rota, e três steps genéricos: `I am on`, `I go to` e `I should be on`. Eles substituíram os steps de navegação que eu tinha escrito um por um nos homeworks anteriores. Também criei o step `the director of "X" should be "Y"`, que confere o diretor salvo no banco. Com isso, os cenários passaram a falhar no ponto certo: faltavam o campo Director e o link "Find Movies With Same Director".

Antes de escrever o código, escrevi os specs. Em [spec/models/movie_spec.rb](spec/models/movie_spec.rb), testei que o método do model encontra os filmes do mesmo diretor, não encontra filmes de outros diretores, não inclui o próprio filme e não devolve nada quando o filme não tem diretor. Em [spec/controllers/movies_controller_spec.rb](spec/controllers/movies_controller_spec.rb), testei a ação nova nos dois casos. Com diretor, ela chama o método do model, renderiza a página de filmes semelhantes e entrega os resultados para a view. Sem diretor, ela volta para a lista com o aviso "'Alien' has no director info". Nesses specs, troquei `Movie.find` e o método do model por stubs, para testar o controller isolado da consulta ao banco. Também escrevi specs para criar, editar, excluir e listar filmes e para a busca no TMDb. Na primeira execução, 12 specs falharam, exatamente os do comportamento novo.

Então implementei o mínimo para tudo passar. No model, criei `Movie#others_by_same_director`, que busca os outros filmes com o mesmo diretor e não devolve nenhum quando o diretor está vazio. No controller, criei a ação `similar` e decidi tratar ali o sad path: se o filme não tem diretor, a ação redireciona para a lista com o aviso. Adicionei a rota `GET /movies/:id/similar` com `as: :similar_movie`, que cria o helper `similar_movie_path`, e liberei o campo `director` nos parâmetros aceitos pelo controller. Nas views, adicionei o campo Director ao formulário, o diretor e o link "Find Movies With Same Director" na página do filme, o botão "Update Movie Info" na edição e a página nova [similar.html.haml](app/views/movies/similar.html.haml).

No fim, os 24 specs do RSpec e os 11 cenários do Cucumber (93 passos) passaram. Para medir a cobertura, coloquei `require "simplecov"` e `SimpleCov.start "rails"` no topo de [spec/spec_helper.rb](spec/spec_helper.rb) e de [features/support/env.rb](features/support/env.rb). Rodando `bundle exec rspec` e `bundle exec cucumber` uma vez cada, o SimpleCov junta as duas execuções em `coverage/index.html`. Models e controllers ficaram com 100% de cobertura e o projeto inteiro com 94,2%; os prints do relatório estão no [README.md](README.md#cobertura-de-testes-hw4). Os únicos arquivos sem cobertura são `application_job.rb` e `application_mailer.rb`, classes base do Rails que a aplicação não usa.

Para a entrega, empacotei o código e o relatório em `hw4_rottenpotatoes.tar.gz` e `hw4_simplecov_report.zip`. Não usei o `tar ... *` literal porque ele incluiria o `config/master.key`, a chave das credenciais do Rails, além de logs, arquivos temporários e bancos locais. Empacotei só os arquivos versionados no git e a pasta `coverage/`.
