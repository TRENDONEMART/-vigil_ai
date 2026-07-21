import 'package:flutter/material.dart';

class RiskScoreGauge extends StatefulWidget {
  final int score;

  const RiskScoreGauge({
    super.key,
    required this.score,
  });

  @override
  State<RiskScoreGauge> createState() => _RiskScoreGaugeState();
}

class _RiskScoreGaugeState extends State<RiskScoreGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progressAnimation;
  late final Animation<int> _scoreAnimation;

  Color get _color {
    if (widget.score >= 80) return Colors.red;
    if (widget.score >= 60) return Colors.deepOrange;
    if (widget.score >= 35) return Colors.orange;
    return Colors.green;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.score / 100,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _scoreAnimation = IntTween(
      begin: 0,
      end: widget.score,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant RiskScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.score != widget.score) {
      _progressAnimation = Tween<double>(
        begin: 0,
        end: widget.score / 100,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );

      _scoreAnimation = IntTween(
        begin: 0,
        end: widget.score,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: _progressAnimation.value,
                  strokeWidth: 13,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation(_color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${_scoreAnimation.value}",
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Risk Score",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}