#  Calabash-android x Appium android

## Quem tem a melhor performance em execução ?

Ao invés de falar melhor mostrar, esse projeto tem como objetivo 
criar um repositorio com calabash android e nesse <a href="https://github.com/danilopolicarpos/Appium-android">Appium Android</a>
para medir-mos a performance dos dois.

## Criando o projeto

    Na pasta do projeto digito o comando:
```
bundle init         # cria o arquivo GEMFILE
```

## Gemfile

Abra o arquivo Gemfile e adicione as gems:
source "https://rubygems.org"
```
# gem "rails"
gem 'calabash-common', '~> 0.0.2'
gem 'calabash-android', '~> 0.9.0'
gem 'calabash-cucumber', '~> 0.20.5'
gem 'pry'
```

Abra o terminal e execute os comandos abaixo :
```
bundle install      
```

## Gerar o esqueleto do projeto
    
Para começar com o calabash na pasta atual digito o comando:
```
calabash-android gen  # cria o esqueleto do projeto

features
|_support
| |_app_installation_hooks.rb
| |_app_life_cycle_hooks.rb
| |_env.rb
| |_hooks.rb
|_step_definitions
| |_calabash_steps.rb
|_my_first.feature
|_app-debug.apk
|_Gemfile
|_Gemfile.lock
```
## Assinar o apk

Há duas formas para assinar o apk:
- Chave debug
- Chave de distribuição

Vamos assinar com a chave debug(mais utilizada) para poder executar os testes e gerar os snippet.
```
bundle exec calabash-android resign app-debug.apk
```

## Inspecionando elementos

Para inspecionar os elementos no calabash-android na pasta atual digito o comando:
```
bundle exec calabash-android console app-debug.apk
```
alguns comando utilizados:
```
reinstall_apps                          # reinstala o app
start_test_server_in_background         # inicia o app
query"*"                                # exibe todos os elementos da tela
query"*",:class                         # exibe elementos tipo class na tela
query"*",:id                            # exibe elementos tipo id na tela
query"*",:text                          # exibe elementos tipo text na tela
query"*",:contentDescription            # exibe elementos tipo contDesc na tela
```
## Executando os testes

Para executar os testes para basta digitar os comandos abaixo:
```
bundle exec calabash-android run app-debug.apk
```

Para executar os testes passando uma feature desejada:
```
bundle exec calabash-android run app-debug.apk features/nome da feature
```


## Respostas

Respondendo então pergunta do tópico. "Até o momento a execução dos testes
com o calabash android é bem mais rápida do que o appium android".Se ficou 
curiosa é só olhar o "reports" nos repositorios e verificar o time.





