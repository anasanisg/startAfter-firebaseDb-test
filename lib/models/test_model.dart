class TestModel {
  final String name;
  final int index;

  TestModel(this.name, this.index);

  TestModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        index = json['index'];
}
