class EventModel {
  String id;
  String titre;
  String description;
  DateTime dateDebut;
  DateTime dateFin;
  int nombreMaxParticipants;
  List<String> participants;
  String createdBy; 
  String statutEvenement;
  String statutParticipants; 

  EventModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.dateDebut,
    required this.dateFin,
    required this.nombreMaxParticipants,
    required this.participants,
    required this.createdBy,
  })  :
    statutEvenement = _determinerStatutEvenement(dateFin),
    statutParticipants = _determinerStatutParticipants(nombreMaxParticipants, participants);

  static String _determinerStatutEvenement(DateTime dateFin) {
    return DateTime.now().isAfter(dateFin) ? "Expiré" : "Actif";
  }

  static String _determinerStatutParticipants(int maxParticipants, List<String> participants) {
    return participants.length >= maxParticipants ? "Complet" : "Non complet";
  }

 
}
