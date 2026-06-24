import 'package:car_mart/app/network/dio_client.dart';
import 'package:car_mart/features/todo/data/models/todo_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'todo_api.g.dart';

@RestApi()
@lazySingleton
abstract class TodoApi {
  @factoryMethod
  factory TodoApi(DioClient client) => _TodoApi(client.dio);

  @GET('/todos/1')
  Future<TodoModel> getTodo();
}
