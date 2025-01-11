import 'package:go_router/go_router.dart';
import 'package:rta_chart_flutter/screens/chart_titles.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ChartTitles(
        title: 'RTA Chart List',
      ),
    ),
  ],
);
