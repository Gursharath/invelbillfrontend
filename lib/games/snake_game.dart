import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SnakeGame extends FlameGame {
  static const int gridSize = 20;
  static const double cellSize = 20.0;

  List<Vector2> snake = [];
  Vector2 direction = Vector2(1, 0);
  Vector2 food = Vector2.zero();
  double timeSinceLastMove = 0.0;
  final double moveInterval = 0.2;

  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

  @override
  Future<void> onLoad() async {
    snake = [Vector2(5, 5)];
    direction = Vector2(1, 0);
    spawnFood();
    scoreNotifier.value = 0;
  }

  void spawnFood() {
    final random = Random();
    while (true) {
      final newFood = Vector2(
        random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble(),
      );
      if (!snake.contains(newFood)) {
        food = newFood;
        break;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeSinceLastMove += dt;

    if (timeSinceLastMove >= moveInterval) {
      timeSinceLastMove = 0;

      final newHead = snake.first + direction;

      // Check bounds
      if (newHead.x < 0 ||
          newHead.y < 0 ||
          newHead.x >= gridSize ||
          newHead.y >= gridSize ||
          snake.contains(newHead)) {
        resetGame();
        return;
      }

      snake.insert(0, newHead);

      if (newHead == food) {
        spawnFood();
        scoreNotifier.value += 10;
      } else {
        snake.removeLast();
      }
    }
  }

  void resetGame() {
    snake = [Vector2(5, 5)];
    direction = Vector2(1, 0);
    spawnFood();
    scoreNotifier.value = 0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paintSnake = Paint()..color = Colors.green;
    final paintFood = Paint()..color = Colors.red;

    for (final segment in snake) {
      canvas.drawRect(
        Rect.fromLTWH(
          segment.x * cellSize,
          segment.y * cellSize,
          cellSize,
          cellSize,
        ),
        paintSnake,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(
        food.x * cellSize,
        food.y * cellSize,
        cellSize,
        cellSize,
      ),
      paintFood,
    );
  }

  void changeDirection(Vector2 newDirection) {
    if (newDirection + direction != Vector2.zero()) {
      direction = newDirection;
    }
  }
}
