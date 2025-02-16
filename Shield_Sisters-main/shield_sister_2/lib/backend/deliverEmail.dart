import 'dart:io';

import 'package:flutter_email_sender/flutter_email_sender.dart';

bool isHTML = false;
Future<void> sendMail(double? latitude_data, double? longitude_Data, DateTime time) async {
  final Link location_link = Link("https://www.google.com/maps?q=$latitude_data,$longitude_Data");
  final Email email = Email(
    body: "S.O.S alert triggerred at $location_link",
    subject: "S.O.S triggered",
    recipients: ["manishwalurkar4@gmail.com"],
    attachmentPaths: null,
    isHTML: isHTML,
  );

  String platformResponse;

  try {
    await FlutterEmailSender.send(email);
    platformResponse = 'success';
  } catch (error) {
    print(error);
    platformResponse = error.toString();
  }
}