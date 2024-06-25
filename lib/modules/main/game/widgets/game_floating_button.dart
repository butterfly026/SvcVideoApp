import 'package:flutter/material.dart';
import 'package:flutter_video_community/modules/main/game/details/game_details_controller.dart';

class GameFloatingButton extends StatelessWidget {
  const GameFloatingButton({
    super.key,
    this.onTap,
  });

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final controller = GameDetailsController.to;
    return SizedBox(
      width: 45,
      height: 45,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.5),
                color: Colors.white.withOpacity(
                  0.3 + controller.animation.value * 0.4,
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(2, 2),
                    color: Colors.black12,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: Colors.black.withOpacity(
                      0.3 + controller.animation.value * 0.4,
                    ),
                    width: 2,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
