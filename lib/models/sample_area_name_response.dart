class SampleAreaNameResponse {
  int? areaId;
  int? id;
  String? name;

  SampleAreaNameResponse({this.areaId, this.id, this.name});

  factory SampleAreaNameResponse.fromJson(Map<String, dynamic> json) {
    return SampleAreaNameResponse(
      areaId: json['area_id'],
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area_id'] = this.areaId;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
