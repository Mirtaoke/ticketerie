class UserModel {
  String id;
  String nom;
  String prenom;
  String email;
  List<String> evenementsParticipes; 

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.evenementsParticipes,
  });

  void participerEvenement(String evenementId) {
    if (!evenementsParticipes.contains(evenementId)) {
      evenementsParticipes.add(evenementId);
    }
  }

  void annulerParticipation(String evenementId) {
    evenementsParticipes.remove(evenementId);
  }
}
