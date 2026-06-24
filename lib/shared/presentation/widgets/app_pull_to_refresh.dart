import 'dart:async';

import 'package:flutter/material.dart';

class AppPullToRefresh extends StatefulWidget {
  const AppPullToRefresh({
    required this.child,
    required this.onRefresh,
    required this.canRefresh,
    this.threshold = 80,
    super.key,
  });

  final Widget child;
  final Future<void> Function() onRefresh;
  final bool canRefresh;
  final double threshold;

  @override
  State<AppPullToRefresh> createState() => _AppPullToRefreshState();
}

class _AppPullToRefreshState extends State<AppPullToRefresh> {
  double _pullDistance = 0;
  bool _isRefreshing = false;

  void _onPointerDown(PointerDownEvent event) {
    if (!_isRefreshing) {
      _pullDistance = 0;
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_isRefreshing || !widget.canRefresh) return;
    if (event.delta.dy > 0) {
      _pullDistance += event.delta.dy * 0.5;
      _pullDistance = _pullDistance.clamp(0, widget.threshold * 1.5);
      setState(() {});
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!_isRefreshing && _pullDistance >= widget.threshold && widget.canRefresh) {
      _isRefreshing = true;
      setState(() {});
      unawaited(_fireRefresh());
    } else {
      _pullDistance = 0;
      if (mounted) setState(() {});
    }
  }

  Future<void> _fireRefresh() async {
    try {
      await widget.onRefresh();
    } finally {
      _isRefreshing = false;
      _pullDistance = 0;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          widget.child,
          if (_pullDistance > 0 || _isRefreshing)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    if (_isRefreshing) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final progress = (_pullDistance / widget.threshold).clamp(0.0, 1.0);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Opacity(
          opacity: progress,
          child: SizedBox(
            width: 24 * progress.clamp(0.4, 1.0),
            height: 24 * progress.clamp(0.4, 1.0),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress < 1.0 ? progress : null,
            ),
          ),
        ),
      ),
    );
  }
}
