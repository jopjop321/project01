import 'package:jstock/constants/imports.dart';

class ProfileProvider with ChangeNotifier {
  ProfileData? _data;

  void setData(ProfileData indata) {
    _data = indata;
  }

  ProfileData? getData(){
    return _data;
  }
  int getDataid(){
    return _data!.employee_id!;
  }
}
