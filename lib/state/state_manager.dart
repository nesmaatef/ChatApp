import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/model/user_model.dart';

final chatUser = StateProvider((ref) => User_Model());
final userLogged = StateProvider((ref) => User_Model());
