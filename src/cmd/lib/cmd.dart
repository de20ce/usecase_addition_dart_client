import 'package:usecase/usecase.dart';

int calculate(int a, int b) {
  return a + b;
}

// To test only the unary op
// Its main file is in src/cmd/bin
Future<int> process(int a, int b) async {
  final channel = ClientChannel(
    '2.tcp.eu.ngrok.io',
    port: 10283,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );

  final stub = AdditionClient(channel);

  var req = AdditionRequest(a: a, b: b);

  final response = await stub.add(req);

  channel.shutdown();

  return response.result;
}

class Client {
  late AdditionClient stub;

  Future<void> main(List<String> args) async {
    final channel = ClientChannel(
      '2.tcp.eu.ngrok.io',
      port: 10283,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    stub = AdditionClient(
      channel,
      options: CallOptions(timeout: Duration(seconds: 30)),
    );

    try {
      await runAdd();
      await runAddChat();
    } catch (e) {
      print("Caught: $e");
    }

    await channel.shutdown();
  }

  Future<void> runAdd() async {
    var req = AdditionRequest(a: 2, b: 65);

    final response = await stub.add(req);

    print('result ${response.result}');
  }

  Future<void> runAddChat() async {
    AdditionRequest createAddition(int a, int b) {
      return AdditionRequest()
        ..a = a
        ..b = b;
    }

    final addRequests = <AdditionRequest>[
      createAddition(30, 20),
      createAddition(120, 250),
      createAddition(1200, 5603),
      createAddition(300, 67),
      createAddition(5, 58),
    ];

    Stream<AdditionRequest> outgoingAddReqs() async* {
      for (final addRequest in addRequests) {
        // short delay to simulate some interaction
        await Future.delayed(Duration(milliseconds: 10));

        print(
            'Sending Addition Op Data a = ${addRequest.a} and b = ${addRequest.b}');
        yield addRequest;
      }
    }

    final call = stub.addChat(outgoingAddReqs());
    await for (var addReq in call) {
      print(' stream Result got: ${addReq.result}');
    }
  }
}
