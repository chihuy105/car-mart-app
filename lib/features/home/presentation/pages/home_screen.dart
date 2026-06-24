import 'package:auto_route/auto_route.dart';
import 'package:car_mart/core/utils/toast_helper.dart';
import 'package:car_mart/di/injection.dart';
import 'package:car_mart/environment.dart';
import 'package:car_mart/features/todo/domain/usecases/get_todo_use_case.dart';
import 'package:car_mart/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:car_mart/features/todo/presentation/bloc/todo_event.dart';
import 'package:car_mart/features/todo/presentation/bloc/todo_state.dart';
import 'package:car_mart/shared/presentation/bloc/bloc_status.dart';
import 'package:car_mart/shared/presentation/widgets/app_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatelessWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TodoBloc(getIt<GetTodoUseCase>())..add(const TodoEvent.load()),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final environmentConfig = getIt<EnvironmentConfig>();

    return BlocListener<TodoBloc, TodoState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        state.status.whenOrNull(
          done: () {
            if (state.todo?.title.isNotEmpty == true) {
              context.showToast(state.todo?.title ?? '');
            }
          },
          error: context.showFailure,
        );
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: AppWebView(
            initialUrl: environmentConfig.sgCarMartUrl,
          ),
        ),
      ),
    );
  }
}
