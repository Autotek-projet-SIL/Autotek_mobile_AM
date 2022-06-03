// To parse this JSON data, do
//
//     final tache = tacheFromJson(jsonString);

import 'dart:convert';

Tache tacheFromJson(String str) => Tache.fromJson(json.decode(str));

String tacheToJson(Tache data) => json.encode(data.toJson());

class Tache {
  Tache({
    required this.idTache,
    required this.objet,
    required this.descriptif,
    required this.etat,
    required this.dateDebut,
    required this.dateFin,
    required this.idAm,
    required this.etatAvancement,
    required this.typeTache,
  });

  int idTache;
  String objet;
  String descriptif;
  String etat;
  DateTime dateDebut;
  DateTime dateFin;
  String idAm;
  int etatAvancement;
  String typeTache;

  factory Tache.fromJson(Map<String, dynamic> json) => Tache(
    idTache: json["id_tache"],
    objet: json["objet"],
    descriptif: json["descriptif"],
    etat: json["etat"],
    dateDebut: DateTime.parse(json["date_debut"]),
    dateFin: DateTime.parse(json["date_fin"]),
    idAm: json["id_am"],
    etatAvancement: json["etat_avancement"],
    typeTache: json["type_tache"],
  );

  Map<String, dynamic> toJson() => {
    "id_tache": idTache,
    "objet": objet,
    "descriptif": descriptif,
    "etat": etat,
    "date_debut": dateDebut.toIso8601String(),
    "date_fin": dateFin.toIso8601String(),
    "id_am": idAm,
    "etat_avancement": etatAvancement,
    "type_tache": typeTache,
  };
}
