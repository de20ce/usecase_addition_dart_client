import 'package:grpc/grpc.dart'; // imported from usecase
import 'package:usecase/src/addition.pbgrpc.dart'; // imported from usecase

class AdditionService {
  String serverURL = "2.tcp.eu.ngrok.io";

  AdditionService._internal();

  static final AdditionService _instance = AdditionService._internal();

  factory AdditionService() => _instance;

  static AdditionService get instance => _instance;

  late AdditionClient _additionClient;

  _createChannel() {
    final channel = ClientChannel(
      serverURL,
      port: 14996,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _additionClient = AdditionClient(channel);
  }

  Future<void> init() async {
    _createChannel();
  }

  AdditionClient get additionClient {
    return _additionClient;
  }
}
