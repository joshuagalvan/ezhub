import 'dart:developer';

import 'package:mysql1/mysql1.dart';

class mySQL {
  Future<MySqlConnection> connect() async {
    log("Connecting to mysql server...");

    //create connection

    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: "10.52.2.124",
      port: 3306,
      user: "root",
      password: "Sys@dmin_uat",
      db: "ezhub",
    ));

    log('$conn');
    return conn;
  }
}
