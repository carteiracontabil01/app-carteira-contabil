import '/flutter_flow/flutter_flow_util.dart';
import 'tickets_widget.dart' show TicketsWidget;
import 'package:flutter/material.dart';

class TicketsModel extends FlutterFlowModel<TicketsWidget> {
  ///  Local state fields for this page.

  List<Map<String, dynamic>> tickets = [];
  void addToTickets(Map<String, dynamic> item) => tickets.add(item);
  void removeFromTickets(Map<String, dynamic> item) => tickets.remove(item);
  void removeAtIndexFromTickets(int index) => tickets.removeAt(index);
  void insertAtIndexInTickets(int index, Map<String, dynamic> item) =>
      tickets.insert(index, item);
  void updateTicketsAtIndex(
          int index, Function(Map<String, dynamic>) updateFn) =>
      tickets[index] = updateFn(tickets[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
