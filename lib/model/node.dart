// ignore_for_file: non_constant_identifier_names, constant_identifier_names

const String tableNodes = 'nodes';

class NodeFields {
  static final List<String> values = [
    // All Fields
    id, name, bg_color, txt_color, size, max_amt, present_amt
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String bg_color = 'bg_color';
  static const String txt_color = 'txt_color';
  static const String size = 'size';
  static const String max_amt = 'max_amt';
  static const String present_amt = 'present_amt';
}

class Node {
  final int? id;
  final String name;
  final String bg_color;
  final String txt_color;
  final int size;
  final int max_amt;
  final int present_amt;

  Node({
    this.id,
    required this.name,
    required this.bg_color,
    required this.txt_color,
    required this.size,
    required this.max_amt,
    required this.present_amt,
  });

  Map<String, Object?> toJson() => {
        NodeFields.id: id,
        NodeFields.name: name,
        NodeFields.bg_color: bg_color,
        NodeFields.txt_color: txt_color,
        NodeFields.size: size,
        NodeFields.max_amt: max_amt,
        NodeFields.present_amt: present_amt
      };

  static Node fromJson(Map<String, Object?> json) {
    return Node(
      id: int.parse(json[NodeFields.id].toString()),
      name: json[NodeFields.name] as String,
      bg_color: json[NodeFields.bg_color] as String,
      txt_color: json[NodeFields.txt_color] as String,
      size: int.parse(json[NodeFields.size] as String),
      max_amt: json[NodeFields.max_amt] as int,
      present_amt: json[NodeFields.present_amt] as int,
    );
  }

  Node copy({
    int? id,
    String? name,
    String? bg_color,
    String? txt_color,
    int? size,
    int? max_amt,
    int? present_amt,
  }) =>
      Node(
        id: id ?? this.id,
        name: name ?? this.name,
        bg_color: bg_color ?? this.bg_color,
        txt_color: txt_color ?? this.txt_color,
        size: size ?? this.size,
        max_amt: max_amt ?? this.max_amt,
        present_amt: present_amt ?? this.present_amt,
      );
}
