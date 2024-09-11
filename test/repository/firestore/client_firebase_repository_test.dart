import 'package:delivery/common/models/address.dart';
import 'package:delivery/common/models/client.dart';
import 'package:delivery/firebase_options.dart';
import 'package:delivery/repository/firebase_store/client_firebase_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); // Inicializa o Firebase

    // Configura o Firestore para usar o emulador local
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080', // Porta do emulador de Firestore para operações
      sslEnabled: false,
      persistenceEnabled: false,
    );
  });

  test('Testando Firestore no emulador', () async {
    final collectionRef =
        FirebaseFirestore.instance.collection('testCollection');
    await collectionRef.add({'testField': 'testValue'});

    final snapshot = await collectionRef.get();
    expect(snapshot.docs.isNotEmpty, isTrue);
  });

  test('Adicionar e buscar cliente com sucesso', () async {
    final repository = ClientFirebaseRepository();

    // Criar um cliente para teste
    final client = ClientModel(
      name: 'Test Client',
      email: 'test@example.com',
      phone: '123456789',
      address: AddressModel(
        zipCode: '12345',
        street: 'Test Street',
        number: '100',
        neighborhood: 'Test Neighborhood',
        state: 'Test State',
        city: 'Test City',
      ),
    );

    // Adicionar cliente no Firestore
    final result = await repository.add(client);

    // Verificar se o cliente foi adicionado com sucesso
    expect(result.isSuccess, isTrue);
    expect(result.data?.id, isNotNull);

    // Buscar cliente pelo ID
    final fetchedClientResult = await repository.get(result.data!.id!);
    expect(fetchedClientResult.isSuccess, isTrue);
    expect(fetchedClientResult.data?.name, 'Test Client');
    expect(fetchedClientResult.data?.phone, '123456789');
  });

  test('Atualizar cliente e verificar alterações', () async {
    final repository = ClientFirebaseRepository();

    // Adicionar cliente para atualização
    final client = ClientModel(
      name: 'Test Client',
      phone: '123456789',
      address: AddressModel(
        zipCode: '12345',
        street: 'Old Street',
        number: '50',
        neighborhood: 'Old Neighborhood',
        state: 'Old State',
        city: 'Old City',
      ),
    );

    final result = await repository.add(client);

    // Atualizar o endereço do cliente
    final updatedClient = client.copyWith(
      address: AddressModel(
        zipCode: '54321',
        street: 'New Street',
        number: '150',
        neighborhood: 'New Neighborhood',
        state: 'New State',
        city: 'New City',
      ),
    );

    final updateResult = await repository.update(updatedClient);

    // Verificar se o cliente foi atualizado corretamente
    expect(updateResult.isSuccess, isTrue);

    final fetchedClientResult = await repository.get(result.data!.id!);
    expect(fetchedClientResult.isSuccess, isTrue);
    expect(fetchedClientResult.data?.address?.street, 'New Street');
  });

  test('Deletar cliente e verificar exclusão', () async {
    final repository = ClientFirebaseRepository();

    // Adicionar cliente para ser deletado
    final client = ClientModel(
      name: 'Test Client to Delete',
      phone: '123456789',
      address: AddressModel(
        zipCode: '12345',
        street: 'Test Street',
        number: '100',
        neighborhood: 'Test Neighborhood',
        state: 'Test State',
        city: 'Test City',
      ),
    );

    final result = await repository.add(client);

    // Deletar cliente
    final deleteResult = await repository.delete(result.data!.id!);
    expect(deleteResult.isSuccess, isTrue);

    // Tentar buscar o cliente deletado
    final fetchedClientResult = await repository.get(result.data!.id!);
    expect(fetchedClientResult.isFailure, isTrue);
  });
}
