// ignore_for_file: non_constant_identifier_names, constant_identifier_names

const String tableFlows = 'flows';

class FlowFields {
  static final List<String> values = [
    // All Fields
    id, name, amt, date_of_flow, is_income
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String amt = 'amt';
  static const String date_of_flow = 'date_of_flow';
  static const String is_income = 'is_income';
}

class MoneyFlow {
  final int? id;
  final String name;
  final int amt;
  final DateTime date_of_flow;
  final bool is_income;

  MoneyFlow({
    this.id,
    required this.name,
    required this.amt,
    required this.date_of_flow,
    required this.is_income,
  });

  Map<String, Object?> toJson() => {
        FlowFields.id: id,
        FlowFields.name: name,
        FlowFields.amt: amt,
        FlowFields.date_of_flow: date_of_flow.toString(),
        FlowFields.is_income: (is_income == true) ? 1 : 0,
      };

  static MoneyFlow fromJson(Map<String, Object?> json) {
    return MoneyFlow(
      id: int.parse(json[FlowFields.id].toString()),
      name: json[FlowFields.name] as String,
      amt: json[FlowFields.amt] as int,
      date_of_flow: DateTime.parse(json[FlowFields.date_of_flow].toString()),
      is_income: (int.parse('${json[FlowFields.is_income]}') == 1),
    );
  }

  MoneyFlow copy({
    int? id,
    String? name,
    int? amt,
    DateTime? date_of_flow,
    bool? is_income,
  }) =>
      MoneyFlow(
        id: id ?? this.id,
        name: name ?? this.name,
        amt: amt ?? this.amt,
        date_of_flow: date_of_flow ?? this.date_of_flow,
        is_income: is_income ?? this.is_income,
      );
}
