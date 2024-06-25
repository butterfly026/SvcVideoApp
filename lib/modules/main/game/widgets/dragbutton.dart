import 'package:flutter/material.dart';

class DraggableFloatingActionButton extends StatefulWidget {
  final Widget child;
  final Offset initialOffset;
  final Function(Offset)? offsetChange;
  final bool dragEnable;

  const DraggableFloatingActionButton({
    super.key,
    required this.child,
    required this.initialOffset,
    this.offsetChange,
    required this.dragEnable,
  });

  @override
  State<StatefulWidget> createState() => _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> {
  final GlobalKey _key = GlobalKey();

  late Offset _offset;
  late Offset _minOffset;
  late Offset _maxOffset;

  @override
  void initState() {
    super.initState();
    _offset = widget.initialOffset;
  }

  void _updatePosition(PointerMoveEvent pointerMoveEvent) {
    double newOffsetX = _offset.dx + pointerMoveEvent.delta.dx;
    double newOffsetY = _offset.dy + pointerMoveEvent.delta.dy;

    if (newOffsetX < _minOffset.dx) {
      newOffsetX = _minOffset.dx;
    } else if (newOffsetX > _maxOffset.dx) {
      newOffsetX = _maxOffset.dx;
    }

    if (newOffsetY < _minOffset.dy) {
      newOffsetY = _minOffset.dy;
    } else if (newOffsetY > _maxOffset.dy) {
      newOffsetY = _maxOffset.dy;
    }

    setState(() {
      _offset = Offset(newOffsetX, newOffsetY);
      widget.offsetChange?.call(_offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Builder(builder: (context) {
        _minOffset = const Offset(0, 0);
        _maxOffset = Offset(MediaQuery.of(context).size.width - 45,
            MediaQuery.of(context).size.height - 45);
        return Listener(
          onPointerMove: (PointerMoveEvent pointerMoveEvent) {
            if (widget.dragEnable) {
              _updatePosition(pointerMoveEvent);
            }
          },
          onPointerUp: (PointerUpEvent pointerUpEvent) {
            print('onPointerUp');
          },
          child: Container(
            key: _key,
            child: widget.child,
          ),
        );
      }),
    );
  }
}
