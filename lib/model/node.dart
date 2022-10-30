// ignore_for_file: non_constant_identifier_names, constant_identifier_names

const String tableNodes = 'nodes';

class NodeFields {
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
