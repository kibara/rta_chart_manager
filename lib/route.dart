import 'package:go_router/go_router.dart';
import 'package:rta_chart_manager/screen/chart_details.dart';
import 'package:rta_chart_manager/screen/chart_titles.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ChartTitles(
        title: 'RTA Chart List',
      ),
    ),
    GoRoute(
      path: '/chart_detail',
      builder: (context, state) => ChartDetails(
        title: state.extra as String,
      ),
    ),
  ],
);
