// To parse this JSON data, do
//
//     final tache = tacheFromJson(jsonString);

import 'dart:convert';

Tache tacheFromJson(String str) => Tache.fromJson(json.decode(str));

String tacheToJson(Tache data) => json.encode(data.toJson());

class Tache {
  Tache({
    required this.idAm,
    required this.nom,
    required this.prenom,
    required this.numeroTelephone,
    required this.motDePasse,
    required this.email,
    required this.photoAm,
    required this.idTache,
    required this.objet,
    required this.descriptif,
    required this.etat,
    required this.dateDebut,
    required this.dateFin,
  });

  String idAm;
  String nom;
  String prenom;
  String numeroTelephone;
  String motDePasse;
  String email;
  String photoAm;
  int idTache;
  String objet;
  String descriptif;
  String etat;
  DateTime dateDebut;
  DateTime dateFin;

  factory Tache.fromJson(Map<String, dynamic> json) => Tache(
    idAm: json["id_am"],
    nom: json["nom"],
    prenom: json["prenom"],
    numeroTelephone: json["numero_telephone"],
    motDePasse: json["mot_de_passe"],
    email: json["email"],
    photoAm: json["photo_am"],
    idTache: json["id_tache"],
    objet: json["objet"],
    descriptif: json["descriptif"],
    etat: json["etat"],
    dateDebut: DateTime.parse(json["date_debut"]),
    dateFin: DateTime.parse(json["date_fin"]),
  );

  Map<String, dynamic> toJson() => {
    "id_am": idAm,
    "nom": nom,
    "prenom": prenom,
    "numero_telephone": numeroTelephone,
    "mot_de_passe": motDePasse,
    "email": email,
    "photo_am": photoAm,
    "id_tache": idTache,
    "objet": objet,
    "descriptif": descriptif,
    "etat": etat,
    "date_debut": dateDebut.toIso8601String(),
    "date_fin": dateFin.toIso8601String(),
  };
}
