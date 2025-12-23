import 'package:clean_architecture/features/connections/data/models/contact.dart';
import 'package:clean_architecture/features/connections/domain/entities/contact.dart';
import 'package:clean_architecture/features/connections/domain/entities/person.dart';

class PersonModel {
  final String personId;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? country;
  final int? genderId;
  final String? parishId;
  final String? birthDate;
  final bool? isDeceased;
  final int professionId;
  final int civilStatus;
  final List<EmailModel?> emails;
  final List<PhoneModel?> phones;

  const PersonModel({
    required this.personId,
    this.firstName,
    this.lastName,
    this.address,
    this.country,
    this.genderId,
    this.parishId,
    this.birthDate,
    this.isDeceased,
    required this.professionId,
    required this.civilStatus,
    required this.emails,
    required this.phones,
  });

  factory PersonModel.fromEntity(PersonEntity entity) {
    return PersonModel(
      personId: entity.personId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      address: entity.address,
      country: entity.country,
      genderId: entity.genderId,
      parishId: entity.parishId,
      birthDate: entity.birthDate,
      isDeceased: entity.isDeceased,
      professionId: entity.professionId,
      civilStatus: entity.civilStatus,
      emails: entity.emails
          .map((e) => e == null ? null : new EmailModel(e.correoid, e.email))
          .toList(),
      phones: entity.phones
          .map((e) => e == null ? null : new PhoneModel(e.telefonoid, e.numero))
          .toList(),
    );
  }

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      personId: json['personId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      country: json['country'] as String? ?? '',
      genderId: json['genderId'] as int? ?? 0,
      parishId: json['parishId'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      isDeceased: json['isDeceased'] as bool? ?? false,
      professionId: json['professionId'] as int? ?? 0,
      civilStatus: json['civilStatus'] as int? ?? 0,
      emails: (json['emails'] as List<dynamic>)
          .map(
            (e) => e == null
                ? null
                : EmailModel(
                    e['correoid'] as int? ?? 0,
                    e['email'] as String? ?? '',
                  ),
          )
          .toList(),
      phones: (json['phones'] as List<dynamic>)
          .map(
            (e) => e == null
                ? null
                : PhoneModel(
                    e['telefonoid'] as int? ?? 0,
                    e['numero'] as String? ?? '',
                  ),
          )
          .toList(),
    );
  }

  static List<PersonModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PersonModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'personId': personId,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'country': country,
      'genderId': genderId,
      'parishId': parishId,
      'birthDate': birthDate,
      'isDeceased': isDeceased,
      'professionId': professionId,
      'civilStatus': civilStatus,
      'emails': emails
          .map(
            (e) =>
                e == null ? null : {'correoid': e.correoid, 'email': e.email},
          )
          .toList(),
      'phones': phones
          .map(
            (e) => e == null
                ? null
                : {'telefonoid': e.telefonoid, 'numero': e.numero},
          )
          .toList(),
    };
  }

  PersonEntity toEntity() {
    return PersonEntity(
      personId: personId,
      firstName: firstName,
      lastName: lastName,
      address: address,
      country: country,
      genderId: genderId,
      parishId: parishId,
      birthDate: birthDate,
      isDeceased: isDeceased,
      professionId: professionId,
      civilStatus: civilStatus,
      emails: emails.map((e) => e?.toEntity()).toList(),
      phones: phones.map((e) => e?.toEntity()).toList(),
    );
  }
}
