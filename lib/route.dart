import 'package:go_router/go_router.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';
import 'package:rta_chart_manager/database/models/chart_title_model.dart';
import 'package:rta_chart_manager/screen/chapter_details.dart';
import 'package:rta_chart_manager/screen/chapter_summary.dart';
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
      path: '/chapter_summary',
      builder: (context, state) => ChapterSummary(
        chartTitle: state.extra as ChartTitleModel,
      ),
    ),
    GoRoute(
      path: '/chapter_detail',
      builder: (context, state) {
        final (summary, editMode) = state.extra as (ChapterSummaryModel, bool);

        return ChapterDetails(
          chapterSummary: summary,
          isEditMode: editMode,
        );
      },
    ),
  ],
);
