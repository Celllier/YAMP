import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';


class GlassWidget extends StatelessWidget {

  const GlassWidget({
    super.key, 
    required this._child,
    this._blurSigma = 18,
    this._cornerRadius = 0,
  });

  final Widget _child;
  final double _blurSigma;
  final double _cornerRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LiquidGlassLens(
        style: LiquidGlassStyle(
          shape: LiquidGlassShape.continuousRoundedRectangle(cornerRadius: _cornerRadius), 
          appearance: LiquidGlassAppearance(
            color: const Color(0x4DFFFFFF), 
            blur: LiquidGlassBlur(sigmaX: _blurSigma, sigmaY: _blurSigma),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
          ),
          child: _child
        ),
      ),
    );
  }

}