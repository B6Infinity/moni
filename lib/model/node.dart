// ignore_for_file: non_constant_identifier_names, constant_identifier_names

const String tableNodes = 'nodes';

class NodeFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String bg_color = 'bg_color';
  static const String txt_color = 'txt_color';
  static const String size = 'size';
  static const String coords = 'coords';
  static const String max_amt = 'max_amt';
  static const String present_amt = 'present_amt';
}

class Node {
  final int? id;
  final String? name;
  final String? bg_color;
  final String? txt_color;
  final int? size;
  final List<int>? coords;
  final int? max_amt;
  final int? present_amt;

  Node({
    this.id,
    this.name,
    this.bg_color,
    this.txt_color,
    this.size,
    this.coords,
    this.max_amt,
    this.present_amt,
  });
}
