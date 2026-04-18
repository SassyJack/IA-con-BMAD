// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_consent.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLegalConsentCollection on Isar {
  IsarCollection<LegalConsent> get legalConsents => this.collection();
}

const LegalConsentSchema = CollectionSchema(
  name: r'LegalConsent',
  id: 7293711776162156509,
  properties: {
    r'acceptedAt': PropertySchema(
      id: 0,
      name: r'acceptedAt',
      type: IsarType.dateTime,
    ),
    r'isAccepted': PropertySchema(
      id: 1,
      name: r'isAccepted',
      type: IsarType.bool,
    )
  },
  estimateSize: _legalConsentEstimateSize,
  serialize: _legalConsentSerialize,
  deserialize: _legalConsentDeserialize,
  deserializeProp: _legalConsentDeserializeProp,
  idName: r'id',
  indexes: {
    r'isAccepted': IndexSchema(
      id: -3674077785089502193,
      name: r'isAccepted',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'isAccepted',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _legalConsentGetId,
  getLinks: _legalConsentGetLinks,
  attach: _legalConsentAttach,
  version: '3.1.0+1',
);

int _legalConsentEstimateSize(
  LegalConsent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _legalConsentSerialize(
  LegalConsent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.acceptedAt);
  writer.writeBool(offsets[1], object.isAccepted);
}

LegalConsent _legalConsentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LegalConsent();
  object.acceptedAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isAccepted = reader.readBool(offsets[1]);
  return object;
}

P _legalConsentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _legalConsentGetId(LegalConsent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _legalConsentGetLinks(LegalConsent object) {
  return [];
}

void _legalConsentAttach(
    IsarCollection<dynamic> col, Id id, LegalConsent object) {
  object.id = id;
}

extension LegalConsentByIndex on IsarCollection<LegalConsent> {
  Future<LegalConsent?> getByIsAccepted(bool isAccepted) {
    return getByIndex(r'isAccepted', [isAccepted]);
  }

  LegalConsent? getByIsAcceptedSync(bool isAccepted) {
    return getByIndexSync(r'isAccepted', [isAccepted]);
  }

  Future<bool> deleteByIsAccepted(bool isAccepted) {
    return deleteByIndex(r'isAccepted', [isAccepted]);
  }

  bool deleteByIsAcceptedSync(bool isAccepted) {
    return deleteByIndexSync(r'isAccepted', [isAccepted]);
  }

  Future<List<LegalConsent?>> getAllByIsAccepted(List<bool> isAcceptedValues) {
    final values = isAcceptedValues.map((e) => [e]).toList();
    return getAllByIndex(r'isAccepted', values);
  }

  List<LegalConsent?> getAllByIsAcceptedSync(List<bool> isAcceptedValues) {
    final values = isAcceptedValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'isAccepted', values);
  }

  Future<int> deleteAllByIsAccepted(List<bool> isAcceptedValues) {
    final values = isAcceptedValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'isAccepted', values);
  }

  int deleteAllByIsAcceptedSync(List<bool> isAcceptedValues) {
    final values = isAcceptedValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'isAccepted', values);
  }

  Future<Id> putByIsAccepted(LegalConsent object) {
    return putByIndex(r'isAccepted', object);
  }

  Id putByIsAcceptedSync(LegalConsent object, {bool saveLinks = true}) {
    return putByIndexSync(r'isAccepted', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIsAccepted(List<LegalConsent> objects) {
    return putAllByIndex(r'isAccepted', objects);
  }

  List<Id> putAllByIsAcceptedSync(List<LegalConsent> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'isAccepted', objects, saveLinks: saveLinks);
  }
}

extension LegalConsentQueryWhereSort
    on QueryBuilder<LegalConsent, LegalConsent, QWhere> {
  QueryBuilder<LegalConsent, LegalConsent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterWhere> anyIsAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isAccepted'),
      );
    });
  }
}

extension LegalConsentQueryWhere
    on QueryBuilder<LegalConsent, LegalConsent, QWhereClause> {
  QueryBuilder<LegalConsent, LegalConsent, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterWhereClause> isAcceptedEqualTo(
      bool isAccepted) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isAccepted',
        value: [isAccepted],
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterWhereClause>
      isAcceptedNotEqualTo(bool isAccepted) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAccepted',
              lower: [],
              upper: [isAccepted],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAccepted',
              lower: [isAccepted],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAccepted',
              lower: [isAccepted],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAccepted',
              lower: [],
              upper: [isAccepted],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LegalConsentQueryFilter
    on QueryBuilder<LegalConsent, LegalConsent, QFilterCondition> {
  QueryBuilder<LegalConsent, LegalConsent, QAfterFilterCondition>
      acceptedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'acceptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterFilterCondition>
      acceptedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'acceptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterFilterCondition>
      acceptedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'acceptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterFilterCondition>
      acceptedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'acceptedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterFilterCondition>
      isAcceptedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAccepted',
        value: value,
      ));
    });
  }
}

extension LegalConsentQueryObject
    on QueryBuilder<LegalConsent, LegalConsent, QFilterCondition> {}

extension LegalConsentQueryLinks
    on QueryBuilder<LegalConsent, LegalConsent, QFilterCondition> {}

extension LegalConsentQuerySortBy
    on QueryBuilder<LegalConsent, LegalConsent, QSortBy> {
  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy> sortByAcceptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acceptedAt', Sort.asc);
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy>
      sortByAcceptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acceptedAt', Sort.desc);
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy> sortByIsAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAccepted', Sort.asc);
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy>
      sortByIsAcceptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAccepted', Sort.desc);
    });
  }
}

extension LegalConsentQuerySortThenBy
    on QueryBuilder<LegalConsent, LegalConsent, QSortThenBy> {
  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy> thenByAcceptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acceptedAt', Sort.asc);
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy>
      thenByAcceptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acceptedAt', Sort.desc);
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy> thenByIsAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAccepted', Sort.asc);
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QAfterSortBy>
      thenByIsAcceptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAccepted', Sort.desc);
    });
  }
}

extension LegalConsentQueryWhereDistinct
    on QueryBuilder<LegalConsent, LegalConsent, QDistinct> {
  QueryBuilder<LegalConsent, LegalConsent, QDistinct> distinctByAcceptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'acceptedAt');
    });
  }

  QueryBuilder<LegalConsent, LegalConsent, QDistinct> distinctByIsAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAccepted');
    });
  }
}

extension LegalConsentQueryProperty
    on QueryBuilder<LegalConsent, LegalConsent, QQueryProperty> {
  QueryBuilder<LegalConsent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LegalConsent, DateTime, QQueryOperations> acceptedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'acceptedAt');
    });
  }

  QueryBuilder<LegalConsent, bool, QQueryOperations> isAcceptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAccepted');
    });
  }
}
