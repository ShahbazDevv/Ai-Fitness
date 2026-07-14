import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
        errorWidget: (context, url, error) => errorWidget ?? _buildError(),
      );
    } else if (imageUrl.isNotEmpty) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildError(),
      );
    }
    return errorWidget ?? _buildError();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.white.withValues(alpha: 0.05),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: width,
      height: height,
      color: Colors.white.withValues(alpha: 0.05),
      padding: EdgeInsets.all(12.w),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white.withValues(alpha: 0.2),
          size: 24.sp,
        ),
      ),
    );
  }
}

class CustomImageProvider {
  static ImageProvider get(String path) {
    if (path.isEmpty) return const AssetImage('assets/profile/screen.png');
    if (path.startsWith('http')) {
      return CachedNetworkImageProvider(path);
    }
    return AssetImage(path);
  }
}
