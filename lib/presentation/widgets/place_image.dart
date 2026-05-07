import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/place.dart';
import '../theme/app_theme.dart';

class PlaceImage extends StatefulWidget {
  const PlaceImage({
    required this.imageUrl,
    required this.height,
    super.key,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imageUrl;
  final double height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  State<PlaceImage> createState() => _PlaceImageState();
}

class _PlaceImageState extends State<PlaceImage> {
  static final _client = http.Client();
  static final _cache = <String, Future<Uint8List?>>{};

  @override
  Widget build(BuildContext context) {
    final image = widget.imageUrl.startsWith('http')
        ? FutureBuilder<Uint8List?>(
            future: _cache.putIfAbsent(
              widget.imageUrl,
              () => _fetchImage(widget.imageUrl),
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final pixelRatio = MediaQuery.devicePixelRatioOf(context);
                final logicalWidth =
                    (widget.width != null &&
                        widget.width!.isFinite &&
                        widget.width! > 0)
                    ? widget.width!
                    : MediaQuery.sizeOf(context).width;
                final logicalHeight =
                    (widget.height.isFinite && widget.height > 0)
                    ? widget.height
                    : 200.0;
                final targetWidth = (logicalWidth * pixelRatio).round().clamp(
                  96,
                  1400,
                );
                final targetHeight = (logicalHeight * pixelRatio).round().clamp(
                  96,
                  1400,
                );
                return Image.memory(
                  snapshot.data!,
                  height: widget.height,
                  width: widget.width,
                  fit: widget.fit,
                  cacheWidth: targetWidth,
                  cacheHeight: targetHeight,
                  filterQuality: FilterQuality.low,
                );
              }
              return _PlaceImagePlaceholder(
                height: widget.height,
                width: widget.width,
              );
            },
          )
        : Image.asset(
            _assetPathFor(widget.imageUrl),
            height: widget.height,
            width: widget.width,
            fit: widget.fit,
            errorBuilder: (_, _, _) {
              return _PlaceImagePlaceholder(
                height: widget.height,
                width: widget.width,
              );
            },
          );

    if (widget.borderRadius == null) return image;

    return ClipRRect(borderRadius: widget.borderRadius!, child: image);
  }

  Future<Uint8List?> _fetchImage(String imageUrl) async {
    try {
      final response = await _client.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (_) {}
    return null;
  }

  String _assetPathFor(String value) {
    if (value.trim().isEmpty || value.startsWith('http')) {
      return Place.localImageAsset;
    }
    return value;
  }
}

class _PlaceImagePlaceholder extends StatelessWidget {
  const _PlaceImagePlaceholder({required this.height, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C3BFF), Color(0xFF8ED1FC)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: -18,
            top: -16,
            child: Icon(
              Icons.flight_takeoff_rounded,
              color: Colors.white.withValues(alpha: 0.25),
              size: 74,
            ),
          ),
          const Icon(Icons.landscape_rounded, color: Colors.white, size: 42),
          Positioned(
            bottom: 12,
            child: Container(
              height: 5,
              width: 72,
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
