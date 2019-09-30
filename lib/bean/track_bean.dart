import 'package:json_annotation/json_annotation.dart'; 
  
part 'track_bean.g.dart';


List<TrackBean> getTrackBeanList(List<dynamic> list){
    List<TrackBean> result = [];
    list.forEach((item){
      result.add(TrackBean.fromJson(item));
    });
    return result;
  }
@JsonSerializable()
class TrackBean extends Object {

  @JsonKey(name: '_id')
  int id;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'repo_owner')
  String repoOwner;

  @JsonKey(name: 'repo_name')
  String repoName;

  @JsonKey(name: 'issue_number')
  String issueNumber;

  @JsonKey(name: 'date')
  int date;

  @JsonKey(name: 'data1')
  String data1;

  @JsonKey(name: 'data2')
  String data2;

  @JsonKey(name: 'data3')
  String data3;

  @JsonKey(name: 'data4')
  String data4;

  TrackBean(this.id,this.url,this.title,this.type,this.repoOwner,this.repoName,this.issueNumber,this.date,this.data1,this.data2,this.data3,this.data4,);

  factory TrackBean.fromJson(Map<String, dynamic> srcJson) => _$TrackBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TrackBeanToJson(this);

}

  
