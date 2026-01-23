// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_result.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPredictionResultCollection on Isar {
  IsarCollection<PredictionResult> get predictionResults => this.collection();
}

const PredictionResultSchema = CollectionSchema(
  name: r'PredictionResult',
  id: -6724504652094380463,
  properties: {
    r'accountAge': PropertySchema(
      id: 0,
      name: r'accountAge',
      type: IsarType.double,
    ),
    r'age': PropertySchema(
      id: 1,
      name: r'age',
      type: IsarType.long,
    ),
    r'avgBalance': PropertySchema(
      id: 2,
      name: r'avgBalance',
      type: IsarType.double,
    ),
    r'avgTransaction': PropertySchema(
      id: 3,
      name: r'avgTransaction',
      type: IsarType.double,
    ),
    r'billAmt1': PropertySchema(
      id: 4,
      name: r'billAmt1',
      type: IsarType.double,
    ),
    r'billAmt2': PropertySchema(
      id: 5,
      name: r'billAmt2',
      type: IsarType.double,
    ),
    r'billAmt3': PropertySchema(
      id: 6,
      name: r'billAmt3',
      type: IsarType.double,
    ),
    r'category': PropertySchema(
      id: 7,
      name: r'category',
      type: IsarType.string,
    ),
    r'categoryDiversity': PropertySchema(
      id: 8,
      name: r'categoryDiversity',
      type: IsarType.double,
    ),
    r'expenseRatio': PropertySchema(
      id: 9,
      name: r'expenseRatio',
      type: IsarType.double,
    ),
    r'incomeStability': PropertySchema(
      id: 10,
      name: r'incomeStability',
      type: IsarType.double,
    ),
    r'limitBal': PropertySchema(
      id: 11,
      name: r'limitBal',
      type: IsarType.double,
    ),
    r'overdraftFrequency': PropertySchema(
      id: 12,
      name: r'overdraftFrequency',
      type: IsarType.double,
    ),
    r'pay0': PropertySchema(
      id: 13,
      name: r'pay0',
      type: IsarType.long,
    ),
    r'pay2': PropertySchema(
      id: 14,
      name: r'pay2',
      type: IsarType.long,
    ),
    r'pay3': PropertySchema(
      id: 15,
      name: r'pay3',
      type: IsarType.long,
    ),
    r'payAmt1': PropertySchema(
      id: 16,
      name: r'payAmt1',
      type: IsarType.double,
    ),
    r'payAmt2': PropertySchema(
      id: 17,
      name: r'payAmt2',
      type: IsarType.double,
    ),
    r'payAmt3': PropertySchema(
      id: 18,
      name: r'payAmt3',
      type: IsarType.double,
    ),
    r'paymentConsistency': PropertySchema(
      id: 19,
      name: r'paymentConsistency',
      type: IsarType.double,
    ),
    r'predictedAt': PropertySchema(
      id: 20,
      name: r'predictedAt',
      type: IsarType.dateTime,
    ),
    r'probabilityOfDefault': PropertySchema(
      id: 21,
      name: r'probabilityOfDefault',
      type: IsarType.double,
    ),
    r'recommendations': PropertySchema(
      id: 22,
      name: r'recommendations',
      type: IsarType.stringList,
    ),
    r'riskDescription': PropertySchema(
      id: 23,
      name: r'riskDescription',
      type: IsarType.string,
    ),
    r'score': PropertySchema(
      id: 24,
      name: r'score',
      type: IsarType.long,
    ),
    r'transactionVolatility': PropertySchema(
      id: 25,
      name: r'transactionVolatility',
      type: IsarType.double,
    )
  },
  estimateSize: _predictionResultEstimateSize,
  serialize: _predictionResultSerialize,
  deserialize: _predictionResultDeserialize,
  deserializeProp: _predictionResultDeserializeProp,
  idName: r'id',
  indexes: {
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _predictionResultGetId,
  getLinks: _predictionResultGetLinks,
  attach: _predictionResultAttach,
  version: '3.1.0+1',
);

int _predictionResultEstimateSize(
  PredictionResult object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.recommendations.length * 3;
  {
    for (var i = 0; i < object.recommendations.length; i++) {
      final value = object.recommendations[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.riskDescription.length * 3;
  return bytesCount;
}

void _predictionResultSerialize(
  PredictionResult object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.accountAge);
  writer.writeLong(offsets[1], object.age);
  writer.writeDouble(offsets[2], object.avgBalance);
  writer.writeDouble(offsets[3], object.avgTransaction);
  writer.writeDouble(offsets[4], object.billAmt1);
  writer.writeDouble(offsets[5], object.billAmt2);
  writer.writeDouble(offsets[6], object.billAmt3);
  writer.writeString(offsets[7], object.category);
  writer.writeDouble(offsets[8], object.categoryDiversity);
  writer.writeDouble(offsets[9], object.expenseRatio);
  writer.writeDouble(offsets[10], object.incomeStability);
  writer.writeDouble(offsets[11], object.limitBal);
  writer.writeDouble(offsets[12], object.overdraftFrequency);
  writer.writeLong(offsets[13], object.pay0);
  writer.writeLong(offsets[14], object.pay2);
  writer.writeLong(offsets[15], object.pay3);
  writer.writeDouble(offsets[16], object.payAmt1);
  writer.writeDouble(offsets[17], object.payAmt2);
  writer.writeDouble(offsets[18], object.payAmt3);
  writer.writeDouble(offsets[19], object.paymentConsistency);
  writer.writeDateTime(offsets[20], object.predictedAt);
  writer.writeDouble(offsets[21], object.probabilityOfDefault);
  writer.writeStringList(offsets[22], object.recommendations);
  writer.writeString(offsets[23], object.riskDescription);
  writer.writeLong(offsets[24], object.score);
  writer.writeDouble(offsets[25], object.transactionVolatility);
}

PredictionResult _predictionResultDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PredictionResult();
  object.accountAge = reader.readDouble(offsets[0]);
  object.age = reader.readLong(offsets[1]);
  object.avgBalance = reader.readDouble(offsets[2]);
  object.avgTransaction = reader.readDouble(offsets[3]);
  object.billAmt1 = reader.readDouble(offsets[4]);
  object.billAmt2 = reader.readDouble(offsets[5]);
  object.billAmt3 = reader.readDouble(offsets[6]);
  object.category = reader.readString(offsets[7]);
  object.categoryDiversity = reader.readDouble(offsets[8]);
  object.expenseRatio = reader.readDouble(offsets[9]);
  object.id = id;
  object.incomeStability = reader.readDouble(offsets[10]);
  object.limitBal = reader.readDouble(offsets[11]);
  object.overdraftFrequency = reader.readDouble(offsets[12]);
  object.pay0 = reader.readLong(offsets[13]);
  object.pay2 = reader.readLong(offsets[14]);
  object.pay3 = reader.readLong(offsets[15]);
  object.payAmt1 = reader.readDouble(offsets[16]);
  object.payAmt2 = reader.readDouble(offsets[17]);
  object.payAmt3 = reader.readDouble(offsets[18]);
  object.paymentConsistency = reader.readDouble(offsets[19]);
  object.predictedAt = reader.readDateTime(offsets[20]);
  object.probabilityOfDefault = reader.readDouble(offsets[21]);
  object.score = reader.readLong(offsets[24]);
  object.transactionVolatility = reader.readDouble(offsets[25]);
  return object;
}

P _predictionResultDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    case 19:
      return (reader.readDouble(offset)) as P;
    case 20:
      return (reader.readDateTime(offset)) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    case 22:
      return (reader.readStringList(offset) ?? []) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readLong(offset)) as P;
    case 25:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _predictionResultGetId(PredictionResult object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _predictionResultGetLinks(PredictionResult object) {
  return [];
}

void _predictionResultAttach(
    IsarCollection<dynamic> col, Id id, PredictionResult object) {
  object.id = id;
}

extension PredictionResultQueryWhereSort
    on QueryBuilder<PredictionResult, PredictionResult, QWhere> {
  QueryBuilder<PredictionResult, PredictionResult, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PredictionResultQueryWhere
    on QueryBuilder<PredictionResult, PredictionResult, QWhereClause> {
  QueryBuilder<PredictionResult, PredictionResult, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<PredictionResult, PredictionResult, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterWhereClause> idBetween(
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

  QueryBuilder<PredictionResult, PredictionResult, QAfterWhereClause>
      categoryEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'category',
        value: [category],
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterWhereClause>
      categoryNotEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PredictionResultQueryFilter
    on QueryBuilder<PredictionResult, PredictionResult, QFilterCondition> {
  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      accountAgeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountAge',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      accountAgeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accountAge',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      accountAgeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accountAge',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      accountAgeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accountAge',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      ageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      ageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      ageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      ageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'age',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      avgBalanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      avgBalanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      avgBalanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      avgBalanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      avgTransactionEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgTransaction',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      avgTransactionGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgTransaction',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      avgTransactionLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgTransaction',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      avgTransactionBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgTransaction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt1EqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billAmt1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt1GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'billAmt1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt1LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'billAmt1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt1Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'billAmt1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt2EqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billAmt2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt2GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'billAmt2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt2LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'billAmt2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt2Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'billAmt2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt3EqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billAmt3',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt3GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'billAmt3',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt3LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'billAmt3',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      billAmt3Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'billAmt3',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryDiversityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryDiversity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryDiversityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryDiversity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryDiversityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryDiversity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      categoryDiversityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryDiversity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      expenseRatioEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expenseRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      expenseRatioGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expenseRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      expenseRatioLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expenseRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      expenseRatioBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expenseRatio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      incomeStabilityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incomeStability',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      incomeStabilityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'incomeStability',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      incomeStabilityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'incomeStability',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      incomeStabilityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'incomeStability',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      limitBalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'limitBal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      limitBalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'limitBal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      limitBalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'limitBal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      limitBalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'limitBal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      overdraftFrequencyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overdraftFrequency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      overdraftFrequencyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'overdraftFrequency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      overdraftFrequencyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'overdraftFrequency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      overdraftFrequencyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'overdraftFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay0EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pay0',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay0GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pay0',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay0LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pay0',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay0Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pay0',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay2EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pay2',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay2GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pay2',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay2LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pay2',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay2Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pay2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay3EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pay3',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay3GreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pay3',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay3LessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pay3',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      pay3Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pay3',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt1EqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payAmt1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt1GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payAmt1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt1LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payAmt1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt1Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payAmt1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt2EqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payAmt2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt2GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payAmt2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt2LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payAmt2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt2Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payAmt2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt3EqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payAmt3',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt3GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payAmt3',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt3LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payAmt3',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      payAmt3Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payAmt3',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      paymentConsistencyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentConsistency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      paymentConsistencyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentConsistency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      paymentConsistencyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentConsistency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      paymentConsistencyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentConsistency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      predictedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predictedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      predictedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'predictedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      predictedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'predictedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      predictedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'predictedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      probabilityOfDefaultEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'probabilityOfDefault',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      probabilityOfDefaultGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'probabilityOfDefault',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      probabilityOfDefaultLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'probabilityOfDefault',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      probabilityOfDefaultBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'probabilityOfDefault',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recommendations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recommendations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recommendations',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recommendations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recommendations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recommendations',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recommendations',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendations',
        value: '',
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recommendations',
        value: '',
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'recommendations',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'recommendations',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'recommendations',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'recommendations',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'recommendations',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      recommendationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'recommendations',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'riskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'riskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'riskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'riskDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'riskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'riskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'riskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'riskDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'riskDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      riskDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'riskDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      scoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      scoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      scoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      scoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      transactionVolatilityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transactionVolatility',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      transactionVolatilityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transactionVolatility',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      transactionVolatilityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transactionVolatility',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterFilterCondition>
      transactionVolatilityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transactionVolatility',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PredictionResultQueryObject
    on QueryBuilder<PredictionResult, PredictionResult, QFilterCondition> {}

extension PredictionResultQueryLinks
    on QueryBuilder<PredictionResult, PredictionResult, QFilterCondition> {}

extension PredictionResultQuerySortBy
    on QueryBuilder<PredictionResult, PredictionResult, QSortBy> {
  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByAccountAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountAge', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByAccountAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountAge', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> sortByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByAvgBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgBalance', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByAvgBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgBalance', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByAvgTransaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgTransaction', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByAvgTransactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgTransaction', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByBillAmt1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt1', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByBillAmt1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt1', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByBillAmt2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt2', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByBillAmt2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt2', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByBillAmt3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt3', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByBillAmt3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt3', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByCategoryDiversity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryDiversity', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByCategoryDiversityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryDiversity', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByExpenseRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseRatio', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByExpenseRatioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseRatio', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByIncomeStability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeStability', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByIncomeStabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeStability', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByLimitBal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'limitBal', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByLimitBalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'limitBal', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByOverdraftFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdraftFrequency', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByOverdraftFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdraftFrequency', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> sortByPay0() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay0', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPay0Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay0', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> sortByPay2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay2', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPay2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay2', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> sortByPay3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay3', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPay3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay3', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPayAmt1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt1', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPayAmt1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt1', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPayAmt2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt2', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPayAmt2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt2', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPayAmt3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt3', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPayAmt3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt3', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPaymentConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentConsistency', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPaymentConsistencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentConsistency', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPredictedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedAt', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByPredictedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedAt', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByProbabilityOfDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probabilityOfDefault', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByProbabilityOfDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probabilityOfDefault', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByRiskDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskDescription', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByRiskDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskDescription', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByTransactionVolatility() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionVolatility', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      sortByTransactionVolatilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionVolatility', Sort.desc);
    });
  }
}

extension PredictionResultQuerySortThenBy
    on QueryBuilder<PredictionResult, PredictionResult, QSortThenBy> {
  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByAccountAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountAge', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByAccountAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountAge', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> thenByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByAvgBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgBalance', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByAvgBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgBalance', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByAvgTransaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgTransaction', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByAvgTransactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgTransaction', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByBillAmt1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt1', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByBillAmt1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt1', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByBillAmt2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt2', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByBillAmt2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt2', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByBillAmt3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt3', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByBillAmt3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billAmt3', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByCategoryDiversity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryDiversity', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByCategoryDiversityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryDiversity', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByExpenseRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseRatio', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByExpenseRatioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseRatio', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByIncomeStability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeStability', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByIncomeStabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeStability', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByLimitBal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'limitBal', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByLimitBalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'limitBal', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByOverdraftFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdraftFrequency', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByOverdraftFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdraftFrequency', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> thenByPay0() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay0', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPay0Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay0', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> thenByPay2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay2', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPay2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay2', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> thenByPay3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay3', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPay3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pay3', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPayAmt1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt1', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPayAmt1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt1', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPayAmt2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt2', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPayAmt2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt2', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPayAmt3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt3', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPayAmt3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payAmt3', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPaymentConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentConsistency', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPaymentConsistencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentConsistency', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPredictedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedAt', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByPredictedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedAt', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByProbabilityOfDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probabilityOfDefault', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByProbabilityOfDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probabilityOfDefault', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByRiskDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskDescription', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByRiskDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskDescription', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByTransactionVolatility() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionVolatility', Sort.asc);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QAfterSortBy>
      thenByTransactionVolatilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionVolatility', Sort.desc);
    });
  }
}

extension PredictionResultQueryWhereDistinct
    on QueryBuilder<PredictionResult, PredictionResult, QDistinct> {
  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByAccountAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountAge');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct> distinctByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'age');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByAvgBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgBalance');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByAvgTransaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgTransaction');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByBillAmt1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'billAmt1');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByBillAmt2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'billAmt2');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByBillAmt3() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'billAmt3');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByCategoryDiversity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryDiversity');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByExpenseRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expenseRatio');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByIncomeStability() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incomeStability');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByLimitBal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'limitBal');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByOverdraftFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overdraftFrequency');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct> distinctByPay0() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pay0');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct> distinctByPay2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pay2');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct> distinctByPay3() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pay3');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByPayAmt1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payAmt1');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByPayAmt2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payAmt2');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByPayAmt3() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payAmt3');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByPaymentConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentConsistency');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByPredictedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predictedAt');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByProbabilityOfDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'probabilityOfDefault');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByRecommendations() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recommendations');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByRiskDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'riskDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<PredictionResult, PredictionResult, QDistinct>
      distinctByTransactionVolatility() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transactionVolatility');
    });
  }
}

extension PredictionResultQueryProperty
    on QueryBuilder<PredictionResult, PredictionResult, QQueryProperty> {
  QueryBuilder<PredictionResult, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      accountAgeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountAge');
    });
  }

  QueryBuilder<PredictionResult, int, QQueryOperations> ageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'age');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      avgBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgBalance');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      avgTransactionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgTransaction');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations> billAmt1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'billAmt1');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations> billAmt2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'billAmt2');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations> billAmt3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'billAmt3');
    });
  }

  QueryBuilder<PredictionResult, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      categoryDiversityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryDiversity');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      expenseRatioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expenseRatio');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      incomeStabilityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incomeStability');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations> limitBalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'limitBal');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      overdraftFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overdraftFrequency');
    });
  }

  QueryBuilder<PredictionResult, int, QQueryOperations> pay0Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pay0');
    });
  }

  QueryBuilder<PredictionResult, int, QQueryOperations> pay2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pay2');
    });
  }

  QueryBuilder<PredictionResult, int, QQueryOperations> pay3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pay3');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations> payAmt1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payAmt1');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations> payAmt2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payAmt2');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations> payAmt3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payAmt3');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      paymentConsistencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentConsistency');
    });
  }

  QueryBuilder<PredictionResult, DateTime, QQueryOperations>
      predictedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predictedAt');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      probabilityOfDefaultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'probabilityOfDefault');
    });
  }

  QueryBuilder<PredictionResult, List<String>, QQueryOperations>
      recommendationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recommendations');
    });
  }

  QueryBuilder<PredictionResult, String, QQueryOperations>
      riskDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'riskDescription');
    });
  }

  QueryBuilder<PredictionResult, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<PredictionResult, double, QQueryOperations>
      transactionVolatilityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transactionVolatility');
    });
  }
}
