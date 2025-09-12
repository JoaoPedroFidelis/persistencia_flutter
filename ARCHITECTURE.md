# Arquitetura
O projeto segue o modelo de arquitetura **MVC (Model-View-Controller)**, sendo organizada em três camadas principais, sendo elas:

- **Model (Domain + Repository):** Representa as entidades de negócio e a persistência dos dados.  
- **View:** Responsável pela interface gráfica e interação com o usuário.  
- **Controller:** Atua como intermediário, recebendo ações da View, aplicando regras de negócio e coordenando chamadas ao Model.  

Essa divisão em camadas garante uma separação de responsabilidades bem definida, o que traz benefícios como maior modularidade, facilidade para realizar testes unitários e de integração além de tornar o código mais simples de manter e evoluir ao longo do tempo.

</br>

# Camadas
### Estrutura de Pastas
```
> lib
    > controller/   # Lógica interna [Controller]
        > FormController.dart
        > PessoaController.dart
    > domain/       # Entidades/Estruturas de Dados [Model]
        > DbTable.dart
        > Pessoa.dart
    > repository/   # Persistência de banco de dados [Model]
        > DatabaseInitializer.dart
        > PessoaRepository.dart
        > TableRepository.dart
    > view/         # Interface e UI [View]
        > pessoas_page.dart
        > main.dart
```


### 1. **Domain**
- Define as entidades centrais do sistema (`Pessoa`, `DbTable`).  
- Representa apenas **dados e campos de tabela**, sem lógica de persistência.

### 2. **Repository**
- Camada de acesso a dados.  
- `DatabaseInitializer` cuida da configuração inicial do banco.  
- `PessoaRepository` implementa operações específicas para a entidade `Pessoa`.  
- `TableRepository` define operações genéricas para tabelas.
- Depende do **Domain**, pois precisa conhecer as entidades que persiste.

### 3. **Controller**
- Coordena a comunicação entre **View** e **Model**.  
- Contém a lógica de aplicação, como validações e chamadas a repositórios.  
- Exemplo: `PessoaController` controla regras relacionadas à entidade `Pessoa`.  

### 4. **View**
- Camada responsável pela interface gráfica.  
- Usa Widgets Flutter (`pessoas_page.dart`, `main.dart`).  
- Se comunica apenas com os **Controllers**, nunca diretamente com o **Repository**.  
- Depende do **Controller** para obter e manipular dados.  


## Dependências entre camadas

> **Fluxo:** View > Controller > Repository > Domain  

- **View > Controller:** A View depende do Controller para interpretar ações do usuário e aplicar lógica de aplicação.  
- **Controller > Repository:** O Controller depende do Repository para buscar, salvar ou atualizar dados sem conhecer os detalhes da persistência.  
- **Repository > Domain:** O Repository depende do Domain para estruturar os dados em entidades de negócio consistentes.  
- **Domain:** O Domain é independente, servindo como núcleo estável da aplicação, livre de detalhes de interface ou persistência.  


## Fluxo de Dados (MVC)

1. **Usuário interage com a View:** ações como cliques ou preenchimento de formulário.  
2. **View chama o Controller:** informando a ação do usuário.  
3. **Controller aplica lógica de negócio:** validações e orquestra chamadas.  
4. **Controller acessa o Repository:** consulta ou persiste dados.  
5. **Repository retorna entidades do Domain:** para o Controller.  
6. **Controller entrega dados processados à View:** para atualização da interface.  

</br>

# Trade-offs

### **Vantagens**
- Separação clara de responsabilidades.  
- Maior testabilidade (Controller e Repository podem ser testados isoladamente).  
- Facilidade de manutenção e evolução do código.  
- Camadas independentes reduzem acoplamento.  

### **Desvantagens**
- Estrutura mais verbosa para projetos pequenos.  
- Pode gerar código boilerplate (Controllers e Repositories extras).  
- Maior curva de aprendizado para novos desenvolvedores no time.  
- Dependência indireta entre camadas pode dificultar mudanças rápidas.  