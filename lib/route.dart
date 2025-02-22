import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rta_chart_manager/screen/chapter_details.dart';
import 'package:rta_chart_manager/screen/chapter_summary.dart';
import 'package:rta_chart_manager/screen/chart_titles.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'chart_title',
      builder: (context, state) => const ChartTitles(
        title: 'RTA Chart List',
      ),
    ),
    GoRoute(
      path: '/chapter_summary/:chartId',
      name: 'chapter_summary',
      builder: (context, state) => ChapterSummary(
        key: Key(state.pathParameters['chartId'] as String),
        chartTitleId: state.pathParameters['chartId'] as String,
      ),
    ),
    GoRoute(
      path: '/chapter_detail/:chartId/:summaryId',
      name: 'chapter_detail',
      builder: (context, state) => ChapterDetails(
        key: Key(state.pathParameters['summaryId'] as String),
        chartTitleId: state.pathParameters['chartId'] as String,
        chapterSummaryId: state.pathParameters['summaryId'] as String,
        isEditMode: bool.parse(state.uri.queryParameters['editMode']!),
      ),
    ),
  ],
);
