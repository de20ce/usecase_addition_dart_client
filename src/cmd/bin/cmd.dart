//import 'package:cmd/cmd.dart' as cmd;
//import 'package:args/args.dart';
import 'package:cmd/cmd.dart';

void main(List<String> args) async {
  /*
  // Unary RPC call received argument from command line
  // I assume you are repo src/c;d from root directory
  // $ art run bin/cmd.dart --vara 10 --varb 20
  var parser = ArgParser();
  parser.addFlag('vara', negatable: false);
  parser.addFlag('varb', negatable: false);

  final results = parser.parse(args);

  final variables = results.rest.map((e) => int.parse(e)).toList();

  try {
    final response = await cmd.process(variables.first, variables.last);
    print('Greeter client received: $response');
  } catch (e) {
    print('Caught error: $e');
  }*/

  await Client().main(args);
}
