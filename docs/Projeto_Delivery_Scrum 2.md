Aqui segue um planejamento das backlogs para os próximos dias de desenvolvimento do projeto delivery.

### Detalhamento dos Épicos em Tarefas

#### **Épico 1: Seleção e Atribuição de Entregas**

1. **História 1.1**: *"Como entregador, quero ver uma lista de lojas próximas para escolher uma encomenda para coleta."*
   
   - **Tarefa 1**: Consultar Firestore para listar lojas próximas (3 pontos)
     - Implementar query para recuperar lojas com coordenadas geográficas próximas do entregador.
     - Utilizar `GeoFlutterFire_Plus` para consulta geoespacial.
   - **Tarefa 2**: Desenvolver a interface de listagem (2 pontos)
     - Criar componente de **listagem** das lojas, incluindo nome, localização, e número de encomendas disponíveis.
     - Testar responsividade e exibição das lojas.
   - **Tarefa 3**: Adicionar lógica de filtragem (2 pontos)
     - Implementar filtro para exibir apenas lojas com encomendas disponíveis para coleta.

2. **História 1.2**: *"Como entregador, quero reservar uma encomenda e atualizar seu status para `orderReservedForPickup`."*
   
   - **Tarefa 1**: Implementar lógica de reserva no Firestore (3 pontos)
     - Utilizar `WriteBatch` para garantir que a encomenda seja reservada de forma atômica.
     - Adicionar os detalhes do entregador ao pedido.
   - **Tarefa 2**: Atualizar ícones de status na interface do entregador (1 ponto)
     - Desenvolver funcionalidade para que o ícone da encomenda mude quando for reservada.
   - **Tarefa 3**: Testar situação de colisão (2 pontos)
     - Testar a lógica para garantir que duas reservas não possam ser feitas simultaneamente.
     - Confirmar que encomendas reservadas ficam invisíveis para outros entregadores.

#### **Épico 2: Fluxo Completo de Entrega**

1. **História 2.1**: *"Como entregador, quero atualizar o status da encomenda para `orderPickedUpForDelivery` após coletá-la."*
   
   - **Tarefa 1**: Desenvolver lógica de atualização no Firestore (2 pontos)
     - Atualizar status da encomenda para `orderPickedUpForDelivery`.
     - Adicionar timestamp (`updatedAt`) para controle da expiração.
   - **Tarefa 2**: Implementar notificação para `manager` e `business` (3 pontos)
     - Configurar notificação via FCM para que os gerentes e comerciantes saibam que o pedido foi coletado.

2. **História 2.2**: *"Como entregador, quero atualizar o status da encomenda enquanto estou em trânsito e após a entrega, para manter o progresso visível."*
   
   - **Tarefa 1**: Implementar mudança de status para `orderInTransit` (2 pontos)
     - Adicionar lógica de transição no Firestore para indicar que o pedido está em trânsito.
   - **Tarefa 2**: Desenvolver funcionalidade de confirmação de entrega (`orderDelivered`) (3 pontos)
     - Criar interface de confirmação onde o entregador possa marcar a entrega como concluída.
     - Registrar assinatura ou foto como confirmação, se necessário.
   - **Tarefa 3**: Testar fluxo completo de coleta e entrega (3 pontos)
     - Realizar testes para garantir que os status mudam corretamente de `orderReservedForPickup` para `orderDelivered`.

#### **Épico 3: Expiração Automática de Reservas**

1. **História 3.1**: *"Como administrador, quero que reservas não coletadas sejam removidas após 5 minutos, para evitar bloqueios de entregas."*
   - **Tarefa 1**: Criar Cloud Function para verificação de expiração (3 pontos)
     - Desenvolver uma função que consulte o Firestore e verifique as reservas com mais de 5 minutos.
   - **Tarefa 2**: Configurar o Cloud Scheduler (2 pontos)
     - Configurar o agendamento da função para ser executada a cada 5 minutos.
   - **Tarefa 3**: Atualizar status das reservas expiradas (2 pontos)
     - Implementar lógica para alterar o status da encomenda de volta para `orderRegisteredForPickup`.
     - Remover o entregador associado à reserva.

#### **Épico 4: Gestão pelo `Manager` e `Business`**

1. **História 4.1**: *"Como `manager`, quero visualizar todas as entregas em andamento e encerrar aquelas concluídas."*
   
   - **Tarefa 1**: Desenvolver dashboard para gerentes (3 pontos)
     - Criar uma interface de visualização com uma lista de todas as entregas em andamento e suas etapas.
   - **Tarefa 2**: Implementar funcionalidade de encerrar entregas (`orderClosed`) (2 pontos)
     - Adicionar lógica para que o `manager` possa alterar o status da entrega para `orderClosed`.
   - **Tarefa 3**: Testar acesso e permissões do `manager` (2 pontos)
     - Garantir que apenas o `manager` ou `admin` possam encerrar entregas.

2. **História 4.2**: *"Como `business`, quero acompanhar o progresso das entregas que saíram da minha loja."*
   
   - **Tarefa 1**: Criar visualização para o comerciante (`business`) (3 pontos)
     - Desenvolver uma interface onde o comerciante possa ver o status das entregas originadas na sua loja.
   - **Tarefa 2**: Adicionar filtros de status na interface do `business` (2 pontos)
     - Implementar filtros para que o comerciante possa visualizar entregas `em andamento`, `entregues` e `pendentes`.

#### **Épico 5: Rastreamento em Tempo Real**

1. **História 5.1**: *"Como cliente, quero acompanhar em tempo real a localização do entregador durante a entrega, para saber quando minha encomenda chegará."*
   - **Tarefa 1**: Utilizar `GeoFlutterFire_Plus` para rastreamento (3 pontos)
     - Integrar `GeoFlutterFire_Plus` para armazenar e consultar a posição dos entregadores.
   - **Tarefa 2**: Desenvolver interface de mapa para o cliente (3 pontos)
     - Criar um componente de mapa que mostre a localização do entregador em tempo real.
   - **Tarefa 3**: Testar funcionalidade de rastreamento (2 pontos)
     - Realizar testes para garantir que a posição é atualizada em tempo real e apresentada corretamente no mapa.

#### **Épico 6: Notificações**

1. **História 6.1**: *"Como entregador e `manager`, quero ser notificado sobre mudanças de status das entregas, para me manter informado sobre o progresso."*
   
   - **Tarefa 1**: Configurar notificações via FCM para o entregador (3 pontos)
     - Enviar notificações para o entregador ao reservar e ao coletar encomendas.
   - **Tarefa 2**: Configurar notificações para o `manager` (2 pontos)
     - Notificar o `manager` quando uma entrega for concluída.

2. **História 6.2**: *"Como cliente, quero receber notificações sobre o status da entrega do meu pedido, para saber quando ele está a caminho e foi entregue."*
   
   - **Tarefa 1**: Configurar notificações para o cliente (2 pontos)
     - Enviar notificações ao cliente para indicar que a entrega está a caminho (`orderInTransit`) e foi concluída (`orderDelivered`).

### Resumo das Tarefas

Cada história de usuário foi dividida em tarefas menores, que são mais fáceis de gerenciar e estimar. Dessa forma, você consegue organizar o trabalho nas sprints de maneira mais granular, garantindo que o progresso seja contínuo e cada funcionalidade seja desenvolvida com qualidade.

Se precisar de mais detalhes sobre alguma tarefa ou se quiser discutir o planejamento das sprints com base nesses backlogs, estou aqui para ajudar!
