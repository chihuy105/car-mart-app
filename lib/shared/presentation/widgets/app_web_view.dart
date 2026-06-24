import 'dart:async';

import 'package:car_mart/core/constants/app_constants.dart';
import 'package:car_mart/shared/presentation/widgets/app_button.dart';
import 'package:car_mart/shared/presentation/widgets/app_pull_to_refresh.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class AppWebView extends StatefulWidget {
  const AppWebView({
    required this.initialUrl,
    this.userAgent,
    this.javaScriptMode = JavaScriptMode.unrestricted,
    super.key,
  });

  final String initialUrl;
  final String? userAgent;
  final JavaScriptMode javaScriptMode;

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late final WebViewController _controller;
  bool _isAtTop = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    final isWebKit = WebViewPlatform.instance is WebKitWebViewPlatform;

    late final PlatformWebViewControllerCreationParams params;
    if (isWebKit) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final userAgent = widget.userAgent ??
        (isWebKit
            ? AppConstants.iosWebViewUserAgent
            : AppConstants.androidWebViewUserAgent);

    _controller = WebViewController.fromPlatformCreationParams(params);
    unawaited(_controller.setJavaScriptMode(widget.javaScriptMode));
    unawaited(_controller.setUserAgent(userAgent));
    unawaited(
      _controller.setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() => _hasError = false);
          },
          onWebResourceError: (error) {
            if (!mounted) return;
            if (error.isForMainFrame ?? true) {
              setState(() => _hasError = true);
            }
          },
        ),
      ),
    );
    unawaited(
      _controller.setOnScrollPositionChange(
        (change) {
          if (!mounted) return;
          setState(() => _isAtTop = change.y <= 0);
        },
      ),
    );

    final platform = _controller.platform;
    if (platform is AndroidWebViewController) {
      unawaited(platform.setMediaPlaybackRequiresUserGesture(false));
    }

    unawaited(_controller.loadRequest(Uri.parse(widget.initialUrl)));
  }

  Future<void> _reload() async {
    _isAtTop = true;
    if (_hasError) {
      _hasError = false;
      if (mounted) setState(() {});
    }
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppPullToRefresh(
          canRefresh: _isAtTop,
          onRefresh: _reload,
          child: WebViewWidget(controller: _controller),
        ),
        if (_hasError)
          Positioned.fill(
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(child: _buildErrorContent(context)),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('common.somethingWentWrong'.tr(), style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'webView.connectionError'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          AppButton(text: 'common.refresh'.tr(), onPressed: _reload),
        ],
      ),
    );
  }
}
