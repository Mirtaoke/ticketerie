class TicketModel {
  String id;
  String userId;
  String eventId;
  DateTime dateAchat;
  bool estValide;

  TicketModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.dateAchat,
    required this.estValide,
  });
}
