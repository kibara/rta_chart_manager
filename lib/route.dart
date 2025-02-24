import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rta_chart_manager/screen/chapter_details.dart';
import 'package:rta_chart_manager/screen/chapter_summary.dart';
import 'package:rta_chart_manager/screen/chart_play_history.dart';
import 'package:rta_chart_manager/screen/chart_titles.dart';

final router = GoRouter(
  routes: [
    // チャート一覧
    GoRoute(
      path: '/',
      name: 'chart_title',
      builder: (context, state) => const ChartTitles(
        title: 'RTA Chart List',
      ),
    ),
    // チャプター一覧
    GoRoute(
      path: '/chapter_summary/:chartId',
      name: 'chapter_summary',
      builder: (context, state) => ChapterSummary(
        key: Key(state.pathParameters['chartId'] as String),
        chartTitleId: state.pathParameters['chartId'] as String,
      ),
    ),
    // チャプター詳細
    GoRoute(
      path: '/chapter_detail/:chartId/:summaryId',
      name: 'chapter_detail',
      builder: (context, state) => ChapterDetails(
        key: Key(state.pathParameters['summaryId'] as String),
        chartTitleId: state.pathParameters['chartId'] as String,
        chapterSummaryId: state.pathParameters['summaryId'] as String,
        chartPlayId: state.uri.queryParameters['playId'],
        isEditMode: bool.parse(state.uri.queryParameters['editMode']!),
      ),
    ),
    // チャートリザルト
    GoRoute(
      path: '/chart_result/:chartId/:playId',
      name: 'chart_result',
      builder: (context, state) => ChartPlayResult(
        key: Key(state.pathParameters['playId'] as String),
        chartTitleId: state.pathParameters['chartId'] as String,
        chartPlayId: state.pathParameters['playId'] as String,
      ),
    ),
  ],
);
