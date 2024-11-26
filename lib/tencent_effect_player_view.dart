import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'constant/constant.dart';
import 'models/index.dart';

/// 事件通知回调
typedef TCEffectPlayerViewCallback = void Function(String viewId, int eventId, Map? param);

/// 融合动画普通字符替换回调
typedef TCEffectPlayerViewStringCallback = List<TencentNormalTextModel> Function(String viewId);

/// 融合动画特效字符(对其颜色等)替换回调
typedef TCEffectPlayerViewEffectStringCallback = List<TencentEffectTextModel> Function(String viewId);

/// 融合动画图片替换回调
typedef TCEffectPlayerViewImageCallback = List<TencentEffectImageModel> Function(String viewId);

/// 融合动画资源点击事件回调
typedef TCEffectPlayerViewClickEventCallback = void Function(String viewId, String tag);

/// 融合动画播放错误回调
typedef TCEffectPlayerViewErrorCallback = void Function(String viewId, Map? error);

/// 普通事件回调
typedef TCEffectPlayerViewNormalEventCallback = void Function(String viewId);

class TencentEffectPlayerView extends StatefulWidget {
  const TencentEffectPlayerView({
    super.key,
    this.url,
    this.playPath,
    this.playAsset,
    this.autoStart = true,
    this.isLoop = false,
    this.viewId,
    this.onViewCreated,
    this.onEventNotification,
    this.onTextContentForPlayer,
    this.onLoadTextForPlayer,
    this.onLoadImageForPlayer,
    this.onTCEffectAnimViewClickEvent,
    this.onTCEffectAnimViewStart,
    this.onTCEffectAnimViewEnd,
    this.onTCEffectAnimViewError,
    this.defaultBuilder,
  });

  /// url
  final String? url;

  /// 播放路径
  final String? playPath;

  /// 播放资源
  final String? playAsset;

  /// 自动播放
  final bool autoStart;

  /// 是否循环播放
  final bool isLoop;

  /// 特殊情况需要自己定义viewId的时候
  final String? viewId;

  // 当平台视图创建时调用
  final ValueChanged<String>? onViewCreated;

  /// 事件通知回调
  final TCEffectPlayerViewCallback? onEventNotification;

  /// 融合动画普通字符替换回调
  final TCEffectPlayerViewStringCallback? onTextContentForPlayer;

  /// 融合动画特效字符(对其颜色等)替换回调
  final TCEffectPlayerViewEffectStringCallback? onLoadTextForPlayer;

  /// 融合动画图片替换回调
  final TCEffectPlayerViewImageCallback? onLoadImageForPlayer;

  /// 融合动画资源点击事件回调
  final TCEffectPlayerViewClickEventCallback? onTCEffectAnimViewClickEvent;

  /// 融合动画开始播放回调
  final TCEffectPlayerViewNormalEventCallback? onTCEffectAnimViewStart;

  /// 融合动画结束播放回调
  final TCEffectPlayerViewNormalEventCallback? onTCEffectAnimViewEnd;

  /// 融合动画播放错误回调
  final TCEffectPlayerViewErrorCallback? onTCEffectAnimViewError;

  /// 加载失败时的默认控件构造器
  final Widget Function(BuildContext context)? defaultBuilder;

  const TencentEffectPlayerView.network(
    this.url, {
    this.autoStart = true,
    this.isLoop = false,
    this.viewId,
    this.onViewCreated,
    this.onEventNotification,
    this.onTextContentForPlayer,
    this.onLoadTextForPlayer,
    this.onLoadImageForPlayer,
    this.onTCEffectAnimViewClickEvent,
    this.onTCEffectAnimViewStart,
    this.onTCEffectAnimViewEnd,
    this.onTCEffectAnimViewError,
    this.defaultBuilder,
    super.key,
  })  : playPath = null,
        playAsset = null;

  const TencentEffectPlayerView.path(
    this.playPath, {
    this.autoStart = true,
    this.isLoop = false,
    this.viewId,
    this.onViewCreated,
    this.onEventNotification,
    this.onTextContentForPlayer,
    this.onLoadTextForPlayer,
    this.onLoadImageForPlayer,
    this.onTCEffectAnimViewClickEvent,
    this.onTCEffectAnimViewStart,
    this.onTCEffectAnimViewEnd,
    this.onTCEffectAnimViewError,
    this.defaultBuilder,
    super.key,
  })  : url = null,
        playAsset = null;

  const TencentEffectPlayerView.asset(
    this.playAsset, {
    this.autoStart = true,
    this.isLoop = false,
    this.viewId,
    this.onViewCreated,
    this.onEventNotification,
    this.onTextContentForPlayer,
    this.onLoadTextForPlayer,
    this.onLoadImageForPlayer,
    this.onTCEffectAnimViewClickEvent,
    this.onTCEffectAnimViewStart,
    this.onTCEffectAnimViewEnd,
    this.onTCEffectAnimViewError,
    this.defaultBuilder,
    super.key,
  })  : url = null,
        playPath = null;

  @override
  State<TencentEffectPlayerView> createState() => _TencentEffectPlayerViewState();
}

class _TencentEffectPlayerViewState extends State<TencentEffectPlayerView> {
  late MethodChannel _channel;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams[kMethodArgsKeyPlayUrl] = widget.url;
    creationParams[kMethodArgsKeyPlayPath] = widget.playPath;
    creationParams[kMethodArgsKeyPlayAsset] = widget.playAsset;
    creationParams[kMethodArgsKeyAutoStart] = widget.autoStart;
    creationParams[kMethodArgsKeyIsLoop] = widget.isLoop;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: kViewType,
          creationParams: creationParams,
          layoutDirection: TextDirection.ltr,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: kViewType,
          layoutDirection: TextDirection.ltr,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }

  void _onPlatformViewCreated(int id) {
    String viewId = '$kChannelNamePrefix$id';
    if (widget.viewId != null) {
      viewId = '$kChannelNamePrefix$widget.viewId';
    }
    _channel = MethodChannel(viewId);
    _channel.setMethodCallHandler(methodCallHandler);
    initPlayerView();

    if (widget.onViewCreated != null) {
      widget.onViewCreated?.call(viewId);
    }
  }

  void initPlayerView() {
    _channel.invokeMethod(kCallbackMethodInitPlayerView);
  }

  Future<dynamic> methodCallHandler(MethodCall call) async {
    if (call.method == kCallbackMethodTCEffectAnimViewEvent) {
      // 事件通知
      if (call.arguments == null) {
        return null;
      }
      final String? viewId = call.arguments[kMethodArgsKeyViewId];
      if (viewId == null) {
        return null;
      }
      final int? eventId = call.arguments[kMethodArgsKeyEventId];
      if (eventId == null) {
        return null;
      }
      final param = call.arguments[kMethodArgsKeyParam];
      widget.onEventNotification?.call(viewId, eventId, param);
    } else if (call.method == kCallbackMethodTextContentForPlayer) {
      if (widget.onTextContentForPlayer == null) {
        return null;
      }
      if (call.arguments == null) {
        return null;
      }
      final String? viewId = call.arguments[kMethodArgsKeyViewId];
      if (viewId == null) {
        return null;
      }
      // 替换融合动画资源配置中的文本占位符
      List<TencentNormalTextModel> textList = widget.onTextContentForPlayer!(viewId);
      return textList.map((e) => e.toJson()).toList();
    } else if (call.method == kCallbackMethodLoadTextForPlayer) {
      if (widget.onLoadTextForPlayer == null) {
        return null;
      }
      if (call.arguments == null) {
        return null;
      }
      final String? viewId = call.arguments[kMethodArgsKeyViewId];
      if (viewId == null) {
        return null;
      }
      // 替换融合动画资源配置中的文本占位符
      List<TencentEffectTextModel> textList = widget.onLoadTextForPlayer!(viewId);
      return textList.map((e) => e.toJson()).toList();
    } else if (call.method == kCallbackMethodLoadImageForPlayer) {
      if (widget.onLoadImageForPlayer == null) {
        return null;
      }
      if (call.arguments == null) {
        return null;
      }
      final String? viewId = call.arguments[kMethodArgsKeyViewId];
      if (viewId == null) {
        return null;
      }
      // 替换融合动画资源配置中的图片占位符
      List<TencentEffectImageModel> imageList = widget.onLoadImageForPlayer!(viewId);
      return imageList.map((e) => e.toJson()).toList();
    } else if (call.method == kCallbackMethodTCEffectAnimViewClickEvent) {
      if (call.arguments == null) {
        return null;
      }
      final String? tag = call.arguments[kMethodArgsKeyTag];
      if (tag == null) {
        return null;
      }
      // 融合动画资源点击事件
      final String? viewId = call.arguments[kMethodArgsKeyViewId];
      if (viewId == null) {
        return null;
      }
      widget.onTCEffectAnimViewClickEvent?.call(viewId, tag);
    } else if (call.method == kCallbackMethodTCEffectAnimViewStart) {
      // 融合动画开始播放
      if (call.arguments == null) {
        return null;
      }
      final String? viewId = call.arguments[kMethodArgsKeyViewId];
      if (viewId == null) {
        return null;
      }
      widget.onTCEffectAnimViewStart?.call(viewId);
    } else if (call.method == kCallbackMethodTCEffectAnimViewEnd) {
      // 融合动画结束播放
      if (call.arguments == null) {
        return null;
      }
      final String? viewId = call.arguments[kMethodArgsKeyViewId];
      if (viewId == null) {
        return null;
      }
      widget.onTCEffectAnimViewEnd?.call(viewId);
    } else if (call.method == kCallbackMethodTCEffectAnimViewError) {
      // 融合动画播放错误
      final String? viewId = call.arguments[kMethodArgsKeyViewId];
      if (viewId == null) {
        return null;
      }
      final Map? error = call.arguments[kMethodArgsKeyTCEPlayerError];
      widget.onTCEffectAnimViewError?.call(viewId, error);
    }
    return null;
  }
}
