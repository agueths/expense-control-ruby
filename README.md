# Gastos Pessoais (Ruby Back-end)

Back-end do sistema de controle de gastos pessoais.

## Requisitos de Sistema

* Ruby 3.3.5
* Biblioteca PostgreSQL

## Técnica de Desenvolvimento

Para que o código do sistema seja de fácil validação e correção, estamos utilizando a técnica de desenvolvimento TDD (_Test Driven Development_).

## Fluxo de Trabalho

### Explicação das branches

* A branch `main` está com o código mais atualizado e possui deploy automático
* Temos a branch `development`, A partir dela são criadas outras branches, onde são desenvolvidas as novas funcionalidades
* A nomenclatura das branches de funcionalidade são `feature-NOME_FUNCIONALIDADE`, ex: `feature-cadastro_compra`
* Em caso de bugs encontrados, é possível abrir branches de correções de bugs
  * Quando o bug está em `development` a nomenclatura da branch deve ser `bugfix-ERRO_ENCONTRADO`, ex: `bugfix-cadastro_compra_nao_identifica_mcc`
  * Quando o bug está em `main`, a nomenclatura da branch deve ser `hotfix-ERRO_ENCONTRADO`, ex: `hotfix-falha_na_conexao_com_bd`

### Fluxo

1. Ter certeza de que está na branch `development` e que ela está atualizada

```
git checkout development
git pull origin development
```

2. Alterar para branch nova

```
git checkout -b NOME_BRANCH
git push --set-upstream origin NOME_BRANCH
```

3. Alterar código para cumprir com o objetivo da branch
4. Salvar as alterações feitas e fazer _commits_ com mensagens explicativas

```
git add [ARQUIVO_INDIVIDUAL || LISTA DE ARQUIVOS]
git commit -m "MENSAGEM EXPLICATIVA"
git push origin NOME_BRANCH
```

5. Criar um Pull Request (PR) para `development` contendo no nome o versionamento:

* `X.X.X`
  * Primeiro X é a versão do sistema
  * Segundo X é o número de funcionalidades implementadas
  * Terceiro X é o número de correções desde a última funcionalidade

6. Após aprovação de (pelo menos) 1 outro programador, realizar o merge

7. Retornar à branch `development` e deletar a branch criada

```
git checkout development
git pull origin development
git branch -d NOME_BRANCH
```

### Git Rebase

Caso você precise de uma funcionalidade que foi para o `development` recentemente, mas não consta na sua branch, você pode fazer um `rebase`.

Digamos que você se depare com o seguinte histórico de branches

```
          A---B---C feature-topic
         /
    D---E---F development
```

e você precise de uma informação que entrou em F para continuar seu desenvolvimento. É possível usar um comando Git chamado `rebase`, com esse comando, seu histórico ficará algo como:

```
              A'--B'--C' feature-topic
             /
    D---E---F development
```

O processo é:

1.

```
git checkout development
git pull origin development
```

2.

```
git checkout SUA_BRANCH
git rebase development
```