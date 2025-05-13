import 'dart:developer';

import 'package:mssql_connection/mssql_connection.dart';

Future boot() async {
  String ip = '10.52.2.236',
      port = '1433',
      username = 'FPGPH',
      password = 'ifrs17',
      databaseName = 'SEA_FPG_PHIL';

  final sqlConnection = MssqlConnection.getInstance();

  if (ip.isEmpty ||
      port.isEmpty ||
      databaseName.isEmpty ||
      username.isEmpty ||
      password.isEmpty) {
    log("Please enter all fields");

    return;
  }
  await sqlConnection
      .connect(
          ip: ip,
          port: port,
          databaseName: databaseName,
          username: username,
          password: password)
      .then((value) {
    if (value) {
      log("Connected");
    } else {
      log("No Connection");
    }
  });
}
