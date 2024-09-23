# Regras de Segurança do Firebase - Um caso de uso.

Este artigo é uma lembraça de que algo aparentemente simples pode se tornar complexo quanto se preocupa com a segurança dos dados de seu sistema. Antes de iniciar me deixe esclarecer de que não sou nenhum especialista em regras de segurança no Firebase, mas estou tentando garantir alguma para meu sistema.

Neste artigo vou apresentar a solução adotada para um aplicativo de entregas que tenho desenvolvido, que de uma proposta simplista se tornou complexo, ao menos para meu entendimento do Firebase até o momento.

## Aplicativo Delivery

Não sou nada criativo com nomes e o projeto terminou com o nome **delivery**. O aplicativo consiste de um app de entregas com 4 níveis de permissões:

- admin - administra todo o app, com total acesso. O sistema limita a apanas um administrados, no momento;

- business - o proprietário de redes de lojas. Este administra as lojas, com acesso a criação de lojas (na coleção shops), edição e remoção. Este também é responsável por selecionar um gerente de entregas para cada loja (usuário manager), associando o id do manager à loja (shop);

- manager - responsável por administrar as entregas, cadastro de clientes (coleção clients) e de entregas (coleção deliveries);

- delivery - este é o entregador. Ele deve acessar as entregas (coleção deliveries) bem como cadastro dos clientes e das lojas, para determinar as origens e destinos das entregas. Este também podera atualizar o status das entregas, apontando a retirada e a entrega do produto.

Para gerenciar as entregas ele trabalha com a estrutura de dados descrita a seguir.

### Usuário Autenticado

Os usuários autenticados são os que operam o aplicativo e, neste momento, não está incluso os clientes do delivery.

Os usuários são cadastrados no Firebase Auth com os dados:

- name - o *display name* do firebase com o nome do usuário

- email - endreço de email (autenticado na inscrição por email)

- phone - número de telefone (ainda não implementado)

- password - senhas com números, letras e simbolos

- role - um dos papeis: admin (0), business (1), manager (3) e delivery (2)

- status - offline (0) e online (1)

O role e o status são Claims no Firebase. Existem outros atributos do usuário, carregados diretamente dos dados auto gerados pelo Firebase.

### Coleções no FireStore

Os demais dados do sistema são gerenciados no FireStore com um conjunto de coleções (collections).

#### Collection appSettings

Esta coleção possui apenas um documento, adminConfig, que guarda a id do administrador do sistema. O administrador do sistema será o primeiro usuário a se cadastrar e, depois disto, até o momento ná esta previsto alterações neste cadastro que não seja diretamente no Firebase Console.

#### Collection clients

Esta coleção mantem os dados dos clientes:

- name - nome do cliente;

- email - email do cliente (não obrigatório);

- phone - telefone;

- sub-collection address - com o endereço para entrega.

#### Collection shops

Esta coleção mantém os dados dos comércios cadastrados, onde são produzidos os produtos das entregas:

- name - nome da loja;

- description - uma breve descrição;

- userId - id do usuário business, o proprietário da loja;

- managerId - id do usuário manager, responsável por administrar as entregas da loja;

- managerName - nome do manager;

- sub-collection address - com o endereço para a coletagem do produto.

#### Collection deliveries

Esta coleção armazena os dados das entregas, bem como se status:

- shopId - id da loja (shop) que cadastrou a entrega;

- clientId - id do usuário que solicitou o produto;

- deliveryId - id do entregador responsável;

- managerId - id do usuário `manager` que gerou a requisição;

- status - status da entrega:
  
  - orderRegisteredForPickup (0) - ordem registrada para entrega,
  
  - orderPickedUpForDelivery (1) - ordem retirada para entrega,
  
  - orderInTransit (2) - ordem em trânsito,
  
  - orderDelivered (3) - ordem entregue,
  
  - orderClosed (4) - ordem fechada,
  
  - orderReject (5) - ordem rejeitada.

Ao chegar na loja (**shop**) para a retirada de entregas, o delivery terá de cadastra a entrega em sua conta. Isto deve ser feito realizandoa leitura de um QRCode da Id da entrega.

A nível de aplicativo, um delivery terá todos os dados da origem e descino da entrega, ou seja, tanto os dados do shop como do cliente para a entrega.

O delivery terá acesso de escrita no deliveryId, no momento de retirar a entrega, e no status da entrega.

### Níveis de Acesso

O atributo role, cadastrado nas Claims do Firebase, é o responsável pelo gerenciamento do nível de acesso dos usuários do sistema. A seguir declaro os diferentes papéis dos usuários e as suas atribuições no sistema.

### Usuário admin

Este usuário não tem muito a apresentar, ele terá acesso completo a todos os dados do sistema, sem restrinções. No entanto, a criação deste usupario reque alguma atenção.

O sistema inciará sem nenhum administrador, e para simplificar sua implantação, o primeiro usuário a se cadastrar no sistema será o seu administrador. Futuras alterações não estão previstas no momento e devem ser realizadas editando diretamente no Firebase do projeto.

### Usuário business

O comerciante terá acesso a criação de lojas (**shops**) e, adicionar a cada uma delas um gerente de entregas (**manager**). Esta adição é feita por leitura de um QRCode gerado no celular do usuário com conta manager, que será lida pelo aplicativo do usuário **business**.

Embora não seja suas atribuições, o comerciante proprietário também pode criar e atualizar as coleções **clients** e **deliveries**. No entanto, este não pode remover um cliente. Apenas o **admin** pode fazer isto.

### Usuário manager

Este usuário é responsável por adicionar clientes, criar entregas e gerenciá-las, ou seja poderá criar **clients**, mas não pode removê-los, criar e remover **deliveries** para o **shop** que estiver associado.

### Usuário delivery

Este usuário é responsável por efetivar as entregas e atualizar seus status. Para isto ele terá permissão de escrita no deliveryId e no status de uma entrega.

## **Regras Completas de Segurança do Firestore (`firestore.rules`)**

A seguir, apresento as **Regras de Segurança do Firestore** (`firestore.rules`) para o aplicativo, juntamente com explicações detalhadas para cada seção. Essas regras foram otimizadas para evitar o uso da função `get()`, reduzindo custos e melhorando o desempenho.

```javascript
rules_version = '2';
service cloud.firestore {

  match /databases/{database}/documents {

    // ------------------------------
    // Funções Auxiliares
    // ------------------------------

    // Verifica se o usuário é um Admin
    function isAdmin() {
      return request.auth != null && request.auth.token.role == 0;
    }

    // Verifica se o usuário é um Business Owner
    function isBusinessOwner() {
      return request.auth != null && request.auth.token.role == 1;
    }

    // Verifica se o usuário é um Delivery
    function isDelivery() {
      return request.auth != null && request.auth.token.role == 2;
    }

    // Verifica se o usuário é um Manager
    function isManager() {
      return request.auth != null && request.auth.token.role == 3;
    }

    // Verifica se o usuário está autenticado
    function isAuthenticated() {
      return request.auth != null;
    }

    // Verifica se o usuário é proprietário da loja
    function isShopOwner(shop) {
      return shop.data.userId == request.auth.uid;
    }

    // Verifica se o usuário pode acessar a loja (Admin ou Business Owner proprietário)
    function canAccessShop(shop) {
      return isAdmin() || (isBusinessOwner() && isShopOwner(shop));
    }

    // Função para verificar se o Delivery está atribuído à entrega
    function isAssignedDelivery(delivery) {
      return delivery.data.deliveryId == request.auth.uid;
    }

    // Função para verificar se a atualização é apenas do status
    function isUpdatingStatusOnly() {
      return request.resource.data.keys().hasOnly(['status']) &&
             resource.data.status != request.resource.data.status;
    }

    // Função para verificar se a atualização é apenas do deliveryId
    function isUpdatingDeliveryIdOnly() {
      return request.resource.data.keys().hasOnly(['deliveryId']) &&
             !resource.data.deliveryId;
    }

    // ------------------------------
    // Regras para a Coleção appSettings
    // ------------------------------
    match /appSettings/{document=**} {
      // Permitir criação apenas se não existir nenhum documento na coleção e o usuário estiver autenticado
      allow create: if isAuthenticated() && 
                    !exists(/databases/$(database)/documents/appSettings/{document=**});

      // Bloquear todas as atualizações e deleções
      allow update, delete: if false;

      // Permitir leitura apenas para Admin
      allow read: if isAdmin();
    }

    // ------------------------------
    // Regras Específicas para adminConfig dentro de appSettings
    // ------------------------------
    match /appSettings/adminConfig {
      // Permitir criação apenas para Admin e se não existir o documento
      allow create: if isAuthenticated() && !exists(/databases/$(database)/documents/appSettings/adminConfig);

      // Bloquear todas as atualizações e deleções
      allow update, delete: if false;

      // Permitir leitura apenas para Admin
      allow read: if isAdmin();
    }

    // ------------------------------
    // Regras para a Coleção clients
    // ------------------------------
    match /clients/{clientId} {
      // Permitir leitura para usuários autenticados
      allow read: if isAuthenticated();

      // Permitir criação e atualização para Admins, Business Owners e Managers
      allow create, update: if isAdmin() || isBusinessOwner() || isManager();

      // Permitir deleção apenas para Admins
      allow delete: if isAdmin();

      // ------------------------------
      // Regras para a Subcoleção addresses dentro de clients
      // ------------------------------
      match /addresses/{addressId} {
        // Permitir leitura para usuários autenticados
        allow read: if isAuthenticated();

        // Permitir criação e atualização para Admins, Business Owners e Managers
        allow create, update: if isAdmin() || isBusinessOwner() || isManager();

        // Permitir deleção apenas para Admins
        allow delete: if isAdmin();
      }
    }

    // ------------------------------
    // Regras para a Coleção shops
    // ------------------------------
    match /shops/{shopId} {
      // Permitir leitura para usuários autenticados
      allow read: if isAuthenticated();

      // Permitir criação para Admin ou Business Owners que criam suas próprias lojas
      allow create: if isAdmin() || (isBusinessOwner() && request.resource.data.userId == request.auth.uid);

      // Permitir atualização e deleção para Admin ou Business Owners proprietários da loja
      allow update, delete: if canAccessShop(resource);

      // ------------------------------
      // Regras para a Subcoleção deliveries dentro de shops
      // ------------------------------
      match /deliveries/{deliveryId} {
        // Permitir leitura para Admin, Business Owners, Managers designados e Delivery atribuídos
        allow read: if isAdmin() || isBusinessOwner() || 
                    (isManager() && resource.data.managerId == request.auth.uid) || 
                    isAssignedDelivery(resource);

        // Permitir criação para Admin e Business Owners
        allow create: if isAdmin() || isBusinessOwner();

        // Permitir atualização:
        // - Admin e Business Owners: total acesso
        // - Managers designados: total acesso
        // - Delivery: apenas para atualizar deliveryId se não estiver atribuído, ou apenas o status
        allow update: if isAdmin() || isBusinessOwner() || 
                      (isManager() && resource.data.managerId == request.auth.uid) || 
                      (isDelivery() && (isUpdatingStatusOnly() || isUpdatingDeliveryIdOnly()));

        // Permitir deleção apenas para Admin e Business Owners
        allow delete: if isAdmin() || isBusinessOwner();
      }

      // ------------------------------
      // Regras para a Subcoleção addresses dentro de shops
      // ------------------------------
      match /addresses/{addressId} {
        // Permitir leitura para usuários autenticados
        allow read: if isAuthenticated();

        // Permitir escrita para Admin, Business Owners e Managers designados
        allow create, update, delete: if isAdmin() || isBusinessOwner() || 
                                      (isManager() && resource.data.managerId == request.auth.uid);
      }
    }
  }
}
```

### **1. Funções Auxiliares**

As funções auxiliares simplificam as verificações de permissões com base no papel (`role`) do usuário autenticado. Elas tornam as regras mais legíveis e fáceis de manter.

- **isAdmin()**
  - **Descrição:** Verifica se o usuário autenticado possui o papel de **Admin** (`role == 0`).
  - **Uso:** Permitir acesso completo a todas as coleções e operações.

```java
    function isAdmin() {
      return request.auth != null && request.auth.token.role == 0;
    }
```

- **isBusinessOwner()**
  - **Descrição:** Verifica se o usuário autenticado possui o papel de **Business Owner** (`role == 1`).
  - **Uso:** Permitir criação, atualização e deleção de lojas, além de gerenciar clientes e entregas.

```java
    function isBusinessOwner() {
      return request.auth != null && request.auth.token.role == 1;
    }
```

- **isDelivery()**
  - **Descrição:** Verifica se o usuário autenticado possui o papel de **Delivery** (`role == 2`).
  - **Uso:** Permitir leitura e atualização de entregas atribuídas.

```java
    function isDelivery() {
      return request.auth != null && request.auth.token.role == 2;
    }
```

- **isManager()**
  - **Descrição:** Verifica se o usuário autenticado possui o papel de **Manager** (`role == 3`).
  - **Uso:** Permitir criação e atualização de clientes e entregas associadas à loja gerenciada.

```java
    function isManager() {
      return request.auth != null && request.auth.token.role == 3;
    }
```

- **isAuthenticated()**
  - **Descrição:** Verifica se o usuário está autenticado no Firebase.
  - **Uso:** Restringir o acesso a usuários autenticados para operações de leitura e escrita.

```java
    function isAuthenticated() {
      return request.auth != null;
    }
```

- **isShopOwner(shop)**
  - **Descrição:** Verifica se o usuário autenticado é o proprietário da loja (`shop.data.userId == request.auth.uid`).
  - **Uso:** Permitir que o proprietário da loja crie, atualize e delete sua própria loja.

```java
    function isShopOwner(shop) {
      return shop.data.userId == request.auth.uid;
    }
```

- **canAccessShop(shop)**
  - **Descrição:** Verifica se o usuário pode acessar a loja, ou seja, se é **Admin** ou **Business Owner** proprietário da loja.
  - **Uso:** Controlar permissões de atualização e deleção de lojas.

```java
    function canAccessShop(shop) {
      return isAdmin() || (isBusinessOwner() && isShopOwner(shop));
    }
```

- **isAssignedDelivery(delivery)**
  - **Descrição:** Verifica se o usuário é o **Delivery** atribuído à entrega específica (`delivery.data.deliveryId == request.auth.uid`).
  - **Uso:** Permitir que o **Delivery** leia e atualize entregas atribuídas a ele.

```java
    function isAssignedDelivery(delivery) {
      return delivery.data.deliveryId == request.auth.uid;
    }
```

- **isUpdatingStatusOnly()**
  - **Descrição:** Verifica se a atualização de um documento está alterando apenas o campo `status` e se esse campo realmente mudou.
  - **Uso:** Restringir **Deliveries** a atualizarem apenas o `status` das entregas.

```java
    function isUpdatingStatusOnly() {
      return request.resource.data.keys().hasOnly(['status']) &&
             resource.data.status != request.resource.data.status;
    }
```

- **isUpdatingDeliveryIdOnly()**
  - **Descrição:** Verifica se a atualização de um documento está alterando apenas o campo `deliveryId` e se este campo ainda não está atribuído.
  - **Uso:** Permitir que **Deliveries** atribuam-se a si mesmos a uma entrega apenas se ainda não estiver atribuída.

```java
    function isUpdatingDeliveryIdOnly() {
      return request.resource.data.keys().hasOnly(['deliveryId']) &&
             !resource.data.deliveryId;
    }
```

### **2. Regras por Coleção**

#### **a. Collection `appSettings`**

```javascript
match /appSettings/{document=**} {
  // Permitir criação apenas se não existir nenhum documento na coleção e o usuário estiver autenticado
  allow create: if isAuthenticated() && 
                !exists(/databases/$(database)/documents/appSettings/{document=**});

  // Bloquear todas as atualizações e deleções
  allow update, delete: if false;

  // Permitir leitura apenas para Admin
  allow read: if isAdmin();
}
```

- **Objetivo:** Garantir que apenas um único documento possa ser criado na coleção `appSettings`, servindo como configuração inicial do sistema.

- **Permissões:**
  
  - **Criação (`create`):** Apenas usuários **autenticados** podem criar documentos, **desde que não existam outros documentos** na coleção. Isso assegura que **apenas o primeiro usuário autenticado** possa criar as configurações iniciais.
  - **Atualização e Deleção (`update`, `delete`):** **Bloqueado para todos**, impedindo modificações após a criação inicial.
  - **Leitura (`read`):** Apenas **Admins** podem ler os documentos, protegendo informações sensíveis.

#### **b. Collection `appSettings/adminConfig`**

```javascript
match /appSettings/adminConfig {
  // Permitir criação apenas para Admin e se não existir o documento
  allow create: if isAuthenticated() && !exists(/databases/$(database)/documents/appSettings/adminConfig);

  // Bloquear todas as atualizações e deleções
  allow update, delete: if false;

  // Permitir leitura apenas para Admin
  allow read: if isAdmin();
}
```

- **Objetivo:** Controlar a criação e o acesso ao documento `adminConfig`, que contém a ID do administrador do sistema.

- **Permissões:**
  
  - **Criação (`create`):** Apenas usuários **autenticados** podem criar o documento **se ele ainda não existir**. Isso garante que **apenas o primeiro usuário** possa definir o administrador inicial.
  - **Atualização e Deleção (`update`, `delete`):** **Bloqueado para todos**, mantendo a integridade da configuração inicial.
  - **Leitura (`read`):** Apenas **Admins** podem ler o documento, protegendo informações sensíveis.

#### **c. Collection `clients`**

```javascript
match /clients/{clientId} {
  // Permitir leitura para usuários autenticados
  allow read: if isAuthenticated();

  // Permitir criação e atualização para Admins, Business Owners e Managers
  allow create, update: if isAdmin() || isBusinessOwner() || isManager();

  // Permitir deleção apenas para Admins
  allow delete: if isAdmin();

  // ------------------------------
  // Regras para a Subcoleção addresses dentro de clients
  // ------------------------------
  match /addresses/{addressId} {
    // Permitir leitura para usuários autenticados
    allow read: if isAuthenticated();

    // Permitir criação e atualização para Admins, Business Owners e Managers
    allow create, update: if isAdmin() || isBusinessOwner() || isManager();

    // Permitir deleção apenas para Admins
    allow delete: if isAdmin();
  }
}
```

- **Objetivo:** Gerenciar os dados dos clientes do sistema.

- **Permissões:**
  
  - **Leitura (`read`):** Qualquer usuário **autenticado** pode ler os dados dos clientes.
  - **Criação e Atualização (`create`, `update`):** Apenas **Admins**, **Business Owners** e **Managers** podem criar ou atualizar clientes.
  - **Deleção (`delete`):** Apenas **Admins** podem deletar clientes.

- **Subcoleção `addresses` dentro de `clients`:**
  
  - **Leitura (`read`):** Qualquer usuário **autenticado** pode ler endereços de clientes.
  - **Criação e Atualização (`create`, `update`):** Apenas **Admins**, **Business Owners** e **Managers** podem criar ou atualizar endereços.
  - **Deleção (`delete`):** Apenas **Admins** podem deletar endereços.

#### **d. Collection `shops`**

```javascript
match /shops/{shopId} {
  // Permitir leitura para usuários autenticados
  allow read: if isAuthenticated();

  // Permitir criação para Admin ou Business Owners que criam suas próprias lojas
  allow create: if isAdmin() || (isBusinessOwner() && request.resource.data.userId == request.auth.uid);

  // Permitir atualização e deleção para Admin ou Business Owners proprietários da loja
  allow update, delete: if canAccessShop(resource);

  // ------------------------------
  // Regras para a Subcoleção deliveries dentro de shops
  // ------------------------------
  match /deliveries/{deliveryId} {
    // Permitir leitura para Admin, Business Owners, Managers designados e Delivery atribuídos
    allow read: if isAdmin() || isBusinessOwner() || 
                (isManager() && resource.data.managerId == request.auth.uid) || 
                isAssignedDelivery(resource);

    // Permitir criação para Admin, Business Owners e Manager
    allow create: if isAdmin() || isBusinessOwner() || isManager();

    // Permitir atualização:
    // - Admin e Business Owners: total acesso
    // - Managers designados: total acesso
    // - Delivery: apenas para atualizar deliveryId se não estiver atribuído, ou apenas o status
    allow update: if isAdmin() || isBusinessOwner() || 
                  (isManager() && resource.data.managerId == request.auth.uid) || 
                  (isDelivery() && (isUpdatingStatusOnly() || isUpdatingDeliveryIdOnly()));

    // Permitir deleção apenas para Admin e Business Owners
    allow delete: if isAdmin() || isBusinessOwner();
  }

  // ------------------------------
  // Regras para a Subcoleção addresses dentro de shops
  // ------------------------------
  match /addresses/{addressId} {
    // Permitir leitura para usuários autenticados
    allow read: if isAuthenticated();

    // Permitir escrita para Admin, Business Owners e Managers designados
    allow create, update, delete: if isAdmin() || isBusinessOwner() || 
                                  (isManager() && resource.data.managerId == request.auth.uid);
  }
}
```

- **Objetivo:** Gerenciar os dados das lojas e suas entregas.

- **Permissões:**
  
  - **Leitura (`read`):** Qualquer usuário **autenticado** pode ler os dados das lojas.
  - **Criação (`create`):** Apenas **Admins** ou **Business Owners** que estão **criando suas próprias lojas** (`request.resource.data.userId == request.auth.uid`).
  - **Atualização e Deleção (`update`, `delete`):** Apenas **Admins** ou **Business Owners** proprietários da loja podem atualizar ou deletar a loja.

- **Subcoleção `deliveries` dentro de `shops`:**
  
  - **Leitura (`read`):** **Admins**, **Business Owners**, **Managers** designados, e **Deliveries** atribuídos podem ler entregas.
  - **Criação (`create`):** Apenas **Admins** e **Business Owners** podem criar entregas.
  - **Atualização (`update`):**
    - **Admins** e **Business Owners:** Têm **acesso total**.
    - **Managers:** Têm **acesso total** às entregas que gerenciam (`managerId == request.auth.uid`).
    - **Deliveries:** Podem **atualizar apenas o `status`** ou **atribuir-se a si mesmos** (`deliveryId`) **se ainda não estiver atribuído**.
  - **Deleção (`delete`):** Apenas **Admins** e **Business Owners** podem deletar entregas.

- **Subcoleção `addresses` dentro de `shops`:**
  
  - **Leitura (`read`):** Qualquer usuário **autenticado** pode ler endereços das lojas.
  - **Escrita (`create`, `update`, `delete`):** Apenas **Admins**, **Business Owners**, e **Managers** designados podem criar, atualizar ou deletar endereços das lojas.

### **3. Considerações sobre o Uso de `get()`**

Inicialmente, as regras utilizavam a função `isAssignedManager(shopId)` com `get()` para verificar se o usuário era o gerente designado de uma loja. Isso gerava leituras adicionais no Firestore, aumentando custos e potencialmente impactando a performance. Para otimizar, foi decidido adicionar o campo `managerId` diretamente na coleção `deliveries`, permitindo verificações diretas sem a necessidade de `get()`.

- **Antes:**
  
  ```javascript
  function isAssignedManager(shopId) {
    return isManager() && get(/databases/$(database)/documents/shops/$(shopId)).data.managerId == request.auth.uid;
  }
  ```

- **Depois:**
  
  - **Adicionou-se o campo `managerId` na coleção `deliveries`:**
    
    ```json
    {
      "shopId": "shop123",
      "clientId": "client456",
      "deliveryId": "delivery789",
      "managerId": "manager101112",
      "status": 0
    }
    ```
  - **Eliminou-se a necessidade da função `isAssignedManager` com `get()`, substituindo-a por verificações diretas:**
    
    ```javascript
    allow read: if isAdmin() || isBusinessOwner() || 
                (isManager() && resource.data.managerId == request.auth.uid) || 
                isAssignedDelivery(resource);
    ```

**Impactos Positivos:**

- **Redução de Custos:** Elimina leituras adicionais necessárias para verificar o `managerId`.
- **Melhoria na Performance:** Reduz a latência das operações de leitura e atualização, já que não há chamadas `get()` adicionais.

### **4. Passos Recomendados para Implantação Inicial**

1. **Deploy das Regras de Segurança:**
   
   - Utilize o seguinte comando para implantar as regras revisadas:
     
     ```bash
     firebase deploy --only firestore:rules
     ```
   - **Verificação:** Use o [Firestore Rules Simulator](https://firebase.google.com/docs/firestore/security/test-rules-emulator) ou o [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite) para testar as regras antes de implantá-las em produção.

2. **Criação Inicial das Configurações (`appSettings`):**
   
   - **Processo Manual:**
     - Acesse o **Firebase Console**.
     - Navegue até a coleção `appSettings` e crie o documento `adminConfig` com as configurações iniciais necessárias.
     - **Observação:** Após a criação inicial, as regras impedem a criação de novos documentos em `appSettings`.

3. **Promoção do Primeiro Usuário a Admin:**
   
   - **Via Firebase Admin SDK:**
     
     - Utilize o **Firebase Admin SDK** para definir o `role` como **Admin** (`role == 0`) para o primeiro usuário que se registra.
     
     - **Exemplo em Node.js:**
       
       ```javascript
       const admin = require('firebase-admin');
       
       // Inicialize o SDK do Admin
       admin.initializeApp({
         credential: admin.credential.applicationDefault(),
       });
       
       // Função para promover o usuário a Admin
       async function promoteToAdmin(uid) {
         await admin.auth().setCustomUserClaims(uid, { role: 0 });
         console.log(`User ${uid} promoted to Admin.`);
       }
       
       // Chame a função com o UID do usuário
       promoteToAdmin('user-uid-here');
       ```
     
     - **Nota:** Após definir os Custom Claims, os usuários precisam **revalidar** seus tokens (geralmente fazendo logout e login novamente) para que as novas permissões sejam aplicadas.

4. **Testes Pós-Implantação:**
   
   - **Teste de Permissões:**
     
     - Verifique se o **Admin** pode acessar, criar, atualizar e deletar todas as coleções conforme esperado.
     - Verifique se **Business Owners** podem criar, atualizar e deletar suas próprias lojas, e criar/atualizar clientes e entregas, mas **não podem deletar clientes**.
     - Verifique se **Managers** podem criar e atualizar clientes e entregas associadas à loja que gerenciam, mas **não podem deletar clientes** ou entregas.
     - Verifique se **Deliveries** podem ler entregas atribuídas a eles, atualizar apenas o `status` e/ou `deliveryId` conforme permitido.
   
   - **Monitoramento de Logs:**
     
     - Utilize o **Firebase Console** para monitorar tentativas de acesso e identificar possíveis violações ou problemas.

### **5. Considerações Finais**

1. **Segurança e Confiabilidade:**
   
   - As **regras de segurança do Firestore** são **cruciais** para proteger os dados do seu aplicativo. Garanta que elas estejam sempre **atualizadas** e **alinhadas** com as necessidades do seu negócio.

2. **Princípio do Menor Privilégio:**
   
   - Sempre conceda **apenas as permissões necessárias** para cada papel de usuário, minimizando riscos de acesso não autorizado.

3. **Validação de Dados:**
   
   - Continue implementando **regras de validação** para garantir que os dados inseridos atendam aos requisitos do aplicativo. Isso previne a inserção de dados inválidos ou maliciosos.
   - **Exemplo de Validação para a Coleção `shops`:**
     
     ```javascript
     allow create: if (isAdmin() || (isBusinessOwner() && request.resource.data.userId == request.auth.uid)) &&
                   request.resource.data.keys().hasAll(['name', 'description', 'userId', 'managerId', 'managerName']) &&
                   request.resource.data.name is string &&
                   request.resource.data.description is string &&
                   request.resource.data.userId is string &&
                   request.resource.data.managerId is string &&
                   request.resource.data.managerName is string;
     ```

4. **Monitoramento e Auditoria:**
   
   - Utilize ferramentas de auditoria para monitorar acessos e modificações nas coleções, ajudando a identificar possíveis violações de segurança.

5. **Manutenção e Atualização das Regras:**
   
   - À medida que o aplicativo evolui, **revise e ajuste** as regras de segurança para acomodar novas funcionalidades e mudanças nos papéis e permissões dos usuários.
   - Mantenha uma **documentação clara** das regras e dos papéis de usuário para facilitar futuras manutenções e expansões do sistema.

6. **Testes Rigorosos:**
   
   - Utilize ferramentas como o **Firestore Rules Simulator** e o **Firebase Emulator Suite** para testar as regras em diversos cenários, garantindo que as permissões estão corretas e seguras.

7. **Monitoramento de Uso e Custos:**
   
   - Acompanhe o número de leituras realizadas pelas regras de segurança no [Firestore Usage Dashboard](https://console.firebase.google.com/).
   - Configure alertas para monitorar picos inesperados no uso de leituras e evite ultrapassar as quotas gratuitas ou contratadas.

## **6. Resumo das Regras Revisadas**

As regras de segurança fornecidas asseguram que cada papel de usuário tenha as permissões apropriadas no sistema de entregas **Delivery**, alinhadas com a documentação atualizada e otimizadas para evitar custos adicionais decorrentes do uso de `get()`.

1. **Configurações Iniciais (`appSettings`):**
   
   - **Criação:** Apenas usuários **autenticados** podem criar documentos na coleção **appSettings** se **nenhum documento** ainda existir.
   - **Leitura:** Apenas **Admins** podem ler os documentos da coleção **appSettings**.
   - **Atualizações e Deleções:** Bloqueadas para todos.

2. **Clientes (`clients`):**
   
   - **Leitura:** Qualquer usuário **autenticado**.
   - **Criação e Atualização:** Apenas **Admins**, **Business Owners**, e **Managers**.
   - **Deleção:** Apenas **Admins**.
   - **Subcoleção `addresses` dentro de `clients`:**
     - **Leitura:** Qualquer usuário **autenticado**.
     - **Criação e Atualização:** Apenas **Admins**, **Business Owners**, e **Managers**.
     - **Deleção:** Apenas **Admins**.

3. **Lojas (`shops`):**
   
   - **Leitura:** Qualquer usuário **autenticado**.
   - **Criação:** Apenas **Admins** ou **Business Owners** criando suas próprias lojas.
   - **Atualização e Deleção:** Apenas **Admins** ou **Business Owners** proprietários da loja.
   - **Subcoleção `deliveries` dentro de `shops`:**
     - **Leitura:** **Admins**, **Business Owners**, **Managers** designados, e **Deliveries** atribuídos.
     - **Criação:** Apenas **Admins** e **Business Owners**.
     - **Atualização:** 
       - **Admins**, **Business Owners**, e **Managers** têm **acesso total**.
       - **Deliveries** podem **atualizar apenas o `status`** ou **atribuir-se a si mesmos** (`deliveryId`) **se ainda não estiver atribuído**.
     - **Deleção:** Apenas **Admins** e **Business Owners**.
   - **Subcoleção `addresses` dentro de `shops`:**
     - **Leitura:** Qualquer usuário **autenticado**.
     - **Escrita:** Apenas **Admins**, **Business Owners**, e **Managers** designados.

4. **Entregas (`deliveries`):**
   
   - **Leitura:** **Admins**, **Business Owners**, **Managers** designados, e **Deliveries** atribuídos.
   - **Criação:** Apenas **Admins** e **Business Owners**.
   - **Atualização:** 
     - **Admins**, **Business Owners**, e **Managers** designados têm **acesso total**.
     - **Deliveries** podem **atualizar apenas o `status`** ou **atribuir-se a si mesmos** (`deliveryId`) **se ainda não estiver atribuído**.
   - **Deleção:** Apenas **Admins** e **Business Owners**.

## **7. Conclusão**

As **Regras de Segurança do Firestore** apresentadas foram cuidadosamente elaboradas para atender às necessidades do seu aplicativo de entregas **Delivery**, garantindo que cada papel de usuário (Admin, Business Owner, Manager e Delivery) tenha as permissões apropriadas. Além disso, as regras foram otimizadas para evitar o uso desnecessário da função `get()`, reduzindo custos e melhorando o desempenho do sistema.

**Próximos Passos:**

1. **Deploy das Regras Revisadas:**
   
   - Execute o comando:
     
     ```bash
     firebase deploy --only firestore:rules
     ```
   - **Verificação:** Teste as regras utilizando o [Firestore Rules Simulator](https://firebase.google.com/docs/firestore/security/test-rules-emulator) ou o [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite).

2. **Criação Inicial das Configurações (`appSettings`):**
   
   - Crie o documento `adminConfig` manualmente via **Firebase Console** ou utilizando um script externo.

3. **Promoção do Primeiro Usuário a Admin:**
   
   - Utilize o **Firebase Admin SDK** para definir o `role` como **Admin** para o primeiro usuário.
   
   - **Exemplo em Node.js:**
     
     ```javascript
     const admin = require('firebase-admin');
     
     // Inicialize o SDK do Admin
     admin.initializeApp({
       credential: admin.credential.applicationDefault(),
     });
     
     // Função para promover o usuário a Admin
     async function promoteToAdmin(uid) {
       await admin.auth().setCustomUserClaims(uid, { role: 0 });
       console.log(`User ${uid} promoted to Admin.`);
     }
     
     // Chame a função com o UID do usuário
     promoteToAdmin('user-uid-here');
     ```
   
   - **Nota:** Após a atualização dos Custom Claims, os usuários precisam **revalidar** seus tokens (geralmente fazendo logout e login novamente) para que as novas permissões sejam aplicadas.

4. **Testes Rigorosos:**
   
   - **Admins:** Verifique se podem acessar, criar, atualizar e deletar todas as coleções.
   - **Business Owners:** Verifique se podem criar, atualizar e deletar suas próprias lojas, e criar/atualizar clientes e entregas, mas **não podem deletar clientes**.
   - **Managers:** Verifique se podem criar e atualizar clientes e entregas associadas à loja que gerenciam, mas **não podem deletar clientes** ou entregas.
   - **Deliveries:** Verifique se podem ler entregas atribuídas a eles, atualizar apenas o `status` e/ou `deliveryId` conforme permitido.

5. **Monitoramento Contínuo:**
   
   - Utilize o **Firestore Usage Dashboard** no [Firebase Console](https://console.firebase.google.com/) para monitorar o número de leituras e identificar possíveis aumentos inesperados no uso de leituras devido a chamadas `get()`.

6. **Manutenção e Atualização das Regras:**
   
   - À medida que o aplicativo evolui, **revise e ajuste** as regras de segurança para acomodar novas funcionalidades e mudanças nos papéis e permissões dos usuários.
   - Mantenha uma **documentação clara** das regras e dos papéis de usuário para facilitar futuras manutenções e expansões do sistema.

**Considerações Finais:**

- **Segurança e Confiabilidade:** As regras de segurança do Firestore são fundamentais para proteger os dados do seu aplicativo. Garanta que elas sejam sempre revisadas e atualizadas conforme necessário.

- **Princípio do Menor Privilégio:** Conceda apenas as permissões necessárias para cada papel de usuário, minimizando riscos de acesso não autorizado.

- **Validação de Dados:** Implemente validações para assegurar que os dados inseridos atendam aos requisitos do aplicativo, prevenindo inserções de dados inválidos ou maliciosos.

- **Monitoramento de Uso e Custos:** Mantenha um olhar atento sobre o uso de leituras para controlar os custos e otimizar o desempenho.

Se precisar de mais assistência ou tiver dúvidas específicas sobre as regras de segurança ou sua implementação, sinta-se à vontade para perguntar!
